import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:project_pm/src/features/dashboard/dashboard_repository.dart';
import 'package:project_pm/src/features/dashboard/dashboard_service.dart';
import '../../core/database/database_provider.dart';
import '../../core/database/database.dart'; // User model
import '../../core/models/project_with_tasks.dart';
import '../projects/providers/api_providers.dart';
import '../../core/providers/user_providers.dart'; // allUsersProvider

part 'dashboard_providers.g.dart';

@riverpod
DashboardRepository dashboardRepository(DashboardRepositoryRef ref) {
  final db = ref.watch(databaseProvider);
  final api = ref.watch(taskApiServiceProvider);
  return DashboardRepository(db, api);
}

@riverpod
Future<List<ProjectWithTasks>> dashboardProjects(
    DashboardProjectsRef ref) async {
  // Keep alive to completely eliminate 15 second dashboard UI navigation or refresh delay securely
  ref.keepAlive();

  // Always try to fetch real data from API first
  try {
    debugPrint('🔍 Dashboard: Fetching projects, tasks and users in parallel...');

    // FETCH IN PARALLEL for maximum speed
    final results = await Future.wait([
      ref.watch(dashboardApiProjectsProvider.future),
      ref.watch(apiTasksProvider.future),
      ref.watch(allUsersForProjectsProvider.future),
    ]);

    final apiProjects = results[0] as List; // Expected List<ProjectModel>
    final apiTasks = results[1] as List; // Expected List<TaskModel>
    final allUsers = results[2] as List<User>;

    debugPrint(
        '✅ Dashboard: Parallel fetch complete (${apiProjects.length} projects, ${apiProjects.length} tasks)');

    // Group tasks by project
    final projectsWithTasks = <ProjectWithTasks>[];

    for (final dynamic apiProject in apiProjects) {
      // Convert API project to local Project model
      // We assume apiProject has toLocalProject() method as per previous logic
      final project = apiProject.toLocalProject();

      // Find all tasks for this project
      final projectTasks = apiTasks
          .where((task) => task.project == apiProject.id)
          .map((dynamic apiTask) {
        final localTask = apiTask.toLocalTask(project.id);

        // Map API assignees to local User objects
        final assignees = <User>[];
        if (apiTask.assigneesList != null) {
          for (final assigneeModel in apiTask.assigneesList!) {
            try {
              final user = allUsers.firstWhere(
                (u) => u.id == assigneeModel.user.toString(),
              );
              assignees.add(user);
            } catch (_) {
              // User not found in local list
            }
          }
        }

        return TaskWithAssignees(
          task: localTask,
          assignees: assignees,
        );
      }).toList();

      projectsWithTasks.add(ProjectWithTasks(
        project: project,
        tasks: projectTasks,
        startDate: DateTime.tryParse(apiProject.startDate),
        dueDate: DateTime.tryParse(apiProject.dueDate),
        projectLeadId: apiProject.projectLeadId,
        projectAssignees: apiProject.projectAssignees,
      ));
    }

    debugPrint(
        '🎉 Dashboard: Successfully loaded ${projectsWithTasks.length} projects');
    return projectsWithTasks;
  } catch (e) {
    debugPrint('❌ Error fetching projects from API: $e');
    rethrow;
  }
}

/// Provider to fetch ALL projects with filter (for dashboard stats)
/// This ensures stats reflect the entire dataset, not just the current page
@riverpod
Future<List<ProjectWithTasks>> filteredDashboardStats(
    FilteredDashboardStatsRef ref,
    {required String filter}) async {
  ref.keepAlive(); // Sustain dashboard cache locally for 0s UI renders
  final apiService = ref.watch(taskApiServiceProvider);
  // Using allUsersForProjectsProvider to ensure we get ALL users for assignee resolution
  final allUsers = await ref.watch(allUsersForProjectsProvider.future);
  final dateRange = ref.watch(dashboardDateRangeProvider);

  try {
    // Fetch all projects with filter (no pagination)
    final projectModels = await apiService.getProjects(
      params: {'filter': filter},
      startDate: dateRange?.start.toIso8601String().split('T')[0],
      endDate: dateRange?.end.toIso8601String().split('T')[0],
      allProjects: true, // Fetch all authorized projects to ensure correct stats
    );

    return projectModels.map((projectModel) {
      final tasks = projectModel.tasks?.map((taskModel) {
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
              task: taskModel.toLocalTask(localProject.id),
              assignees: assignees,
            );
          }).toList() ??
          [];

      final localProject = projectModel.toLocalProject();
      return ProjectWithTasks(
        project: localProject,
        tasks: tasks,
        startDate: DateTime.tryParse(projectModel.startDate),
        dueDate: DateTime.tryParse(projectModel.dueDate),
        projectLeadId: projectModel.projectLeadId,
        projectAssignees: projectModel.projectAssignees,
      );
    }).toList();
  } catch (e) {
    debugPrint('Error fetching dashboard stats: $e');
    return [];
  }
}

/// Selected user ID for project work statistics
/// By default, NO user is selected to allow "Select User" dropdown hint.
final selectedStatsUserIdProvider = StateProvider<int?>((ref) => null);

/// Options: 'all', 'today', 'week', 'month'
final selectedStatsPeriodProvider = StateProvider<String>((ref) => 'month');

/// Dashboard Date Range Filter for Overview Stats
/// If null, it shows absolute total/overall data
final dashboardDateRangeProvider = StateProvider<DateTimeRange?>((ref) => null);

/// Selected project ID for project work statistics
final selectedStatsProjectIdProvider = StateProvider<int?>((ref) => null);

/// State providers for Project Working Report section
final workingReportScopeProvider = StateProvider<String>((ref) => 'My');
final workingReportViewProvider = StateProvider<String>((ref) => 'Projects');
final workingReportYearProvider = StateProvider<int>((ref) => DateTime.now().year);

/// Selected month string for drill-down project detail (e.g., 'March 2026')
/// If null, the chart is shown. If not null, the project list is shown.
final workingReportDetailMonthProvider = StateProvider<String?>((ref) => null);

/// Type of drill-down content: 'Projects', 'Tasks', or 'Hours'
final workingReportDrillDownTypeProvider = StateProvider<String>((ref) => 'Projects');


/// Provider for fetching users list for stats dropdown
@riverpod
Future<List<dynamic>> usersForStats(UsersForStatsRef ref) async {
  ref.keepAlive(); // Cache user list for stats dropdown
  final apiService = ref.watch(taskApiServiceProvider);
  try {
    return await apiService.getUsersForStats();
  } catch (e) {
    print('Error fetching users for stats: $e');
    return [];
  }
}

/// Provider for fetching project work statistics
@riverpod
Future<Map<String, dynamic>> projectWorkStats(
  ProjectWorkStatsRef ref,
) async {
  final selectedUserId = ref.watch(selectedStatsUserIdProvider);
  
  // We fetch results even if no user is selected to show project totals.
  // The API service handles null userId by summing across all users.

  // NEW: Prioritize the global dashboard date range if set
  final globalDateRange = ref.watch(dashboardDateRangeProvider);
  
  String? startDate;
  String? endDate;

  if (globalDateRange != null) {
    startDate = globalDateRange.start.toIso8601String().split('T')[0];
    endDate = globalDateRange.end.toIso8601String().split('T')[0];
  } else {
    // Fallback to the local period selector if no global filter is active
    final period = ref.watch(selectedStatsPeriodProvider);
    final now = DateTime.now();
    
    if (period == 'today') {
      startDate = now.toIso8601String().split('T')[0];
      endDate = startDate;
    } else if (period == 'week') {
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      startDate = startOfWeek.toIso8601String().split('T')[0];
    } else if (period == 'month') {
      startDate = DateTime(now.year, now.month, 1).toIso8601String().split('T')[0];
    }
  }

  final apiService = ref.watch(taskApiServiceProvider);
  final selectedProjectId = ref.watch(selectedStatsProjectIdProvider);

  try {
    return await apiService.getProjectWorkStats(
      selectedUserId,
      startDate: startDate,
      endDate: endDate,
      projectId: selectedProjectId,
    );
  } catch (e) {
    debugPrint('Error fetching project work stats: $e');
    return {'projects': [], 'user': null};
  }
}

/// Provider for fetching user-specific projects for the stats dropdown
@riverpod
Future<List<dynamic>> statsProjects(StatsProjectsRef ref) async {
  final selectedUserId = ref.watch(selectedStatsUserIdProvider);
  final apiService = ref.watch(taskApiServiceProvider);
  try {
    // If no user is selected, return ALL projects for the dropdown.
    // If a user is selected, return only THEIR assigned projects.
    final projects = await apiService.getProjects(
      params: {
        if (selectedUserId != null) 'user_id': selectedUserId,
        if (selectedUserId != null) 'filter': 'my',
      },
      allProjects: false, // Dashboard dropdown should only show allowed projects
    );

    // Map to simple JSON format if needed, though ProjectModel might be fine
    return projects.map((p) => {
      'id': p.id,
      'name': p.name,
    }).toList();
  } catch (e) {
    debugPrint('Error fetching specific projects for user $selectedUserId: $e');
    return [];
  }
}

class ProjectChartParams {
  final int year;
  final String filter;
  final int? userId;
  ProjectChartParams({required this.year, required this.filter, this.userId});
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProjectChartParams &&
          year == other.year &&
          filter == other.filter &&
          userId == other.userId;
  @override
  int get hashCode => year.hashCode ^ filter.hashCode ^ userId.hashCode;
}

@riverpod
Future<Map<String, dynamic>> projectCompletionChart(
    ProjectCompletionChartRef ref, ProjectChartParams params) async {
  try {
    final repo = ref.watch(dashboardRepositoryProvider);
    return await repo.fetchProjectCompletionChart(params.year, params.filter, params.userId);
  } catch (e) {
    debugPrint('❌ Error in projectCompletionChart: $e');
    return {'data': []};
  }
}

class TaskChartParams {
  final String startDate;
  final String endDate;
  final String filter;
  final int? userId;

  TaskChartParams(
      {required this.startDate, required this.endDate, required this.filter, this.userId});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskChartParams &&
          runtimeType == other.runtimeType &&
          startDate == other.startDate &&
          endDate == other.endDate &&
          filter == other.filter &&
          userId == other.userId;

  @override
  int get hashCode => startDate.hashCode ^ endDate.hashCode ^ filter.hashCode ^ userId.hashCode;
}

@riverpod
Future<Map<String, dynamic>> taskCompletionChart(
    TaskCompletionChartRef ref, TaskChartParams params) async {
  try {
    final repo = ref.watch(dashboardRepositoryProvider);
    return await repo.fetchTaskCompletionChart(
        params.startDate, params.endDate, params.filter, params.userId);
  } catch (e) {
    debugPrint('❌ Error in taskCompletionChart: $e');
    return {'data': []};
  }
}

@riverpod
Future<List<dynamic>> hoursCompletionChart(
    HoursCompletionChartRef ref, ProjectChartParams params) async {
  try {
    final repo = ref.watch(dashboardRepositoryProvider);
    return await repo.fetchHoursCompletionChart(params.year, params.filter, params.userId);
  } catch (e) {
    debugPrint('❌ Error in hoursCompletionChart: $e');
    return [];
  }
}

@riverpod
DashboardService dashboardService(DashboardServiceRef ref) {
  return DashboardService();
}

@riverpod
Future<DashboardMetrics> dashboardMetrics(DashboardMetricsRef ref) async {
  ref.keepAlive(); // Cache dashboard metrics for instant rebuilds
  try {
    final projects = await ref.watch(dashboardProjectsProvider.future);
    final service = ref.watch(dashboardServiceProvider);
    final repo = ref.watch(dashboardRepositoryProvider);

    // Fetch team stats with error handling
    TeamActivityStats? teamStats;
    try {
      teamStats = await repo.fetchTeamActivityStats();
    } catch (e) {
      // If team stats fail, continue with null
      teamStats = null;
    }

    // Fetch recent activities with error handling
    List<RecentActivity> recentActivities = [];
    try {
      recentActivities = await repo.fetchRecentActivities();
    } catch (e) {
      // If recent activities fail, continue with empty list
      recentActivities = [];
    }

    return DashboardMetrics(
      risks: service.analyzeRisks(projects),
      focusItems: service.identifyFocusItems(projects),
      totalProjects: projects.length,
      teamStats: teamStats,
      recentActivities: recentActivities,
    );
  } catch (e) {
    // If everything fails, return empty metrics
    return DashboardMetrics(
      risks: [],
      focusItems: [],
      totalProjects: 0,
      teamStats: null,
      recentActivities: [],
    );
  }
}

/// Provider for project-specific KPI summary
final projectDashboardAnalyticsProvider =
    FutureProvider.family<Map<String, dynamic>, int>((ref, projectId) async {
  final apiService = ref.watch(taskApiServiceProvider);
  return apiService.getProjectDashboard(projectId);
});

/// Provider for project-specific bar chart data
final projectBarsAnalyticsProvider =
    FutureProvider.family<List<dynamic>, int>((ref, projectId) async {
  final apiService = ref.watch(taskApiServiceProvider);
  return apiService.getProjectAnalytics(projectId);
});

/// Provider for user daily trend line chart
final dailyTrendAnalyticsProvider =
    FutureProvider.family<List<dynamic>, int>((ref, userId) async {
  final apiService = ref.watch(taskApiServiceProvider);
  return apiService.getDailyTrend(userId);
});

class DashboardMetrics {
  final List<Risk> risks;
  final List<FocusItem> focusItems;

  final int totalProjects;
  final TeamActivityStats? teamStats;
  final List<RecentActivity> recentActivities;

  DashboardMetrics({
    required this.risks,
    required this.focusItems,
    required this.totalProjects,
    this.teamStats,
    this.recentActivities = const [],
  });
}
