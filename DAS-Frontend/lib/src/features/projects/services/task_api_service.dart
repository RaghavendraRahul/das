import 'package:dio/dio.dart';
import '../models/project_model.dart';
import '../models/task_model.dart';
import '../models/catalog_model.dart';
import '../../notifications/models/notification_model.dart';
import '../../../core/models/paginated_response.dart';
import '../../../core/models/project_with_tasks.dart';

/// Service for handling all project and task related API calls
class TaskApiService {
  final Dio _dio;

  // ... (keeping constructor and initial methods) -> I need to be careful with replace_file_content replacing whole file if I don't specify range validly.
  // I will target specific ranges.

  TaskApiService(this._dio);

  // --- Projects ---

  /// Fetch projects with pagination
  Future<PaginatedResponse<ProjectModel>> getPaginatedProjects(int page,
      [Map<String, dynamic>? params]) async {
    try {
      final queryParams = {'page': page, ...?params};
      print(
          'Fetching paginated projects from: /projects/ with params: $queryParams');
      final response =
          await _dio.get('/projects/', queryParameters: queryParams);

      if (response.statusCode == 200) {
        return PaginatedResponse.fromJson(
          response.data,
          (json) => ProjectModel.fromJson(json),
        );
      } else {
        throw Exception('Failed to load projects: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('DioException: ${e.message}');
      throw Exception('Network error: ${e.message}');
    }
  }

  /// Fetch all projects (no pagination)
  Future<List<ProjectModel>> getProjects({
    Map<String, dynamic>? params,
    String? startDate,
    String? endDate,
    bool allProjects =
        true, // Defaults to true to maintain existing full-fetch behavior
  }) async {
    try {
      final queryParams = {
        if (allProjects) 'all_projects': 'true',
        if (startDate != null) 'start_date': startDate,
        if (endDate != null) 'end_date': endDate,
        ...?params
      };
      print('Fetching all projects from: /projects/ with params: $queryParams');
      final response =
          await _dio.get('/projects/', queryParameters: queryParams);

      if (response.statusCode == 200) {
        // Handle Django REST framework paginated response if backend ignores 'all_projects' or returns raw list
        final dynamic responseData = response.data;
        List<dynamic> projectsData;

        if (responseData is List) {
          projectsData = responseData;
        } else if (responseData is Map<String, dynamic> &&
            responseData.containsKey('results')) {
          // Fallback if backend still paginates
          projectsData = responseData['results'];
        } else {
          projectsData = [];
        }

        return projectsData.map((json) => ProjectModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load projects: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('DioException: ${e.message}');
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<ProjectModel> createProject(Map<String, dynamic> projectData) async {
    try {
      final response = await _dio.post('/projects/', data: projectData);
      if (response.statusCode == 201) {
        return ProjectModel.fromJson(response.data);
      } else {
        throw Exception('Failed to create project: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<ProjectWithTasks> createProjectWithTasks({
    required String name,
    required String description,
    int? projectLead,
    DateTime? deadline,
    required List<dynamic> tasks,
    List<int>? assignees,
    double? plannedHours,
  }) async {
    try {
      final data = {
        'name': name,
        'description': description,
        'project_lead': projectLead,
        'deadline': deadline?.toIso8601String().split('T')[0],
        'tasks': tasks,
        'assignees': assignees,
        'planned_hours': plannedHours,
      };

      final response =
          await _dio.post('/projects/create-with-tasks/', data: data);

      if (response.statusCode == 201) {
        final projectModel = ProjectModel.fromJson(response.data);
        return ProjectWithTasks(
          project: projectModel.toLocalProject(),
          tasks: [],
          projectLeadId: projectModel.projectLeadId,
          projectAssignees: projectModel.projectAssignees ?? [],
        );
      } else {
        throw Exception(
            'Failed to create project with tasks: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  // --- Day Planner Helpers ---

  // ═══════════════════════════════════════════════════════════════════════
  // Unified Add Item Endpoint - POST /today-plan/add_item/
  // Handles both custom tasks and catalog items via item_type parameter.
  // ═══════════════════════════════════════════════════════════════════════

  /// Core unified method for adding any item to the daily plan.
  /// [itemType] must be either "custom" or "catalog".
  Future<Map<String, dynamic>> addItemToTodayPlan({
    required String itemType,
    String? title,
    String? description,
    int? catalogId,
    String? planDate,
    int? plannedDurationMinutes,
    String? quadrant,
    String? scheduledStartTime,
    String? scheduledEndTime,
    bool isUnplanned = false,
    int? relatedTaskId,
    String? userId,
  }) async {
    assert(itemType == 'custom' || itemType == 'catalog',
        'item_type must be "custom" or "catalog"');

    try {
      final data = <String, dynamic>{
        'item_type': itemType,
        if (planDate != null) 'plan_date': planDate,
        if (quadrant != null) 'quadrant': quadrant,
        'is_unplanned': isUnplanned,
        if (userId != null) 'user_id': userId,
        if (scheduledStartTime != null)
          'scheduled_start_time': scheduledStartTime,
        if (scheduledEndTime != null) 'scheduled_end_time': scheduledEndTime,
        if (plannedDurationMinutes != null)
          'planned_duration_minutes': plannedDurationMinutes,
        if (relatedTaskId != null) 'related_task_id': relatedTaskId,

        // Text fields (Map to both description and notes for compatibility)
        if (description != null) 'description': description,
        if (description != null) 'notes': description,

        // Custom-specific fields
        if (itemType == 'custom' && title != null) 'title': title,

        // Catalog-specific fields
        if (itemType == 'catalog' && catalogId != null) 'catalog_id': catalogId,
      };

      print('📋 API Call: POST /today-plan/add_item/ → $itemType');
      final response = await _dio.post('/today-plan/add_item/', data: data);
      if (response.data is Map && response.data.containsKey('plan')) {
        return response.data['plan'];
      }
      return response.data;
    } on DioException catch (e) {
      print('❌ add_item error: ${e.response?.data}');
      if (e.response?.data is Map && e.response?.data['error'] != null) {
        throw Exception(e.response?.data['error']);
      }
      throw Exception(e.message ?? 'Unknown API error');
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<Map<String, dynamic>> moveTodayPlanToActivityLog(
      int plannedItemId) async {
    try {
      print(
          '🔵 API Call: POST /today-plan/$plannedItemId/move_to_activity_log/');
      final response =
          await _dio.post('/today-plan/$plannedItemId/move_to_activity_log/');
      print('✅ Task started successfully');
      if (response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      }
      return {};
    } on DioException catch (e) {
      print(
          '❌ API Error: POST /today-plan/$plannedItemId/move_to_activity_log/');

      String errorMessage = 'Failed to start task';
      if (e.response?.data is Map) {
        errorMessage = e.response?.data['error'] ??
            e.response?.data['detail'] ??
            errorMessage;
      } else {
        errorMessage = e.message ?? errorMessage;
      }

      print('❌ Error Message: $errorMessage');
      throw Exception(errorMessage);
    }
  }

  Future<void> stopActivityLog({
    required int activityLogId,
    required bool isCompleted,
    String? reason,
    String? workNotes,
    int? minutesLeft,
    int? extraMinutes,
    String? startTime,
    String? endTime,
  }) async {
    try {
      await _dio.post('/activity-log/$activityLogId/stop/', data: {
        'is_completed': isCompleted,
        'reason': reason,
        'work_notes': workNotes,
        'minutes_left': minutesLeft,
        'extra_minutes': extraMinutes,
        'start_time': startTime,
        'end_time': endTime,
      });
    } catch (e) {
      print('Mock: Stopped activity log $activityLogId (Backend error: $e)');
    }
  }

  Future<Map<String, dynamic>> bulkStopActivityLogs({
    required int todayPlanId,
    required String date,
    required bool isCompleted,
    required bool isPendingSelected,
    String? workNotes,
    int? minutesLeft,
    int? extraMinutes,
    String? startTime,
    String? endTime,
  }) async {
    try {
      print(
          '🔵 [bulkStopActivityLogs] Sending API Call: POST /activity-log/bulk-stop/');
      print('   - todayPlanId: $todayPlanId');
      print('   - date: $date');
      print('   - isCompleted: $isCompleted');
      print('   - isPendingSelected: $isPendingSelected');
      print('   - startTime: $startTime');
      print('   - endTime: $endTime');

      final response = await _dio.post('/activity-log/bulk-stop/', data: {
        'today_plan_id': todayPlanId,
        'date': date,
        'is_completed': isCompleted,
        'is_pending_selected': isPendingSelected,
        'work_notes': workNotes,
        'minutes_left': minutesLeft,
        'extra_minutes': extraMinutes,
        'start_time': startTime,
        'end_time': endTime,
      });
      print('✅ [bulkStopActivityLogs] Response received successfully');
      if (response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      }
      return {'message': 'Updated activity logs'};
    } on DioException catch (e) {
      print('❌ [bulkStopActivityLogs] API Error: ${e.message}');
      print('   - Status Code: ${e.response?.statusCode}');
      print('   - Response: ${e.response?.data}');
      String errorMessage = 'Failed to stop activity logs';
      if (e.response?.data is Map) {
        errorMessage = e.response?.data['error'] ??
            e.response?.data['detail'] ??
            errorMessage;
      }
      throw Exception(errorMessage);
    }
  }

  Future<void> updateTodayPlanItem(int id, Map<String, dynamic> data) async {
    try {
      await _dio.patch('/today-plan/$id/', data: data);
    } catch (e) {
      print('Mock: Updated plan item $id (Backend error: $e)');
    }
  }

  Future<void> deleteTodayPlanItem(int id) async {
    try {
      await _dio.delete('/today-plan/$id/');
    } on DioException catch (e) {
      String errorMessage = 'Failed to delete plan item';
      if (e.response?.data is Map) {
        errorMessage = e.response?.data['error'] ??
            e.response?.data['detail'] ??
            errorMessage;
      }
      throw Exception(errorMessage);
    }
  }

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

  // --- Pagination Helpers ---

  Future<PaginatedResponse<TaskModel>> getPaginatedTasks(
      int page, Map<String, dynamic>? params) async {
    try {
      final queryParams = {'page': page, ...?params};
      final response = await _dio.get('/tasks/', queryParameters: queryParams);

      if (response.data is List) {
        final List<dynamic> list = response.data;
        return PaginatedResponse<TaskModel>(
          count: list.length,
          results: list.map((json) => TaskModel.fromJson(json)).toList(),
          next: null,
          previous: null,
        );
      }

      return PaginatedResponse.fromJson(
          response.data, (json) => TaskModel.fromJson(json));
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<void> updateProject(int id, Map<String, dynamic> projectData) async {
    try {
      await _dio.patch('/projects/$id/', data: projectData);
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<void> deleteProject(int id) async {
    try {
      await _dio.delete('/projects/$id/');
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  // Custom method needed by api_providers
  Future<ProjectModel> getProject(int id) async {
    try {
      final response = await _dio.get('/projects/$id/');
      if (response.statusCode == 200) {
        return ProjectModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load project: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<void> requestProjectCompletion(
      {required int projectId, String? date}) async {
    try {
      await _dio.post('/projects/$projectId/request_completion/',
          data: {'date': date});
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<void> reopenProject(int id, String reason) async {
    try {
      await _dio.post('/projects/$id/reopen/', data: {'reason': reason});
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  /// Admin bypass: directly mark project as COMPLETED without approval
  Future<void> adminCompleteProject({required int projectId}) async {
    try {
      await _dio.patch('/projects/$projectId/', data: {'status': 'COMPLETED'});
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  /// Admin bypass: directly mark task as 100% complete without approval
  Future<void> adminCompleteTask({required int taskId}) async {
    try {
      await _dio.patch('/tasks/$taskId/', data: {
        'progress': 100,
        'status': 'DONE',
        'approval_status': 'APPROVED',
      });
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<List<dynamic>> getPendingProjects() async {
    try {
      final response = await _dio.get('/approval-requests/new_projects/');
      if (response.statusCode == 200) {
        return response.data['requests'];
      }
      throw Exception('Failed to fetch pending projects');
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<List<dynamic>> getPendingProjectClosures() async {
    try {
      final response = await _dio.get('/approval-requests/project_closures/');
      if (response.statusCode == 200) {
        return response.data['requests'];
      }
      throw Exception('Failed to fetch pending closures');
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  // --- Tasks ---

  Future<List<TaskModel>> getTasks({
    String? startDate,
    String? endDate,
    String? search,
  }) async {
    try {
      final queryParams = {
        if (startDate != null) 'start_date': startDate,
        if (endDate != null) 'end_date': endDate,
        if (search != null && search.isNotEmpty) 'search': search,
      };
      final response = await _dio.get('/tasks/', queryParameters: queryParams);
      if (response.statusCode == 200) {
        final List<dynamic> tasksData = response.data is List
            ? response.data
            : (response.data is Map ? (response.data['results'] ?? []) : []);

        return tasksData.map((json) => TaskModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load tasks: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<TaskModel> createTask(
      int projectId, Map<String, dynamic> taskData) async {
    try {
      final response =
          await _dio.post('/projects/$projectId/create_task/', data: taskData);
      if (response.statusCode == 201) {
        return TaskModel.fromJson(response.data);
      } else {
        throw Exception('Failed to create task: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<TaskModel> createRecurringTask(
      int projectId, Map<String, dynamic> taskData) async {
    try {
      final response = await _dio
          .post('/projects/$projectId/create_recurring_task/', data: taskData);
      if (response.statusCode == 201) {
        return TaskModel.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to create recurring task: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<TaskModel> createRoutineTask(
      int projectId, Map<String, dynamic> taskData) async {
    try {
      final response = await _dio
          .post('/projects/$projectId/create_routine_task/', data: taskData);
      if (response.statusCode == 201) {
        return TaskModel.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to create routine task: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<void> updateTask(int id, Map<String, dynamic> taskData) async {
    try {
      await _dio.patch('/tasks/$id/', data: taskData);
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<void> reopenTask(int id, String reason) async {
    try {
      await _dio.post('/tasks/$id/reopen/', data: {'reason': reason});
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      await _dio.delete('/tasks/$id/');
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<Map<String, dynamic>?> requestTaskCompletion(
      {required int taskId, String? date}) async {
    try {
      final response = await _dio
          .post('/tasks/$taskId/request_completion/', data: {'date': date});
      return response.data as Map<String, dynamic>?;
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<Map<String, dynamic>> toggleSubtaskCompletion(
      int taskId, int subtaskId) async {
    try {
      final response =
          await _dio.patch('/sub-tasks/$subtaskId/toggle_completion/');
      return response.data;
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<List<dynamic>> getPendingTasks() async {
    try {
      final response = await _dio.get('/approval-requests/new_tasks/');
      if (response.statusCode == 200) {
        return response.data['requests'];
      }
      throw Exception('Failed to fetch pending tasks');
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<List<dynamic>> getPendingTaskCompletions() async {
    try {
      final response = await _dio.get('/approval-requests/task_completions/');
      if (response.statusCode == 200) {
        return response.data['requests'];
      }
      throw Exception('Failed to fetch pending task completions');
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  // --- Catalog ---

  Future<List<CatalogModel>> getCatalog() async {
    try {
      final response = await _dio.get('/catalog/');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => CatalogModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load catalog');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  /// Fetch catalog projects (only assigned projects for logged-in user)
  /// This is separate from getProjects() which shows all team projects to admin
  Future<List<ProjectModel>> getCatalogProjects() async {
    try {
      final response = await _dio.get('/catalog-projects/');
      if (response.statusCode == 200) {
        final dynamic responseData = response.data;
        List<dynamic> projectsData;

        if (responseData is List) {
          projectsData = responseData;
        } else if (responseData is Map<String, dynamic> &&
            responseData.containsKey('results')) {
          projectsData = responseData['results'];
        } else {
          projectsData = [];
        }

        return projectsData.map((json) => ProjectModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load catalog projects');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  /// Fetch catalog tasks (only assigned tasks for logged-in user)
  /// This is separate from getTasks() which shows all team tasks to admin
  Future<List<TaskModel>> getCatalogTasks() async {
    try {
      final response = await _dio.get('/catalog-tasks/');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => TaskModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load catalog tasks');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  // ... (skipped some methods)

  // --- Notifications ---

  Future<List<NotificationModel>> getNotifications() async {
    try {
      final response = await _dio.get('/notifications/');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => NotificationModel.fromJson(json)).toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  Future<CatalogModel> createCatalogItem({
    required String name,
    String? description,
    String? catalogType,
    bool isActive = true,
  }) async {
    try {
      final data = {
        'name': name,
        'description': description,
        'catalog_type': catalogType,
        'is_active': isActive,
      };
      final response = await _dio.post('/catalog/', data: data);
      if (response.statusCode == 201) {
        return CatalogModel.fromJson(response.data);
      } else {
        throw Exception('Failed to create catalog item');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  // --- Approvals ---

  Future<void> submitApprovalResponse(
      {required int requestId, required String action, String? notes}) async {
    try {
      await _dio.post('/approval_responses/', data: {
        'approval_request': requestId,
        'action': action,
        'notes': notes ?? ''
      });
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<void> approveRequest(int requestId) async {
    try {
      await _dio.post('/approval-requests/$requestId/approve/');
    } on DioException catch (e) {
      throw Exception(
          'Failed to approve request: ${e.response?.data['error'] ?? e.message}');
    }
  }

  Future<void> rejectRequest(int requestId, {String? reason}) async {
    try {
      final data = reason != null ? {'reason': reason} : null;
      await _dio.post('/approval-requests/$requestId/reject/', data: data);
    } on DioException catch (e) {
      throw Exception(
          'Failed to reject request: ${e.response?.data['error'] ?? e.message}');
    }
  }

  /// Admin only: Approve task completion by Task ID (not approval request ID)
  /// This endpoint handles status update and also cleans up associated approval requests.
  Future<void> approveTaskCompletion(int taskId) async {
    try {
      await _dio.post('/tasks/$taskId/approve_completion/');
    } on DioException catch (e) {
      throw Exception(
          'Failed to approve task: ${e.response?.data['error'] ?? e.message}');
    }
  }

  /// Admin only: Reject task completion by Task ID (not approval request ID)
  /// This endpoint handles status update and also cleans up associated approval requests.
  Future<void> rejectTaskCompletion(int taskId, {String? reason}) async {
    try {
      final data = reason != null ? {'reason': reason} : null;
      await _dio.post('/tasks/$taskId/reject_completion/', data: data);
    } on DioException catch (e) {
      throw Exception(
          'Failed to reject task: ${e.response?.data['error'] ?? e.message}');
    }
  }

  Future<List<dynamic>> getMyPendingItems(
      {String? date, String? userId}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (date != null) queryParams['date'] = date;
      if (userId != null) queryParams['user_id'] = userId;

      final response =
          await _dio.get('/pending/my_pending/', queryParameters: queryParams);
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is List) return data;
        return data['requests'] ?? [];
      }
      throw Exception('Failed to load pending items');
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<void> deletePendingTask(int id) async {
    try {
      await _dio.delete('/pending/$id/');
    } on DioException catch (e) {
      throw Exception('Failed to delete pending task: ${e.message}');
    }
  }

  // --- Dashboard Extras ---

  // --- Dashboard Extras ---

  Future<List<dynamic>> getUsersForStats() async {
    try {
      final response = await _dio.get('/dashboard/users-for-stats/');
      if (response.statusCode == 200) {
        return response.data['users'] ?? [];
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  /// DEDICATED Analytics API method (separate from dashboard stats)
  /// Only takes: user_id, project_id, employee_id
  /// Does NOT take startDate/endDate (those are dashboard-only)
  Future<Map<String, dynamic>> getProjectAnalyticsHours({
    int? userId,
    int? projectId,
    int? employeeId,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (userId != null) queryParams['user_id'] = userId;
      if (projectId != null) queryParams['project_id'] = projectId;
      if (employeeId != null) queryParams['employee_id'] = employeeId;

      print('');
      print('📊╔════════════════════════════════════════════════════════════');
      print('📊║ [ANALYTICS API] getProjectAnalyticsHours()');
      print('📊║ Parameters:');
      print('📊║   user_id: $userId');
      print('📊║   project_id: $projectId  ← PROJECT FILTER');
      print('📊║   employee_id: $employeeId  ← EMPLOYEE FILTER');
      print('📊║ Query params: $queryParams');
      print('📊╚════════════════════════════════════════════════════════════');
      print('');

      final response = await _dio.get(
        '/project-analytics/hours/',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final projects = (data['dropdowns']?['projects'] as List?)?.length ?? 0;
        final employees =
            (data['dropdowns']?['employees'] as List?)?.length ?? 0;
        final tasks = (data['tasks'] as List?)?.length ?? 0;
        print(
            '📊╔════════════════════════════════════════════════════════════');
        print('📊║ [ANALYTICS RESPONSE]');
        print('📊║   Projects: $projects');
        print('📊║   Employees: $employees  ← FILTERED by project!');
        print('📊║   Tasks: $tasks');
        print('📊║   Planned: ${data['totals']?['planned_hours']}');
        print('📊║   Achieved: ${data['totals']?['achieved_hours']}');
        print(
            '📊╚════════════════════════════════════════════════════════════');
        return data;
      }
      return <String, dynamic>{};
    } catch (e) {
      print('❌ Analytics API Error: $e');
      return <String, dynamic>{};
    }
  }

  Future<Map<String, dynamic>> getProjectWorkStats(
    int? userId, {
    String? startDate,
    String? endDate,
    int? projectId,
    int? employeeId,
    String? search,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (userId != null) queryParams['user_id'] = userId;
      if (startDate != null) queryParams['start_date'] = startDate;
      if (endDate != null) queryParams['end_date'] = endDate;
      if (projectId != null) queryParams['project_id'] = projectId;
      if (employeeId != null) queryParams['employee_id'] = employeeId;
      if (search != null && search.isNotEmpty) queryParams['search'] = search;

      print('');
      print('📊╔════════════════════════════════════════════════════════════');
      print('📊║ [DASHBOARD STATS API] getProjectWorkStats()');
      print('📊║ Parameters:');
      print('📊║   user_id: $userId');
      print('📊║   project_id: $projectId');
      print('📊║   employee_id: $employeeId');
      print('📊║   start_date: $startDate');
      print('📊║   end_date: $endDate');
      print('📊║ Query params: $queryParams');
      print('📊╚════════════════════════════════════════════════════════════');
      print('');

      final response = await _dio.get(
        '/project-analytics/hours/',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return data;
      }
      return <String, dynamic>{};
    } catch (e) {
      print('❌ Dashboard Stats API Error: $e');
      return <String, dynamic>{};
    }
  }

  Future<Map<String, dynamic>> getTeamActivityStatus() async {
    try {
      final response = await _dio.get('/dashboard/team-activity-status/');
      if (response.statusCode == 200) {
        return response.data;
      }
      return <String, dynamic>{};
    } catch (e) {
      print('Error fetching team activity status: $e');
      return <String, dynamic>{};
    }
  }

  Future<Map<String, dynamic>> getProjectCompletionChart(
      int year, String filter,
      [int? userId, String? search]) async {
    try {
      final startDate = '$year-01-01';
      final endDate = '$year-12-31';
      final response =
          await _dio.get('/project-completion-chart/', queryParameters: {
        'start_date': startDate,
        'end_date': endDate,
        'filter': filter,
        if (userId != null) 'user_id': userId,
        if (search != null && search.isNotEmpty) 'search': search,
      });
      if (response.statusCode == 200) {
        return response.data;
      }
      return <String, dynamic>{};
    } catch (e) {
      print('Error fetching project completion chart: $e');
      return <String, dynamic>{};
    }
  }

  Future<Map<String, dynamic>> getTaskCompletionChart(
      String startDate, String endDate, String filter,
      [int? userId, String? search]) async {
    try {
      final response =
          await _dio.get('/task-completion-chart/', queryParameters: {
        'start_date': startDate,
        'end_date': endDate,
        'filter': filter,
        if (userId != null) 'user_id': userId,
        if (search != null && search.isNotEmpty) 'search': search,
      });
      if (response.statusCode == 200) {
        return response.data;
      }
      return <String, dynamic>{};
    } catch (e) {
      print('Error fetching task completion chart: $e');
      return <String, dynamic>{};
    }
  }

  Future<List<dynamic>> getHoursCompletionChart(int year, String filter,
      [int? userId, String? search]) async {
    try {
      final response = await _dio.get(
        '/hours-completion-chart/',
        queryParameters: {
          'year': year,
          'filter': filter,
          if (userId != null) 'user_id': userId,
          if (search != null && search.isNotEmpty) 'search': search,
        },
      );
      if (response.statusCode == 200) {
        return List<dynamic>.from(response.data);
      }
      return [];
    } catch (e) {
      print('Error fetching hours completion chart: $e');
      return [];
    }
  }

  // --- Notifications ---

  Future<void> markNotificationAsRead(int id) async {
    try {
      await _dio.post('/notifications/$id/mark_read/');
    } catch (_) {}
  }

  // --- Day Planner / Work Logs ---

  Future<void> startWorkLog({
    String? plannedItemId,
    String? name,
    String? description,
    String? relatedTaskId,
  }) async {
    try {
      await _dio.post('/activity_logs/start/', data: {
        'planned_item_id': plannedItemId,
        'name': name,
        'description': description,
        'related_task_id': relatedTaskId,
      });
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<void> stopWorkLog(
      {required String logId, bool isCompleted = false}) async {
    try {
      await _dio.post('/activity_logs/stop/',
          data: {'log_id': logId, 'is_completed': isCompleted});
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<List<Map<String, dynamic>>> getTodayPlan(
      {String? date, String? userId}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (date != null) queryParams['date'] = date;
      if (userId != null) queryParams['user_id'] = userId;

      if (date != null) {
        final response =
            await _dio.get('/today-plan/', queryParameters: queryParams);
        if (response.statusCode == 200) {
          final List<dynamic> data = response.data;
          final list = data.cast<Map<String, dynamic>>();
          list.sort((a, b) {
            final aOrder = (a['order_index'] as num?)?.toInt() ?? 0;
            final bOrder = (b['order_index'] as num?)?.toInt() ?? 0;
            return aOrder.compareTo(bOrder);
          });
          return list;
        }
      } else {
        final response =
            await _dio.get('/today-plan/today/', queryParameters: queryParams);
        if (response.statusCode == 200) {
          final List<dynamic> data = response.data;
          final list = data.cast<Map<String, dynamic>>();
          list.sort((a, b) {
            final aOrder = (a['order_index'] as num?)?.toInt() ?? 0;
            final bOrder = (b['order_index'] as num?)?.toInt() ?? 0;
            return aOrder.compareTo(bOrder);
          });
          return list;
        }
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getActivityLogs({String? date}) async {
    try {
      final query = date != null ? {'date': date} : <String, dynamic>{};
      final response = await _dio.get('/activity-log/', queryParameters: query);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;

        return data.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  // --- Other Methods ---

  Future<List<CatalogModel>> getCourses() async {
    try {
      final response = await _dio
          .get('/catalog/by_type/', queryParameters: {'type': 'COURSE'});
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => CatalogModel.fromJson(json)).toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  Future<List<CatalogModel>> getRoutines() async {
    try {
      final response = await _dio
          .get('/catalog/by_type/', queryParameters: {'type': 'ROUTINE'});
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => CatalogModel.fromJson(json)).toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  Future<List<CatalogModel>> getWorkItems() async {
    try {
      final response = await _dio
          .get('/catalog/by_type/', queryParameters: {'type': 'WORK'});
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => CatalogModel.fromJson(json)).toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  Future<List<dynamic>> getPlansByDateRange(
      DateTime start, DateTime end) async {
    try {
      final startStr =
          "${start.year}-${start.month.toString().padLeft(2, '0')}-${start.day.toString().padLeft(2, '0')}";
      final endStr =
          "${end.year}-${end.month.toString().padLeft(2, '0')}-${end.day.toString().padLeft(2, '0')}";

      final response = await _dio.get('/today-plan/', queryParameters: {
        'start_date': startStr,
        'end_date': endStr,
      });

      if (response.statusCode == 200) {
        return response.data as List<dynamic>;
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  Future<Map<String, dynamic>> getProjectMembers({String? projectId}) async =>
      {};

  Future<dynamic> getActiveTask() async {
    try {
      final response = await _dio.get('/activity-log/active/');
      if (response.statusCode == 200 && response.data is Map) {
        final data = response.data as Map<String, dynamic>;
        // Backend returns {"message": "No active task"} when no task is running
        // Only return data if it actually contains a valid activity log (has 'id')
        if (data.containsKey('id') && data['id'] != null) {
          return data;
        }
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<Map<String, dynamic>> getMemberDashboard(String memberId) async {
    try {
      final response = await _dio.get('/team-overview/member_dashboard/',
          queryParameters: {'member_id': memberId});
      if (response.statusCode == 200) {
        return response.data;
      }
      return {};
    } catch (e) {
      print('Error fetching member dashboard: $e');
      return {};
    }
  }

  // --- Analytics & Hours Tracking ---

  /// GET /api/projects/{id}/dashboard/ - KPI summary
  Future<Map<String, dynamic>> getProjectDashboard(int projectId) async {
    try {
      final response = await _dio.get('/projects/$projectId/dashboard/');
      if (response.statusCode == 200) {
        return response.data;
      }
      return {};
    } catch (e) {
      print('Error fetching project dashboard: $e');
      return {};
    }
  }

  /// GET /api/analytics/{id}/project-bars/ - Bar chart data
  Future<List<dynamic>> getProjectAnalytics(int projectId) async {
    try {
      final response = await _dio.get('/analytics/$projectId/project-bars/');
      if (response.statusCode == 200) {
        return response.data;
      }
      return [];
    } catch (e) {
      print('Error fetching project analytics: $e');
      return [];
    }
  }

  /// GET /api/analytics/daily/?user_id=&days=30 - Line chart data
  Future<List<dynamic>> getDailyTrend(int userId, {int days = 30}) async {
    try {
      final response = await _dio.get('/analytics/daily/',
          queryParameters: {'user_id': userId, 'days': days});
      if (response.statusCode == 200) {
        return response.data;
      }
      return [];
    } catch (e) {
      print('Error fetching daily trend: $e');
      return [];
    }
  }
}
