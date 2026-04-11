import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/networking/api_client.dart';
import '../models/approval_request.dart';

final approvalServiceProvider = Provider<ApprovalService>((ref) {
  return ApprovalService(ref.read(dioProvider));
});

class ApprovalService {
  final Dio _dioClient;

  ApprovalService(this._dioClient);

  // Get pending new projects
  Future<List<ApprovalRequest>> getPendingNewProjects() async {
    try {
      final response = await _dioClient.get('/approval-requests/new_projects/');
      final List data = response.data['requests'];
      return data.map((e) {
        // Inject generic types for model parsing
        final Map<String, dynamic> json = Map.from(e);
        json['reference_type'] = 'PROJECT';
        json['approval_type'] = 'CREATION';
        return ApprovalRequest.fromJson(json);
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  // Get pending project completions
  Future<List<ApprovalRequest>> getPendingProjectClosures() async {
    try {
      final response =
          await _dioClient.get('/approval-requests/project_closures/');
      final List data = response.data['requests'];
      return data.map((e) {
        final Map<String, dynamic> json = Map.from(e);
        json['reference_type'] = 'PROJECT';
        json['approval_type'] = 'COMPLETION';
        return ApprovalRequest.fromJson(json);
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  // Get pending new tasks
  Future<List<ApprovalRequest>> getPendingNewTasks() async {
    try {
      final response = await _dioClient.get('/approval-requests/new_tasks/');
      final List data = response.data['requests'];
      return data.map((e) {
        final Map<String, dynamic> json = Map.from(e);
        json['reference_type'] = 'TASK';
        json['approval_type'] = 'CREATION';
        return ApprovalRequest.fromJson(json);
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  // Get pending task completions
  Future<List<ApprovalRequest>> getPendingTaskCompletions() async {
    try {
      final response =
          await _dioClient.get('/approval-requests/task_completions/');
      final List data = response.data['requests'];
      return data.map((e) {
        final Map<String, dynamic> json = Map.from(e);
        json['reference_type'] = 'TASK';
        json['approval_type'] = 'COMPLETION';
        return ApprovalRequest.fromJson(json);
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  // Approve a request
  Future<void> approveRequest(int requestId) async {
    try {
      await _dioClient.post('/approval-responses/', data: {
        'approval_request': requestId,
        'action': 'APPROVED',
      });
    } catch (e) {
      rethrow;
    }
  }

  // Reject a request
  Future<void> rejectRequest(int requestId, {String? reason}) async {
    try {
      await _dioClient.post('/approval-responses/', data: {
        'approval_request': requestId,
        'action': 'REJECTED',
        'rejection_reason': reason,
      });
    } catch (e) {
      rethrow;
    }
  }

  // Get summary counts
  Future<Map<String, int>> getSummary() async {
    try {
      final response = await _dioClient.get('/approval-requests/summary/');
      return Map<String, int>.from(response.data);
    } catch (e) {
      print('Error fetching summary: $e');
      return {};
    }
  }
}
