import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:project_pm/src/core/networking/api_client.dart';

part 'team_api_service.g.dart';

@Riverpod(keepAlive: true)
TeamApiService teamApiService(TeamApiServiceRef ref) {
  final dio = ref.watch(dioProvider);
  return TeamApiService(dio);
}

/// Service for Team Overview API endpoints
class TeamApiService {
  final Dio _dio;

  TeamApiService(this._dio);

  /// Fetch team members with statistics
  /// GET /api/team-overview/team_members/
  /// Returns: { "count": int, "total_count": int, "page": int, "page_size": int, "total_pages": int, "members": [ {...} ] }
  ///
  /// Parameters:
  /// - allUsers: If true, returns all active users (for project assignments)
  /// - page: Page number for pagination (default: 1)
  /// - pageSize: Number of items per page (default: 10)
  Future<Map<String, dynamic>> getTeamMembers(
      {bool allUsers = false, int page = 1, int pageSize = 10}) async {
    try {
      final queryParams = <String, String>{};
      if (allUsers) queryParams['all_users'] = 'true';
      queryParams['page'] = page.toString();
      queryParams['page_size'] = pageSize.toString();
      final response = await _dio.get(
        '/team-overview/team_members/',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Failed to load team members: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
            'Server error: ${e.response?.statusCode} - ${e.response?.data}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    }
  }

  /// Fetch detailed dashboard for a specific team member
  /// GET /api/team-overview/member_dashboard/?member_id={id}
  Future<Map<String, dynamic>> getMemberDashboard(String memberId) async {
    try {
      final response = await _dio.get(
        '/team-overview/member_dashboard/',
        queryParameters: {'member_id': memberId},
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception(
            'Failed to load member dashboard: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
            'Server error: ${e.response?.statusCode} - ${e.response?.data}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    }
  }

  /// Fetch specific user profile by ID
  /// GET /api/users/{id}/profile/
  Future<Map<String, dynamic>> getUserProfile(String userId) async {
    try {
      final response = await _dio.get('/user-preferences/$userId/profile/');

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Failed to load user profile: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
            'Server error: ${e.response?.statusCode} - ${e.response?.data}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    }
  }
}
