import 'dart:convert';

import 'package:project_pm/src/core/database/database.dart';
import 'package:project_pm/src/core/models/project_with_tasks.dart';
import 'package:rxdart/rxdart.dart';
import 'package:project_pm/src/features/projects/services/task_api_service.dart';

class DashboardRepository {
  final AppDatabase _db;
  final TaskApiService _api;

  DashboardRepository(this._db, this._api);

  Stream<List<ProjectWithTasks>> watchProjects() {
    // Watch all relevant tables
    return _db.select(_db.projects).watch().switchMap((projects) {
      // For each update to projects, we re-query tasks and users
      // Ideally we should use joins, but for flexibility/MVP we query separately
      return Stream.fromFuture(_hydrateProjects(projects));
    });
  }

  Future<List<ProjectWithTasks>> _hydrateProjects(
      List<Project> projects) async {
    if (projects.isEmpty) return [];

    // Fetch all users for lookup
    final allUsers = await _db.select(_db.users).get();
    final userMap = {for (var u in allUsers) u.id: u};

    final result = <ProjectWithTasks>[];

    for (var project in projects) {
      // Fetch tasks for this project
      final tasks = await (_db.select(_db.tasks)
            ..where((t) => t.projectId.equals(project.id)))
          .get();

      final tasksWithAssignees = tasks.map((task) {
        // Parse assigneesJson
        List<String> assigneeIds = [];
        try {
          assigneeIds =
              List<String>.from(jsonDecode(task.assigneesJson) as List);
        } catch (_) {
          // invalid json or empty
        }

        final assignees =
            assigneeIds.map((id) => userMap[id]).whereType<User>().toList();

        return TaskWithAssignees(task: task, assignees: assignees);
      }).toList();

      result.add(ProjectWithTasks(
        project: project,
        tasks: tasksWithAssignees,
      ));
    }

    return result;
  }

  Future<List<ProjectWithTasks>> fetchProjectsWithTasks() async {
    final projects = await _db.select(_db.projects).get();
    return _hydrateProjects(projects);
  }

  Future<TeamActivityStats> fetchTeamActivityStats() async {
    try {
      final data = await _api.getTeamActivityStatus();
      return TeamActivityStats(
        totalUsers: data['total_users'] as int? ?? 0,
        filledCount: data['filled'] as int? ?? 0,
        notFilledCount: data['not_filled'] as int? ?? 0,
      );
    } catch (e) {
      print('Failed to fetch team stats from API: $e');
      // Return empty stats on error, do not fallback to local DB
      return TeamActivityStats(
        totalUsers: 0,
        filledCount: 0,
        notFilledCount: 0,
      );
    }
  }

  Future<List<RecentActivity>> fetchRecentActivities() async {
    try {
      // Fetch recent activity logs from API (limit to 5 if possible, or filter locally)
      // We use getActivityLogs which returns a list of maps
      final logs = await _api.getActivityLogs();

      // Sort by date desc and take top 5
      // Assuming 'date' or 'start_time' is available for sorting
      // The API response for activity logs usually contains:
      // id, user (obj or id), project (obj or id), task (obj or id), date, hours_worked, description, etc.

      // We need to map this to RecentActivity
      /*
      RecentActivity needs:
      final String id;
      final String title;
      final DateTime time;
      final String userAvatarUrl;
      final String userName;
      final String description;
      */

      final recentLogs = logs.take(5).toList();

      return recentLogs.map((log) {
        // Safe extraction of nested data
        final userObj = log['user'] is Map ? log['user'] : {};
        final projectObj = log['project'] is Map ? log['project'] : {};
        final taskObj = log['task'] is Map ? log['task'] : {};

        final String title =
            taskObj['name'] ?? projectObj['name'] ?? 'Work Log';
        final String userName = userObj['username'] ?? 'User';
        // Avatar might not be in the log list response, use placeholder or empty
        const String userAvatar = '';

        DateTime time = DateTime.now();
        if (log['date'] != null) {
          try {
            time = DateTime.parse(log['date'].toString());
          } catch (_) {}
        }

        return RecentActivity(
          id: log['id']?.toString() ?? '',
          title: title,
          time: time,
          userAvatarUrl: userAvatar,
          userName: userName,
          description: log['description'] ?? '',
        );
      }).toList();
    } catch (e) {
      print('Failed to fetch recent activities from API: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> fetchProjectCompletionChart(
      int year, String filter, int? userId, String? search) async {
    return _api.getProjectCompletionChart(year, filter, userId, search);
  }

  Future<Map<String, dynamic>> fetchTaskCompletionChart(
      String startDate, String endDate, String filter, int? userId,
      String? search) async {
    return _api.getTaskCompletionChart(
        startDate, endDate, filter, userId, search);
  }

  Future<List<dynamic>> fetchHoursCompletionChart(
      int year, String filter, int? userId, String? search) async {
    return _api.getHoursCompletionChart(year, filter, userId, search);
  }
}

class TeamActivityStats {
  final int totalUsers;
  final int filledCount;
  final int notFilledCount;

  TeamActivityStats({
    required this.totalUsers,
    required this.filledCount,
    required this.notFilledCount,
  });
}

class RecentActivity {
  final String id;
  final String title;
  final DateTime time;
  final String userAvatarUrl;
  final String userName;
  final String description;

  RecentActivity({
    required this.id,
    required this.title,
    required this.time,
    required this.userAvatarUrl,
    required this.userName,
    required this.description,
  });
}
