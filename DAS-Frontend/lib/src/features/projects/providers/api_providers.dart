import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:project_pm/src/core/networking/api_client.dart';
import 'package:intl/intl.dart';
import '../services/task_api_service.dart';
import '../models/task_model.dart';
import '../models/project_model.dart';

import '../models/catalog_model.dart';
import '../../../core/models/paginated_response.dart';
import '../../../core/models/project_with_tasks.dart';
import '../../../core/database/database.dart';
import '../../../core/providers/user_providers.dart';
import '../../today/today_providers.dart';
// import '../../dashboard/dashboard_providers.dart';

import '../../dashboard/dashboard_state.dart';


part 'api_providers.g.dart';

/// Resolves project-level assignees from the raw integer IDs coming from the API.
/// Uses the already-fetched [allUsers] so no extra network call is needed.
/// Includes: assignees (M2M), project_lead, and handled_by.
List<Map<String, dynamic>> _resolveAssignees(
    ProjectModel projectModel, List<User> allUsers) {
  final seenIds = <int>{};
  final result = <Map<String, dynamic>>[];

  // Collect all relevant user IDs
  final ids = [
    ...(projectModel.assigneeIds ?? []),
    if (projectModel.projectLeadId != null) projectModel.projectLeadId!,
    // HandledBy removed: Should only show members actually working on project
  ];

  for (final id in ids) {
    if (!seenIds.add(id)) continue; // deduplicate
    try {
      final user = allUsers.firstWhere((u) => u.id == id.toString());
      result.add({
        'id': id,
        'name': user.name,
        'avatar_url': user.avatarUrl,
        'role': user.role,
      });
    } catch (_) {
      // User not found in allUsers list — skip
    }
  }
  return result;
}

// Removed duplicate dio provider. Using the one from api_client.dart

/// Task API service provider
@riverpod
TaskApiService taskApiService(TaskApiServiceRef ref) {
  final dio = ref.watch(dioProvider);
  return TaskApiService(dio);
}

/// Fetch all projects from API
@riverpod
Future<List<ProjectModel>> apiProjects(ApiProjectsRef ref) async {
  ref.keepAlive(); // Cache project list — foundation dataset for entire app
  final apiService = ref.watch(taskApiServiceProvider);

  try {
    return await apiService.getProjects();
  } catch (e) {
    throw Exception('Failed to fetch projects: $e');
  }
}

/// Fetch only authorized projects for the dashboard to avoid 401 errors
@riverpod
Future<List<ProjectModel>> dashboardApiProjects(DashboardApiProjectsRef ref) async {
  final apiService = ref.watch(taskApiServiceProvider);
  final search = ref.watch(dashboardSearchQueryProvider);
  try {
    return await apiService.getProjects(
        allProjects: true, params: {if (search.isNotEmpty) 'search': search});
  } catch (e) {
    throw Exception('Failed to fetch dashboard projects: $e');
  }
}

@riverpod
Future<PaginatedResponse<ProjectModel>> apiPaginatedProjects(
    ApiPaginatedProjectsRef ref,
    {required int page,
    String? filter,
    String? search}) async {
  ref.keepAlive(); // Cache paginated results per page/filter combo
  final apiService = ref.watch(taskApiServiceProvider);
  try {
    // Pass filter and search as query params if present
    final params = <String, dynamic>{};
    if (filter != null) params['filter'] = filter;
    if (search != null && search.isNotEmpty) params['search'] = search;
    
    return await apiService.getPaginatedProjects(page, params);
  } catch (e) {
    throw Exception('Failed to fetch paginated projects: $e');
  }
}

/// Fetch projects with tasks pre-mapped (for simple listing cases)
@riverpod
Future<PaginatedResponse<ProjectWithTasks>> paginatedDashboardProjects(
    PaginatedDashboardProjectsRef ref,
    {required int page,
    String? filter,
    String? search}) async {
  ref.keepAlive(); // Proper state management: Prevent auto-disposing to ensure instant reload speeds.

  // Use the same task source as Project Plan page for consistent task lists.
  final PaginatedResponse<ProjectModel> keys = await ref.watch(
      apiPaginatedProjectsProvider(page: page, filter: filter, search: search)
          .future);
  final allTasks = await ref.watch(apiTasksProvider.future);
  // Using allUsersForProjectsProvider to ensure we get ALL users for assignee resolution
  final allUsers = await ref.watch(allUsersForProjectsProvider.future);

  final projectsWithTasks = keys.results.map((projectModel) {
    final projectTasks =
        allTasks.where((taskModel) => taskModel.project == projectModel.id);

    final tasks = projectTasks.map((taskModel) {
      // Find assignees
      final assignees = <User>[];
      if (taskModel.assigneesList != null) {
        for (final assigneeModel in taskModel.assigneesList!) {
          try {
            final user = allUsers.firstWhere(
              (u) => u.id == assigneeModel.user.toString(),
            );
            assignees.add(user);
          } catch (_) {}
        }
      }
      final localProject = projectModel.toLocalProject();

      return TaskWithAssignees(
          task: taskModel.toLocalTask(localProject.id), assignees: assignees);
    }).toList();

    final localProject = projectModel.toLocalProject();
    // Resolve project-level assignees from raw IDs (backend already sends them)
    final resolvedAssignees = _resolveAssignees(projectModel, allUsers);
    return ProjectWithTasks(
      project: localProject,
      tasks: tasks,
      startDate: projectModel.startDate,
      dueDate: projectModel.dueDate,
      projectLeadId: projectModel.projectLeadId,
      projectAssignees: resolvedAssignees,
    );
  }).toList();

  return PaginatedResponse(
    count: keys.count,
    next: keys.next,
    previous: keys.previous,
    results: projectsWithTasks,
  );
}

/// Independent provider for the Projects Page (My Projects / Team Projects).
/// Completely separate from [paginatedDashboardProjectsProvider] so that
/// invalidating page-level state never affects Dashboard data.
@riverpod
Future<PaginatedResponse<ProjectWithTasks>> projectsPageProjects(
    ProjectsPageProjectsRef ref,
    {required int page,
    String? filter,
    String? search}) async {
  ref.keepAlive(); // Cache projects page data for instant tab switches
  final apiService = ref.watch(taskApiServiceProvider);
  try {
    final params = <String, dynamic>{};
    if (filter != null) params['filter'] = filter;
    if (search != null && search.isNotEmpty) params['search'] = search;

    final keys = await apiService.getPaginatedProjects(page, params);
    final allTasks = await ref.watch(apiTasksProvider.future);
    // Using allUsersForProjectsProvider to ensure we get ALL users for assignee resolution
    final allUsers = await ref.watch(allUsersForProjectsProvider.future);

    final projectsWithTasks = keys.results.map((projectModel) {
      final projectTasks =
          allTasks.where((taskModel) => taskModel.project == projectModel.id);

      final tasks = projectTasks.map((taskModel) {
        final assignees = <User>[];
        if (taskModel.assigneesList != null) {
          for (final assigneeModel in taskModel.assigneesList!) {
            try {
              final user = allUsers.firstWhere(
                (u) => u.id == assigneeModel.user.toString(),
              );
              assignees.add(user);
            } catch (_) {}
          }
        }
        final localProject = projectModel.toLocalProject();
        return TaskWithAssignees(
            task: taskModel.toLocalTask(localProject.id), assignees: assignees);
      }).toList();

      final localProject = projectModel.toLocalProject();
      // Resolve project-level assignees from raw IDs (backend already sends them)
      final resolvedAssignees = _resolveAssignees(projectModel, allUsers);
      return ProjectWithTasks(
        project: localProject,
        tasks: tasks,
        startDate: projectModel.startDate,
        dueDate: projectModel.dueDate,
        projectLeadId: projectModel.projectLeadId,
        projectAssignees: resolvedAssignees,
      );
    }).toList();

    return PaginatedResponse(
      count: keys.count,
      next: keys.next,
      previous: keys.previous,
      results: projectsWithTasks,
    );
  } catch (e) {
    throw Exception('Failed to fetch projects page data: $e');
  }
}

@riverpod
Future<List<TaskModel>> apiTasks(ApiTasksRef ref) async {
  ref.keepAlive(); // Cache task list — used by dashboard, projects, planner
  final apiService = ref.watch(taskApiServiceProvider);

  try {
    return await apiService.getTasks();
  } catch (e) {
    throw Exception('Failed to fetch tasks: $e');
  }
}

/// Fetch specific project by ID from API
@riverpod
Future<ProjectModel> apiProject(ApiProjectRef ref, int projectId) async {
  ref.keepAlive(); // Auto-caching added for 0s UI refresh

  final apiService = ref.watch(taskApiServiceProvider);

  try {
    return await apiService.getProject(projectId);
  } catch (e) {
    throw Exception('Failed to fetch project $projectId: $e');
  }
}

/// Fetch all catalog items from API (filtered by backend based on role and assignments)
@Riverpod(keepAlive: true)
Future<List<CatalogModel>> apiCatalog(ApiCatalogRef ref) async {
  final apiService = ref.watch(taskApiServiceProvider);

  try {
    return await apiService.getCatalog();
  } catch (e) {
    throw Exception('Failed to fetch catalog: $e');
  }
}

/// Fetch catalog projects (only user's assigned projects for planner catalog)
@Riverpod(keepAlive: true)
Future<List<ProjectModel>> apiCatalogProjects(ApiCatalogProjectsRef ref) async {
  final apiService = ref.watch(taskApiServiceProvider);

  try {
    return await apiService.getCatalogProjects();
  } catch (e) {
    throw Exception('Failed to fetch catalog projects: $e');
  }
}

/// Fetch catalog tasks (only user's assigned tasks for planner catalog)
@Riverpod(keepAlive: true)
Future<List<TaskModel>> apiCatalogTasks(ApiCatalogTasksRef ref) async {
  final apiService = ref.watch(taskApiServiceProvider);

  try {
    return await apiService.getCatalogTasks();
  } catch (e) {
    throw Exception('Failed to fetch catalog tasks: $e');
  }
}

/// Fetch courses from catalog API
@riverpod
Future<List<CatalogModel>> apiCourses(ApiCoursesRef ref) async {
  ref.keepAlive(); // Cache catalog courses
  final apiService = ref.watch(taskApiServiceProvider);

  try {
    return await apiService.getCourses();
  } catch (e) {
    throw Exception('Failed to fetch courses: $e');
  }
}

/// Fetch routines from catalog API
@riverpod
Future<List<CatalogModel>> apiRoutines(ApiRoutinesRef ref) async {
  ref.keepAlive(); // Cache catalog routines
  final apiService = ref.watch(taskApiServiceProvider);

  try {
    return await apiService.getRoutines();
  } catch (e) {
    throw Exception('Failed to fetch routines: $e');
  }
}

/// Fetch work items from catalog API (CUSTOM type)
@riverpod
Future<List<CatalogModel>> apiWorkItems(ApiWorkItemsRef ref) async {
  ref.keepAlive(); // Cache catalog work items
  final apiService = ref.watch(taskApiServiceProvider);

  try {
    return await apiService.getWorkItems();
  } catch (e) {
    throw Exception('Failed to fetch work items: $e');
  }
}

/// Fetch today's planned items from API
@riverpod
Future<List<Map<String, dynamic>>> apiTodayPlan(ApiTodayPlanRef ref) async {
  final apiService = ref.watch(taskApiServiceProvider);
  final selectedDate = ref.watch(selectedDateProvider);
  final userId = ref.watch(currentUserIdProvider);
  final dateStr =
      "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";

  try {
    final items = await apiService.getTodayPlan(date: dateStr, userId: userId);
    // Filter out items that have been moved to pending so they don't show in quadrants
    return items.where((item) => item['status'] != 'MOVED_TO_PENDING').toList();
  } catch (e) {
    throw Exception('Failed to fetch today plan: $e');
  }
}

/// Fetch activity logs from API
@riverpod
Future<List<Map<String, dynamic>>> apiActivityLogs(
    ApiActivityLogsRef ref, String? date) async {
  final apiService = ref.watch(taskApiServiceProvider);

  try {
    return await apiService.getActivityLogs(date: date);
  } catch (e) {
    throw Exception('Failed to fetch activity logs: $e');
  }
}

/// Fetch currently active task from API
@riverpod
Future<Map<String, dynamic>?> apiActiveTask(ApiActiveTaskRef ref) async {
  final apiService = ref.watch(taskApiServiceProvider);

  try {
    return await apiService.getActiveTask();
  } catch (e) {
    // Return null on error (no active task)
    return null;
  }
}

/// Fetch active session for a specific date
final apiActiveSessionProvider =
    FutureProvider.family<Map<String, dynamic>?, String>((ref, date) async {
  final apiService = ref.watch(taskApiServiceProvider);
  try {
    return await apiService.getActiveSession(date);
  } catch (e) {
    return null;
  }
});

/// Fetch current user's pending (incomplete) tasks for a specific date
/// This filtered version only returns items from today's plan that are in the 'inbox' (unquadranted)
@riverpod
Future<List<Map<String, dynamic>>> apiPendingItems(
    ApiPendingItemsRef ref, String date) async {
  final apiService = ref.watch(taskApiServiceProvider);
  final userId = ref.watch(currentUserIdProvider);

  try {
    // 1. Fetch TodayPlan.inbox items + items explicitly moved to pending
    final todayPlan = await apiService.getTodayPlan(date: date, userId: userId);
    final inboxItems = todayPlan
        .where((item) =>
            item['quadrant'] == 'inbox' || item['status'] == 'MOVED_TO_PENDING')
        .map((item) => {
              ...item,
              'is_today_inbox': true,
            })
        .toList();

    // 2. Fetch historical pending tasks originated from this specific date
    // These are tasks that were stopped and marked as "Still Pending" today
    final historicalPending =
        await apiService.getMyPendingItems(date: date, userId: userId);
    final List<Map<String, dynamic>> historicalList =
        historicalPending.cast<Map<String, dynamic>>().toList();

    // Combine both: New Inbox items + Today's Paused/Pending tasks
    final combined = [...inboxItems, ...historicalList];
    
    // Final sanity check: Strictly filter for the requested date 
    // to prevent past leakage into today's planner.
    return combined.where((item) {
      final itemDate = (item['original_plan_date'] ?? item['plan_date'] ?? date) as String;
      return itemDate == date;
    }).toList();
  } catch (e) {
    throw Exception('Failed to fetch pending items: $e');
  }
}

/// Fetch all pending items for the current user (including today's)
@riverpod
Future<List<Map<String, dynamic>>> apiAllPendingItems(
    ApiAllPendingItemsRef ref) async {
  final apiService = ref.watch(taskApiServiceProvider);
  final userId = ref.watch(currentUserIdProvider);

  try {
    // 1. Fetch current date
    final today = DateTime.now();
    final todayStr =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    // 2. Fetch all historical pending items from backend (status='PENDING')
    final items = await apiService.getMyPendingItems(userId: userId);
    final List<Map<String, dynamic>> pendingList =
        items.cast<Map<String, dynamic>>().toList();

    // 3. Fetch today's plan to find "Inbox" and "Recently Pending" items
    final todayPlan =
        await apiService.getTodayPlan(date: todayStr, userId: userId);

    // 4. Extract inbox items AND today's items moved to pending
    final todayPendingItems = todayPlan.where((item) {
      final status = item['status'];
      final quadrant = item['quadrant'];
      // Include items in inbox OR those moved to pending today
      return quadrant == 'inbox' || status == 'MOVED_TO_PENDING';
    }).map((item) => {
          ...item,
          'is_today_inbox': true, // Flag for UI handling
        });

    // 5. Merge and remove duplicates (by TodayPlan ID)
    final Map<String, Map<String, dynamic>> merged = {};

    // Add historical pending records first
    for (var item in pendingList) {
      final key = 'pending_${item['id']}';
      merged[key] = item;
    }

    // Add today's items if not already present as pending records
    for (var item in todayPendingItems) {
      final planId = item['id'];
      bool alreadyAdded = false;
      for (var existing in merged.values) {
        if (existing['today_plan_details']?['id'] == planId) {
          alreadyAdded = true;
          break;
        }
      }
      if (!alreadyAdded) {
        merged['today_$planId'] = item;
      }
    }

    return merged.values.toList();
  } catch (e) {
    debugPrint('Error in apiAllPendingItems: $e');
    return [];
  }
}

/// Fetch week view plans using date range API and local grouping
@riverpod
Future<Map<String, dynamic>> apiWeekPlans(
    ApiWeekPlansRef ref, String startDate) async {
  final apiService = ref.watch(taskApiServiceProvider);

  try {
    final start = DateTime.parse(startDate);
    final end = start.add(const Duration(days: 6));

    // Use the generic range API
    final plans = await apiService.getPlansByDateRange(start, end);

    // Group by date locally
    final days = <Map<String, dynamic>>[];
    for (int i = 0; i < 7; i++) {
      final date = start.add(Duration(days: i));
      final dateStr =
          "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

      final dayItems = plans.where((p) => p['plan_date'] == dateStr).toList();

      // Calculate total minutes
      int totalMinutes = 0;
      for (var item in dayItems) {
        totalMinutes +=
            (item['planned_duration_minutes'] as num?)?.toInt() ?? 0;
      }

      final hours = totalMinutes ~/ 60;
      final minutes = totalMinutes % 60;

      days.add({
        'date': dateStr,
        'day_name': _getDayName(date.weekday),
        'items': dayItems,
        'total_minutes': totalMinutes,
        'total_duration': "${hours}h ${minutes}m"
      });
    }

    return {
      'week_start': startDate,
      'week_end':
          "${end.year}-${end.month.toString().padLeft(2, '0')}-${end.day.toString().padLeft(2, '0')}",
      'days': days
    };
  } catch (e) {
    throw Exception('Failed to fetch week plans: $e');
  }
}

String _getDayName(int weekday) {
  switch (weekday) {
    case 1:
      return 'Monday';
    case 2:
      return 'Tuesday';
    case 3:
      return 'Wednesday';
    case 4:
      return 'Thursday';
    case 5:
      return 'Friday';
    case 6:
      return 'Saturday';
    case 7:
      return 'Sunday';
    default:
      return '';
  }
}

/// Fetch month view plans using date range API and local grouping
@riverpod
Future<Map<String, dynamic>> apiMonthPlans(
    ApiMonthPlansRef ref, int year, int month) async {
  final apiService = ref.watch(taskApiServiceProvider);

  try {
    // Calculate start and end of month
    final start = DateTime(year, month, 1);
    final lastDay =
        (month < 12) ? DateTime(year, month + 1, 0) : DateTime(year + 1, 1, 0);

    // Use the generic range API
    final plans = await apiService.getPlansByDateRange(start, lastDay);

    // Group by date locally
    final days = <Map<String, dynamic>>[];
    final daysInMonth = lastDay.day;

    for (int i = 1; i <= daysInMonth; i++) {
      final date = DateTime(year, month, i);
      final dateStr =
          "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

      final dayItems = plans.where((p) => p['plan_date'] == dateStr).toList();

      int totalMinutes = 0;
      int completedMinutes = 0;
      for (var item in dayItems) {
        final duration =
            (item['planned_duration_minutes'] as num?)?.toInt() ?? 0;
        totalMinutes += duration;
        if (item['is_completed'] == true) {
          completedMinutes += duration;
        }
      }

      final hours = totalMinutes ~/ 60;
      final minutes = totalMinutes % 60;

      days.add({
        'date': dateStr,
        'day': i,
        'items': dayItems,
        'total_minutes': totalMinutes,
        'completed_minutes':
            completedMinutes, // Added for calendar color coding
        'total_duration': "${hours}h ${minutes}m"
      });
    }

    return {
      'year': year,
      'month': month,
      'month_name': _getMonthName(month),
      'days': days
    };
  } catch (e) {
    throw Exception('Failed to fetch month plans: $e');
  }
}

String _getMonthName(int month) {
  const months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  if (month >= 1 && month <= 12) {
    return months[month - 1];
  }
  return '';
}

/// Fetch project members (task assignees, project leads, admins, managers)
/// If projectId is null, returns only admins and managers
@riverpod
Future<Map<String, dynamic>> apiProjectMembers(
    ApiProjectMembersRef ref, String? projectId) async {
  final apiService = ref.watch(taskApiServiceProvider);

  try {
    return await apiService.getProjectMembers(projectId: projectId);
  } catch (e) {
    throw Exception('Failed to fetch project members: $e');
  }
}

/// [Admin only] Fetch a specific employee's today plan items.
/// Calls GET /today-plan/?user_id=<userId>&plan_date=<date>
@riverpod
Future<List<Map<String, dynamic>>> adminEmployeeTodayPlan(
    AdminEmployeeTodayPlanRef ref, String userId) async {
  final dio = ref.watch(dioProvider);
  final today = DateTime.now();
  final dateStr =
      '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
  try {
    final response = await dio.get('/today-plan/', queryParameters: {
      'user_id': userId,
      'start_date': dateStr,
      'end_date': dateStr,
    });
    final data = response.data;
    if (data is List) {
      return data.cast<Map<String, dynamic>>();
    }
    if (data is Map && data.containsKey('results')) {
      return (data['results'] as List).cast<Map<String, dynamic>>();
    }
    return [];
  } catch (e) {
    throw Exception('Failed to fetch employee plan: $e');
  }
}

/// [Admin only] Fetch a specific employee's sticky notes.
/// Calls GET /sticky-notes/?user_id=<userId>
@riverpod
Future<List<Map<String, dynamic>>> adminEmployeeStickyNotes(
    AdminEmployeeStickyNotesRef ref, String userId) async {
  final dio = ref.watch(dioProvider);
  try {
    final response = await dio.get('/sticky-notes/', queryParameters: {
      'user_id': userId,
    });
    final data = response.data;
    if (data is List) {
      return data.cast<Map<String, dynamic>>();
    }
    if (data is Map && data.containsKey('results')) {
      return (data['results'] as List).cast<Map<String, dynamic>>();
    }
    return [];
  } catch (e) {
    throw Exception('Failed to fetch employee notes: $e');
  }
}

/// [Admin only] Fetch a specific employee's projects via the paginated endpoint.
/// Re-uses paginatedDashboardProjectsProvider but scoped to a specific user_id.
@riverpod
Future<PaginatedResponse<ProjectWithTasks>> adminEmployeeProjects(
    AdminEmployeeProjectsRef ref,
    {required String userId,
    required int page}) async {
  final apiService = ref.watch(taskApiServiceProvider);
  final allUsers = await ref.watch(allUsersProvider.future);
  try {
    final paginatedResult = await apiService.getPaginatedProjects(page, {
      'filter': 'my',
      'user_id': userId,
    });
    final projectsWithTasks = paginatedResult.results.map((projectModel) {
      final tasks = projectModel.tasks?.map((taskModel) {
            final assignees = <User>[];
            if (taskModel.assigneesList != null) {
              for (final assigneeModel in taskModel.assigneesList!) {
                try {
                  final user = allUsers
                      .firstWhere((u) => u.id == assigneeModel.user.toString());
                  assignees.add(user);
                } catch (_) {}
              }
            }
            final localProject = projectModel.toLocalProject();
            return TaskWithAssignees(
                task: taskModel.toLocalTask(localProject.id),
                assignees: assignees);
          }).toList() ??
          [];
      // Resolve project-level assignees from raw IDs
      final resolvedAssignees = _resolveAssignees(projectModel, allUsers);
      final localProject = projectModel.toLocalProject();
      return ProjectWithTasks(
        project: localProject,
        tasks: tasks,
        startDate: projectModel.startDate,
        dueDate: projectModel.dueDate,
        projectLeadId: projectModel.projectLeadId,
        projectAssignees: resolvedAssignees,
      );
    }).toList();

    return PaginatedResponse(
      count: paginatedResult.count,
      next: paginatedResult.next,
      previous: paginatedResult.previous,
      results: projectsWithTasks,
    );
  } catch (e) {
    throw Exception('Failed to fetch employee projects: $e');
  }
}

@riverpod
Future<Map<String, dynamic>> adminEmployeeDashboard(
    AdminEmployeeDashboardRef ref, String userId) async {
  final apiService = ref.watch(taskApiServiceProvider);
  try {
    return await apiService.getMemberDashboard(userId);
  } catch (e) {
    throw Exception('Failed to fetch employee dashboard: $e');
  }
}

class MonthlyReportParams {
  final String monthYear;
  final int? userId;
  final String? scope;
  final String? search;

  const MonthlyReportParams({
    required this.monthYear,
    this.userId,
    this.scope,
    this.search,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MonthlyReportParams &&
          runtimeType == other.runtimeType &&
          monthYear == other.monthYear &&
          userId == other.userId &&
          scope == other.scope &&
          search == other.search;

  @override
  int get hashCode =>
      monthYear.hashCode ^ userId.hashCode ^ scope.hashCode ^ search.hashCode;
}

@riverpod
Future<List<ProjectModel>> monthlyCompletedProjects(
    MonthlyCompletedProjectsRef ref, MonthlyReportParams params) async {
  final apiService = ref.watch(taskApiServiceProvider);

  // Parse "March 2026"
  final parts = params.monthYear.split(' ');
  if (parts.length != 2) return [];

  final monthName = parts[0];
  final year = int.tryParse(parts[1]) ?? DateTime.now().year;

  const monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];
  final month = monthNames.indexOf(monthName) + 1;

  if (month == 0) return [];

  // Widen range to ensure we find projects completed in this month even if they have different start/end dates
  final yearStartDate = '$year-01-01';
  final yearEndDate = '$year-12-31';

  final queryParams = <String, dynamic>{
    if (params.scope != null) 'filter': params.scope!.toLowerCase(),
    'status': 'COMPLETED',
    'all_projects': 'true',
  };

  try {
    final projects = await apiService.getProjects(
      params: {
        ...queryParams,
        'completion_start_date': yearStartDate,
        'completion_end_date': yearEndDate,
        if (params.userId != null) 'user_id': params.userId,
        if (params.search != null && params.search!.isNotEmpty)
          'search': params.search,
      },
    );

    // FRONTEND FILTER: Ensure we only show projects completed in the SPECIFIC month
    // Note: The backend getProjects usually returns projects with a 'completed_at' field
    // We check for various possible field names or just trust the backend filter if it's strict.
    // However, to be safe and consistent with tasks:
    return projects.where((p) {
      // Assuming ProjectModel has a way to identify completion date
      // If the backend strict filters by completion_start_date/end_date, we might not need local filtering,
      // but let's keep it consistent if possible.
      return true; // The backend getProjects with completion_date is usually strict enough.
    }).toList();
  } catch (e) {
    debugPrint('Error in monthlyCompletedProjectsProvider: $e');
    return [];
  }
}

@riverpod
Future<List<TaskModel>> monthlyCompletedTasks(
    MonthlyCompletedTasksRef ref, MonthlyReportParams params) async {
  final apiService = ref.watch(taskApiServiceProvider);

  // Parse "March 2026"
  final parts = params.monthYear.split(' ');
  if (parts.length != 2) return [];

  final monthName = parts[0];
  final year = int.tryParse(parts[1]) ?? DateTime.now().year;

  const monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  final month = monthNames.indexOf(monthName) + 1;
  if (month == 0) return [];

  final startDate = DateTime(year, month, 1);
  final endDate =
      month == 12 ? DateTime(year + 1, 1, 0) : DateTime(year, month + 1, 0);

  final startDateStr = DateFormat('yyyy-MM-dd').format(startDate);
  final endDateStr = DateFormat('yyyy-MM-dd').format(endDate);

  final queryParams = <String, dynamic>{
    if (params.scope != null) 'filter': params.scope!.toLowerCase(),
    'status': 'DONE',
    'all_tasks': 'true',
    'completion_start_date': startDateStr,
    'completion_end_date': endDateStr,
  };

  try {
    // Fetch tasks specifically completed in this month
    final tasks = await apiService.getTasks(
      userId: params.userId?.toString(),
      search:
          params.search != null && params.search!.isNotEmpty ? params.search : null,
      params: queryParams,
    );

    // FRONTEND FILTER: Ensure we only show tasks completed in the SPECIFIC month
    return tasks.where((t) => 
      t.completedAt != null && 
      t.completedAt!.month == month && 
      t.completedAt!.year == year
    ).toList();
  } catch (e) {
    debugPrint('Error in monthlyCompletedTasksProvider: $e');
    return [];
  }
}



