// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProjectModel _$ProjectModelFromJson(Map<String, dynamic> json) => ProjectModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      status: json['status'] as String,
      startDate: json['start_date'] as String,
      dueDate: json['due_date'] as String,
      description: json['description'] as String,
      workingHours: (json['working_hours'] as num).toInt(),
      createDate: json['create_date'] as String,
      duration: (json['duration'] as num).toInt(),
      completedDate: json['completed_date'] as String?,
      isApproved: json['is_approved'] as bool,
      approvalStatus: json['approval_status'] as String?,
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
      rejectionReason: json['rejection_reason'] as String?,
      plannedHours: (json['planned_hours'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$ProjectModelToJson(ProjectModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'status': instance.status,
      'start_date': instance.startDate,
      'due_date': instance.dueDate,
      'description': instance.description,
      'working_hours': instance.workingHours,
      'create_date': instance.createDate,
      'duration': instance.duration,
      'completed_date': instance.completedDate,
      'is_approved': instance.isApproved,
      'approval_status': instance.approvalStatus,
      'tasks': instance.tasks,
      'project_assignees': instance.projectAssignees,
      'rejection_reason': instance.rejectionReason,
      'planned_hours': instance.plannedHours,
      'assignees': instance.assigneeIds,
      'project_lead': instance.projectLeadId,
      'handled_by': instance.handledById,
    };
