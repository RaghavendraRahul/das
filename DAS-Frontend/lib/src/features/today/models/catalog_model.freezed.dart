// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'catalog_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CatalogItem _$CatalogItemFromJson(Map<String, dynamic> json) {
  return _CatalogItem.fromJson(json);
}

/// @nodoc
mixin _$CatalogItem {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_email')
  String get userEmail => throw _privateConstructorUsedError;
  @JsonKey(name: 'project_name')
  String? get projectName => throw _privateConstructorUsedError;
  @JsonKey(name: 'task_title')
  String? get taskTitle => throw _privateConstructorUsedError;
  @JsonKey(name: 'instructor_email')
  String? get instructorEmail => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'catalog_type')
  String get catalogType => throw _privateConstructorUsedError;
  @JsonKey(name: 'estimated_hours')
  String get estimatedHours => throw _privateConstructorUsedError;
  @JsonKey(name: 'progress_percentage')
  int get progressPercentage => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;
  int get user => throw _privateConstructorUsedError;
  int? get project => throw _privateConstructorUsedError;
  int? get task => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CatalogItemCopyWith<CatalogItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CatalogItemCopyWith<$Res> {
  factory $CatalogItemCopyWith(
          CatalogItem value, $Res Function(CatalogItem) then) =
      _$CatalogItemCopyWithImpl<$Res, CatalogItem>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'user_email') String userEmail,
      @JsonKey(name: 'project_name') String? projectName,
      @JsonKey(name: 'task_title') String? taskTitle,
      @JsonKey(name: 'instructor_email') String? instructorEmail,
      String name,
      String description,
      @JsonKey(name: 'catalog_type') String catalogType,
      @JsonKey(name: 'estimated_hours') String estimatedHours,
      @JsonKey(name: 'progress_percentage') int progressPercentage,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      int user,
      int? project,
      int? task});
}

/// @nodoc
class _$CatalogItemCopyWithImpl<$Res, $Val extends CatalogItem>
    implements $CatalogItemCopyWith<$Res> {
  _$CatalogItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userEmail = null,
    Object? projectName = freezed,
    Object? taskTitle = freezed,
    Object? instructorEmail = freezed,
    Object? name = null,
    Object? description = null,
    Object? catalogType = null,
    Object? estimatedHours = null,
    Object? progressPercentage = null,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? user = null,
    Object? project = freezed,
    Object? task = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      userEmail: null == userEmail
          ? _value.userEmail
          : userEmail // ignore: cast_nullable_to_non_nullable
              as String,
      projectName: freezed == projectName
          ? _value.projectName
          : projectName // ignore: cast_nullable_to_non_nullable
              as String?,
      taskTitle: freezed == taskTitle
          ? _value.taskTitle
          : taskTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      instructorEmail: freezed == instructorEmail
          ? _value.instructorEmail
          : instructorEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      catalogType: null == catalogType
          ? _value.catalogType
          : catalogType // ignore: cast_nullable_to_non_nullable
              as String,
      estimatedHours: null == estimatedHours
          ? _value.estimatedHours
          : estimatedHours // ignore: cast_nullable_to_non_nullable
              as String,
      progressPercentage: null == progressPercentage
          ? _value.progressPercentage
          : progressPercentage // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as int,
      project: freezed == project
          ? _value.project
          : project // ignore: cast_nullable_to_non_nullable
              as int?,
      task: freezed == task
          ? _value.task
          : task // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CatalogItemImplCopyWith<$Res>
    implements $CatalogItemCopyWith<$Res> {
  factory _$$CatalogItemImplCopyWith(
          _$CatalogItemImpl value, $Res Function(_$CatalogItemImpl) then) =
      __$$CatalogItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'user_email') String userEmail,
      @JsonKey(name: 'project_name') String? projectName,
      @JsonKey(name: 'task_title') String? taskTitle,
      @JsonKey(name: 'instructor_email') String? instructorEmail,
      String name,
      String description,
      @JsonKey(name: 'catalog_type') String catalogType,
      @JsonKey(name: 'estimated_hours') String estimatedHours,
      @JsonKey(name: 'progress_percentage') int progressPercentage,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      int user,
      int? project,
      int? task});
}

/// @nodoc
class __$$CatalogItemImplCopyWithImpl<$Res>
    extends _$CatalogItemCopyWithImpl<$Res, _$CatalogItemImpl>
    implements _$$CatalogItemImplCopyWith<$Res> {
  __$$CatalogItemImplCopyWithImpl(
      _$CatalogItemImpl _value, $Res Function(_$CatalogItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userEmail = null,
    Object? projectName = freezed,
    Object? taskTitle = freezed,
    Object? instructorEmail = freezed,
    Object? name = null,
    Object? description = null,
    Object? catalogType = null,
    Object? estimatedHours = null,
    Object? progressPercentage = null,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? user = null,
    Object? project = freezed,
    Object? task = freezed,
  }) {
    return _then(_$CatalogItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      userEmail: null == userEmail
          ? _value.userEmail
          : userEmail // ignore: cast_nullable_to_non_nullable
              as String,
      projectName: freezed == projectName
          ? _value.projectName
          : projectName // ignore: cast_nullable_to_non_nullable
              as String?,
      taskTitle: freezed == taskTitle
          ? _value.taskTitle
          : taskTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      instructorEmail: freezed == instructorEmail
          ? _value.instructorEmail
          : instructorEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      catalogType: null == catalogType
          ? _value.catalogType
          : catalogType // ignore: cast_nullable_to_non_nullable
              as String,
      estimatedHours: null == estimatedHours
          ? _value.estimatedHours
          : estimatedHours // ignore: cast_nullable_to_non_nullable
              as String,
      progressPercentage: null == progressPercentage
          ? _value.progressPercentage
          : progressPercentage // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as int,
      project: freezed == project
          ? _value.project
          : project // ignore: cast_nullable_to_non_nullable
              as int?,
      task: freezed == task
          ? _value.task
          : task // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CatalogItemImpl implements _CatalogItem {
  const _$CatalogItemImpl(
      {required this.id,
      @JsonKey(name: 'user_email') required this.userEmail,
      @JsonKey(name: 'project_name') this.projectName,
      @JsonKey(name: 'task_title') this.taskTitle,
      @JsonKey(name: 'instructor_email') this.instructorEmail,
      required this.name,
      required this.description,
      @JsonKey(name: 'catalog_type') required this.catalogType,
      @JsonKey(name: 'estimated_hours') required this.estimatedHours,
      @JsonKey(name: 'progress_percentage') required this.progressPercentage,
      @JsonKey(name: 'is_active') required this.isActive,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt,
      required this.user,
      this.project,
      this.task});

  factory _$CatalogItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$CatalogItemImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'user_email')
  final String userEmail;
  @override
  @JsonKey(name: 'project_name')
  final String? projectName;
  @override
  @JsonKey(name: 'task_title')
  final String? taskTitle;
  @override
  @JsonKey(name: 'instructor_email')
  final String? instructorEmail;
  @override
  final String name;
  @override
  final String description;
  @override
  @JsonKey(name: 'catalog_type')
  final String catalogType;
  @override
  @JsonKey(name: 'estimated_hours')
  final String estimatedHours;
  @override
  @JsonKey(name: 'progress_percentage')
  final int progressPercentage;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  @override
  final int user;
  @override
  final int? project;
  @override
  final int? task;

  @override
  String toString() {
    return 'CatalogItem(id: $id, userEmail: $userEmail, projectName: $projectName, taskTitle: $taskTitle, instructorEmail: $instructorEmail, name: $name, description: $description, catalogType: $catalogType, estimatedHours: $estimatedHours, progressPercentage: $progressPercentage, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt, user: $user, project: $project, task: $task)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CatalogItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userEmail, userEmail) ||
                other.userEmail == userEmail) &&
            (identical(other.projectName, projectName) ||
                other.projectName == projectName) &&
            (identical(other.taskTitle, taskTitle) ||
                other.taskTitle == taskTitle) &&
            (identical(other.instructorEmail, instructorEmail) ||
                other.instructorEmail == instructorEmail) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.catalogType, catalogType) ||
                other.catalogType == catalogType) &&
            (identical(other.estimatedHours, estimatedHours) ||
                other.estimatedHours == estimatedHours) &&
            (identical(other.progressPercentage, progressPercentage) ||
                other.progressPercentage == progressPercentage) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.project, project) || other.project == project) &&
            (identical(other.task, task) || other.task == task));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userEmail,
      projectName,
      taskTitle,
      instructorEmail,
      name,
      description,
      catalogType,
      estimatedHours,
      progressPercentage,
      isActive,
      createdAt,
      updatedAt,
      user,
      project,
      task);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CatalogItemImplCopyWith<_$CatalogItemImpl> get copyWith =>
      __$$CatalogItemImplCopyWithImpl<_$CatalogItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CatalogItemImplToJson(
      this,
    );
  }
}

abstract class _CatalogItem implements CatalogItem {
  const factory _CatalogItem(
      {required final int id,
      @JsonKey(name: 'user_email') required final String userEmail,
      @JsonKey(name: 'project_name') final String? projectName,
      @JsonKey(name: 'task_title') final String? taskTitle,
      @JsonKey(name: 'instructor_email') final String? instructorEmail,
      required final String name,
      required final String description,
      @JsonKey(name: 'catalog_type') required final String catalogType,
      @JsonKey(name: 'estimated_hours') required final String estimatedHours,
      @JsonKey(name: 'progress_percentage')
      required final int progressPercentage,
      @JsonKey(name: 'is_active') required final bool isActive,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      @JsonKey(name: 'updated_at') required final DateTime updatedAt,
      required final int user,
      final int? project,
      final int? task}) = _$CatalogItemImpl;

  factory _CatalogItem.fromJson(Map<String, dynamic> json) =
      _$CatalogItemImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'user_email')
  String get userEmail;
  @override
  @JsonKey(name: 'project_name')
  String? get projectName;
  @override
  @JsonKey(name: 'task_title')
  String? get taskTitle;
  @override
  @JsonKey(name: 'instructor_email')
  String? get instructorEmail;
  @override
  String get name;
  @override
  String get description;
  @override
  @JsonKey(name: 'catalog_type')
  String get catalogType;
  @override
  @JsonKey(name: 'estimated_hours')
  String get estimatedHours;
  @override
  @JsonKey(name: 'progress_percentage')
  int get progressPercentage;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;
  @override
  int get user;
  @override
  int? get project;
  @override
  int? get task;
  @override
  @JsonKey(ignore: true)
  _$$CatalogItemImplCopyWith<_$CatalogItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreateCatalogRequest _$CreateCatalogRequestFromJson(Map<String, dynamic> json) {
  return _CreateCatalogRequest.fromJson(json);
}

/// @nodoc
mixin _$CreateCatalogRequest {
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'catalog_type')
  String get catalogType => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CreateCatalogRequestCopyWith<CreateCatalogRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateCatalogRequestCopyWith<$Res> {
  factory $CreateCatalogRequestCopyWith(CreateCatalogRequest value,
          $Res Function(CreateCatalogRequest) then) =
      _$CreateCatalogRequestCopyWithImpl<$Res, CreateCatalogRequest>;
  @useResult
  $Res call(
      {String name,
      String description,
      @JsonKey(name: 'catalog_type') String catalogType,
      @JsonKey(name: 'is_active') bool isActive});
}

/// @nodoc
class _$CreateCatalogRequestCopyWithImpl<$Res,
        $Val extends CreateCatalogRequest>
    implements $CreateCatalogRequestCopyWith<$Res> {
  _$CreateCatalogRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? description = null,
    Object? catalogType = null,
    Object? isActive = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      catalogType: null == catalogType
          ? _value.catalogType
          : catalogType // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateCatalogRequestImplCopyWith<$Res>
    implements $CreateCatalogRequestCopyWith<$Res> {
  factory _$$CreateCatalogRequestImplCopyWith(_$CreateCatalogRequestImpl value,
          $Res Function(_$CreateCatalogRequestImpl) then) =
      __$$CreateCatalogRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      String description,
      @JsonKey(name: 'catalog_type') String catalogType,
      @JsonKey(name: 'is_active') bool isActive});
}

/// @nodoc
class __$$CreateCatalogRequestImplCopyWithImpl<$Res>
    extends _$CreateCatalogRequestCopyWithImpl<$Res, _$CreateCatalogRequestImpl>
    implements _$$CreateCatalogRequestImplCopyWith<$Res> {
  __$$CreateCatalogRequestImplCopyWithImpl(_$CreateCatalogRequestImpl _value,
      $Res Function(_$CreateCatalogRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? description = null,
    Object? catalogType = null,
    Object? isActive = null,
  }) {
    return _then(_$CreateCatalogRequestImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      catalogType: null == catalogType
          ? _value.catalogType
          : catalogType // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateCatalogRequestImpl implements _CreateCatalogRequest {
  const _$CreateCatalogRequestImpl(
      {required this.name,
      required this.description,
      @JsonKey(name: 'catalog_type') required this.catalogType,
      @JsonKey(name: 'is_active') this.isActive = true});

  factory _$CreateCatalogRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateCatalogRequestImplFromJson(json);

  @override
  final String name;
  @override
  final String description;
  @override
  @JsonKey(name: 'catalog_type')
  final String catalogType;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;

  @override
  String toString() {
    return 'CreateCatalogRequest(name: $name, description: $description, catalogType: $catalogType, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateCatalogRequestImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.catalogType, catalogType) ||
                other.catalogType == catalogType) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, name, description, catalogType, isActive);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateCatalogRequestImplCopyWith<_$CreateCatalogRequestImpl>
      get copyWith =>
          __$$CreateCatalogRequestImplCopyWithImpl<_$CreateCatalogRequestImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateCatalogRequestImplToJson(
      this,
    );
  }
}

abstract class _CreateCatalogRequest implements CreateCatalogRequest {
  const factory _CreateCatalogRequest(
          {required final String name,
          required final String description,
          @JsonKey(name: 'catalog_type') required final String catalogType,
          @JsonKey(name: 'is_active') final bool isActive}) =
      _$CreateCatalogRequestImpl;

  factory _CreateCatalogRequest.fromJson(Map<String, dynamic> json) =
      _$CreateCatalogRequestImpl.fromJson;

  @override
  String get name;
  @override
  String get description;
  @override
  @JsonKey(name: 'catalog_type')
  String get catalogType;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(ignore: true)
  _$$CreateCatalogRequestImplCopyWith<_$CreateCatalogRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}
