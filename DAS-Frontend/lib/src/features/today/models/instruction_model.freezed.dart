// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'instruction_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TeamInstruction _$TeamInstructionFromJson(Map<String, dynamic> json) {
  return _TeamInstruction.fromJson(json);
}

/// @nodoc
mixin _$TeamInstruction {
  int get id => throw _privateConstructorUsedError;
  int? get project => throw _privateConstructorUsedError;
  @JsonKey(name: 'project_name')
  String get projectName => throw _privateConstructorUsedError;
  List<int> get recipients => throw _privateConstructorUsedError;
  @JsonKey(name: 'recipient_emails')
  List<String> get recipientEmails => throw _privateConstructorUsedError;
  @JsonKey(name: 'recipient_count')
  int get recipientCount => throw _privateConstructorUsedError;
  String get subject => throw _privateConstructorUsedError;
  String get instructions => throw _privateConstructorUsedError;
  @JsonKey(name: 'sent_by')
  int get sentBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'sent_by_email')
  String get sentByEmail => throw _privateConstructorUsedError;
  @JsonKey(name: 'sent_at')
  DateTime get sentAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TeamInstructionCopyWith<TeamInstruction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeamInstructionCopyWith<$Res> {
  factory $TeamInstructionCopyWith(
          TeamInstruction value, $Res Function(TeamInstruction) then) =
      _$TeamInstructionCopyWithImpl<$Res, TeamInstruction>;
  @useResult
  $Res call(
      {int id,
      int? project,
      @JsonKey(name: 'project_name') String projectName,
      List<int> recipients,
      @JsonKey(name: 'recipient_emails') List<String> recipientEmails,
      @JsonKey(name: 'recipient_count') int recipientCount,
      String subject,
      String instructions,
      @JsonKey(name: 'sent_by') int sentBy,
      @JsonKey(name: 'sent_by_email') String sentByEmail,
      @JsonKey(name: 'sent_at') DateTime sentAt});
}

/// @nodoc
class _$TeamInstructionCopyWithImpl<$Res, $Val extends TeamInstruction>
    implements $TeamInstructionCopyWith<$Res> {
  _$TeamInstructionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? project = freezed,
    Object? projectName = null,
    Object? recipients = null,
    Object? recipientEmails = null,
    Object? recipientCount = null,
    Object? subject = null,
    Object? instructions = null,
    Object? sentBy = null,
    Object? sentByEmail = null,
    Object? sentAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      project: freezed == project
          ? _value.project
          : project // ignore: cast_nullable_to_non_nullable
              as int?,
      projectName: null == projectName
          ? _value.projectName
          : projectName // ignore: cast_nullable_to_non_nullable
              as String,
      recipients: null == recipients
          ? _value.recipients
          : recipients // ignore: cast_nullable_to_non_nullable
              as List<int>,
      recipientEmails: null == recipientEmails
          ? _value.recipientEmails
          : recipientEmails // ignore: cast_nullable_to_non_nullable
              as List<String>,
      recipientCount: null == recipientCount
          ? _value.recipientCount
          : recipientCount // ignore: cast_nullable_to_non_nullable
              as int,
      subject: null == subject
          ? _value.subject
          : subject // ignore: cast_nullable_to_non_nullable
              as String,
      instructions: null == instructions
          ? _value.instructions
          : instructions // ignore: cast_nullable_to_non_nullable
              as String,
      sentBy: null == sentBy
          ? _value.sentBy
          : sentBy // ignore: cast_nullable_to_non_nullable
              as int,
      sentByEmail: null == sentByEmail
          ? _value.sentByEmail
          : sentByEmail // ignore: cast_nullable_to_non_nullable
              as String,
      sentAt: null == sentAt
          ? _value.sentAt
          : sentAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TeamInstructionImplCopyWith<$Res>
    implements $TeamInstructionCopyWith<$Res> {
  factory _$$TeamInstructionImplCopyWith(_$TeamInstructionImpl value,
          $Res Function(_$TeamInstructionImpl) then) =
      __$$TeamInstructionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      int? project,
      @JsonKey(name: 'project_name') String projectName,
      List<int> recipients,
      @JsonKey(name: 'recipient_emails') List<String> recipientEmails,
      @JsonKey(name: 'recipient_count') int recipientCount,
      String subject,
      String instructions,
      @JsonKey(name: 'sent_by') int sentBy,
      @JsonKey(name: 'sent_by_email') String sentByEmail,
      @JsonKey(name: 'sent_at') DateTime sentAt});
}

/// @nodoc
class __$$TeamInstructionImplCopyWithImpl<$Res>
    extends _$TeamInstructionCopyWithImpl<$Res, _$TeamInstructionImpl>
    implements _$$TeamInstructionImplCopyWith<$Res> {
  __$$TeamInstructionImplCopyWithImpl(
      _$TeamInstructionImpl _value, $Res Function(_$TeamInstructionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? project = freezed,
    Object? projectName = null,
    Object? recipients = null,
    Object? recipientEmails = null,
    Object? recipientCount = null,
    Object? subject = null,
    Object? instructions = null,
    Object? sentBy = null,
    Object? sentByEmail = null,
    Object? sentAt = null,
  }) {
    return _then(_$TeamInstructionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      project: freezed == project
          ? _value.project
          : project // ignore: cast_nullable_to_non_nullable
              as int?,
      projectName: null == projectName
          ? _value.projectName
          : projectName // ignore: cast_nullable_to_non_nullable
              as String,
      recipients: null == recipients
          ? _value._recipients
          : recipients // ignore: cast_nullable_to_non_nullable
              as List<int>,
      recipientEmails: null == recipientEmails
          ? _value._recipientEmails
          : recipientEmails // ignore: cast_nullable_to_non_nullable
              as List<String>,
      recipientCount: null == recipientCount
          ? _value.recipientCount
          : recipientCount // ignore: cast_nullable_to_non_nullable
              as int,
      subject: null == subject
          ? _value.subject
          : subject // ignore: cast_nullable_to_non_nullable
              as String,
      instructions: null == instructions
          ? _value.instructions
          : instructions // ignore: cast_nullable_to_non_nullable
              as String,
      sentBy: null == sentBy
          ? _value.sentBy
          : sentBy // ignore: cast_nullable_to_non_nullable
              as int,
      sentByEmail: null == sentByEmail
          ? _value.sentByEmail
          : sentByEmail // ignore: cast_nullable_to_non_nullable
              as String,
      sentAt: null == sentAt
          ? _value.sentAt
          : sentAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TeamInstructionImpl implements _TeamInstruction {
  const _$TeamInstructionImpl(
      {required this.id,
      this.project,
      @JsonKey(name: 'project_name') required this.projectName,
      required final List<int> recipients,
      @JsonKey(name: 'recipient_emails')
      required final List<String> recipientEmails,
      @JsonKey(name: 'recipient_count') required this.recipientCount,
      required this.subject,
      required this.instructions,
      @JsonKey(name: 'sent_by') required this.sentBy,
      @JsonKey(name: 'sent_by_email') required this.sentByEmail,
      @JsonKey(name: 'sent_at') required this.sentAt})
      : _recipients = recipients,
        _recipientEmails = recipientEmails;

  factory _$TeamInstructionImpl.fromJson(Map<String, dynamic> json) =>
      _$$TeamInstructionImplFromJson(json);

  @override
  final int id;
  @override
  final int? project;
  @override
  @JsonKey(name: 'project_name')
  final String projectName;
  final List<int> _recipients;
  @override
  List<int> get recipients {
    if (_recipients is EqualUnmodifiableListView) return _recipients;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recipients);
  }

  final List<String> _recipientEmails;
  @override
  @JsonKey(name: 'recipient_emails')
  List<String> get recipientEmails {
    if (_recipientEmails is EqualUnmodifiableListView) return _recipientEmails;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recipientEmails);
  }

  @override
  @JsonKey(name: 'recipient_count')
  final int recipientCount;
  @override
  final String subject;
  @override
  final String instructions;
  @override
  @JsonKey(name: 'sent_by')
  final int sentBy;
  @override
  @JsonKey(name: 'sent_by_email')
  final String sentByEmail;
  @override
  @JsonKey(name: 'sent_at')
  final DateTime sentAt;

  @override
  String toString() {
    return 'TeamInstruction(id: $id, project: $project, projectName: $projectName, recipients: $recipients, recipientEmails: $recipientEmails, recipientCount: $recipientCount, subject: $subject, instructions: $instructions, sentBy: $sentBy, sentByEmail: $sentByEmail, sentAt: $sentAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeamInstructionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.project, project) || other.project == project) &&
            (identical(other.projectName, projectName) ||
                other.projectName == projectName) &&
            const DeepCollectionEquality()
                .equals(other._recipients, _recipients) &&
            const DeepCollectionEquality()
                .equals(other._recipientEmails, _recipientEmails) &&
            (identical(other.recipientCount, recipientCount) ||
                other.recipientCount == recipientCount) &&
            (identical(other.subject, subject) || other.subject == subject) &&
            (identical(other.instructions, instructions) ||
                other.instructions == instructions) &&
            (identical(other.sentBy, sentBy) || other.sentBy == sentBy) &&
            (identical(other.sentByEmail, sentByEmail) ||
                other.sentByEmail == sentByEmail) &&
            (identical(other.sentAt, sentAt) || other.sentAt == sentAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      project,
      projectName,
      const DeepCollectionEquality().hash(_recipients),
      const DeepCollectionEquality().hash(_recipientEmails),
      recipientCount,
      subject,
      instructions,
      sentBy,
      sentByEmail,
      sentAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TeamInstructionImplCopyWith<_$TeamInstructionImpl> get copyWith =>
      __$$TeamInstructionImplCopyWithImpl<_$TeamInstructionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TeamInstructionImplToJson(
      this,
    );
  }
}

abstract class _TeamInstruction implements TeamInstruction {
  const factory _TeamInstruction(
          {required final int id,
          final int? project,
          @JsonKey(name: 'project_name') required final String projectName,
          required final List<int> recipients,
          @JsonKey(name: 'recipient_emails')
          required final List<String> recipientEmails,
          @JsonKey(name: 'recipient_count') required final int recipientCount,
          required final String subject,
          required final String instructions,
          @JsonKey(name: 'sent_by') required final int sentBy,
          @JsonKey(name: 'sent_by_email') required final String sentByEmail,
          @JsonKey(name: 'sent_at') required final DateTime sentAt}) =
      _$TeamInstructionImpl;

  factory _TeamInstruction.fromJson(Map<String, dynamic> json) =
      _$TeamInstructionImpl.fromJson;

  @override
  int get id;
  @override
  int? get project;
  @override
  @JsonKey(name: 'project_name')
  String get projectName;
  @override
  List<int> get recipients;
  @override
  @JsonKey(name: 'recipient_emails')
  List<String> get recipientEmails;
  @override
  @JsonKey(name: 'recipient_count')
  int get recipientCount;
  @override
  String get subject;
  @override
  String get instructions;
  @override
  @JsonKey(name: 'sent_by')
  int get sentBy;
  @override
  @JsonKey(name: 'sent_by_email')
  String get sentByEmail;
  @override
  @JsonKey(name: 'sent_at')
  DateTime get sentAt;
  @override
  @JsonKey(ignore: true)
  _$$TeamInstructionImplCopyWith<_$TeamInstructionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreateTeamInstructionRequest _$CreateTeamInstructionRequestFromJson(
    Map<String, dynamic> json) {
  return _CreateTeamInstructionRequest.fromJson(json);
}

/// @nodoc
mixin _$CreateTeamInstructionRequest {
  int? get project => throw _privateConstructorUsedError;
  List<int> get recipients => throw _privateConstructorUsedError;
  String get subject => throw _privateConstructorUsedError;
  String get instructions => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CreateTeamInstructionRequestCopyWith<CreateTeamInstructionRequest>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateTeamInstructionRequestCopyWith<$Res> {
  factory $CreateTeamInstructionRequestCopyWith(
          CreateTeamInstructionRequest value,
          $Res Function(CreateTeamInstructionRequest) then) =
      _$CreateTeamInstructionRequestCopyWithImpl<$Res,
          CreateTeamInstructionRequest>;
  @useResult
  $Res call(
      {int? project,
      List<int> recipients,
      String subject,
      String instructions});
}

/// @nodoc
class _$CreateTeamInstructionRequestCopyWithImpl<$Res,
        $Val extends CreateTeamInstructionRequest>
    implements $CreateTeamInstructionRequestCopyWith<$Res> {
  _$CreateTeamInstructionRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? project = freezed,
    Object? recipients = null,
    Object? subject = null,
    Object? instructions = null,
  }) {
    return _then(_value.copyWith(
      project: freezed == project
          ? _value.project
          : project // ignore: cast_nullable_to_non_nullable
              as int?,
      recipients: null == recipients
          ? _value.recipients
          : recipients // ignore: cast_nullable_to_non_nullable
              as List<int>,
      subject: null == subject
          ? _value.subject
          : subject // ignore: cast_nullable_to_non_nullable
              as String,
      instructions: null == instructions
          ? _value.instructions
          : instructions // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateTeamInstructionRequestImplCopyWith<$Res>
    implements $CreateTeamInstructionRequestCopyWith<$Res> {
  factory _$$CreateTeamInstructionRequestImplCopyWith(
          _$CreateTeamInstructionRequestImpl value,
          $Res Function(_$CreateTeamInstructionRequestImpl) then) =
      __$$CreateTeamInstructionRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? project,
      List<int> recipients,
      String subject,
      String instructions});
}

/// @nodoc
class __$$CreateTeamInstructionRequestImplCopyWithImpl<$Res>
    extends _$CreateTeamInstructionRequestCopyWithImpl<$Res,
        _$CreateTeamInstructionRequestImpl>
    implements _$$CreateTeamInstructionRequestImplCopyWith<$Res> {
  __$$CreateTeamInstructionRequestImplCopyWithImpl(
      _$CreateTeamInstructionRequestImpl _value,
      $Res Function(_$CreateTeamInstructionRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? project = freezed,
    Object? recipients = null,
    Object? subject = null,
    Object? instructions = null,
  }) {
    return _then(_$CreateTeamInstructionRequestImpl(
      project: freezed == project
          ? _value.project
          : project // ignore: cast_nullable_to_non_nullable
              as int?,
      recipients: null == recipients
          ? _value._recipients
          : recipients // ignore: cast_nullable_to_non_nullable
              as List<int>,
      subject: null == subject
          ? _value.subject
          : subject // ignore: cast_nullable_to_non_nullable
              as String,
      instructions: null == instructions
          ? _value.instructions
          : instructions // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateTeamInstructionRequestImpl
    implements _CreateTeamInstructionRequest {
  const _$CreateTeamInstructionRequestImpl(
      {this.project,
      required final List<int> recipients,
      required this.subject,
      required this.instructions})
      : _recipients = recipients;

  factory _$CreateTeamInstructionRequestImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$CreateTeamInstructionRequestImplFromJson(json);

  @override
  final int? project;
  final List<int> _recipients;
  @override
  List<int> get recipients {
    if (_recipients is EqualUnmodifiableListView) return _recipients;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recipients);
  }

  @override
  final String subject;
  @override
  final String instructions;

  @override
  String toString() {
    return 'CreateTeamInstructionRequest(project: $project, recipients: $recipients, subject: $subject, instructions: $instructions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateTeamInstructionRequestImpl &&
            (identical(other.project, project) || other.project == project) &&
            const DeepCollectionEquality()
                .equals(other._recipients, _recipients) &&
            (identical(other.subject, subject) || other.subject == subject) &&
            (identical(other.instructions, instructions) ||
                other.instructions == instructions));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, project,
      const DeepCollectionEquality().hash(_recipients), subject, instructions);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateTeamInstructionRequestImplCopyWith<
          _$CreateTeamInstructionRequestImpl>
      get copyWith => __$$CreateTeamInstructionRequestImplCopyWithImpl<
          _$CreateTeamInstructionRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateTeamInstructionRequestImplToJson(
      this,
    );
  }
}

abstract class _CreateTeamInstructionRequest
    implements CreateTeamInstructionRequest {
  const factory _CreateTeamInstructionRequest(
      {final int? project,
      required final List<int> recipients,
      required final String subject,
      required final String instructions}) = _$CreateTeamInstructionRequestImpl;

  factory _CreateTeamInstructionRequest.fromJson(Map<String, dynamic> json) =
      _$CreateTeamInstructionRequestImpl.fromJson;

  @override
  int? get project;
  @override
  List<int> get recipients;
  @override
  String get subject;
  @override
  String get instructions;
  @override
  @JsonKey(ignore: true)
  _$$CreateTeamInstructionRequestImplCopyWith<
          _$CreateTeamInstructionRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}
