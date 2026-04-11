import 'package:json_annotation/json_annotation.dart';
import '../../../core/database/database.dart';
import 'task_model.dart';

part 'project_model.g.dart';

@JsonSerializable()
class ProjectModel {
  final int id;
  final String name;
  final String status;
  @JsonKey(name: 'start_date')
  final String startDate;
  @JsonKey(name: 'due_date')
  final String dueDate;
  final String description;
  @JsonKey(name: 'working_hours')
  final int workingHours;
  @JsonKey(name: 'create_date')
  final String createDate;
  final int duration;
  @JsonKey(name: 'completed_date')
  final String? completedDate;
  @JsonKey(name: 'is_approved')
  final bool isApproved;
  @JsonKey(name: 'approval_status')
  final String? approvalStatus;
  // Tasks are included when fetching project detail (not in list endpoint)
  final List<TaskModel>? tasks;
  // Project-level assignees (from Projects.assignees M2M field) — may be populated by backend
  @JsonKey(name: 'project_assignees')
  final List<Map<String, dynamic>>? projectAssignees;
  @JsonKey(name: 'rejection_reason')
  final String? rejectionReason;
  @JsonKey(name: 'planned_hours')
  final double plannedHours;

  // Raw ID fields from the API response (used for client-side user resolution)
  @JsonKey(name: 'assignees')
  final List<int>? assigneeIds;
  @JsonKey(name: 'project_lead')
  final int? projectLeadId;
  @JsonKey(name: 'handled_by')
  final int? handledById;

  const ProjectModel({
    required this.id,
    required this.name,
    required this.status,
    required this.startDate,
    required this.dueDate,
    required this.description,
    required this.workingHours,
    required this.createDate,
    required this.duration,
    this.completedDate,
    required this.isApproved,
    this.approvalStatus,
    this.tasks,
    this.projectAssignees,
    this.assigneeIds,
    this.projectLeadId,
    this.handledById,
    this.rejectionReason,
    this.plannedHours = 0.0,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) =>
      _$ProjectModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProjectModelToJson(this);

  /// Convert to local database Project model
  Project toLocalProject() {
    return Project(
      id: 'api_project_$id',
      name: name,
      context: description,
      status: status.toLowerCase(),
      approvalStatus: approvalStatus?.toLowerCase() ??
          (isApproved ? 'approved' : 'pending'),
      dueDate: DateTime.tryParse(dueDate),
      completedDate: completedDate != null ? DateTime.tryParse(completedDate!) : null,
      rejectionReason: rejectionReason,
      plannedHours: plannedHours,
    );
  }
}
