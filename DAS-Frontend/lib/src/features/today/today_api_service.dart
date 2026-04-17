import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:project_pm/src/core/networking/api_client.dart';

part 'today_api_service.g.dart';

@Riverpod(keepAlive: true)
TodayApiService todayApiService(TodayApiServiceRef ref) {
  final dio = ref.watch(dioProvider);
  return TodayApiService(dio);
}

class TodayApiService {
  final Dio _dio;

  TodayApiService(this._dio);

  /// Create a new planned activity:
  /// 1. First creates a Catalog entry for the activity
  /// 2. Then creates a TodayPlan entry referencing the catalog item
  Future<void> createPlannedActivity({
    required String activityName,
    required String description,
    required DateTime planDate,
    required DateTime scheduledStartTime,
    required int plannedDurationMinutes,
    required String quadrant,
  }) async {
    try {
      print('🔵 API Call: POST /catalog/');
      print('📤 Creating catalog entry: $activityName');

      // Step 1: Create Catalog entry
      final catalogResponse = await _dio.post('/catalog/', data: {
        'name': activityName,
        'description': description,
        'catalog_type': 'CUSTOM', // Type for manually created activities
        'estimated_hours': (plannedDurationMinutes / 60).toStringAsFixed(2),
        'is_active': true,
      });

      final catalogId = catalogResponse.data['id'];
      print('✅ Catalog created with ID: $catalogId');

      // Step 2: Calculate end time
      final scheduledEndTime = scheduledStartTime.add(
        Duration(minutes: plannedDurationMinutes),
      );

      // Step 3: Create TodayPlan entry
      final todayPlanPayload = {
        'catalog_item': catalogId,
        'plan_date': _formatDate(planDate),
        'scheduled_start_time': _formatTime(scheduledStartTime),
        'scheduled_end_time': _formatTime(scheduledEndTime),
        'planned_duration_minutes': plannedDurationMinutes,
        'quadrant': quadrant.toUpperCase(), // Q1, Q2, Q3, Q4
        'notes': description,
        'status': 'PLANNED',
      };

      print('🔵 API Call: POST /today-plan/');
      print('📤 Request Data: $todayPlanPayload');

      final response = await _dio.post('/today-plan/', data: todayPlanPayload);

      print('✅ TodayPlan created successfully');
      print('📥 Response: ${response.data}');
    } on DioException catch (e) {
      print('❌ API Error: Failed to create planned activity');
      print('❌ Error Details: ${e.message}');
      print('❌ Response: ${e.response?.data}');
      throw Exception('Failed to create planned activity: ${e.message}');
    }
  }

  /// Get a single plan item by ID for verification
  Future<Map<String, dynamic>> getPlanItemById(int id) async {
    try {
      print('🔵 API Call: GET /today-plan/$id/');

      final response = await _dio.get('/today-plan/$id/');

      print('✅ Plan item retrieved successfully');
      print('📥 Response: ${response.data}');

      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      print('❌ API Error: GET /today-plan/$id/');
      print('❌ Error Details: ${e.message}');
      throw Exception('Failed to get plan item: ${e.message}');
    }
  }

  /// Update an entire plan item with new data
  Future<void> updatePlanItem({
    required int id,
    required Map<String, dynamic> updates,
  }) async {
    try {
      print('🔵 API Call: PATCH /today-plan/$id/');
      print('📤 Update Data: $updates');

      final response = await _dio.patch('/today-plan/$id/', data: updates);

      print('✅ Plan item updated successfully');
      print('📥 Response: ${response.data}');
    } on DioException catch (e) {
      print('❌ API Error: PATCH /today-plan/$id/');
      print('❌ Error Details: ${e.message}');
      print('❌ Response: ${e.response?.data}');
      throw Exception('Failed to update plan item: ${e.message}');
    }
  }

  /// Update only the status of a plan item
  /// Status options: PLANNED, STARTED, IN_ACTIVITY, COMPLETED, MOVED_TO_PENDING
  Future<void> updatePlanStatus({
    required int id,
    required String status,
  }) async {
    try {
      print('🔵 API Call: PATCH /today-plan/$id/ (status only)');
      print('📤 Status: $status');

      final response = await _dio.patch('/today-plan/$id/', data: {
        'status': status.toUpperCase(),
      });

      print('✅ Status updated to: $status');
      print('📥 Response: ${response.data}');
    } on DioException catch (e) {
      print('❌ API Error: Failed to update status');
      print('❌ Error Details: ${e.message}');
      throw Exception('Failed to update plan status: ${e.message}');
    }
  }

  /// Reorder items in the today plan
  Future<void> reorderTodayPlan(List<Map<String, dynamic>> items) async {
    try {
      print('🔵 API Call: POST /today-plan/reorder/');
      print('📤 Items: $items');

      final response = await _dio.post('/today-plan/reorder/', data: {
        'items': items,
      });

      print('✅ Items reordered successfully');
      print('📥 Response status: ${response.statusCode}');
    } on DioException catch (e) {
      print('❌ API Error: POST /today-plan/reorder/');
      print('❌ Error Details: ${e.message}');
      print('❌ Response: ${e.response?.data}');
      // Don't throw for reorder sync - local state is usually ahead
    }
  }

  /// Delete a plan item from today's plan

  /// Start the work day session
  Future<Map<String, dynamic>> startDay() async {
    try {
      print('🔵 API Call: POST /day-session/start_day/');
      final response = await _dio.post('/day-session/start_day/');
      print('✅ Day started successfully');
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      print('❌ API Error: POST /day-session/start_day/');
      print('❌ Error Details: ${e.message}');
      print('❌ Response: ${e.response?.data}');

      String errorMessage = 'Failed to start day';
      if (e.response?.data is Map) {
        errorMessage = e.response?.data['error'] ??
            e.response?.data['detail'] ??
            errorMessage;
      } else if (e.response?.statusCode == 404) {
        errorMessage =
            'Endpoint not found (404). Please check backend URL configuration.';
      } else {
        errorMessage = e.message ?? errorMessage;
      }

      throw Exception(errorMessage);
    }
  }

  /// Get active session for a specific date
  Future<Map<String, dynamic>?> getActiveSession(String date) async {
    try {
      print('🔵 API Call: GET /day-session/ - date: $date');
      final response = await _dio.get('/day-session/', queryParameters: {
        'session_date': date,
        'is_active': true,
      });

      final List<dynamic> sessions = response.data is List
          ? response.data
          : (response.data is Map ? (response.data['results'] ?? []) : []);

      if (sessions.isNotEmpty) {
        print('✅ Active session found');
        return sessions.first as Map<String, dynamic>;
      }
      print('ℹ️ No active session found for $date');
      return null;
    } on DioException catch (e) {
      print('❌ API Error: GET /day-session/');
      print('❌ Error Details: ${e.message}');
      return null;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:00';
  }
}
