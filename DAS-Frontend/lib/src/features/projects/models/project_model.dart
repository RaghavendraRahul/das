import '../../../core/database/database.dart';
import 'task_model.dart';

/// Hydrated model for Project data fetching and storage mapping.
/// Redesigned with manual JSON parsing for maximum resilience against backend nulls/mismatches.
class ProjectModel {
  final int id;
  final String name;
  final String status;
  final DateTime? startDate;
  final DateTime? dueDate;
  final String? description;
  final int workingHours;
  final DateTime? createDate;
  final int duration;
  final DateTime? completedDate;
  final bool isApproved;
  final String? approvalStatus;

  // Tasks are included when fetching project detail (not in list endpoint)
  final List<TaskModel>? tasks;

  // Project-level assignees (M2M field) may be populated by backend
  final List<Map<String, dynamic>>? projectAssignees;

  final String? rejectionReason;
  final double plannedHours;

  // Raw ID fields from API (used for client-side resolution in Providers)
  final List<int>? assigneeIds;
  final int? projectLeadId;
  final int? handledById;

  const ProjectModel({
    required this.id,
    required this.name,
    required this.status,
    this.startDate,
    this.dueDate,
    this.description,
    this.workingHours = 0,
    this.createDate,
    this.duration = 0,
    this.completedDate,
    this.isApproved = false,
    this.approvalStatus,
    this.tasks,
    this.projectAssignees,
    this.assigneeIds,
    this.projectLeadId,
    this.handledById,
    this.rejectionReason,
    this.plannedHours = 0.0,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? 'Unnamed Project',
      status: json['status']?.toString() ?? 'ACTIVE',
      startDate: json['start_date'] != null
          ? DateTime.tryParse(json['start_date'].toString())
          : null,
      dueDate: json['due_date'] != null
          ? DateTime.tryParse(json['due_date'].toString())
          : (json['deadline'] != null
              ? DateTime.tryParse(json['deadline'].toString())
              : null),
      description:
          json['description']?.toString() ?? json['context']?.toString(),
      workingHours: (json['working_hours'] as num?)?.toInt() ?? 0,
      createDate: json['create_date'] != null
          ? DateTime.tryParse(json['create_date'].toString())
          : null,
      duration: (json['duration'] as num?)?.toInt() ?? 0,
      completedDate: json['completed_date'] != null
          ? DateTime.tryParse(json['completed_date'].toString())
          : null,
      isApproved: json['is_approved'] == true ||
          json['approval_status']?.toString().toLowerCase() == 'approved',
      approvalStatus: json['approval_status']?.toString(),
      tasks: (json['tasks'] as List<dynamic>?)
          ?.map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      projectAssignees: (json['project_assignees'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      assigneeIds: (json['assignees'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      projectLeadId: (json['project_lead'] as num?)?.toInt(),
      handledById: (json['handled_by'] as num?)?.toInt(),
      rejectionReason: json['rejection_reason']?.toString(),
      plannedHours: (json['planned_hours'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'start_date': startDate?.toIso8601String(),
      'due_date': dueDate?.toIso8601String(),
      'description': description,
      'working_hours': workingHours,
      'create_date': createDate?.toIso8601String(),
      'duration': duration,
      'completed_date': completedDate?.toIso8601String(),
      'is_approved': isApproved,
      'approval_status': approvalStatus,
      'tasks': tasks?.map((e) => e.toJson()).toList(),
      'project_assignees': projectAssignees,
      'assignees': assigneeIds,
      'project_lead': projectLeadId,
      'handled_by': handledById,
      'rejection_reason': rejectionReason,
      'planned_hours': plannedHours,
    };
  }

  /// Convert to local database Project model
  Project toLocalProject() {
    return Project(
      id: 'api_project_$id',
      name: name,
      context: description ?? '',
      status: status.toLowerCase(),
      approvalStatus: approvalStatus?.toLowerCase() ??
          (isApproved ? 'approved' : 'pending'),
      dueDate: dueDate,
      completedDate: completedDate,
      rejectionReason: rejectionReason,
      plannedHours: plannedHours,
    );
  }
}
