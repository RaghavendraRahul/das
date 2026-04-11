import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../projects/services/task_api_service.dart';
import '../../projects/providers/api_providers.dart';
import '../../projects/project_providers.dart';
import '../models/notification_model.dart';

final notificationPollingProvider =
    StateNotifierProvider<NotificationPollingService, List<NotificationModel>>(
        (ref) {
  final apiService = ref.watch(taskApiServiceProvider);
  return NotificationPollingService(apiService, ref);
});

class NotificationPollingService
    extends StateNotifier<List<NotificationModel>> {
  final TaskApiService _apiService;
  final Ref _ref;
  Timer? _timer;
  Set<int> _lastPendingIds = {};
  bool _isFirstFetch = true;

  NotificationPollingService(this._apiService, this._ref) : super([]) {
    _startPolling();
  }

  void _startPolling() {
    _fetchData(); // Initial fetch
    // Increased interval from 20s to 60s since WebSockets now handle real-time delivery.
    _timer = Timer.periodic(const Duration(seconds: 60), (_) {
      _fetchData();
    });
  }

  Future<void> _fetchData() async {
    // Guard: skip all API calls if user is not logged in (no token stored)
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    if (token == null || token.isEmpty) return;

    await _fetchNotifications();
    await _checkPendingStatusUpdates();
  }

  Future<void> _fetchNotifications() async {
    try {
      final newNotifications = await _apiService.getNotifications();

      // Check for new critical notifications to trigger popup
      // Simple logic: if new notification ID > existing max ID
      if (state.isNotEmpty && newNotifications.isNotEmpty) {
        final maxId = state.map((n) => n.id).fold(0, (p, c) => p > c ? p : c);
        final newlyAdded = newNotifications.where((n) => n.id > maxId).toList();

        if (newlyAdded.isNotEmpty) {
          // We could expose a stream for "new critical events" here
          // For now, StateNotifier updates the list, UI can listen
        }
      }

      state = newNotifications;
    } catch (e) {
      print('Notification Polling error: $e');
    }
  }

  Future<void> _checkPendingStatusUpdates() async {
    try {
      final pendingItems = await _apiService.getMyPendingItems();
      final currentIds = <int>{};

      for (var item in pendingItems) {
        if (item is Map && item.containsKey('id')) {
          currentIds.add(item['id'] as int);
        }
      }

      // If this isn't the first fetch, check if items were removed
      if (!_isFirstFetch) {
        final removedIds = _lastPendingIds.difference(currentIds);

        if (removedIds.isNotEmpty) {
          // Items were processed by Admin!
          // We don't know if approved or rejected, so we refresh everything relevant.
          _ref.invalidate(apiProjectsProvider);
          _ref.invalidate(apiTasksProvider);
          _ref.invalidate(projectsWithTasksProvider);
          _ref.invalidate(pendingProjectClosuresProvider);
          _ref.invalidate(pendingTaskCompletionsProvider);

          // Also invalidate paginated dashboard results to be safe
          _ref.invalidate(apiPaginatedProjectsProvider);
          _ref.invalidate(paginatedDashboardProjectsProvider);
        }
      }

      _lastPendingIds = currentIds;
      _isFirstFetch = false;
    } catch (e) {
      print('Status Polling error: $e');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> markAsRead(int id) async {
    await _apiService.markNotificationAsRead(id);
    // Optimistic update
    state = [
      for (final n in state)
        if (n.id == id) n.copyWith(isRead: true) else n
    ];
  }

  Future<void> markAllAsRead() async {
    // Ideally calls a backend endpoint for bulk update
    // For now, iterate and optimistic update
    // await _apiService.markAllAsRead(); // Logic if backend supports it
    // Loop through unread
    for (var n in state.where((n) => !n.isRead)) {
      _apiService.markNotificationAsRead(n.id);
    }

    state = [for (final n in state) n.copyWith(isRead: true)];
  }
}
