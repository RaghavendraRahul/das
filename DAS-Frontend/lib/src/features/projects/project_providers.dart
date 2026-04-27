import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/foundation.dart';
import '../../core/database/database.dart';
import '../../core/database/database_provider.dart';
import 'project_repository.dart';
import '../../core/models/project_with_tasks.dart';
import 'providers/api_providers.dart';
import '../../core/providers/user_providers.dart';
import 'models/task_model.dart';

part 'project_providers.g.dart';

/// Selected project ID - set when user clicks a project card
final selectedProjectIdProvider = StateProvider<String?>((ref) => null);

@riverpod
ProjectRepository projectRepository(ProjectRepositoryRef ref) {
  final db = ref.watch(databaseProvider);
  final apiService = ref.watch(taskApiServiceProvider);
  return ProjectRepository(db, apiService, ref);
}

@riverpod
Future<ProjectWithTasks?> currentProject(CurrentProjectRef ref) async {
  ref.keepAlive(); // Cache current project for instant tab switches

  final selectedId = ref.watch(selectedProjectIdProvider);

  // 1. Try to find in the cached full projects list
  final allProjects = await ref.watch(projectsWithTasksProvider.future);

  if (selectedId != null) {
    final cached =
        allProjects.where((p) => p.project.id == selectedId).firstOrNull;
    if (cached != null) return cached;

    // 2. If not in cached list, fetch specifically from API
    if (selectedId.startsWith('api_project_')) {
      final rawIdStr = selectedId.replaceFirst('api_project_', '');
      final rawId = int.tryParse(rawIdStr);
      if (rawId != null) {
        try {
          final projectModel = await ref.read(apiProjectProvider(rawId).future);
          final allTasks = await ref.read(apiTasksProvider.future);
          final allUsers = await ref.read(allUsersForProjectsProvider.future);

          final projectTasks = allTasks.where((t) => t.project == rawId);
          final localProject = projectModel.toLocalProject();

          final tasks = projectTasks.map((taskModel) {
            final assignees = <User>[];
            if (taskModel.assigneesList != null) {
              for (final a in taskModel.assigneesList!) {
                try {
                  assignees.add(
                      allUsers.firstWhere((u) => u.id == a.user.toString()));
                } catch (_) {}
              }
            }
            return TaskWithAssignees(
                task: taskModel.toLocalTask(localProject.id),
                assignees: assignees);
          }).toList();

          return ProjectWithTasks(
            project: localProject,
            tasks: tasks,
            startDate: projectModel.startDate,
            dueDate: projectModel.dueDate,
            projectLeadId: projectModel.projectLeadId,
            projectAssignees: projectModel.projectAssignees ?? [],
          );
        } catch (e) {
          debugPrint('❌ Error fetching individual project ($rawId): $e');
        }
      }
    }
    return null; // Not found anywhere
  }

  // If no project is selected, return the first available project
  if (allProjects.isEmpty) return null;
  return allProjects.first;
}

/// All projects with tasks for Activity Catalog
/// Uses apiTasksProvider which already returns tasks WITH subtasks (via TaskSerializer)
@riverpod
Future<List<ProjectWithTasks>> projectsWithTasks(
    ProjectsWithTasksRef ref) async {
  // Keep alive — re-fetching all projects+tasks is expensive and undesirable on every module switch
  ref.keepAlive();
  try {
    // Fetch projects and tasks from API
    final projects = await ref.watch(apiProjectsProvider.future);
    final tasks = await ref.watch(apiTasksProvider.future);
    // Fetch all users for assignee lookup - Use allUsersForProjectsProvider to get everyone
    final allUsers = await ref.watch(allUsersForProjectsProvider.future);
    final userMap = {for (var u in allUsers) u.id: u};

    // Group tasks by project ID - show ALL tasks for projects user has access to
    final Map<int, List<TaskModel>> tasksByProject = {};
    for (final task in tasks) {
      if (task.project != null) {
        tasksByProject.putIfAbsent(task.project!, () => []).add(task);
      }
    }

    // Convert to ProjectWithTasks
    final List<ProjectWithTasks> result = [];
    for (final project in projects) {
      final projectTasks = tasksByProject[project.id] ?? [];

      final localProject = project.toLocalProject();

      final tasksWithAssignees = projectTasks.map((task) {
        List<User> assignees = [];
        if (task.assigneesList != null) {
          assignees = task.assigneesList!
              .map((a) => userMap[a.user.toString()])
              .whereType<User>()
              .toList();
        }

        return TaskWithAssignees(
          task: task.toLocalTask(localProject.id),
          assignees: assignees,
        );
      }).toList();

      result.add(ProjectWithTasks(
        project: localProject,
        tasks: tasksWithAssignees,
        startDate: project.startDate,
        dueDate: project.dueDate,
        projectLeadId: project.projectLeadId,
        projectAssignees: project.projectAssignees ?? [],
      ));
    }

    return result;
  } catch (e) {
    rethrow;
  }
}

@riverpod
Stream<List<Project>> pendingProjects(PendingProjectsRef ref) {
  return ref.watch(projectRepositoryProvider).watchPendingProjects();
}

@riverpod
Stream<List<Project>> pendingProjectClosures(PendingProjectClosuresRef ref) {
  return ref.watch(projectRepositoryProvider).watchPendingProjectClosures();
}

@riverpod
Stream<List<TaskWithProject>> pendingNewTasks(PendingNewTasksRef ref) {
  return ref.watch(projectRepositoryProvider).watchPendingNewTasks();
}

@riverpod
Stream<List<TaskWithProject>> pendingTaskCompletions(
    PendingTaskCompletionsRef ref) {
  return ref.watch(projectRepositoryProvider).watchPendingTaskCompletions();
}

@riverpod
Stream<List<ActivityTemplate>> pendingTemplates(PendingTemplatesRef ref) {
  // If we want API for templates, add check here. For now defaulting to local DB
  final db = ref.watch(databaseProvider);
  return (db.select(db.activityTemplates)
        ..where((t) => t.status.equals('pending')))
      .watch();
}

/// ============================================================================
/// Project Analytics Providers - for hours breakdown with cascading filters
/// ============================================================================

/// Selected project ID for analytics view
final selectedAnalyticsProjectIdProvider = StateProvider<int?>((ref) => null);

/// Selected employee ID for analytics view
final selectedAnalyticsEmployeeIdProvider = StateProvider<int?>((ref) => null);

/// Fetches project analytics hours with optional project and employee filters
/// DEDICATED provider for analytics - does NOT use dashboard's date filters
@riverpod
Future<Map<String, dynamic>> analyticsData(AnalyticsDataRef ref) async {
  final apiService = ref.watch(taskApiServiceProvider);
  final currentUserAsync = ref.watch(currentUserProvider);
  final currentUserIdStr = currentUserAsync.valueOrNull?.id;
  final currentUserId =
      currentUserIdStr != null ? int.tryParse(currentUserIdStr) : null;
  final selectedProjectId = ref.watch(selectedAnalyticsProjectIdProvider);
  final selectedEmployeeId = ref.watch(selectedAnalyticsEmployeeIdProvider);

  debugPrint('');
  debugPrint('🔄╔════════════════════════════════════════════════════════════');
  debugPrint('🔄║ [ANALYTICS PROVIDER] analyticsData()');
  debugPrint('🔄║ CURRENT STATE:');
  debugPrint('🔄║   User ID: $currentUserId');
  debugPrint('🔄║   Project ID: $selectedProjectId  ← WATCH THIS');
  debugPrint('🔄║   Employee ID: $selectedEmployeeId  ← WATCH THIS');
  debugPrint('🔄╚════════════════════════════════════════════════════════════');
  debugPrint('');

  try {
    final data = await apiService.getProjectAnalyticsHours(
      userId: currentUserId,
      projectId: selectedProjectId,
      employeeId: selectedEmployeeId,
    );
    debugPrint('✅ Analytics Provider: Data fetched successfully');
    return data;
  } catch (e) {
    debugPrint('❌ Analytics Provider: Error $e');
    return {
      'dropdowns': {},
      'tasks': [],
      'totals': {'planned_hours': 0, 'achieved_hours': 0},
    };
  }
}

/// Fetch all approved clients for project/routine creation
@riverpod
Future<List<Map<String, dynamic>>> approvedClients(
    ApprovedClientsRef ref) async {
  final apiService = ref.watch(taskApiServiceProvider);

  try {
    return await apiService.getApprovedClients();
  } catch (e) {
    debugPrint('❌ Error fetching approved clients: $e');
    return [];
  }
}

