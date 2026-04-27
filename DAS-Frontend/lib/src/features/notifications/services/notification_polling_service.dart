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

final lastReadMaxIdProvider = StateProvider<int>((ref) => 0);

final unreadCountProvider = Provider<int>((ref) {
  final notifications = ref.watch(notificationPollingProvider);
  final lastReadMaxId = ref.watch(lastReadMaxIdProvider);
  
  // Count unread notifications that have an ID greater than the last cleared ID
  return notifications.where((n) => n.id > lastReadMaxId && !n.isRead).length;
});

class NotificationPollingService
    extends StateNotifier<List<NotificationModel>> {
  final TaskApiService _apiService;
  final Ref _ref;
  Timer? _timer;
  Set<int> _lastPendingIds = {};
  bool _isFirstFetch = true;

  NotificationPollingService(this._apiService, this._ref) : super([]) {
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    final lastReadMaxId = prefs.getInt('last_read_max_id') ?? 0;
    _ref.read(lastReadMaxIdProvider.notifier).state = lastReadMaxId;
    _startPolling();
  }

  void _startPolling() {
    _fetchData(); // Initial fetch
    _timer = Timer.periodic(const Duration(seconds: 60), (_) {
      _fetchData();
    });
  }

  Future<void> _fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    if (token == null || token.isEmpty) return;

    await _fetchNotifications();
    await _checkPendingStatusUpdates();
  }

  Future<void> _fetchNotifications() async {
    try {
      final newNotifications = await _apiService.getNotifications();
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

      if (!_isFirstFetch) {
        final removedIds = _lastPendingIds.difference(currentIds);
        if (removedIds.isNotEmpty) {
          _ref.invalidate(apiProjectsProvider);
          _ref.invalidate(apiTasksProvider);
          _ref.invalidate(projectsWithTasksProvider);
          _ref.invalidate(pendingProjectClosuresProvider);
          _ref.invalidate(pendingTaskCompletionsProvider);
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
    state = [
      for (final n in state)
        if (n.id == id) n.copyWith(isRead: true) else n
    ];
  }

  Future<void> markAllAsRead() async {
    // 1. Calculate the max ID from current notifications
    final maxId = state.isEmpty ? 0 : state.map((n) => n.id).reduce((a, b) => a > b ? a : b);
    
    // 2. Update the lastReadMaxId locally and in persistent storage
    _ref.read(lastReadMaxIdProvider.notifier).state = maxId;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('last_read_max_id', maxId);

    // 3. Optimistically update all to isRead: true in UI
    state = [for (final n in state) n.copyWith(isRead: true)];
    
    // 4. Update on server (best effort)
    try {
      // If backend has a bulk markRead endpoint, use it. 
      // Otherwise, we do it individually but it won't block the UI.
      for (var n in state.where((n) => !n.isRead)) {
        _apiService.markNotificationAsRead(n.id);
      }
    } catch (_) {}
  }
}
