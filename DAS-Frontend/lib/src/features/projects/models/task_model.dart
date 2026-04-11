import 'dart:convert';
import '../../../core/database/database.dart';

class TaskModel {
  final int id;
  final String title;
  final int? project;
  final String? projectName;
  final int? projectLead;
  final String? taskType;
  final String priority;
  final String status;
  final DateTime? startDate;
  final DateTime dueDate;
  final DateTime? nextOccurrence;
  final String? recurrencePattern;
  final String? githubLink;
  final String? figmaLink;
  final DateTime? completedAt;
  final DateTime createdAt;
  final int? progress;
  final List<SubTaskModel>? subtasks;
  final List<TaskAssigneeModel>? assigneesList;
  final String? rejectionReason;
  final String? approvalStatus;
  final double plannedHours;

  TaskModel({
    required this.id,
    required this.title,
    this.project,
    this.projectName,
    this.projectLead,
    this.taskType,
    required this.priority,
    required this.status,
    this.startDate,
    required this.dueDate,
    this.nextOccurrence,
    this.recurrencePattern,
    this.githubLink,
    this.figmaLink,
    this.completedAt,
    required this.createdAt,
    this.progress,
    this.subtasks,
    this.assigneesList,
    this.rejectionReason,
    this.approvalStatus,
    this.plannedHours = 0.0,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] is int
          ? json['id']
          : int.parse(json['id']
              .toString()
              .split('/')
              .lastWhere((e) => e.isNotEmpty, orElse: () => '0')),
      title: json['title']?.toString() ?? '',
      project: json['project'] is int
          ? json['project']
          : (json['project'] != null
              ? int.tryParse(json['project']
                  .toString()
                  .split('/')
                  .lastWhere((e) => e.isNotEmpty, orElse: () => '0'))
              : null),
      projectName: json['project_name']?.toString(),
      projectLead: json['project_lead'] is int
          ? json['project_lead']
          : (json['project_lead'] != null
              ? int.tryParse(json['project_lead'].toString())
              : null),
      taskType: json['task_type']?.toString(),
      priority: json['priority']?.toString() ?? 'MEDIUM',
      status: json['status']?.toString() ?? 'PENDING',
      startDate: json['start_date'] != null
          ? DateTime.tryParse(json['start_date'].toString())
          : null,
      dueDate: DateTime.tryParse(json['due_date'].toString()) ?? DateTime.now(),
      nextOccurrence: json['next_occurrence'] != null
          ? DateTime.tryParse(json['next_occurrence'].toString())
          : null,
      recurrencePattern: json['recurrence_pattern']?.toString(),
      githubLink: json['github_link']?.toString(),
      figmaLink: json['figma_link']?.toString(),
      completedAt: json['completed_at'] != null
          ? DateTime.tryParse(json['completed_at'].toString())
          : null,
      createdAt:
          DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now(),
      progress: json['progress'] is int
          ? json['progress']
          : (json['progress'] != null
              ? int.tryParse(json['progress'].toString())
              : null),
      subtasks: (json['subtasks'] as List<dynamic>?)
          ?.map((e) => SubTaskModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      assigneesList: (json['assignees_list'] as List<dynamic>?)
          ?.map((e) => TaskAssigneeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      rejectionReason: json['rejection_reason']?.toString(),
      approvalStatus: json['approval_status']?.toString(),
      plannedHours: (json['planned_hours'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'project': project,
      'project_name': projectName,
      'project_lead': projectLead,
      'task_type': taskType,
      'priority': priority,
      'status': status,
      'start_date': startDate?.toIso8601String(),
      'due_date': dueDate.toIso8601String(),
      'next_occurrence': nextOccurrence?.toIso8601String(),
      'recurrence_pattern': recurrencePattern,
      'github_link': githubLink,
      'figma_link': figmaLink,
      'completed_at': completedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'progress': progress,
      'subtasks': subtasks?.map((e) => e.toJson()).toList(),
      'assignees_list': assigneesList?.map((e) => e.toJson()).toList(),
      'rejection_reason': rejectionReason,
      'approval_status': approvalStatus,
    };
  }

  /// Convert to local database Task model
  Task toLocalTask(String projectId) {
    // Convert subtasks to milestones JSON format
    String milestonesJson = '[]';
    if (subtasks != null && subtasks!.isNotEmpty) {
      final milestones = subtasks!
          .map((subtask) => {
                'id': 'milestone_${subtask.id}',
                'name': subtask.title,
                'completed': subtask.status == 'DONE',
                'weight': subtask.progressWeight,
                'completedBy': subtask.completedByName,
                'completedByAvatar': subtask.completedByAvatar,
                'completedById': subtask.completedBy?.toString(),
              })
          .toList();
      milestonesJson = jsonEncode(milestones);
    }

    // Convert assignees to JSON list of IDs
    String assigneesJson = '[]';
    if (assigneesList != null && assigneesList!.isNotEmpty) {
      final ids = assigneesList!.map((a) => a.user.toString()).toList();
      assigneesJson = jsonEncode(ids);
    }

    // Use API-computed progress if available, otherwise derive from status
    int progressVal = progress ?? 0;
    if (progress == null) {
      if (status == 'DONE' || status == 'COMPLETED') {
        progressVal = 100;
      } else if (status == 'IN_PROGRESS') {
        progressVal = 50;
      } else if (status == 'PENDING_APPROVAL') {
        progressVal = 100;
      } else {
        progressVal = 0;
      }
    }

    String? displayApprovalStatus = approvalStatus?.toLowerCase();

    // Fallback logic or overrides based on status
    if (status == 'DONE' || status == 'COMPLETED') {
      displayApprovalStatus = 'approved';
    } else if (displayApprovalStatus == null) {
      if (status == 'PENDING_APPROVAL') {
        displayApprovalStatus = 'pending_completion';
      } else if (status == 'REJECTED') {
        displayApprovalStatus = 'rejected';
      }
    }

    return Task(
      id: 'api_project_task_$id',
      name: title,
      projectId: projectId,
      progress: progressVal,
      priority: priority,
      startDate: startDate ?? DateTime.now(),
      endDate: dueDate,
      assigneesJson: assigneesJson,
      milestonesJson: milestonesJson,
      approvalStatus: displayApprovalStatus,
      githubLink: githubLink,
      figmaLink: figmaLink,
      taskType: taskType ?? 'standard',
      recurrencePattern: recurrencePattern,
      nextOccurrence: nextOccurrence,
      rejectionReason: rejectionReason,
      plannedHours: plannedHours,
    );
  }
}

class SubTaskModel {
  final int id;
  final String title;
  final String status;
  final int progressWeight;
  final String dueDate;
  final String? completedByName;
  final String? completedByAvatar;
  final int? completedBy;

  const SubTaskModel({
    required this.id,
    required this.title,
    required this.status,
    required this.progressWeight,
    required this.dueDate,
    this.completedByName,
    this.completedByAvatar,
    this.completedBy,
  });

  factory SubTaskModel.fromJson(Map<String, dynamic> json) {
    return SubTaskModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      title: json['title']?.toString() ?? '',
      status: json['status']?.toString() ?? 'PENDING',
      progressWeight: json['progress_weight'] is int
          ? json['progress_weight']
          : int.tryParse(json['progress_weight']?.toString() ?? '25') ?? 25,
      dueDate: json['due_date']?.toString() ?? '',
      completedByName: json['completed_by_name']?.toString(),
      completedByAvatar: json['completed_by_avatar']?.toString(),
      completedBy: json['completed_by'] is int ? json['completed_by'] : int.tryParse(json['completed_by']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'status': status,
      'progress_weight': progressWeight,
      'due_date': dueDate,
      'completed_by_name': completedByName,
      'completed_by_avatar': completedByAvatar,
      'completed_by': completedBy,
    };
  }
}

class TaskAssigneeModel {
  final int id;
  final int user; // User ID
  final String userEmail;
  final String role;

  const TaskAssigneeModel({
    required this.id,
    required this.user,
    required this.userEmail,
    required this.role,
  });

  factory TaskAssigneeModel.fromJson(Map<String, dynamic> json) {
    return TaskAssigneeModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      user: json['user'] is int
          ? json['user']
          : int.tryParse(json['user']?.toString() ?? '0') ?? 0,
      userEmail: json['user_email']?.toString() ?? '',
      role: json['role']?.toString() ?? 'DEV',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user,
      'user_email': userEmail,
      'role': role,
    };
  }
}
