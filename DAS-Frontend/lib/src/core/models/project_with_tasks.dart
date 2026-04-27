import 'package:project_pm/src/core/database/database.dart';

// hydrated model
class ProjectWithTasks {
  final Project project;
  final List<TaskWithAssignees> tasks;
  final DateTime? startDate;
  final DateTime? dueDate;

  /// Project-level assignees from Projects.assignees M2M (id, name, avatar_url)
  final List<Map<String, dynamic>> projectAssignees;
  final int? projectLeadId;

  final DateTime? completedDate;

  ProjectWithTasks({
    required this.project,
    required this.tasks,
    this.startDate,
    this.dueDate,
    this.completedDate,
    this.projectLeadId,
    List<Map<String, dynamic>>? projectAssignees,
  }) : projectAssignees = projectAssignees ?? [];

  // Helper to match React's "status" logic if needed
  // Case-insensitive status mapping for backend compatibility (ACTIVE, active, etc.)
  bool get isActive => project.status.toLowerCase() == 'active' || project.status.toLowerCase() == 'ongoing';
  bool get isCompleted => project.status.toLowerCase() == 'completed' || project.status.toLowerCase() == 'done';
}

class TaskWithAssignees {
  final Task task;
  final List<User> assignees;

  TaskWithAssignees({required this.task, required this.assignees});

  double get progress => task.progress.toDouble();
  DateTime get endDate => task.endDate;
}
