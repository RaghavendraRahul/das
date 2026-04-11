import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart';
import 'package:rxdart/rxdart.dart';
import '../../core/database/database.dart';
import '../../core/models/project_with_tasks.dart';
import '../../core/models/milestone.dart';
import 'services/task_api_service.dart';

class ProjectRepository {
  final AppDatabase _db;
  final TaskApiService? _apiService;

  ProjectRepository(this._db, [this._apiService]);

  Stream<ProjectWithTasks?> watchProject(String projectId) {
    // Start watching the local database immediately.
    // Riverpod and Drift will handle the reactivity when the tasks table changes.

    final projectStream = (_db.select(_db.projects)
          ..where((p) => p.id.equals(projectId)))
        .watchSingleOrNull();

    return projectStream.switchMap((project) {
      if (project == null) return Stream.value(null);

      return (_db.select(_db.tasks)
            ..where((t) => t.projectId.equals(projectId)))
          .watch()
          .switchMap((tasks) => Stream.fromFuture(_hydrateTasks(tasks)))
          .map((tasksWithAssignees) => ProjectWithTasks(
                project: project,
                tasks: tasksWithAssignees,
              ));
    });
  }

  Future<List<TaskWithAssignees>> _hydrateTasks(List<Task> tasks) async {
    if (tasks.isEmpty) return [];

    // Fetch all users for lookup
    final allUsers = await _db.select(_db.users).get();
    final userMap = {for (var u in allUsers) u.id: u};

    return tasks.map((task) {
      // Parse assigneesJson
      List<String> assigneeIds = [];
      try {
        assigneeIds = List<String>.from(jsonDecode(task.assigneesJson) as List);
      } catch (_) {
        // invalid json or empty
      }

      final assignees =
          assigneeIds.map((id) => userMap[id]).whereType<User>().toList();

      return TaskWithAssignees(task: task, assignees: assignees);
    }).toList();
  }

  Future<void> updateTaskMilestones(String taskId, List<Milestone> milestones,
      {int? progressFromBackend}) async {
    // On web, skip local DB writes - API handles persistence
    if (kIsWeb) return;

    final jsonStr = jsonEncode(milestones.map((m) => m.toJson()).toList());
    final progress = progressFromBackend ?? _calculateProgress(milestones);

    await (_db.update(_db.tasks)..where((t) => t.id.equals(taskId))).write(
      TasksCompanion(
        milestonesJson: Value(jsonStr),
        progress: Value(progress),
        approvalStatus: const Value(null),
      ),
    );
  }

  int _calculateProgress(List<Milestone> milestones) {
    if (milestones.isEmpty) return 0;
    int completedWeight = milestones
        .where((m) => m.completed)
        .fold(0, (sum, m) => sum + m.weight);
    return completedWeight > 100 ? 100 : completedWeight;
  }

  Future<void> updateProject(ProjectsCompanion project) async {
    await (_db.update(_db.projects)
          ..where((p) => p.id.equals(project.id.value)))
        .write(project);
  }

  Future<void> updateProjectContext(String projectId, String context) async {
    await (_db.update(_db.projects)..where((p) => p.id.equals(projectId)))
        .write(
      ProjectsCompanion(context: Value(context)),
    );
  }

  Stream<List<TaskWithAssignees>> watchPendingApprovals() {
    return (_db.select(_db.tasks)
          ..where((t) => t.approvalStatus.equals('pending')))
        .watch()
        .map((tasks) => tasks
            .map((t) => TaskWithAssignees(task: t, assignees: []))
            .toList());
  }

  Future<void> createProject(ProjectsCompanion project) async {
    if (_apiService != null) {
      try {
        final data = {
          'name': project.name.value,
          'description': project.context.value,
          'status': 'ACTIVE',
          if (project.dueDate.value != null)
            'deadline':
                "${project.dueDate.value!.year}-${project.dueDate.value!.month.toString().padLeft(2, '0')}-${project.dueDate.value!.day.toString().padLeft(2, '0')}",
        };
        await _apiService!.createProject(data);
        // After API success, we might want to reload or just return
        return;
      } catch (e) {
        // Fallback or error handling
        print('API create project failed: $e');
        // We could throw here, or fall back to local if offline support is needed
        // For now, let's allow local insert as a "pending sync" state if we had one,
        // but here we just rethrow to let UI know
        rethrow;
      }
    }
    await _db.into(_db.projects).insert(project);
  }

  Future<void> createTask(TasksCompanion task) async {
    if (_apiService != null) {
      try {
        final projectIdStr = task.projectId.value;
        // Handle "api_project_X" or "X" formats
        final projectId = int.tryParse(projectIdStr) ??
            int.tryParse(projectIdStr.replaceFirst('api_project_', '')) ??
            1;

        final data = {
          'name': task.name.value,
          'priority': task.priority.value,
          'start_date': task.startDate.value.toIso8601String().substring(0, 10),
          'due_date': task.endDate.value.toIso8601String().substring(0, 10),
          'assignees': jsonDecode(task.assigneesJson.value),
          'milestones': jsonDecode(task.milestonesJson.value),
          'github_link': task.githubLink.value,
          'figma_link': task.figmaLink.value,
        };

        final type = task.taskType.value;
        if (type == 'recurring') {
          data['recurrence_pattern'] = task.recurrencePattern.value;
          data['next_occurrence'] =
              task.nextOccurrence.value?.toIso8601String().substring(0, 10);
          await _apiService!.createRecurringTask(projectId, data);
        } else if (type == 'routine') {
          await _apiService!.createRoutineTask(projectId, data);
        } else {
          // Default to standard
          await _apiService!.createTask(projectId, data);
        }
        return;
      } catch (e) {
        print('API create task failed: $e');
        rethrow;
      }
    }
    await _db.into(_db.tasks).insert(task);
  }

  Future<void> updateTask(TasksCompanion task) async {
    if (_apiService != null) {
      // Update task via API not fully implemented in this iteration
      // Just local update for now or skipping
    }
    await (_db.update(_db.tasks)..where((t) => t.id.equals(task.id.value)))
        .write(task);
  }

  /// Watch all projects with their tasks for Activity Catalog
  Stream<List<ProjectWithTasks>> watchAllProjects() {
    // Start watching the local database immediately for reactivity.
    final projectsStream = _db.select(_db.projects).watch();

    return projectsStream.switchMap((projects) {
      if (projects.isEmpty) return Stream.value(<ProjectWithTasks>[]);

      // Use the hydrate logic to get tasks and assignees for each project
      return _db.select(_db.tasks).watch().switchMap((allTasks) {
        return Stream.fromFuture(_hydrateTasks(allTasks)).map((hydratedTasks) {
          return projects.map((project) {
            final projectTasks = hydratedTasks
                .where((t) => t.task.projectId == project.id)
                .toList();

            return ProjectWithTasks(project: project, tasks: projectTasks);
          }).toList();
        });
      });
    });
  }

  // ========== APPROVAL WORKFLOWS ==========

  // ========== APPROVAL WORKFLOWS ==========

  /// Watch projects pending creation approval
  Stream<List<Project>> watchPendingProjects() {
    if (_apiService != null) {
      return Stream.fromFuture(_apiService!.getPendingProjects())
          .map((data) => data.map((item) {
                return Project(
                  id: item['approval_id'].toString(),
                  name: item['project_name'] ?? 'Unknown',
                  context: item['description'] ?? '',
                  status: item['status'] ?? 'pending',
                  approvalStatus: 'pending_creation',
                  plannedHours:
                      (item['planned_hours'] as num?)?.toDouble() ?? 0.0,
                );
              }).toList());
    }
    return (_db.select(_db.projects)
          ..where((p) => p.approvalStatus.equals('pending_creation')))
        .watch();
  }

  /// Watch projects pending completion/closure approval
  Stream<List<Project>> watchPendingProjectClosures() {
    if (_apiService != null) {
      return Stream.fromFuture(_apiService!.getPendingProjectClosures())
          .map((data) => data.map((item) {
                return Project(
                  id: item['approval_id'].toString(),
                  name: item['project_name'] ?? 'Unknown',
                  context: item['description'] ?? '',
                  status: item['current_status'] ?? 'active',
                  approvalStatus: 'pending_completion',
                  plannedHours:
                      (item['planned_hours'] as num?)?.toDouble() ?? 0.0,
                );
              }).toList());
    }
    return (_db.select(_db.projects)
          ..where((p) => p.approvalStatus.equals('pending_completion')))
        .watch();
  }

  /// Watch tasks pending creation approval (with project info)
  Stream<List<TaskWithProject>> watchPendingNewTasks() {
    if (_apiService != null) {
      return Stream.fromFuture(_apiService!.getPendingTasks())
          .map((data) => data.map((item) {
                final project = Project(
                  id: (item['project_id'] ?? 0).toString(),
                  name: item['project'] ?? 'Unknown',
                  context: '',
                  status: 'active',
                  approvalStatus: null,
                  plannedHours: 0.0,
                );

                final task = Task(
                  id: item['approval_id'].toString(),
                  projectId: project.id,
                  name: item['task_title'] ?? 'Unknown',
                  priority: item['priority'] ?? 'Medium',
                  startDate: DateTime.tryParse(item['start_date'] ?? '') ??
                      DateTime.now(),
                  endDate: DateTime.tryParse(item['due_date'] ?? '') ??
                      DateTime.now(),
                  assigneesJson: '[]',
                  milestonesJson: '[]',
                  approvalStatus: 'pending_creation',
                  taskType: 'standard',
                  progress: 0,
                  plannedHours: (item['planned_hours'] as num?)?.toDouble() ?? 0.0,
                );

                return TaskWithProject(task: task, project: project);
              }).toList());
    }
    final query = _db.select(_db.tasks).join([
      innerJoin(_db.projects, _db.projects.id.equalsExp(_db.tasks.projectId)),
    ])
      ..where(_db.tasks.approvalStatus.equals('pending_creation'));

    return query.watch().map((rows) {
      return rows.map((row) {
        return TaskWithProject(
          task: row.readTable(_db.tasks),
          project: row.readTable(_db.projects),
        );
      }).toList();
    });
  }

  /// Watch tasks pending completion approval (with project info)
  Stream<List<TaskWithProject>> watchPendingTaskCompletions() {
    if (_apiService != null) {
      return Stream.fromFuture(_apiService!.getPendingTaskCompletions())
          .map((data) => data.map((item) {
                final project = Project(
                  id: (item['project_id'] ?? 0).toString(),
                  name: item['project'] ?? 'Unknown',
                  context: '',
                  status: 'active',
                  approvalStatus: null,
                  plannedHours: 0.0,
                );

                final task = Task(
                  id: item['approval_id'].toString(),
                  projectId: project.id,
                  name: item['task_title'] ?? 'Unknown',
                  priority: item['priority'] ?? 'Medium',
                  startDate: DateTime.tryParse(item['start_date'] ?? '') ??
                      DateTime.now(),
                  endDate: DateTime.tryParse(item['due_date'] ?? '') ??
                      DateTime.now(),
                  assigneesJson: '[]',
                  milestonesJson: '[]',
                  approvalStatus: 'pending_completion',
                  taskType: 'standard',
                  progress: 100,
                  plannedHours: (item['planned_hours'] as num?)?.toDouble() ?? 0.0,
                );

                return TaskWithProject(task: task, project: project);
              }).toList());
    }
    final query = _db.select(_db.tasks).join([
      innerJoin(_db.projects, _db.projects.id.equalsExp(_db.tasks.projectId)),
    ])
      ..where(_db.tasks.approvalStatus.equals('pending_completion'));

    return query.watch().map((rows) {
      return rows.map((row) {
        return TaskWithProject(
          task: row.readTable(_db.tasks),
          project: row.readTable(_db.projects),
        );
      }).toList();
    });
  }

  // --- Approve/Reject Actions ---

  Future<void> approveProject(dynamic projectOrId) async {
    if (_apiService != null) {
      // Assuming projectOrId is a Map or object with approval_id
      final id = projectOrId is Map
          ? projectOrId['approval_id']
          : int.tryParse(projectOrId.toString());
      if (id != null) {
        await _apiService!.approveRequest(id);
        return;
      }
    }
    // Local DB fallback (id is string projectId)
    final projectId = projectOrId.toString();
    await (_db.update(_db.projects)..where((p) => p.id.equals(projectId)))
        .write(const ProjectsCompanion(approvalStatus: Value('approved')));
  }

  Future<void> rejectProject(dynamic projectOrId) async {
    if (_apiService != null) {
      final id = projectOrId is Map
          ? projectOrId['approval_id']
          : int.tryParse(projectOrId.toString());
      if (id != null) {
        await _apiService!.rejectRequest(id);
        return;
      }
    }
    final projectId = projectOrId.toString();
    await (_db.update(_db.projects)..where((p) => p.id.equals(projectId)))
        .write(const ProjectsCompanion(approvalStatus: Value('rejected')));
  }

  Future<void> approveProjectCompletion(dynamic projectOrId) async {
    if (_apiService != null) {
      final id = projectOrId is Map
          ? projectOrId['approval_id']
          : int.tryParse(projectOrId.toString());
      if (id != null) {
        await _apiService!.approveRequest(id);
        return;
      }
    }
    final projectId = projectOrId.toString();
    await (_db.update(_db.projects)..where((p) => p.id.equals(projectId)))
        .write(const ProjectsCompanion(
            approvalStatus: Value('approved'), status: Value('completed')));
  }

  Future<void> rejectProjectCompletion(dynamic projectOrId,
      {String reason = ""}) async {
    if (_apiService != null) {
      final id = projectOrId is Map
          ? projectOrId['approval_id']
          : int.tryParse(projectOrId.toString());
      if (id != null) {
        await _apiService!.rejectRequest(id, reason: reason);
        return;
      }
    }
    // Keep it open - mark as rejected for UI to show resubmit option
    final projectId = projectOrId.toString();
    await (_db.update(_db.projects)..where((p) => p.id.equals(projectId)))
        .write(ProjectsCompanion(
            approvalStatus: const Value('rejected'),
            rejectionReason: Value(reason)));
  }

  Future<void> approveTask(dynamic taskOrId) async {
    if (_apiService != null) {
      final id = taskOrId is Map
          ? taskOrId['approval_id']
          : int.tryParse(taskOrId.toString());
      if (id != null) {
        await _apiService!.approveRequest(id);
        return;
      }
    }
    final taskId = taskOrId.toString();
    await (_db.update(_db.tasks)..where((t) => t.id.equals(taskId)))
        .write(const TasksCompanion(approvalStatus: Value('approved')));
  }

  Future<void> rejectTask(dynamic taskOrId) async {
    if (_apiService != null) {
      final id = taskOrId is Map
          ? taskOrId['approval_id']
          : int.tryParse(taskOrId.toString());
      if (id != null) {
        await _apiService!.rejectRequest(id);
        return;
      }
    }
    final taskId = taskOrId.toString();
    await (_db.update(_db.tasks)..where((t) => t.id.equals(taskId)))
        .write(const TasksCompanion(approvalStatus: Value('rejected')));
  }

  Future<void> approveTaskCompletion(dynamic taskOrId) async {
    if (_apiService != null) {
      final id = taskOrId is Map
          ? taskOrId['approval_id']
          : int.tryParse(taskOrId.toString());
      if (id != null) {
        await _apiService!.approveRequest(id);
        return;
      }
    }
    final taskId = taskOrId.toString();
    await (_db.update(_db.tasks)..where((t) => t.id.equals(taskId))).write(
        const TasksCompanion(
            approvalStatus: Value('approved'), progress: Value(100)));
  }

  Future<void> rejectTaskCompletion(dynamic taskOrId, String reason) async {
    if (_apiService != null) {
      final id = taskOrId is Map
          ? taskOrId['approval_id']
          : int.tryParse(taskOrId.toString());
      if (id != null) {
        await _apiService!.rejectRequest(id, reason: reason);
        return;
      }
    }
    // Revoke completion - set back to rejected
    final taskId = taskOrId.toString();
    await (_db.update(_db.tasks)..where((t) => t.id.equals(taskId)))
        .write(TasksCompanion(
            approvalStatus: const Value('rejected'),
            rejectionReason: Value(reason)));
  }

  Future<void> reopenTask(dynamic taskOrId, String reason) async {
    final taskIdStr = taskOrId.toString();
    final id = int.tryParse(taskIdStr.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

    // For web: skip local DB writes (schema may not have rejection_reason column)
    // Just call the API directly and let provider refresh handle the UI update.
    if (kIsWeb && _apiService != null && id > 0) {
      await _apiService!.reopenTask(id, reason);
      return;
    }

    // --- OPTIMISTIC UPDATE (native only) ---
    final taskEntry = await (_db.select(_db.tasks)
          ..where((t) => t.id.equals(taskIdStr) | t.id.like('%_$id')))
        .getSingleOrNull();

    List<Milestone> milestones = [];
    if (taskEntry != null) {
      try {
        final List<dynamic> json =
            jsonDecode(taskEntry.milestonesJson) as List<dynamic>;
        milestones = json
            .map((j) => Milestone.fromJson(j as Map<String, dynamic>))
            .toList();

        // Reset all milestones using copyWith
        milestones =
            milestones.map((m) => m.copyWith(completed: false)).toList();
      } catch (_) {}
    } 

    // Set local status and progress immediately - using robust filter
    await (_db.update(_db.tasks)
          ..where((t) => t.id.equals(taskIdStr) | t.id.like('%_$id')))
        .write(TasksCompanion(
            approvalStatus: const Value('rejected'),
            rejectionReason: Value(reason),
            milestonesJson:
                Value(jsonEncode(milestones.map((m) => m.toJson()).toList())),
            progress: const Value(0)));

    // --- OPTIMISTIC PROJECT DE-COMPLETION ---
    if (taskEntry != null) {
      final projectId = taskEntry.projectId;
      final project = await (_db.select(_db.projects)
            ..where((p) => p.id.equals(projectId)))
          .getSingleOrNull();

      if (project != null &&
          (project.status.toLowerCase() == 'completed' ||
              project.approvalStatus?.toLowerCase() == 'pending_completion')) {
        await (_db.update(_db.projects)..where((p) => p.id.equals(projectId)))
            .write(const ProjectsCompanion(
          status: Value('active'),
          approvalStatus: Value('rejected'),
        ));
      }
    }

    // --- BACKGROUND API CALL ---
    if (_apiService != null && id > 0) {
      _apiService!.reopenTask(id, reason).then((_) {
      }).catchError((e) {
        print("Backend reopen failed: $e");
      });
    }
  }


  /// Request project completion - sets approval status to pending_completion
  Future<void> requestProjectCompletion(String projectId) async {
    if (_apiService != null) {
      try {
        final id = int.tryParse(projectId) ??
            int.tryParse(projectId.replaceFirst('api_project_', '')) ??
            0;
        if (id == 0) throw Exception('Invalid project ID: $projectId');

        await _apiService!.requestProjectCompletion(projectId: id);
        // Sync local status
        await (_db.update(_db.projects)..where((p) => p.id.equals(projectId)))
            .write(const ProjectsCompanion(
          approvalStatus: Value('pending_completion'),
        ));
        return;
      } catch (e) {
        print('API request project completion failed: $e');
        rethrow;
      }
    }
    await (_db.update(_db.projects)..where((p) => p.id.equals(projectId)))
        .write(const ProjectsCompanion(
      approvalStatus: Value('pending_completion'),
    ));
  }

  /// Admin bypass: directly complete project (no approval needed)
  Future<void> adminCompleteProject(String projectId) async {
    if (_apiService != null) {
      final id = int.tryParse(projectId) ??
          int.tryParse(projectId.replaceFirst('api_project_', '')) ??
          0;
      if (id > 0) await _apiService!.adminCompleteProject(projectId: id);
    }
    await (_db.update(_db.projects)..where((p) => p.id.equals(projectId)))
        .write(const ProjectsCompanion(
      status: Value('completed'),
      approvalStatus: Value(null),
    ));
  }

  /// Admin bypass: directly complete task (no approval needed)
  Future<void> adminCompleteTask(String taskId) async {
    if (_apiService != null) {
      final id = int.tryParse(taskId.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      if (id > 0) await _apiService!.adminCompleteTask(taskId: id);
    }
    await (_db.update(_db.tasks)..where((t) => t.id.equals(taskId))).write(
      const TasksCompanion(
        progress: Value(100),
        approvalStatus: Value('approved'),
      ),
    );
  }

  /// Request task completion approval - marks task as 100% and pending approval
  Future<String?> requestTaskCompletion(String taskId) async {
    if (_apiService != null) {
      try {
        final response = await _apiService!.requestTaskCompletion(
            taskId: int.parse(taskId.replaceAll(RegExp(r'[^0-9]'), '')));

        // Sync local
        await (_db.update(_db.tasks)..where((t) => t.id.equals(taskId)))
            .write(const TasksCompanion(
          approvalStatus: Value('pending_completion'),
          progress: Value(100),
        ));

        return response?['message']?.toString();
      } catch (e) {
        print('API request task completion failed: $e');
        rethrow;
      }
    }
    await (_db.update(_db.tasks)..where((t) => t.id.equals(taskId)))
        .write(const TasksCompanion(
      approvalStatus: Value('pending_completion'),
      progress: Value(100),
    ));
    return null;
  }

  /// Revoke task completion - revert to approved status with previous progress
  Future<void> revokeTaskCompletion(String taskId, int previousProgress) async {
    await (_db.update(_db.tasks)..where((t) => t.id.equals(taskId)))
        .write(TasksCompanion(
      approvalStatus: const Value('approved'),
      progress: Value(previousProgress),
    ));
  }


}

/// Model for task with its parent project
class TaskWithProject {
  final Task task;
  final Project project;

  TaskWithProject({required this.task, required this.project});
}
