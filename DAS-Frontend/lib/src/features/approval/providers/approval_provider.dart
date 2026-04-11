import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/approval_request.dart';
import '../services/approval_service.dart';

final approvalProvider = StateNotifierProvider<ApprovalNotifier,
    AsyncValue<Map<String, List<ApprovalRequest>>>>((ref) {
  return ApprovalNotifier(ref.watch(approvalServiceProvider));
});

class ApprovalNotifier
    extends StateNotifier<AsyncValue<Map<String, List<ApprovalRequest>>>> {
  final ApprovalService _service;

  ApprovalNotifier(this._service) : super(const AsyncValue.loading()) {
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
      await fetchAllApprovals(); // Refresh list
    } catch (e) {
      // Handle error (maybe show toast via a side effect provider)
      rethrow;
    }
  }

  Future<void> rejectRequest(int id, String reason) async {
    try {
      await _service.rejectRequest(id, reason: reason);
      await fetchAllApprovals(); // Refresh list
    } catch (e) {
      rethrow;
    }
  }
}
