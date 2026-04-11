import 'package:freezed_annotation/freezed_annotation.dart';

part 'catalog_model.freezed.dart';
part 'catalog_model.g.dart';

@freezed
class CatalogItem with _$CatalogItem {
  const factory CatalogItem({
    required int id,
    @JsonKey(name: 'user_email') required String userEmail,
    @JsonKey(name: 'project_name') String? projectName,
    @JsonKey(name: 'task_title') String? taskTitle,
    @JsonKey(name: 'instructor_email') String? instructorEmail,
    required String name,
    required String description,
    @JsonKey(name: 'catalog_type') required String catalogType,
    @JsonKey(name: 'estimated_hours') required String estimatedHours,
    @JsonKey(name: 'progress_percentage') required int progressPercentage,
    @JsonKey(name: 'is_active') required bool isActive,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    required int user,
    int? project,
    int? task,
  }) = _CatalogItem;

  factory CatalogItem.fromJson(Map<String, dynamic> json) =>
      _$CatalogItemFromJson(json);
}

@freezed
class CreateCatalogRequest with _$CreateCatalogRequest {
  const factory CreateCatalogRequest({
    required String name,
    required String description,
    @JsonKey(name: 'catalog_type') required String catalogType,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
  }) = _CreateCatalogRequest;

  factory CreateCatalogRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateCatalogRequestFromJson(json);
}
