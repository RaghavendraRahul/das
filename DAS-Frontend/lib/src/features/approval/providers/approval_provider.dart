import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/approval_request.dart';
import '../services/approval_service.dart';
import '../../projects/providers/api_providers.dart';
import '../../projects/project_providers.dart';

final approvalProvider = StateNotifierProvider<ApprovalNotifier,
    AsyncValue<Map<String, List<ApprovalRequest>>>>((ref) {
  return ApprovalNotifier(ref.watch(approvalServiceProvider), ref);
});

class ApprovalNotifier
    extends StateNotifier<AsyncValue<Map<String, List<ApprovalRequest>>>> {
  final ApprovalService _service;
  final Ref _ref;

  ApprovalNotifier(this._service, this._ref) : super(const AsyncValue.loading()) {
    fetchAllApprovals();
  }

  Future<void> fetchAllApprovals() async {
    state = const AsyncValue.loading();
    try {
      final newProjects = await _service.getPendingNewProjects();
      final closeProjects = await _service.getPendingProjectClosures();
      final newTasks = await _service.getPendingNewTasks();
      final closeTasks = await _service.getPendingTaskCompletions();

      state = AsyncValue.data({
        'newProjects': newProjects,
        'closeProjects': closeProjects,
        'newTasks': newTasks,
        'closeTasks': closeTasks,
      });
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> approveRequest(int id) async {
    try {
      await _service.approveRequest(id);
      
      // NEW: Cross-invalidate project providers for instant sync
      _ref.invalidate(apiProjectsProvider);
      _ref.invalidate(apiTasksProvider);
      _ref.invalidate(projectsWithTasksProvider);
      _ref.invalidate(apiPaginatedProjectsProvider);
      _ref.invalidate(paginatedDashboardProjectsProvider);
      _ref.invalidate(currentProjectProvider);

      await fetchAllApprovals(); // Refresh list
    } catch (e) {
      rethrow;
    }
  }

  Future<void> rejectRequest(int id, String reason) async {
    try {
      await _service.rejectRequest(id, reason: reason);
      
      // NEW: Cross-invalidate project providers for instant sync
      _ref.invalidate(apiProjectsProvider);
      _ref.invalidate(apiTasksProvider);
      _ref.invalidate(projectsWithTasksProvider);
      
      await fetchAllApprovals(); // Refresh list
    } catch (e) {
      rethrow;
    }
  }
}
