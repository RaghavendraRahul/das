import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:project_pm/src/core/networking/api_client.dart';
import 'package:project_pm/src/features/today/models/instruction_model.dart';
import 'package:project_pm/src/features/auth/auth_state_providers.dart';
import 'package:project_pm/src/core/database/database.dart' as db;

part 'instruction_service.g.dart';

@riverpod
InstructionService instructionService(InstructionServiceRef ref) {
  return InstructionService(ref.watch(dioProvider));
}

class InstructionService {
  final Dio _dio;

  InstructionService(this._dio);

  Future<TeamInstruction> sendInstruction(
      CreateTeamInstructionRequest request) async {
    try {
      final response = await _dio.post(
        '/team-instructions/',
        data: request.toJson(),
      );

      return TeamInstruction.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to send instruction: ${e.message}');
    }
  }

  Future<List<TeamInstruction>> getReceivedInstructions() async {
    try {
      // The backend filters based on the logged-in user in get_queryset
      final response = await _dio.get('/team-instructions/');
      return (response.data as List)
          .map((item) => TeamInstruction.fromJson(item))
          .toList();
    } on DioException catch (e) {
      throw Exception('Failed to fetch instructions: ${e.message}');
    }
  }

  Future<Map<String, dynamic>> getProjectMembers(int? projectId) async {
    try {
      final queryParams =
          projectId != null ? {'project_id': projectId} : <String, dynamic>{};
      final response = await _dio.get(
        '/team-instructions/project_members/',
        queryParameters: queryParams,
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception('Failed to fetch project members: ${e.message}');
    }
  }
}

@riverpod
Future<List<TeamInstruction>> receivedInstructions(
    ReceivedInstructionsRef ref) async {
  final instructions =
      await ref.watch(instructionServiceProvider).getReceivedInstructions();
  final authState = ref.watch(authNotifierProvider);
  final userId = authState.valueOrNull?.userId;

  if (userId == null) return [];

  // Filter instructions where user is in 'recipients' list
  return instructions
      .where((inst) => inst.recipients.contains(userId))
      .toList();
}

@riverpod
Future<List<TeamInstruction>> sentInstructions(SentInstructionsRef ref) async {
  final instructions =
      await ref.watch(instructionServiceProvider).getReceivedInstructions();
  final authState = ref.watch(authNotifierProvider);
  final userId = authState.valueOrNull?.userId;

  if (userId == null) return [];

  // Filter instructions where 'sentBy' matches current user
  return instructions.where((inst) => inst.sentBy == userId).toList();
}

@riverpod
Future<List<db.User>> projectMembers(
    ProjectMembersRef ref, int? projectId) async {
  final data =
      await ref.watch(instructionServiceProvider).getProjectMembers(projectId);
  final membersList = data['members'] as List;
  return membersList.map((m) {
    return db.User(
      id: m['id'].toString(),
      name: m['name'] as String,
      email: m['email'] as String,
      avatarUrl: '', // Will be handled by NetworkImage/Profile logic
      role: m['role'] as String,
    );
  }).toList();
}
