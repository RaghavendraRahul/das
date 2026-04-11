// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CatalogItemImpl _$$CatalogItemImplFromJson(Map<String, dynamic> json) =>
    _$CatalogItemImpl(
      id: (json['id'] as num).toInt(),
      userEmail: json['user_email'] as String,
      projectName: json['project_name'] as String?,
      taskTitle: json['task_title'] as String?,
      instructorEmail: json['instructor_email'] as String?,
      name: json['name'] as String,
      description: json['description'] as String,
      catalogType: json['catalog_type'] as String,
      estimatedHours: json['estimated_hours'] as String,
      progressPercentage: (json['progress_percentage'] as num).toInt(),
      isActive: json['is_active'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      user: (json['user'] as num).toInt(),
      project: (json['project'] as num?)?.toInt(),
      task: (json['task'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$CatalogItemImplToJson(_$CatalogItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_email': instance.userEmail,
      'project_name': instance.projectName,
      'task_title': instance.taskTitle,
      'instructor_email': instance.instructorEmail,
      'name': instance.name,
      'description': instance.description,
      'catalog_type': instance.catalogType,
      'estimated_hours': instance.estimatedHours,
      'progress_percentage': instance.progressPercentage,
      'is_active': instance.isActive,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'user': instance.user,
      'project': instance.project,
      'task': instance.task,
    };

_$CreateCatalogRequestImpl _$$CreateCatalogRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateCatalogRequestImpl(
      name: json['name'] as String,
      description: json['description'] as String,
      catalogType: json['catalog_type'] as String,
      isActive: json['is_active'] as bool? ?? true,
    );

Map<String, dynamic> _$$CreateCatalogRequestImplToJson(
        _$CreateCatalogRequestImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'catalog_type': instance.catalogType,
      'is_active': instance.isActive,
    };
