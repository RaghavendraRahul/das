import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
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
  return ProjectRepository(db, apiService);
}

@riverpod
Future<ProjectWithTasks?> currentProject(CurrentProjectRef ref) async {
  ref.keepAlive(); // Cache current project for instant tab switches

  final selectedId = ref.watch(selectedProjectIdProvider);

  // Use the API-backed projects instead of the local database watch.
  final allProjects = await ref.watch(projectsWithTasksProvider.future);

  if (selectedId != null) {
    try {
      return allProjects.firstWhere((p) => p.project.id == selectedId);
    } catch (_) {
      return null; // Not found
    }
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

      // Skip projects with no tasks for better UX (especially for employees)
      // They can see the project exists, but can't plan tasks they don't have access to
      if (projectTasks.isEmpty) {
        continue; // Don't add projects with no accessible tasks
      }

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
        startDate: DateTime.tryParse(project.startDate),
        dueDate: DateTime.tryParse(project.dueDate),
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
