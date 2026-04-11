// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _avatarUrlMeta =
      const VerificationMeta('avatarUrl');
  @override
  late final GeneratedColumn<String> avatarUrl = GeneratedColumn<String>(
      'avatar_url', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
      'role', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _reportingManagerIdMeta =
      const VerificationMeta('reportingManagerId');
  @override
  late final GeneratedColumn<String> reportingManagerId =
      GeneratedColumn<String>('reporting_manager_id', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _departmentMeta =
      const VerificationMeta('department');
  @override
  late final GeneratedColumn<String> department = GeneratedColumn<String>(
      'department', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, avatarUrl, email, role, reportingManagerId, department];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(Insertable<User> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('avatar_url')) {
      context.handle(_avatarUrlMeta,
          avatarUrl.isAcceptableOrUnknown(data['avatar_url']!, _avatarUrlMeta));
    } else if (isInserting) {
      context.missing(_avatarUrlMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
          _roleMeta, role.isAcceptableOrUnknown(data['role']!, _roleMeta));
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('reporting_manager_id')) {
      context.handle(
          _reportingManagerIdMeta,
          reportingManagerId.isAcceptableOrUnknown(
              data['reporting_manager_id']!, _reportingManagerIdMeta));
    }
    if (data.containsKey('department')) {
      context.handle(
          _departmentMeta,
          department.isAcceptableOrUnknown(
              data['department']!, _departmentMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      avatarUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}avatar_url'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email'])!,
      role: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role'])!,
      reportingManagerId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}reporting_manager_id']),
      department: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}department']),
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final String id;
  final String name;
  final String avatarUrl;
  final String email;
  final String role;
  final String? reportingManagerId;
  final String? department;
  const User(
      {required this.id,
      required this.name,
      required this.avatarUrl,
      required this.email,
      required this.role,
      this.reportingManagerId,
      this.department});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['avatar_url'] = Variable<String>(avatarUrl);
    map['email'] = Variable<String>(email);
    map['role'] = Variable<String>(role);
    if (!nullToAbsent || reportingManagerId != null) {
      map['reporting_manager_id'] = Variable<String>(reportingManagerId);
    }
    if (!nullToAbsent || department != null) {
      map['department'] = Variable<String>(department);
    }
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      name: Value(name),
      avatarUrl: Value(avatarUrl),
      email: Value(email),
      role: Value(role),
      reportingManagerId: reportingManagerId == null && nullToAbsent
          ? const Value.absent()
          : Value(reportingManagerId),
      department: department == null && nullToAbsent
          ? const Value.absent()
          : Value(department),
    );
  }

  factory User.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      avatarUrl: serializer.fromJson<String>(json['avatarUrl']),
      email: serializer.fromJson<String>(json['email']),
      role: serializer.fromJson<String>(json['role']),
      reportingManagerId:
          serializer.fromJson<String?>(json['reportingManagerId']),
      department: serializer.fromJson<String?>(json['department']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'avatarUrl': serializer.toJson<String>(avatarUrl),
      'email': serializer.toJson<String>(email),
      'role': serializer.toJson<String>(role),
      'reportingManagerId': serializer.toJson<String?>(reportingManagerId),
      'department': serializer.toJson<String?>(department),
    };
  }

  User copyWith(
          {String? id,
          String? name,
          String? avatarUrl,
          String? email,
          String? role,
          Value<String?> reportingManagerId = const Value.absent(),
          Value<String?> department = const Value.absent()}) =>
      User(
        id: id ?? this.id,
        name: name ?? this.name,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        email: email ?? this.email,
        role: role ?? this.role,
        reportingManagerId: reportingManagerId.present
            ? reportingManagerId.value
            : this.reportingManagerId,
        department: department.present ? department.value : this.department,
      );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      avatarUrl: data.avatarUrl.present ? data.avatarUrl.value : this.avatarUrl,
      email: data.email.present ? data.email.value : this.email,
      role: data.role.present ? data.role.value : this.role,
      reportingManagerId: data.reportingManagerId.present
          ? data.reportingManagerId.value
          : this.reportingManagerId,
      department:
          data.department.present ? data.department.value : this.department,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('email: $email, ')
          ..write('role: $role, ')
          ..write('reportingManagerId: $reportingManagerId, ')
          ..write('department: $department')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, name, avatarUrl, email, role, reportingManagerId, department);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.name == this.name &&
          other.avatarUrl == this.avatarUrl &&
          other.email == this.email &&
          other.role == this.role &&
          other.reportingManagerId == this.reportingManagerId &&
          other.department == this.department);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> avatarUrl;
  final Value<String> email;
  final Value<String> role;
  final Value<String?> reportingManagerId;
  final Value<String?> department;
  final Value<int> rowid;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    this.email = const Value.absent(),
    this.role = const Value.absent(),
    this.reportingManagerId = const Value.absent(),
    this.department = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersCompanion.insert({
    required String id,
    required String name,
    required String avatarUrl,
    required String email,
    required String role,
    this.reportingManagerId = const Value.absent(),
    this.department = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        avatarUrl = Value(avatarUrl),
        email = Value(email),
        role = Value(role);
  static Insertable<User> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? avatarUrl,
    Expression<String>? email,
    Expression<String>? role,
    Expression<String>? reportingManagerId,
    Expression<String>? department,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      if (email != null) 'email': email,
      if (role != null) 'role': role,
      if (reportingManagerId != null)
        'reporting_manager_id': reportingManagerId,
      if (department != null) 'department': department,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? avatarUrl,
      Value<String>? email,
      Value<String>? role,
      Value<String?>? reportingManagerId,
      Value<String?>? department,
      Value<int>? rowid}) {
    return UsersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      email: email ?? this.email,
      role: role ?? this.role,
      reportingManagerId: reportingManagerId ?? this.reportingManagerId,
      department: department ?? this.department,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (avatarUrl.present) {
      map['avatar_url'] = Variable<String>(avatarUrl.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (reportingManagerId.present) {
      map['reporting_manager_id'] = Variable<String>(reportingManagerId.value);
    }
    if (department.present) {
      map['department'] = Variable<String>(department.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('email: $email, ')
          ..write('role: $role, ')
          ..write('reportingManagerId: $reportingManagerId, ')
          ..write('department: $department, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProjectsTable extends Projects with TableInfo<$ProjectsTable, Project> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProjectsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _contextMeta =
      const VerificationMeta('context');
  @override
  late final GeneratedColumn<String> context = GeneratedColumn<String>(
      'context', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _approvalStatusMeta =
      const VerificationMeta('approvalStatus');
  @override
  late final GeneratedColumn<String> approvalStatus = GeneratedColumn<String>(
      'approval_status', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _rejectionReasonMeta =
      const VerificationMeta('rejectionReason');
  @override
  late final GeneratedColumn<String> rejectionReason = GeneratedColumn<String>(
      'rejection_reason', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dueDateMeta =
      const VerificationMeta('dueDate');
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
      'due_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _completedDateMeta =
      const VerificationMeta('completedDate');
  @override
  late final GeneratedColumn<DateTime> completedDate =
      GeneratedColumn<DateTime>('completed_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _plannedHoursMeta =
      const VerificationMeta('plannedHours');
  @override
  late final GeneratedColumn<double> plannedHours = GeneratedColumn<double>(
      'planned_hours', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        context,
        approvalStatus,
        rejectionReason,
        status,
        dueDate,
        completedDate,
        plannedHours
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'projects';
  @override
  VerificationContext validateIntegrity(Insertable<Project> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('context')) {
      context.handle(_contextMeta,
          this.context.isAcceptableOrUnknown(data['context']!, _contextMeta));
    } else if (isInserting) {
      context.missing(_contextMeta);
    }
    if (data.containsKey('approval_status')) {
      context.handle(
          _approvalStatusMeta,
          approvalStatus.isAcceptableOrUnknown(
              data['approval_status']!, _approvalStatusMeta));
    }
    if (data.containsKey('rejection_reason')) {
      context.handle(
          _rejectionReasonMeta,
          rejectionReason.isAcceptableOrUnknown(
              data['rejection_reason']!, _rejectionReasonMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('due_date')) {
      context.handle(_dueDateMeta,
          dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta));
    }
    if (data.containsKey('completed_date')) {
      context.handle(
          _completedDateMeta,
          completedDate.isAcceptableOrUnknown(
              data['completed_date']!, _completedDateMeta));
    }
    if (data.containsKey('planned_hours')) {
      context.handle(
          _plannedHoursMeta,
          plannedHours.isAcceptableOrUnknown(
              data['planned_hours']!, _plannedHoursMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Project map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Project(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      context: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}context'])!,
      approvalStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}approval_status']),
      rejectionReason: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}rejection_reason']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      dueDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}due_date']),
      completedDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}completed_date']),
      plannedHours: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}planned_hours'])!,
    );
  }

  @override
  $ProjectsTable createAlias(String alias) {
    return $ProjectsTable(attachedDatabase, alias);
  }
}

class Project extends DataClass implements Insertable<Project> {
  final String id;
  final String name;
  final String context;
  final String? approvalStatus;
  final String? rejectionReason;
  final String status;
  final DateTime? dueDate;
  final DateTime? completedDate;
  final double plannedHours;
  const Project(
      {required this.id,
      required this.name,
      required this.context,
      this.approvalStatus,
      this.rejectionReason,
      required this.status,
      this.dueDate,
      this.completedDate,
      required this.plannedHours});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['context'] = Variable<String>(context);
    if (!nullToAbsent || approvalStatus != null) {
      map['approval_status'] = Variable<String>(approvalStatus);
    }
    if (!nullToAbsent || rejectionReason != null) {
      map['rejection_reason'] = Variable<String>(rejectionReason);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<DateTime>(dueDate);
    }
    if (!nullToAbsent || completedDate != null) {
      map['completed_date'] = Variable<DateTime>(completedDate);
    }
    map['planned_hours'] = Variable<double>(plannedHours);
    return map;
  }

  ProjectsCompanion toCompanion(bool nullToAbsent) {
    return ProjectsCompanion(
      id: Value(id),
      name: Value(name),
      context: Value(context),
      approvalStatus: approvalStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(approvalStatus),
      rejectionReason: rejectionReason == null && nullToAbsent
          ? const Value.absent()
          : Value(rejectionReason),
      status: Value(status),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      completedDate: completedDate == null && nullToAbsent
          ? const Value.absent()
          : Value(completedDate),
      plannedHours: Value(plannedHours),
    );
  }

  factory Project.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Project(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      context: serializer.fromJson<String>(json['context']),
      approvalStatus: serializer.fromJson<String?>(json['approvalStatus']),
      rejectionReason: serializer.fromJson<String?>(json['rejectionReason']),
      status: serializer.fromJson<String>(json['status']),
      dueDate: serializer.fromJson<DateTime?>(json['dueDate']),
      completedDate: serializer.fromJson<DateTime?>(json['completedDate']),
      plannedHours: serializer.fromJson<double>(json['plannedHours']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'context': serializer.toJson<String>(context),
      'approvalStatus': serializer.toJson<String?>(approvalStatus),
      'rejectionReason': serializer.toJson<String?>(rejectionReason),
      'status': serializer.toJson<String>(status),
      'dueDate': serializer.toJson<DateTime?>(dueDate),
      'completedDate': serializer.toJson<DateTime?>(completedDate),
      'plannedHours': serializer.toJson<double>(plannedHours),
    };
  }

  Project copyWith(
          {String? id,
          String? name,
          String? context,
          Value<String?> approvalStatus = const Value.absent(),
          Value<String?> rejectionReason = const Value.absent(),
          String? status,
          Value<DateTime?> dueDate = const Value.absent(),
          Value<DateTime?> completedDate = const Value.absent(),
          double? plannedHours}) =>
      Project(
        id: id ?? this.id,
        name: name ?? this.name,
        context: context ?? this.context,
        approvalStatus:
            approvalStatus.present ? approvalStatus.value : this.approvalStatus,
        rejectionReason: rejectionReason.present
            ? rejectionReason.value
            : this.rejectionReason,
        status: status ?? this.status,
        dueDate: dueDate.present ? dueDate.value : this.dueDate,
        completedDate:
            completedDate.present ? completedDate.value : this.completedDate,
        plannedHours: plannedHours ?? this.plannedHours,
      );
  Project copyWithCompanion(ProjectsCompanion data) {
    return Project(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      context: data.context.present ? data.context.value : this.context,
      approvalStatus: data.approvalStatus.present
          ? data.approvalStatus.value
          : this.approvalStatus,
      rejectionReason: data.rejectionReason.present
          ? data.rejectionReason.value
          : this.rejectionReason,
      status: data.status.present ? data.status.value : this.status,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      completedDate: data.completedDate.present
          ? data.completedDate.value
          : this.completedDate,
      plannedHours: data.plannedHours.present
          ? data.plannedHours.value
          : this.plannedHours,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Project(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('context: $context, ')
          ..write('approvalStatus: $approvalStatus, ')
          ..write('rejectionReason: $rejectionReason, ')
          ..write('status: $status, ')
          ..write('dueDate: $dueDate, ')
          ..write('completedDate: $completedDate, ')
          ..write('plannedHours: $plannedHours')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, context, approvalStatus,
      rejectionReason, status, dueDate, completedDate, plannedHours);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Project &&
          other.id == this.id &&
          other.name == this.name &&
          other.context == this.context &&
          other.approvalStatus == this.approvalStatus &&
          other.rejectionReason == this.rejectionReason &&
          other.status == this.status &&
          other.dueDate == this.dueDate &&
          other.completedDate == this.completedDate &&
          other.plannedHours == this.plannedHours);
}

class ProjectsCompanion extends UpdateCompanion<Project> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> context;
  final Value<String?> approvalStatus;
  final Value<String?> rejectionReason;
  final Value<String> status;
  final Value<DateTime?> dueDate;
  final Value<DateTime?> completedDate;
  final Value<double> plannedHours;
  final Value<int> rowid;
  const ProjectsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.context = const Value.absent(),
    this.approvalStatus = const Value.absent(),
    this.rejectionReason = const Value.absent(),
    this.status = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.completedDate = const Value.absent(),
    this.plannedHours = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProjectsCompanion.insert({
    required String id,
    required String name,
    required String context,
    this.approvalStatus = const Value.absent(),
    this.rejectionReason = const Value.absent(),
    required String status,
    this.dueDate = const Value.absent(),
    this.completedDate = const Value.absent(),
    this.plannedHours = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        context = Value(context),
        status = Value(status);
  static Insertable<Project> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? context,
    Expression<String>? approvalStatus,
    Expression<String>? rejectionReason,
    Expression<String>? status,
    Expression<DateTime>? dueDate,
    Expression<DateTime>? completedDate,
    Expression<double>? plannedHours,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (context != null) 'context': context,
      if (approvalStatus != null) 'approval_status': approvalStatus,
      if (rejectionReason != null) 'rejection_reason': rejectionReason,
      if (status != null) 'status': status,
      if (dueDate != null) 'due_date': dueDate,
      if (completedDate != null) 'completed_date': completedDate,
      if (plannedHours != null) 'planned_hours': plannedHours,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProjectsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? context,
      Value<String?>? approvalStatus,
      Value<String?>? rejectionReason,
      Value<String>? status,
      Value<DateTime?>? dueDate,
      Value<DateTime?>? completedDate,
      Value<double>? plannedHours,
      Value<int>? rowid}) {
    return ProjectsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      context: context ?? this.context,
      approvalStatus: approvalStatus ?? this.approvalStatus,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      status: status ?? this.status,
      dueDate: dueDate ?? this.dueDate,
      completedDate: completedDate ?? this.completedDate,
      plannedHours: plannedHours ?? this.plannedHours,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (context.present) {
      map['context'] = Variable<String>(context.value);
    }
    if (approvalStatus.present) {
      map['approval_status'] = Variable<String>(approvalStatus.value);
    }
    if (rejectionReason.present) {
      map['rejection_reason'] = Variable<String>(rejectionReason.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (completedDate.present) {
      map['completed_date'] = Variable<DateTime>(completedDate.value);
    }
    if (plannedHours.present) {
      map['planned_hours'] = Variable<double>(plannedHours.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProjectsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('context: $context, ')
          ..write('approvalStatus: $approvalStatus, ')
          ..write('rejectionReason: $rejectionReason, ')
          ..write('status: $status, ')
          ..write('dueDate: $dueDate, ')
          ..write('completedDate: $completedDate, ')
          ..write('plannedHours: $plannedHours, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TasksTable extends Tasks with TableInfo<$TasksTable, Task> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _projectIdMeta =
      const VerificationMeta('projectId');
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
      'project_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES projects (id)'));
  static const VerificationMeta _progressMeta =
      const VerificationMeta('progress');
  @override
  late final GeneratedColumn<int> progress = GeneratedColumn<int>(
      'progress', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _priorityMeta =
      const VerificationMeta('priority');
  @override
  late final GeneratedColumn<String> priority = GeneratedColumn<String>(
      'priority', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _startDateMeta =
      const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
      'start_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _endDateMeta =
      const VerificationMeta('endDate');
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
      'end_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _approvalStatusMeta =
      const VerificationMeta('approvalStatus');
  @override
  late final GeneratedColumn<String> approvalStatus = GeneratedColumn<String>(
      'approval_status', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _rejectionReasonMeta =
      const VerificationMeta('rejectionReason');
  @override
  late final GeneratedColumn<String> rejectionReason = GeneratedColumn<String>(
      'rejection_reason', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _assigneesJsonMeta =
      const VerificationMeta('assigneesJson');
  @override
  late final GeneratedColumn<String> assigneesJson = GeneratedColumn<String>(
      'assignees_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _milestonesJsonMeta =
      const VerificationMeta('milestonesJson');
  @override
  late final GeneratedColumn<String> milestonesJson = GeneratedColumn<String>(
      'milestones_json', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _githubLinkMeta =
      const VerificationMeta('githubLink');
  @override
  late final GeneratedColumn<String> githubLink = GeneratedColumn<String>(
      'github_link', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _figmaLinkMeta =
      const VerificationMeta('figmaLink');
  @override
  late final GeneratedColumn<String> figmaLink = GeneratedColumn<String>(
      'figma_link', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _taskTypeMeta =
      const VerificationMeta('taskType');
  @override
  late final GeneratedColumn<String> taskType = GeneratedColumn<String>(
      'task_type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('standard'));
  static const VerificationMeta _recurrencePatternMeta =
      const VerificationMeta('recurrencePattern');
  @override
  late final GeneratedColumn<String> recurrencePattern =
      GeneratedColumn<String>('recurrence_pattern', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _nextOccurrenceMeta =
      const VerificationMeta('nextOccurrence');
  @override
  late final GeneratedColumn<DateTime> nextOccurrence =
      GeneratedColumn<DateTime>('next_occurrence', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _plannedHoursMeta =
      const VerificationMeta('plannedHours');
  @override
  late final GeneratedColumn<double> plannedHours = GeneratedColumn<double>(
      'planned_hours', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        projectId,
        progress,
        priority,
        startDate,
        endDate,
        approvalStatus,
        rejectionReason,
        assigneesJson,
        milestonesJson,
        githubLink,
        figmaLink,
        taskType,
        recurrencePattern,
        nextOccurrence,
        plannedHours
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasks';
  @override
  VerificationContext validateIntegrity(Insertable<Task> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(_projectIdMeta,
          projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta));
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('progress')) {
      context.handle(_progressMeta,
          progress.isAcceptableOrUnknown(data['progress']!, _progressMeta));
    }
    if (data.containsKey('priority')) {
      context.handle(_priorityMeta,
          priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta));
    } else if (isInserting) {
      context.missing(_priorityMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta));
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(_endDateMeta,
          endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta));
    } else if (isInserting) {
      context.missing(_endDateMeta);
    }
    if (data.containsKey('approval_status')) {
      context.handle(
          _approvalStatusMeta,
          approvalStatus.isAcceptableOrUnknown(
              data['approval_status']!, _approvalStatusMeta));
    }
    if (data.containsKey('rejection_reason')) {
      context.handle(
          _rejectionReasonMeta,
          rejectionReason.isAcceptableOrUnknown(
              data['rejection_reason']!, _rejectionReasonMeta));
    }
    if (data.containsKey('assignees_json')) {
      context.handle(
          _assigneesJsonMeta,
          assigneesJson.isAcceptableOrUnknown(
              data['assignees_json']!, _assigneesJsonMeta));
    } else if (isInserting) {
      context.missing(_assigneesJsonMeta);
    }
    if (data.containsKey('milestones_json')) {
      context.handle(
          _milestonesJsonMeta,
          milestonesJson.isAcceptableOrUnknown(
              data['milestones_json']!, _milestonesJsonMeta));
    }
    if (data.containsKey('github_link')) {
      context.handle(
          _githubLinkMeta,
          githubLink.isAcceptableOrUnknown(
              data['github_link']!, _githubLinkMeta));
    }
    if (data.containsKey('figma_link')) {
      context.handle(_figmaLinkMeta,
          figmaLink.isAcceptableOrUnknown(data['figma_link']!, _figmaLinkMeta));
    }
    if (data.containsKey('task_type')) {
      context.handle(_taskTypeMeta,
          taskType.isAcceptableOrUnknown(data['task_type']!, _taskTypeMeta));
    }
    if (data.containsKey('recurrence_pattern')) {
      context.handle(
          _recurrencePatternMeta,
          recurrencePattern.isAcceptableOrUnknown(
              data['recurrence_pattern']!, _recurrencePatternMeta));
    }
    if (data.containsKey('next_occurrence')) {
      context.handle(
          _nextOccurrenceMeta,
          nextOccurrence.isAcceptableOrUnknown(
              data['next_occurrence']!, _nextOccurrenceMeta));
    }
    if (data.containsKey('planned_hours')) {
      context.handle(
          _plannedHoursMeta,
          plannedHours.isAcceptableOrUnknown(
              data['planned_hours']!, _plannedHoursMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Task map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Task(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      projectId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}project_id'])!,
      progress: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}progress'])!,
      priority: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}priority'])!,
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_date'])!,
      endDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end_date'])!,
      approvalStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}approval_status']),
      rejectionReason: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}rejection_reason']),
      assigneesJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}assignees_json'])!,
      milestonesJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}milestones_json'])!,
      githubLink: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}github_link']),
      figmaLink: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}figma_link']),
      taskType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}task_type'])!,
      recurrencePattern: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}recurrence_pattern']),
      nextOccurrence: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}next_occurrence']),
      plannedHours: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}planned_hours'])!,
    );
  }

  @override
  $TasksTable createAlias(String alias) {
    return $TasksTable(attachedDatabase, alias);
  }
}

class Task extends DataClass implements Insertable<Task> {
  final String id;
  final String name;
  final String projectId;
  final int progress;
  final String priority;
  final DateTime startDate;
  final DateTime endDate;
  final String? approvalStatus;
  final String? rejectionReason;
  final String assigneesJson;
  final String milestonesJson;
  final String? githubLink;
  final String? figmaLink;
  final String taskType;
  final String? recurrencePattern;
  final DateTime? nextOccurrence;
  final double plannedHours;
  const Task(
      {required this.id,
      required this.name,
      required this.projectId,
      required this.progress,
      required this.priority,
      required this.startDate,
      required this.endDate,
      this.approvalStatus,
      this.rejectionReason,
      required this.assigneesJson,
      required this.milestonesJson,
      this.githubLink,
      this.figmaLink,
      required this.taskType,
      this.recurrencePattern,
      this.nextOccurrence,
      required this.plannedHours});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['project_id'] = Variable<String>(projectId);
    map['progress'] = Variable<int>(progress);
    map['priority'] = Variable<String>(priority);
    map['start_date'] = Variable<DateTime>(startDate);
    map['end_date'] = Variable<DateTime>(endDate);
    if (!nullToAbsent || approvalStatus != null) {
      map['approval_status'] = Variable<String>(approvalStatus);
    }
    if (!nullToAbsent || rejectionReason != null) {
      map['rejection_reason'] = Variable<String>(rejectionReason);
    }
    map['assignees_json'] = Variable<String>(assigneesJson);
    map['milestones_json'] = Variable<String>(milestonesJson);
    if (!nullToAbsent || githubLink != null) {
      map['github_link'] = Variable<String>(githubLink);
    }
    if (!nullToAbsent || figmaLink != null) {
      map['figma_link'] = Variable<String>(figmaLink);
    }
    map['task_type'] = Variable<String>(taskType);
    if (!nullToAbsent || recurrencePattern != null) {
      map['recurrence_pattern'] = Variable<String>(recurrencePattern);
    }
    if (!nullToAbsent || nextOccurrence != null) {
      map['next_occurrence'] = Variable<DateTime>(nextOccurrence);
    }
    map['planned_hours'] = Variable<double>(plannedHours);
    return map;
  }

  TasksCompanion toCompanion(bool nullToAbsent) {
    return TasksCompanion(
      id: Value(id),
      name: Value(name),
      projectId: Value(projectId),
      progress: Value(progress),
      priority: Value(priority),
      startDate: Value(startDate),
      endDate: Value(endDate),
      approvalStatus: approvalStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(approvalStatus),
      rejectionReason: rejectionReason == null && nullToAbsent
          ? const Value.absent()
          : Value(rejectionReason),
      assigneesJson: Value(assigneesJson),
      milestonesJson: Value(milestonesJson),
      githubLink: githubLink == null && nullToAbsent
          ? const Value.absent()
          : Value(githubLink),
      figmaLink: figmaLink == null && nullToAbsent
          ? const Value.absent()
          : Value(figmaLink),
      taskType: Value(taskType),
      recurrencePattern: recurrencePattern == null && nullToAbsent
          ? const Value.absent()
          : Value(recurrencePattern),
      nextOccurrence: nextOccurrence == null && nullToAbsent
          ? const Value.absent()
          : Value(nextOccurrence),
      plannedHours: Value(plannedHours),
    );
  }

  factory Task.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Task(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      projectId: serializer.fromJson<String>(json['projectId']),
      progress: serializer.fromJson<int>(json['progress']),
      priority: serializer.fromJson<String>(json['priority']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime>(json['endDate']),
      approvalStatus: serializer.fromJson<String?>(json['approvalStatus']),
      rejectionReason: serializer.fromJson<String?>(json['rejectionReason']),
      assigneesJson: serializer.fromJson<String>(json['assigneesJson']),
      milestonesJson: serializer.fromJson<String>(json['milestonesJson']),
      githubLink: serializer.fromJson<String?>(json['githubLink']),
      figmaLink: serializer.fromJson<String?>(json['figmaLink']),
      taskType: serializer.fromJson<String>(json['taskType']),
      recurrencePattern:
          serializer.fromJson<String?>(json['recurrencePattern']),
      nextOccurrence: serializer.fromJson<DateTime?>(json['nextOccurrence']),
      plannedHours: serializer.fromJson<double>(json['plannedHours']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'projectId': serializer.toJson<String>(projectId),
      'progress': serializer.toJson<int>(progress),
      'priority': serializer.toJson<String>(priority),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime>(endDate),
      'approvalStatus': serializer.toJson<String?>(approvalStatus),
      'rejectionReason': serializer.toJson<String?>(rejectionReason),
      'assigneesJson': serializer.toJson<String>(assigneesJson),
      'milestonesJson': serializer.toJson<String>(milestonesJson),
      'githubLink': serializer.toJson<String?>(githubLink),
      'figmaLink': serializer.toJson<String?>(figmaLink),
      'taskType': serializer.toJson<String>(taskType),
      'recurrencePattern': serializer.toJson<String?>(recurrencePattern),
      'nextOccurrence': serializer.toJson<DateTime?>(nextOccurrence),
      'plannedHours': serializer.toJson<double>(plannedHours),
    };
  }

  Task copyWith(
          {String? id,
          String? name,
          String? projectId,
          int? progress,
          String? priority,
          DateTime? startDate,
          DateTime? endDate,
          Value<String?> approvalStatus = const Value.absent(),
          Value<String?> rejectionReason = const Value.absent(),
          String? assigneesJson,
          String? milestonesJson,
          Value<String?> githubLink = const Value.absent(),
          Value<String?> figmaLink = const Value.absent(),
          String? taskType,
          Value<String?> recurrencePattern = const Value.absent(),
          Value<DateTime?> nextOccurrence = const Value.absent(),
          double? plannedHours}) =>
      Task(
        id: id ?? this.id,
        name: name ?? this.name,
        projectId: projectId ?? this.projectId,
        progress: progress ?? this.progress,
        priority: priority ?? this.priority,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        approvalStatus:
            approvalStatus.present ? approvalStatus.value : this.approvalStatus,
        rejectionReason: rejectionReason.present
            ? rejectionReason.value
            : this.rejectionReason,
        assigneesJson: assigneesJson ?? this.assigneesJson,
        milestonesJson: milestonesJson ?? this.milestonesJson,
        githubLink: githubLink.present ? githubLink.value : this.githubLink,
        figmaLink: figmaLink.present ? figmaLink.value : this.figmaLink,
        taskType: taskType ?? this.taskType,
        recurrencePattern: recurrencePattern.present
            ? recurrencePattern.value
            : this.recurrencePattern,
        nextOccurrence:
            nextOccurrence.present ? nextOccurrence.value : this.nextOccurrence,
        plannedHours: plannedHours ?? this.plannedHours,
      );
  Task copyWithCompanion(TasksCompanion data) {
    return Task(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      progress: data.progress.present ? data.progress.value : this.progress,
      priority: data.priority.present ? data.priority.value : this.priority,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      approvalStatus: data.approvalStatus.present
          ? data.approvalStatus.value
          : this.approvalStatus,
      rejectionReason: data.rejectionReason.present
          ? data.rejectionReason.value
          : this.rejectionReason,
      assigneesJson: data.assigneesJson.present
          ? data.assigneesJson.value
          : this.assigneesJson,
      milestonesJson: data.milestonesJson.present
          ? data.milestonesJson.value
          : this.milestonesJson,
      githubLink:
          data.githubLink.present ? data.githubLink.value : this.githubLink,
      figmaLink: data.figmaLink.present ? data.figmaLink.value : this.figmaLink,
      taskType: data.taskType.present ? data.taskType.value : this.taskType,
      recurrencePattern: data.recurrencePattern.present
          ? data.recurrencePattern.value
          : this.recurrencePattern,
      nextOccurrence: data.nextOccurrence.present
          ? data.nextOccurrence.value
          : this.nextOccurrence,
      plannedHours: data.plannedHours.present
          ? data.plannedHours.value
          : this.plannedHours,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Task(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('projectId: $projectId, ')
          ..write('progress: $progress, ')
          ..write('priority: $priority, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('approvalStatus: $approvalStatus, ')
          ..write('rejectionReason: $rejectionReason, ')
          ..write('assigneesJson: $assigneesJson, ')
          ..write('milestonesJson: $milestonesJson, ')
          ..write('githubLink: $githubLink, ')
          ..write('figmaLink: $figmaLink, ')
          ..write('taskType: $taskType, ')
          ..write('recurrencePattern: $recurrencePattern, ')
          ..write('nextOccurrence: $nextOccurrence, ')
          ..write('plannedHours: $plannedHours')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      projectId,
      progress,
      priority,
      startDate,
      endDate,
      approvalStatus,
      rejectionReason,
      assigneesJson,
      milestonesJson,
      githubLink,
      figmaLink,
      taskType,
      recurrencePattern,
      nextOccurrence,
      plannedHours);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Task &&
          other.id == this.id &&
          other.name == this.name &&
          other.projectId == this.projectId &&
          other.progress == this.progress &&
          other.priority == this.priority &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.approvalStatus == this.approvalStatus &&
          other.rejectionReason == this.rejectionReason &&
          other.assigneesJson == this.assigneesJson &&
          other.milestonesJson == this.milestonesJson &&
          other.githubLink == this.githubLink &&
          other.figmaLink == this.figmaLink &&
          other.taskType == this.taskType &&
          other.recurrencePattern == this.recurrencePattern &&
          other.nextOccurrence == this.nextOccurrence &&
          other.plannedHours == this.plannedHours);
}

class TasksCompanion extends UpdateCompanion<Task> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> projectId;
  final Value<int> progress;
  final Value<String> priority;
  final Value<DateTime> startDate;
  final Value<DateTime> endDate;
  final Value<String?> approvalStatus;
  final Value<String?> rejectionReason;
  final Value<String> assigneesJson;
  final Value<String> milestonesJson;
  final Value<String?> githubLink;
  final Value<String?> figmaLink;
  final Value<String> taskType;
  final Value<String?> recurrencePattern;
  final Value<DateTime?> nextOccurrence;
  final Value<double> plannedHours;
  final Value<int> rowid;
  const TasksCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.projectId = const Value.absent(),
    this.progress = const Value.absent(),
    this.priority = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.approvalStatus = const Value.absent(),
    this.rejectionReason = const Value.absent(),
    this.assigneesJson = const Value.absent(),
    this.milestonesJson = const Value.absent(),
    this.githubLink = const Value.absent(),
    this.figmaLink = const Value.absent(),
    this.taskType = const Value.absent(),
    this.recurrencePattern = const Value.absent(),
    this.nextOccurrence = const Value.absent(),
    this.plannedHours = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TasksCompanion.insert({
    required String id,
    required String name,
    required String projectId,
    this.progress = const Value.absent(),
    required String priority,
    required DateTime startDate,
    required DateTime endDate,
    this.approvalStatus = const Value.absent(),
    this.rejectionReason = const Value.absent(),
    required String assigneesJson,
    this.milestonesJson = const Value.absent(),
    this.githubLink = const Value.absent(),
    this.figmaLink = const Value.absent(),
    this.taskType = const Value.absent(),
    this.recurrencePattern = const Value.absent(),
    this.nextOccurrence = const Value.absent(),
    this.plannedHours = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        projectId = Value(projectId),
        priority = Value(priority),
        startDate = Value(startDate),
        endDate = Value(endDate),
        assigneesJson = Value(assigneesJson);
  static Insertable<Task> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? projectId,
    Expression<int>? progress,
    Expression<String>? priority,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<String>? approvalStatus,
    Expression<String>? rejectionReason,
    Expression<String>? assigneesJson,
    Expression<String>? milestonesJson,
    Expression<String>? githubLink,
    Expression<String>? figmaLink,
    Expression<String>? taskType,
    Expression<String>? recurrencePattern,
    Expression<DateTime>? nextOccurrence,
    Expression<double>? plannedHours,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (projectId != null) 'project_id': projectId,
      if (progress != null) 'progress': progress,
      if (priority != null) 'priority': priority,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (approvalStatus != null) 'approval_status': approvalStatus,
      if (rejectionReason != null) 'rejection_reason': rejectionReason,
      if (assigneesJson != null) 'assignees_json': assigneesJson,
      if (milestonesJson != null) 'milestones_json': milestonesJson,
      if (githubLink != null) 'github_link': githubLink,
      if (figmaLink != null) 'figma_link': figmaLink,
      if (taskType != null) 'task_type': taskType,
      if (recurrencePattern != null) 'recurrence_pattern': recurrencePattern,
      if (nextOccurrence != null) 'next_occurrence': nextOccurrence,
      if (plannedHours != null) 'planned_hours': plannedHours,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TasksCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? projectId,
      Value<int>? progress,
      Value<String>? priority,
      Value<DateTime>? startDate,
      Value<DateTime>? endDate,
      Value<String?>? approvalStatus,
      Value<String?>? rejectionReason,
      Value<String>? assigneesJson,
      Value<String>? milestonesJson,
      Value<String?>? githubLink,
      Value<String?>? figmaLink,
      Value<String>? taskType,
      Value<String?>? recurrencePattern,
      Value<DateTime?>? nextOccurrence,
      Value<double>? plannedHours,
      Value<int>? rowid}) {
    return TasksCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      projectId: projectId ?? this.projectId,
      progress: progress ?? this.progress,
      priority: priority ?? this.priority,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      approvalStatus: approvalStatus ?? this.approvalStatus,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      assigneesJson: assigneesJson ?? this.assigneesJson,
      milestonesJson: milestonesJson ?? this.milestonesJson,
      githubLink: githubLink ?? this.githubLink,
      figmaLink: figmaLink ?? this.figmaLink,
      taskType: taskType ?? this.taskType,
      recurrencePattern: recurrencePattern ?? this.recurrencePattern,
      nextOccurrence: nextOccurrence ?? this.nextOccurrence,
      plannedHours: plannedHours ?? this.plannedHours,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (progress.present) {
      map['progress'] = Variable<int>(progress.value);
    }
    if (priority.present) {
      map['priority'] = Variable<String>(priority.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (approvalStatus.present) {
      map['approval_status'] = Variable<String>(approvalStatus.value);
    }
    if (rejectionReason.present) {
      map['rejection_reason'] = Variable<String>(rejectionReason.value);
    }
    if (assigneesJson.present) {
      map['assignees_json'] = Variable<String>(assigneesJson.value);
    }
    if (milestonesJson.present) {
      map['milestones_json'] = Variable<String>(milestonesJson.value);
    }
    if (githubLink.present) {
      map['github_link'] = Variable<String>(githubLink.value);
    }
    if (figmaLink.present) {
      map['figma_link'] = Variable<String>(figmaLink.value);
    }
    if (taskType.present) {
      map['task_type'] = Variable<String>(taskType.value);
    }
    if (recurrencePattern.present) {
      map['recurrence_pattern'] = Variable<String>(recurrencePattern.value);
    }
    if (nextOccurrence.present) {
      map['next_occurrence'] = Variable<DateTime>(nextOccurrence.value);
    }
    if (plannedHours.present) {
      map['planned_hours'] = Variable<double>(plannedHours.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('projectId: $projectId, ')
          ..write('progress: $progress, ')
          ..write('priority: $priority, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('approvalStatus: $approvalStatus, ')
          ..write('rejectionReason: $rejectionReason, ')
          ..write('assigneesJson: $assigneesJson, ')
          ..write('milestonesJson: $milestonesJson, ')
          ..write('githubLink: $githubLink, ')
          ..write('figmaLink: $figmaLink, ')
          ..write('taskType: $taskType, ')
          ..write('recurrencePattern: $recurrencePattern, ')
          ..write('nextOccurrence: $nextOccurrence, ')
          ..write('plannedHours: $plannedHours, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DailyLogsTable extends DailyLogs
    with TableInfo<$DailyLogsTable, DailyLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _isFinalizedMeta =
      const VerificationMeta('isFinalized');
  @override
  late final GeneratedColumn<bool> isFinalized = GeneratedColumn<bool>(
      'is_finalized', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_finalized" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [id, date, userId, isFinalized];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_logs';
  @override
  VerificationContext validateIntegrity(Insertable<DailyLog> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('is_finalized')) {
      context.handle(
          _isFinalizedMeta,
          isFinalized.isAcceptableOrUnknown(
              data['is_finalized']!, _isFinalizedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DailyLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyLog(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      isFinalized: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_finalized'])!,
    );
  }

  @override
  $DailyLogsTable createAlias(String alias) {
    return $DailyLogsTable(attachedDatabase, alias);
  }
}

class DailyLog extends DataClass implements Insertable<DailyLog> {
  final String id;
  final DateTime date;
  final String userId;
  final bool isFinalized;
  const DailyLog(
      {required this.id,
      required this.date,
      required this.userId,
      required this.isFinalized});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['date'] = Variable<DateTime>(date);
    map['user_id'] = Variable<String>(userId);
    map['is_finalized'] = Variable<bool>(isFinalized);
    return map;
  }

  DailyLogsCompanion toCompanion(bool nullToAbsent) {
    return DailyLogsCompanion(
      id: Value(id),
      date: Value(date),
      userId: Value(userId),
      isFinalized: Value(isFinalized),
    );
  }

  factory DailyLog.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyLog(
      id: serializer.fromJson<String>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      userId: serializer.fromJson<String>(json['userId']),
      isFinalized: serializer.fromJson<bool>(json['isFinalized']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'date': serializer.toJson<DateTime>(date),
      'userId': serializer.toJson<String>(userId),
      'isFinalized': serializer.toJson<bool>(isFinalized),
    };
  }

  DailyLog copyWith(
          {String? id, DateTime? date, String? userId, bool? isFinalized}) =>
      DailyLog(
        id: id ?? this.id,
        date: date ?? this.date,
        userId: userId ?? this.userId,
        isFinalized: isFinalized ?? this.isFinalized,
      );
  DailyLog copyWithCompanion(DailyLogsCompanion data) {
    return DailyLog(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      userId: data.userId.present ? data.userId.value : this.userId,
      isFinalized:
          data.isFinalized.present ? data.isFinalized.value : this.isFinalized,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyLog(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('userId: $userId, ')
          ..write('isFinalized: $isFinalized')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, userId, isFinalized);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyLog &&
          other.id == this.id &&
          other.date == this.date &&
          other.userId == this.userId &&
          other.isFinalized == this.isFinalized);
}

class DailyLogsCompanion extends UpdateCompanion<DailyLog> {
  final Value<String> id;
  final Value<DateTime> date;
  final Value<String> userId;
  final Value<bool> isFinalized;
  final Value<int> rowid;
  const DailyLogsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.userId = const Value.absent(),
    this.isFinalized = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailyLogsCompanion.insert({
    required String id,
    required DateTime date,
    required String userId,
    this.isFinalized = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        date = Value(date),
        userId = Value(userId);
  static Insertable<DailyLog> custom({
    Expression<String>? id,
    Expression<DateTime>? date,
    Expression<String>? userId,
    Expression<bool>? isFinalized,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (userId != null) 'user_id': userId,
      if (isFinalized != null) 'is_finalized': isFinalized,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailyLogsCompanion copyWith(
      {Value<String>? id,
      Value<DateTime>? date,
      Value<String>? userId,
      Value<bool>? isFinalized,
      Value<int>? rowid}) {
    return DailyLogsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      userId: userId ?? this.userId,
      isFinalized: isFinalized ?? this.isFinalized,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (isFinalized.present) {
      map['is_finalized'] = Variable<bool>(isFinalized.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyLogsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('userId: $userId, ')
          ..write('isFinalized: $isFinalized, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlannedItemsTable extends PlannedItems
    with TableInfo<$PlannedItemsTable, PlannedItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlannedItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dailyLogIdMeta =
      const VerificationMeta('dailyLogId');
  @override
  late final GeneratedColumn<String> dailyLogId = GeneratedColumn<String>(
      'daily_log_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES daily_logs (id)'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _quadrantMeta =
      const VerificationMeta('quadrant');
  @override
  late final GeneratedColumn<String> quadrant = GeneratedColumn<String>(
      'quadrant', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('q4'));
  static const VerificationMeta _durationMinutesMeta =
      const VerificationMeta('durationMinutes');
  @override
  late final GeneratedColumn<int> durationMinutes = GeneratedColumn<int>(
      'duration_minutes', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _relatedTaskIdMeta =
      const VerificationMeta('relatedTaskId');
  @override
  late final GeneratedColumn<String> relatedTaskId = GeneratedColumn<String>(
      'related_task_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES tasks (id)'));
  static const VerificationMeta _startTimeMeta =
      const VerificationMeta('startTime');
  @override
  late final GeneratedColumn<DateTime> startTime = GeneratedColumn<DateTime>(
      'start_time', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isCompletedMeta =
      const VerificationMeta('isCompleted');
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
      'is_completed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_completed" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        dailyLogId,
        name,
        description,
        quadrant,
        durationMinutes,
        relatedTaskId,
        startTime,
        isCompleted
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'planned_items';
  @override
  VerificationContext validateIntegrity(Insertable<PlannedItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('daily_log_id')) {
      context.handle(
          _dailyLogIdMeta,
          dailyLogId.isAcceptableOrUnknown(
              data['daily_log_id']!, _dailyLogIdMeta));
    } else if (isInserting) {
      context.missing(_dailyLogIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('quadrant')) {
      context.handle(_quadrantMeta,
          quadrant.isAcceptableOrUnknown(data['quadrant']!, _quadrantMeta));
    }
    if (data.containsKey('duration_minutes')) {
      context.handle(
          _durationMinutesMeta,
          durationMinutes.isAcceptableOrUnknown(
              data['duration_minutes']!, _durationMinutesMeta));
    }
    if (data.containsKey('related_task_id')) {
      context.handle(
          _relatedTaskIdMeta,
          relatedTaskId.isAcceptableOrUnknown(
              data['related_task_id']!, _relatedTaskIdMeta));
    }
    if (data.containsKey('start_time')) {
      context.handle(_startTimeMeta,
          startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta));
    }
    if (data.containsKey('is_completed')) {
      context.handle(
          _isCompletedMeta,
          isCompleted.isAcceptableOrUnknown(
              data['is_completed']!, _isCompletedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlannedItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlannedItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      dailyLogId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}daily_log_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      quadrant: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}quadrant'])!,
      durationMinutes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration_minutes'])!,
      relatedTaskId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}related_task_id']),
      startTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_time']),
      isCompleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_completed'])!,
    );
  }

  @override
  $PlannedItemsTable createAlias(String alias) {
    return $PlannedItemsTable(attachedDatabase, alias);
  }
}

class PlannedItem extends DataClass implements Insertable<PlannedItem> {
  final String id;
  final String dailyLogId;
  final String name;
  final String description;
  final String quadrant;
  final int durationMinutes;
  final String? relatedTaskId;
  final DateTime? startTime;
  final bool isCompleted;
  const PlannedItem(
      {required this.id,
      required this.dailyLogId,
      required this.name,
      required this.description,
      required this.quadrant,
      required this.durationMinutes,
      this.relatedTaskId,
      this.startTime,
      required this.isCompleted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['daily_log_id'] = Variable<String>(dailyLogId);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    map['quadrant'] = Variable<String>(quadrant);
    map['duration_minutes'] = Variable<int>(durationMinutes);
    if (!nullToAbsent || relatedTaskId != null) {
      map['related_task_id'] = Variable<String>(relatedTaskId);
    }
    if (!nullToAbsent || startTime != null) {
      map['start_time'] = Variable<DateTime>(startTime);
    }
    map['is_completed'] = Variable<bool>(isCompleted);
    return map;
  }

  PlannedItemsCompanion toCompanion(bool nullToAbsent) {
    return PlannedItemsCompanion(
      id: Value(id),
      dailyLogId: Value(dailyLogId),
      name: Value(name),
      description: Value(description),
      quadrant: Value(quadrant),
      durationMinutes: Value(durationMinutes),
      relatedTaskId: relatedTaskId == null && nullToAbsent
          ? const Value.absent()
          : Value(relatedTaskId),
      startTime: startTime == null && nullToAbsent
          ? const Value.absent()
          : Value(startTime),
      isCompleted: Value(isCompleted),
    );
  }

  factory PlannedItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlannedItem(
      id: serializer.fromJson<String>(json['id']),
      dailyLogId: serializer.fromJson<String>(json['dailyLogId']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      quadrant: serializer.fromJson<String>(json['quadrant']),
      durationMinutes: serializer.fromJson<int>(json['durationMinutes']),
      relatedTaskId: serializer.fromJson<String?>(json['relatedTaskId']),
      startTime: serializer.fromJson<DateTime?>(json['startTime']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'dailyLogId': serializer.toJson<String>(dailyLogId),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'quadrant': serializer.toJson<String>(quadrant),
      'durationMinutes': serializer.toJson<int>(durationMinutes),
      'relatedTaskId': serializer.toJson<String?>(relatedTaskId),
      'startTime': serializer.toJson<DateTime?>(startTime),
      'isCompleted': serializer.toJson<bool>(isCompleted),
    };
  }

  PlannedItem copyWith(
          {String? id,
          String? dailyLogId,
          String? name,
          String? description,
          String? quadrant,
          int? durationMinutes,
          Value<String?> relatedTaskId = const Value.absent(),
          Value<DateTime?> startTime = const Value.absent(),
          bool? isCompleted}) =>
      PlannedItem(
        id: id ?? this.id,
        dailyLogId: dailyLogId ?? this.dailyLogId,
        name: name ?? this.name,
        description: description ?? this.description,
        quadrant: quadrant ?? this.quadrant,
        durationMinutes: durationMinutes ?? this.durationMinutes,
        relatedTaskId:
            relatedTaskId.present ? relatedTaskId.value : this.relatedTaskId,
        startTime: startTime.present ? startTime.value : this.startTime,
        isCompleted: isCompleted ?? this.isCompleted,
      );
  PlannedItem copyWithCompanion(PlannedItemsCompanion data) {
    return PlannedItem(
      id: data.id.present ? data.id.value : this.id,
      dailyLogId:
          data.dailyLogId.present ? data.dailyLogId.value : this.dailyLogId,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      quadrant: data.quadrant.present ? data.quadrant.value : this.quadrant,
      durationMinutes: data.durationMinutes.present
          ? data.durationMinutes.value
          : this.durationMinutes,
      relatedTaskId: data.relatedTaskId.present
          ? data.relatedTaskId.value
          : this.relatedTaskId,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      isCompleted:
          data.isCompleted.present ? data.isCompleted.value : this.isCompleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlannedItem(')
          ..write('id: $id, ')
          ..write('dailyLogId: $dailyLogId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('quadrant: $quadrant, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('relatedTaskId: $relatedTaskId, ')
          ..write('startTime: $startTime, ')
          ..write('isCompleted: $isCompleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, dailyLogId, name, description, quadrant,
      durationMinutes, relatedTaskId, startTime, isCompleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlannedItem &&
          other.id == this.id &&
          other.dailyLogId == this.dailyLogId &&
          other.name == this.name &&
          other.description == this.description &&
          other.quadrant == this.quadrant &&
          other.durationMinutes == this.durationMinutes &&
          other.relatedTaskId == this.relatedTaskId &&
          other.startTime == this.startTime &&
          other.isCompleted == this.isCompleted);
}

class PlannedItemsCompanion extends UpdateCompanion<PlannedItem> {
  final Value<String> id;
  final Value<String> dailyLogId;
  final Value<String> name;
  final Value<String> description;
  final Value<String> quadrant;
  final Value<int> durationMinutes;
  final Value<String?> relatedTaskId;
  final Value<DateTime?> startTime;
  final Value<bool> isCompleted;
  final Value<int> rowid;
  const PlannedItemsCompanion({
    this.id = const Value.absent(),
    this.dailyLogId = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.quadrant = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.relatedTaskId = const Value.absent(),
    this.startTime = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlannedItemsCompanion.insert({
    required String id,
    required String dailyLogId,
    required String name,
    this.description = const Value.absent(),
    this.quadrant = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.relatedTaskId = const Value.absent(),
    this.startTime = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        dailyLogId = Value(dailyLogId),
        name = Value(name);
  static Insertable<PlannedItem> custom({
    Expression<String>? id,
    Expression<String>? dailyLogId,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? quadrant,
    Expression<int>? durationMinutes,
    Expression<String>? relatedTaskId,
    Expression<DateTime>? startTime,
    Expression<bool>? isCompleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dailyLogId != null) 'daily_log_id': dailyLogId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (quadrant != null) 'quadrant': quadrant,
      if (durationMinutes != null) 'duration_minutes': durationMinutes,
      if (relatedTaskId != null) 'related_task_id': relatedTaskId,
      if (startTime != null) 'start_time': startTime,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlannedItemsCompanion copyWith(
      {Value<String>? id,
      Value<String>? dailyLogId,
      Value<String>? name,
      Value<String>? description,
      Value<String>? quadrant,
      Value<int>? durationMinutes,
      Value<String?>? relatedTaskId,
      Value<DateTime?>? startTime,
      Value<bool>? isCompleted,
      Value<int>? rowid}) {
    return PlannedItemsCompanion(
      id: id ?? this.id,
      dailyLogId: dailyLogId ?? this.dailyLogId,
      name: name ?? this.name,
      description: description ?? this.description,
      quadrant: quadrant ?? this.quadrant,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      relatedTaskId: relatedTaskId ?? this.relatedTaskId,
      startTime: startTime ?? this.startTime,
      isCompleted: isCompleted ?? this.isCompleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (dailyLogId.present) {
      map['daily_log_id'] = Variable<String>(dailyLogId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (quadrant.present) {
      map['quadrant'] = Variable<String>(quadrant.value);
    }
    if (durationMinutes.present) {
      map['duration_minutes'] = Variable<int>(durationMinutes.value);
    }
    if (relatedTaskId.present) {
      map['related_task_id'] = Variable<String>(relatedTaskId.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<DateTime>(startTime.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlannedItemsCompanion(')
          ..write('id: $id, ')
          ..write('dailyLogId: $dailyLogId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('quadrant: $quadrant, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('relatedTaskId: $relatedTaskId, ')
          ..write('startTime: $startTime, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LoggedItemsTable extends LoggedItems
    with TableInfo<$LoggedItemsTable, LoggedItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LoggedItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dailyLogIdMeta =
      const VerificationMeta('dailyLogId');
  @override
  late final GeneratedColumn<String> dailyLogId = GeneratedColumn<String>(
      'daily_log_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES daily_logs (id)'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _startTimeMeta =
      const VerificationMeta('startTime');
  @override
  late final GeneratedColumn<DateTime> startTime = GeneratedColumn<DateTime>(
      'start_time', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _endTimeMeta =
      const VerificationMeta('endTime');
  @override
  late final GeneratedColumn<DateTime> endTime = GeneratedColumn<DateTime>(
      'end_time', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isUnplannedMeta =
      const VerificationMeta('isUnplanned');
  @override
  late final GeneratedColumn<bool> isUnplanned = GeneratedColumn<bool>(
      'is_unplanned', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_unplanned" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _plannedItemIdMeta =
      const VerificationMeta('plannedItemId');
  @override
  late final GeneratedColumn<String> plannedItemId = GeneratedColumn<String>(
      'planned_item_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES planned_items (id)'));
  static const VerificationMeta _relatedTaskIdMeta =
      const VerificationMeta('relatedTaskId');
  @override
  late final GeneratedColumn<String> relatedTaskId = GeneratedColumn<String>(
      'related_task_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES tasks (id)'));
  static const VerificationMeta _remarksJsonMeta =
      const VerificationMeta('remarksJson');
  @override
  late final GeneratedColumn<String> remarksJson = GeneratedColumn<String>(
      'remarks_json', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        dailyLogId,
        name,
        description,
        startTime,
        endTime,
        isUnplanned,
        plannedItemId,
        relatedTaskId,
        remarksJson
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'logged_items';
  @override
  VerificationContext validateIntegrity(Insertable<LoggedItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('daily_log_id')) {
      context.handle(
          _dailyLogIdMeta,
          dailyLogId.isAcceptableOrUnknown(
              data['daily_log_id']!, _dailyLogIdMeta));
    } else if (isInserting) {
      context.missing(_dailyLogIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('start_time')) {
      context.handle(_startTimeMeta,
          startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta));
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(_endTimeMeta,
          endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta));
    }
    if (data.containsKey('is_unplanned')) {
      context.handle(
          _isUnplannedMeta,
          isUnplanned.isAcceptableOrUnknown(
              data['is_unplanned']!, _isUnplannedMeta));
    }
    if (data.containsKey('planned_item_id')) {
      context.handle(
          _plannedItemIdMeta,
          plannedItemId.isAcceptableOrUnknown(
              data['planned_item_id']!, _plannedItemIdMeta));
    }
    if (data.containsKey('related_task_id')) {
      context.handle(
          _relatedTaskIdMeta,
          relatedTaskId.isAcceptableOrUnknown(
              data['related_task_id']!, _relatedTaskIdMeta));
    }
    if (data.containsKey('remarks_json')) {
      context.handle(
          _remarksJsonMeta,
          remarksJson.isAcceptableOrUnknown(
              data['remarks_json']!, _remarksJsonMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LoggedItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LoggedItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      dailyLogId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}daily_log_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      startTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_time'])!,
      endTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end_time']),
      isUnplanned: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_unplanned'])!,
      plannedItemId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}planned_item_id']),
      relatedTaskId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}related_task_id']),
      remarksJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}remarks_json'])!,
    );
  }

  @override
  $LoggedItemsTable createAlias(String alias) {
    return $LoggedItemsTable(attachedDatabase, alias);
  }
}

class LoggedItem extends DataClass implements Insertable<LoggedItem> {
  final String id;
  final String dailyLogId;
  final String name;
  final String description;
  final DateTime startTime;
  final DateTime? endTime;
  final bool isUnplanned;
  final String? plannedItemId;
  final String? relatedTaskId;
  final String remarksJson;
  const LoggedItem(
      {required this.id,
      required this.dailyLogId,
      required this.name,
      required this.description,
      required this.startTime,
      this.endTime,
      required this.isUnplanned,
      this.plannedItemId,
      this.relatedTaskId,
      required this.remarksJson});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['daily_log_id'] = Variable<String>(dailyLogId);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    map['start_time'] = Variable<DateTime>(startTime);
    if (!nullToAbsent || endTime != null) {
      map['end_time'] = Variable<DateTime>(endTime);
    }
    map['is_unplanned'] = Variable<bool>(isUnplanned);
    if (!nullToAbsent || plannedItemId != null) {
      map['planned_item_id'] = Variable<String>(plannedItemId);
    }
    if (!nullToAbsent || relatedTaskId != null) {
      map['related_task_id'] = Variable<String>(relatedTaskId);
    }
    map['remarks_json'] = Variable<String>(remarksJson);
    return map;
  }

  LoggedItemsCompanion toCompanion(bool nullToAbsent) {
    return LoggedItemsCompanion(
      id: Value(id),
      dailyLogId: Value(dailyLogId),
      name: Value(name),
      description: Value(description),
      startTime: Value(startTime),
      endTime: endTime == null && nullToAbsent
          ? const Value.absent()
          : Value(endTime),
      isUnplanned: Value(isUnplanned),
      plannedItemId: plannedItemId == null && nullToAbsent
          ? const Value.absent()
          : Value(plannedItemId),
      relatedTaskId: relatedTaskId == null && nullToAbsent
          ? const Value.absent()
          : Value(relatedTaskId),
      remarksJson: Value(remarksJson),
    );
  }

  factory LoggedItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LoggedItem(
      id: serializer.fromJson<String>(json['id']),
      dailyLogId: serializer.fromJson<String>(json['dailyLogId']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      startTime: serializer.fromJson<DateTime>(json['startTime']),
      endTime: serializer.fromJson<DateTime?>(json['endTime']),
      isUnplanned: serializer.fromJson<bool>(json['isUnplanned']),
      plannedItemId: serializer.fromJson<String?>(json['plannedItemId']),
      relatedTaskId: serializer.fromJson<String?>(json['relatedTaskId']),
      remarksJson: serializer.fromJson<String>(json['remarksJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'dailyLogId': serializer.toJson<String>(dailyLogId),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'startTime': serializer.toJson<DateTime>(startTime),
      'endTime': serializer.toJson<DateTime?>(endTime),
      'isUnplanned': serializer.toJson<bool>(isUnplanned),
      'plannedItemId': serializer.toJson<String?>(plannedItemId),
      'relatedTaskId': serializer.toJson<String?>(relatedTaskId),
      'remarksJson': serializer.toJson<String>(remarksJson),
    };
  }

  LoggedItem copyWith(
          {String? id,
          String? dailyLogId,
          String? name,
          String? description,
          DateTime? startTime,
          Value<DateTime?> endTime = const Value.absent(),
          bool? isUnplanned,
          Value<String?> plannedItemId = const Value.absent(),
          Value<String?> relatedTaskId = const Value.absent(),
          String? remarksJson}) =>
      LoggedItem(
        id: id ?? this.id,
        dailyLogId: dailyLogId ?? this.dailyLogId,
        name: name ?? this.name,
        description: description ?? this.description,
        startTime: startTime ?? this.startTime,
        endTime: endTime.present ? endTime.value : this.endTime,
        isUnplanned: isUnplanned ?? this.isUnplanned,
        plannedItemId:
            plannedItemId.present ? plannedItemId.value : this.plannedItemId,
        relatedTaskId:
            relatedTaskId.present ? relatedTaskId.value : this.relatedTaskId,
        remarksJson: remarksJson ?? this.remarksJson,
      );
  LoggedItem copyWithCompanion(LoggedItemsCompanion data) {
    return LoggedItem(
      id: data.id.present ? data.id.value : this.id,
      dailyLogId:
          data.dailyLogId.present ? data.dailyLogId.value : this.dailyLogId,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      isUnplanned:
          data.isUnplanned.present ? data.isUnplanned.value : this.isUnplanned,
      plannedItemId: data.plannedItemId.present
          ? data.plannedItemId.value
          : this.plannedItemId,
      relatedTaskId: data.relatedTaskId.present
          ? data.relatedTaskId.value
          : this.relatedTaskId,
      remarksJson:
          data.remarksJson.present ? data.remarksJson.value : this.remarksJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LoggedItem(')
          ..write('id: $id, ')
          ..write('dailyLogId: $dailyLogId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('isUnplanned: $isUnplanned, ')
          ..write('plannedItemId: $plannedItemId, ')
          ..write('relatedTaskId: $relatedTaskId, ')
          ..write('remarksJson: $remarksJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, dailyLogId, name, description, startTime,
      endTime, isUnplanned, plannedItemId, relatedTaskId, remarksJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LoggedItem &&
          other.id == this.id &&
          other.dailyLogId == this.dailyLogId &&
          other.name == this.name &&
          other.description == this.description &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.isUnplanned == this.isUnplanned &&
          other.plannedItemId == this.plannedItemId &&
          other.relatedTaskId == this.relatedTaskId &&
          other.remarksJson == this.remarksJson);
}

class LoggedItemsCompanion extends UpdateCompanion<LoggedItem> {
  final Value<String> id;
  final Value<String> dailyLogId;
  final Value<String> name;
  final Value<String> description;
  final Value<DateTime> startTime;
  final Value<DateTime?> endTime;
  final Value<bool> isUnplanned;
  final Value<String?> plannedItemId;
  final Value<String?> relatedTaskId;
  final Value<String> remarksJson;
  final Value<int> rowid;
  const LoggedItemsCompanion({
    this.id = const Value.absent(),
    this.dailyLogId = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.isUnplanned = const Value.absent(),
    this.plannedItemId = const Value.absent(),
    this.relatedTaskId = const Value.absent(),
    this.remarksJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LoggedItemsCompanion.insert({
    required String id,
    required String dailyLogId,
    required String name,
    this.description = const Value.absent(),
    required DateTime startTime,
    this.endTime = const Value.absent(),
    this.isUnplanned = const Value.absent(),
    this.plannedItemId = const Value.absent(),
    this.relatedTaskId = const Value.absent(),
    this.remarksJson = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        dailyLogId = Value(dailyLogId),
        name = Value(name),
        startTime = Value(startTime);
  static Insertable<LoggedItem> custom({
    Expression<String>? id,
    Expression<String>? dailyLogId,
    Expression<String>? name,
    Expression<String>? description,
    Expression<DateTime>? startTime,
    Expression<DateTime>? endTime,
    Expression<bool>? isUnplanned,
    Expression<String>? plannedItemId,
    Expression<String>? relatedTaskId,
    Expression<String>? remarksJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dailyLogId != null) 'daily_log_id': dailyLogId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (isUnplanned != null) 'is_unplanned': isUnplanned,
      if (plannedItemId != null) 'planned_item_id': plannedItemId,
      if (relatedTaskId != null) 'related_task_id': relatedTaskId,
      if (remarksJson != null) 'remarks_json': remarksJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LoggedItemsCompanion copyWith(
      {Value<String>? id,
      Value<String>? dailyLogId,
      Value<String>? name,
      Value<String>? description,
      Value<DateTime>? startTime,
      Value<DateTime?>? endTime,
      Value<bool>? isUnplanned,
      Value<String?>? plannedItemId,
      Value<String?>? relatedTaskId,
      Value<String>? remarksJson,
      Value<int>? rowid}) {
    return LoggedItemsCompanion(
      id: id ?? this.id,
      dailyLogId: dailyLogId ?? this.dailyLogId,
      name: name ?? this.name,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isUnplanned: isUnplanned ?? this.isUnplanned,
      plannedItemId: plannedItemId ?? this.plannedItemId,
      relatedTaskId: relatedTaskId ?? this.relatedTaskId,
      remarksJson: remarksJson ?? this.remarksJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (dailyLogId.present) {
      map['daily_log_id'] = Variable<String>(dailyLogId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<DateTime>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<DateTime>(endTime.value);
    }
    if (isUnplanned.present) {
      map['is_unplanned'] = Variable<bool>(isUnplanned.value);
    }
    if (plannedItemId.present) {
      map['planned_item_id'] = Variable<String>(plannedItemId.value);
    }
    if (relatedTaskId.present) {
      map['related_task_id'] = Variable<String>(relatedTaskId.value);
    }
    if (remarksJson.present) {
      map['remarks_json'] = Variable<String>(remarksJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LoggedItemsCompanion(')
          ..write('id: $id, ')
          ..write('dailyLogId: $dailyLogId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('isUnplanned: $isUnplanned, ')
          ..write('plannedItemId: $plannedItemId, ')
          ..write('relatedTaskId: $relatedTaskId, ')
          ..write('remarksJson: $remarksJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChatSessionsTable extends ChatSessions
    with TableInfo<$ChatSessionsTable, ChatSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChatSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lastModifiedMeta =
      const VerificationMeta('lastModified');
  @override
  late final GeneratedColumn<DateTime> lastModified = GeneratedColumn<DateTime>(
      'last_modified', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, userId, title, lastModified];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chat_sessions';
  @override
  VerificationContext validateIntegrity(Insertable<ChatSession> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('last_modified')) {
      context.handle(
          _lastModifiedMeta,
          lastModified.isAcceptableOrUnknown(
              data['last_modified']!, _lastModifiedMeta));
    } else if (isInserting) {
      context.missing(_lastModifiedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChatSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChatSession(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      lastModified: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_modified'])!,
    );
  }

  @override
  $ChatSessionsTable createAlias(String alias) {
    return $ChatSessionsTable(attachedDatabase, alias);
  }
}

class ChatSession extends DataClass implements Insertable<ChatSession> {
  final String id;
  final String userId;
  final String title;
  final DateTime lastModified;
  const ChatSession(
      {required this.id,
      required this.userId,
      required this.title,
      required this.lastModified});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['title'] = Variable<String>(title);
    map['last_modified'] = Variable<DateTime>(lastModified);
    return map;
  }

  ChatSessionsCompanion toCompanion(bool nullToAbsent) {
    return ChatSessionsCompanion(
      id: Value(id),
      userId: Value(userId),
      title: Value(title),
      lastModified: Value(lastModified),
    );
  }

  factory ChatSession.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChatSession(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      title: serializer.fromJson<String>(json['title']),
      lastModified: serializer.fromJson<DateTime>(json['lastModified']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'title': serializer.toJson<String>(title),
      'lastModified': serializer.toJson<DateTime>(lastModified),
    };
  }

  ChatSession copyWith(
          {String? id,
          String? userId,
          String? title,
          DateTime? lastModified}) =>
      ChatSession(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        title: title ?? this.title,
        lastModified: lastModified ?? this.lastModified,
      );
  ChatSession copyWithCompanion(ChatSessionsCompanion data) {
    return ChatSession(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      title: data.title.present ? data.title.value : this.title,
      lastModified: data.lastModified.present
          ? data.lastModified.value
          : this.lastModified,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChatSession(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('title: $title, ')
          ..write('lastModified: $lastModified')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, title, lastModified);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatSession &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.title == this.title &&
          other.lastModified == this.lastModified);
}

class ChatSessionsCompanion extends UpdateCompanion<ChatSession> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> title;
  final Value<DateTime> lastModified;
  final Value<int> rowid;
  const ChatSessionsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.title = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChatSessionsCompanion.insert({
    required String id,
    required String userId,
    required String title,
    required DateTime lastModified,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        userId = Value(userId),
        title = Value(title),
        lastModified = Value(lastModified);
  static Insertable<ChatSession> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? title,
    Expression<DateTime>? lastModified,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (title != null) 'title': title,
      if (lastModified != null) 'last_modified': lastModified,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChatSessionsCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<String>? title,
      Value<DateTime>? lastModified,
      Value<int>? rowid}) {
    return ChatSessionsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      lastModified: lastModified ?? this.lastModified,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (lastModified.present) {
      map['last_modified'] = Variable<DateTime>(lastModified.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChatSessionsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('title: $title, ')
          ..write('lastModified: $lastModified, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChatMessagesTable extends ChatMessages
    with TableInfo<$ChatMessagesTable, ChatMessage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChatMessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sessionIdMeta =
      const VerificationMeta('sessionId');
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
      'session_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES chat_sessions (id)'));
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _senderMeta = const VerificationMeta('sender');
  @override
  late final GeneratedColumn<String> sender = GeneratedColumn<String>(
      'sender', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, sessionId, content, sender, timestamp];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chat_messages';
  @override
  VerificationContext validateIntegrity(Insertable<ChatMessage> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(_sessionIdMeta,
          sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta));
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('sender')) {
      context.handle(_senderMeta,
          sender.isAcceptableOrUnknown(data['sender']!, _senderMeta));
    } else if (isInserting) {
      context.missing(_senderMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChatMessage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChatMessage(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      sessionId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}session_id'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      sender: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sender'])!,
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}timestamp'])!,
    );
  }

  @override
  $ChatMessagesTable createAlias(String alias) {
    return $ChatMessagesTable(attachedDatabase, alias);
  }
}

class ChatMessage extends DataClass implements Insertable<ChatMessage> {
  final String id;
  final String sessionId;
  final String content;
  final String sender;
  final DateTime timestamp;
  const ChatMessage(
      {required this.id,
      required this.sessionId,
      required this.content,
      required this.sender,
      required this.timestamp});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['session_id'] = Variable<String>(sessionId);
    map['content'] = Variable<String>(content);
    map['sender'] = Variable<String>(sender);
    map['timestamp'] = Variable<DateTime>(timestamp);
    return map;
  }

  ChatMessagesCompanion toCompanion(bool nullToAbsent) {
    return ChatMessagesCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      content: Value(content),
      sender: Value(sender),
      timestamp: Value(timestamp),
    );
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChatMessage(
      id: serializer.fromJson<String>(json['id']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      content: serializer.fromJson<String>(json['content']),
      sender: serializer.fromJson<String>(json['sender']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sessionId': serializer.toJson<String>(sessionId),
      'content': serializer.toJson<String>(content),
      'sender': serializer.toJson<String>(sender),
      'timestamp': serializer.toJson<DateTime>(timestamp),
    };
  }

  ChatMessage copyWith(
          {String? id,
          String? sessionId,
          String? content,
          String? sender,
          DateTime? timestamp}) =>
      ChatMessage(
        id: id ?? this.id,
        sessionId: sessionId ?? this.sessionId,
        content: content ?? this.content,
        sender: sender ?? this.sender,
        timestamp: timestamp ?? this.timestamp,
      );
  ChatMessage copyWithCompanion(ChatMessagesCompanion data) {
    return ChatMessage(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      content: data.content.present ? data.content.value : this.content,
      sender: data.sender.present ? data.sender.value : this.sender,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChatMessage(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('content: $content, ')
          ..write('sender: $sender, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, sessionId, content, sender, timestamp);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatMessage &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.content == this.content &&
          other.sender == this.sender &&
          other.timestamp == this.timestamp);
}

class ChatMessagesCompanion extends UpdateCompanion<ChatMessage> {
  final Value<String> id;
  final Value<String> sessionId;
  final Value<String> content;
  final Value<String> sender;
  final Value<DateTime> timestamp;
  final Value<int> rowid;
  const ChatMessagesCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.content = const Value.absent(),
    this.sender = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChatMessagesCompanion.insert({
    required String id,
    required String sessionId,
    required String content,
    required String sender,
    required DateTime timestamp,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        sessionId = Value(sessionId),
        content = Value(content),
        sender = Value(sender),
        timestamp = Value(timestamp);
  static Insertable<ChatMessage> custom({
    Expression<String>? id,
    Expression<String>? sessionId,
    Expression<String>? content,
    Expression<String>? sender,
    Expression<DateTime>? timestamp,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (content != null) 'content': content,
      if (sender != null) 'sender': sender,
      if (timestamp != null) 'timestamp': timestamp,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChatMessagesCompanion copyWith(
      {Value<String>? id,
      Value<String>? sessionId,
      Value<String>? content,
      Value<String>? sender,
      Value<DateTime>? timestamp,
      Value<int>? rowid}) {
    return ChatMessagesCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      content: content ?? this.content,
      sender: sender ?? this.sender,
      timestamp: timestamp ?? this.timestamp,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (sender.present) {
      map['sender'] = Variable<String>(sender.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChatMessagesCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('content: $content, ')
          ..write('sender: $sender, ')
          ..write('timestamp: $timestamp, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ActivityTemplatesTable extends ActivityTemplates
    with TableInfo<$ActivityTemplatesTable, ActivityTemplate> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActivityTemplatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _defaultDurationMeta =
      const VerificationMeta('defaultDuration');
  @override
  late final GeneratedColumn<int> defaultDuration = GeneratedColumn<int>(
      'default_duration', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(60));
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _createdByMeta =
      const VerificationMeta('createdBy');
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
      'created_by', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isSystemMeta =
      const VerificationMeta('isSystem');
  @override
  late final GeneratedColumn<bool> isSystem = GeneratedColumn<bool>(
      'is_system', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_system" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        category,
        defaultDuration,
        description,
        status,
        createdBy,
        isSystem
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'activity_templates';
  @override
  VerificationContext validateIntegrity(Insertable<ActivityTemplate> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('default_duration')) {
      context.handle(
          _defaultDurationMeta,
          defaultDuration.isAcceptableOrUnknown(
              data['default_duration']!, _defaultDurationMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('created_by')) {
      context.handle(_createdByMeta,
          createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));
    }
    if (data.containsKey('is_system')) {
      context.handle(_isSystemMeta,
          isSystem.isAcceptableOrUnknown(data['is_system']!, _isSystemMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ActivityTemplate map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActivityTemplate(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      defaultDuration: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}default_duration'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      createdBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_by']),
      isSystem: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_system'])!,
    );
  }

  @override
  $ActivityTemplatesTable createAlias(String alias) {
    return $ActivityTemplatesTable(attachedDatabase, alias);
  }
}

class ActivityTemplate extends DataClass
    implements Insertable<ActivityTemplate> {
  final String id;
  final String name;
  final String category;
  final int defaultDuration;
  final String? description;
  final String status;
  final String? createdBy;
  final bool isSystem;
  const ActivityTemplate(
      {required this.id,
      required this.name,
      required this.category,
      required this.defaultDuration,
      this.description,
      required this.status,
      this.createdBy,
      required this.isSystem});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['category'] = Variable<String>(category);
    map['default_duration'] = Variable<int>(defaultDuration);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || createdBy != null) {
      map['created_by'] = Variable<String>(createdBy);
    }
    map['is_system'] = Variable<bool>(isSystem);
    return map;
  }

  ActivityTemplatesCompanion toCompanion(bool nullToAbsent) {
    return ActivityTemplatesCompanion(
      id: Value(id),
      name: Value(name),
      category: Value(category),
      defaultDuration: Value(defaultDuration),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      status: Value(status),
      createdBy: createdBy == null && nullToAbsent
          ? const Value.absent()
          : Value(createdBy),
      isSystem: Value(isSystem),
    );
  }

  factory ActivityTemplate.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActivityTemplate(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      category: serializer.fromJson<String>(json['category']),
      defaultDuration: serializer.fromJson<int>(json['defaultDuration']),
      description: serializer.fromJson<String?>(json['description']),
      status: serializer.fromJson<String>(json['status']),
      createdBy: serializer.fromJson<String?>(json['createdBy']),
      isSystem: serializer.fromJson<bool>(json['isSystem']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'category': serializer.toJson<String>(category),
      'defaultDuration': serializer.toJson<int>(defaultDuration),
      'description': serializer.toJson<String?>(description),
      'status': serializer.toJson<String>(status),
      'createdBy': serializer.toJson<String?>(createdBy),
      'isSystem': serializer.toJson<bool>(isSystem),
    };
  }

  ActivityTemplate copyWith(
          {String? id,
          String? name,
          String? category,
          int? defaultDuration,
          Value<String?> description = const Value.absent(),
          String? status,
          Value<String?> createdBy = const Value.absent(),
          bool? isSystem}) =>
      ActivityTemplate(
        id: id ?? this.id,
        name: name ?? this.name,
        category: category ?? this.category,
        defaultDuration: defaultDuration ?? this.defaultDuration,
        description: description.present ? description.value : this.description,
        status: status ?? this.status,
        createdBy: createdBy.present ? createdBy.value : this.createdBy,
        isSystem: isSystem ?? this.isSystem,
      );
  ActivityTemplate copyWithCompanion(ActivityTemplatesCompanion data) {
    return ActivityTemplate(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      category: data.category.present ? data.category.value : this.category,
      defaultDuration: data.defaultDuration.present
          ? data.defaultDuration.value
          : this.defaultDuration,
      description:
          data.description.present ? data.description.value : this.description,
      status: data.status.present ? data.status.value : this.status,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      isSystem: data.isSystem.present ? data.isSystem.value : this.isSystem,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActivityTemplate(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('defaultDuration: $defaultDuration, ')
          ..write('description: $description, ')
          ..write('status: $status, ')
          ..write('createdBy: $createdBy, ')
          ..write('isSystem: $isSystem')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, category, defaultDuration,
      description, status, createdBy, isSystem);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActivityTemplate &&
          other.id == this.id &&
          other.name == this.name &&
          other.category == this.category &&
          other.defaultDuration == this.defaultDuration &&
          other.description == this.description &&
          other.status == this.status &&
          other.createdBy == this.createdBy &&
          other.isSystem == this.isSystem);
}

class ActivityTemplatesCompanion extends UpdateCompanion<ActivityTemplate> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> category;
  final Value<int> defaultDuration;
  final Value<String?> description;
  final Value<String> status;
  final Value<String?> createdBy;
  final Value<bool> isSystem;
  final Value<int> rowid;
  const ActivityTemplatesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.category = const Value.absent(),
    this.defaultDuration = const Value.absent(),
    this.description = const Value.absent(),
    this.status = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.isSystem = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ActivityTemplatesCompanion.insert({
    required String id,
    required String name,
    required String category,
    this.defaultDuration = const Value.absent(),
    this.description = const Value.absent(),
    this.status = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.isSystem = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        category = Value(category);
  static Insertable<ActivityTemplate> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? category,
    Expression<int>? defaultDuration,
    Expression<String>? description,
    Expression<String>? status,
    Expression<String>? createdBy,
    Expression<bool>? isSystem,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (category != null) 'category': category,
      if (defaultDuration != null) 'default_duration': defaultDuration,
      if (description != null) 'description': description,
      if (status != null) 'status': status,
      if (createdBy != null) 'created_by': createdBy,
      if (isSystem != null) 'is_system': isSystem,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ActivityTemplatesCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? category,
      Value<int>? defaultDuration,
      Value<String?>? description,
      Value<String>? status,
      Value<String?>? createdBy,
      Value<bool>? isSystem,
      Value<int>? rowid}) {
    return ActivityTemplatesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      defaultDuration: defaultDuration ?? this.defaultDuration,
      description: description ?? this.description,
      status: status ?? this.status,
      createdBy: createdBy ?? this.createdBy,
      isSystem: isSystem ?? this.isSystem,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (defaultDuration.present) {
      map['default_duration'] = Variable<int>(defaultDuration.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (isSystem.present) {
      map['is_system'] = Variable<bool>(isSystem.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivityTemplatesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('defaultDuration: $defaultDuration, ')
          ..write('description: $description, ')
          ..write('status: $status, ')
          ..write('createdBy: $createdBy, ')
          ..write('isSystem: $isSystem, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsersTable users = $UsersTable(this);
  late final $ProjectsTable projects = $ProjectsTable(this);
  late final $TasksTable tasks = $TasksTable(this);
  late final $DailyLogsTable dailyLogs = $DailyLogsTable(this);
  late final $PlannedItemsTable plannedItems = $PlannedItemsTable(this);
  late final $LoggedItemsTable loggedItems = $LoggedItemsTable(this);
  late final $ChatSessionsTable chatSessions = $ChatSessionsTable(this);
  late final $ChatMessagesTable chatMessages = $ChatMessagesTable(this);
  late final $ActivityTemplatesTable activityTemplates =
      $ActivityTemplatesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        users,
        projects,
        tasks,
        dailyLogs,
        plannedItems,
        loggedItems,
        chatSessions,
        chatMessages,
        activityTemplates
      ];
}

typedef $$UsersTableCreateCompanionBuilder = UsersCompanion Function({
  required String id,
  required String name,
  required String avatarUrl,
  required String email,
  required String role,
  Value<String?> reportingManagerId,
  Value<String?> department,
  Value<int> rowid,
});
typedef $$UsersTableUpdateCompanionBuilder = UsersCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> avatarUrl,
  Value<String> email,
  Value<String> role,
  Value<String?> reportingManagerId,
  Value<String?> department,
  Value<int> rowid,
});

final class $$UsersTableReferences
    extends BaseReferences<_$AppDatabase, $UsersTable, User> {
  $$UsersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$DailyLogsTable, List<DailyLog>>
      _dailyLogsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.dailyLogs,
          aliasName: $_aliasNameGenerator(db.users.id, db.dailyLogs.userId));

  $$DailyLogsTableProcessedTableManager get dailyLogsRefs {
    final manager = $$DailyLogsTableTableManager($_db, $_db.dailyLogs)
        .filter((f) => f.userId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_dailyLogsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ChatSessionsTable, List<ChatSession>>
      _chatSessionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.chatSessions,
          aliasName: $_aliasNameGenerator(db.users.id, db.chatSessions.userId));

  $$ChatSessionsTableProcessedTableManager get chatSessionsRefs {
    final manager = $$ChatSessionsTableTableManager($_db, $_db.chatSessions)
        .filter((f) => f.userId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_chatSessionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get avatarUrl => $composableBuilder(
      column: $table.avatarUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reportingManagerId => $composableBuilder(
      column: $table.reportingManagerId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get department => $composableBuilder(
      column: $table.department, builder: (column) => ColumnFilters(column));

  Expression<bool> dailyLogsRefs(
      Expression<bool> Function($$DailyLogsTableFilterComposer f) f) {
    final $$DailyLogsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.dailyLogs,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DailyLogsTableFilterComposer(
              $db: $db,
              $table: $db.dailyLogs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> chatSessionsRefs(
      Expression<bool> Function($$ChatSessionsTableFilterComposer f) f) {
    final $$ChatSessionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.chatSessions,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChatSessionsTableFilterComposer(
              $db: $db,
              $table: $db.chatSessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get avatarUrl => $composableBuilder(
      column: $table.avatarUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reportingManagerId => $composableBuilder(
      column: $table.reportingManagerId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get department => $composableBuilder(
      column: $table.department, builder: (column) => ColumnOrderings(column));
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get avatarUrl =>
      $composableBuilder(column: $table.avatarUrl, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get reportingManagerId => $composableBuilder(
      column: $table.reportingManagerId, builder: (column) => column);

  GeneratedColumn<String> get department => $composableBuilder(
      column: $table.department, builder: (column) => column);

  Expression<T> dailyLogsRefs<T extends Object>(
      Expression<T> Function($$DailyLogsTableAnnotationComposer a) f) {
    final $$DailyLogsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.dailyLogs,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DailyLogsTableAnnotationComposer(
              $db: $db,
              $table: $db.dailyLogs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> chatSessionsRefs<T extends Object>(
      Expression<T> Function($$ChatSessionsTableAnnotationComposer a) f) {
    final $$ChatSessionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.chatSessions,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChatSessionsTableAnnotationComposer(
              $db: $db,
              $table: $db.chatSessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$UsersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, $$UsersTableReferences),
    User,
    PrefetchHooks Function({bool dailyLogsRefs, bool chatSessionsRefs})> {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> avatarUrl = const Value.absent(),
            Value<String> email = const Value.absent(),
            Value<String> role = const Value.absent(),
            Value<String?> reportingManagerId = const Value.absent(),
            Value<String?> department = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UsersCompanion(
            id: id,
            name: name,
            avatarUrl: avatarUrl,
            email: email,
            role: role,
            reportingManagerId: reportingManagerId,
            department: department,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String avatarUrl,
            required String email,
            required String role,
            Value<String?> reportingManagerId = const Value.absent(),
            Value<String?> department = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UsersCompanion.insert(
            id: id,
            name: name,
            avatarUrl: avatarUrl,
            email: email,
            role: role,
            reportingManagerId: reportingManagerId,
            department: department,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$UsersTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {dailyLogsRefs = false, chatSessionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (dailyLogsRefs) db.dailyLogs,
                if (chatSessionsRefs) db.chatSessions
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (dailyLogsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$UsersTableReferences._dailyLogsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UsersTableReferences(db, table, p0).dailyLogsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.userId == item.id),
                        typedResults: items),
                  if (chatSessionsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$UsersTableReferences._chatSessionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UsersTableReferences(db, table, p0)
                                .chatSessionsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.userId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$UsersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, $$UsersTableReferences),
    User,
    PrefetchHooks Function({bool dailyLogsRefs, bool chatSessionsRefs})>;
typedef $$ProjectsTableCreateCompanionBuilder = ProjectsCompanion Function({
  required String id,
  required String name,
  required String context,
  Value<String?> approvalStatus,
  Value<String?> rejectionReason,
  required String status,
  Value<DateTime?> dueDate,
  Value<DateTime?> completedDate,
  Value<double> plannedHours,
  Value<int> rowid,
});
typedef $$ProjectsTableUpdateCompanionBuilder = ProjectsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> context,
  Value<String?> approvalStatus,
  Value<String?> rejectionReason,
  Value<String> status,
  Value<DateTime?> dueDate,
  Value<DateTime?> completedDate,
  Value<double> plannedHours,
  Value<int> rowid,
});

final class $$ProjectsTableReferences
    extends BaseReferences<_$AppDatabase, $ProjectsTable, Project> {
  $$ProjectsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TasksTable, List<Task>> _tasksRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.tasks,
          aliasName: $_aliasNameGenerator(db.projects.id, db.tasks.projectId));

  $$TasksTableProcessedTableManager get tasksRefs {
    final manager = $$TasksTableTableManager($_db, $_db.tasks)
        .filter((f) => f.projectId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_tasksRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ProjectsTableFilterComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get context => $composableBuilder(
      column: $table.context, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get approvalStatus => $composableBuilder(
      column: $table.approvalStatus,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rejectionReason => $composableBuilder(
      column: $table.rejectionReason,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
      column: $table.dueDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get completedDate => $composableBuilder(
      column: $table.completedDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get plannedHours => $composableBuilder(
      column: $table.plannedHours, builder: (column) => ColumnFilters(column));

  Expression<bool> tasksRefs(
      Expression<bool> Function($$TasksTableFilterComposer f) f) {
    final $$TasksTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.tasks,
        getReferencedColumn: (t) => t.projectId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TasksTableFilterComposer(
              $db: $db,
              $table: $db.tasks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ProjectsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get context => $composableBuilder(
      column: $table.context, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get approvalStatus => $composableBuilder(
      column: $table.approvalStatus,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rejectionReason => $composableBuilder(
      column: $table.rejectionReason,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
      column: $table.dueDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get completedDate => $composableBuilder(
      column: $table.completedDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get plannedHours => $composableBuilder(
      column: $table.plannedHours,
      builder: (column) => ColumnOrderings(column));
}

class $$ProjectsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get context =>
      $composableBuilder(column: $table.context, builder: (column) => column);

  GeneratedColumn<String> get approvalStatus => $composableBuilder(
      column: $table.approvalStatus, builder: (column) => column);

  GeneratedColumn<String> get rejectionReason => $composableBuilder(
      column: $table.rejectionReason, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<DateTime> get completedDate => $composableBuilder(
      column: $table.completedDate, builder: (column) => column);

  GeneratedColumn<double> get plannedHours => $composableBuilder(
      column: $table.plannedHours, builder: (column) => column);

  Expression<T> tasksRefs<T extends Object>(
      Expression<T> Function($$TasksTableAnnotationComposer a) f) {
    final $$TasksTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.tasks,
        getReferencedColumn: (t) => t.projectId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TasksTableAnnotationComposer(
              $db: $db,
              $table: $db.tasks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ProjectsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProjectsTable,
    Project,
    $$ProjectsTableFilterComposer,
    $$ProjectsTableOrderingComposer,
    $$ProjectsTableAnnotationComposer,
    $$ProjectsTableCreateCompanionBuilder,
    $$ProjectsTableUpdateCompanionBuilder,
    (Project, $$ProjectsTableReferences),
    Project,
    PrefetchHooks Function({bool tasksRefs})> {
  $$ProjectsTableTableManager(_$AppDatabase db, $ProjectsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProjectsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProjectsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProjectsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> context = const Value.absent(),
            Value<String?> approvalStatus = const Value.absent(),
            Value<String?> rejectionReason = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime?> dueDate = const Value.absent(),
            Value<DateTime?> completedDate = const Value.absent(),
            Value<double> plannedHours = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProjectsCompanion(
            id: id,
            name: name,
            context: context,
            approvalStatus: approvalStatus,
            rejectionReason: rejectionReason,
            status: status,
            dueDate: dueDate,
            completedDate: completedDate,
            plannedHours: plannedHours,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String context,
            Value<String?> approvalStatus = const Value.absent(),
            Value<String?> rejectionReason = const Value.absent(),
            required String status,
            Value<DateTime?> dueDate = const Value.absent(),
            Value<DateTime?> completedDate = const Value.absent(),
            Value<double> plannedHours = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProjectsCompanion.insert(
            id: id,
            name: name,
            context: context,
            approvalStatus: approvalStatus,
            rejectionReason: rejectionReason,
            status: status,
            dueDate: dueDate,
            completedDate: completedDate,
            plannedHours: plannedHours,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$ProjectsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({tasksRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (tasksRefs) db.tasks],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (tasksRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$ProjectsTableReferences._tasksRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ProjectsTableReferences(db, table, p0).tasksRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.projectId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ProjectsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProjectsTable,
    Project,
    $$ProjectsTableFilterComposer,
    $$ProjectsTableOrderingComposer,
    $$ProjectsTableAnnotationComposer,
    $$ProjectsTableCreateCompanionBuilder,
    $$ProjectsTableUpdateCompanionBuilder,
    (Project, $$ProjectsTableReferences),
    Project,
    PrefetchHooks Function({bool tasksRefs})>;
typedef $$TasksTableCreateCompanionBuilder = TasksCompanion Function({
  required String id,
  required String name,
  required String projectId,
  Value<int> progress,
  required String priority,
  required DateTime startDate,
  required DateTime endDate,
  Value<String?> approvalStatus,
  Value<String?> rejectionReason,
  required String assigneesJson,
  Value<String> milestonesJson,
  Value<String?> githubLink,
  Value<String?> figmaLink,
  Value<String> taskType,
  Value<String?> recurrencePattern,
  Value<DateTime?> nextOccurrence,
  Value<double> plannedHours,
  Value<int> rowid,
});
typedef $$TasksTableUpdateCompanionBuilder = TasksCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> projectId,
  Value<int> progress,
  Value<String> priority,
  Value<DateTime> startDate,
  Value<DateTime> endDate,
  Value<String?> approvalStatus,
  Value<String?> rejectionReason,
  Value<String> assigneesJson,
  Value<String> milestonesJson,
  Value<String?> githubLink,
  Value<String?> figmaLink,
  Value<String> taskType,
  Value<String?> recurrencePattern,
  Value<DateTime?> nextOccurrence,
  Value<double> plannedHours,
  Value<int> rowid,
});

final class $$TasksTableReferences
    extends BaseReferences<_$AppDatabase, $TasksTable, Task> {
  $$TasksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProjectsTable _projectIdTable(_$AppDatabase db) => db.projects
      .createAlias($_aliasNameGenerator(db.tasks.projectId, db.projects.id));

  $$ProjectsTableProcessedTableManager? get projectId {
    if ($_item.projectId == null) return null;
    final manager = $$ProjectsTableTableManager($_db, $_db.projects)
        .filter((f) => f.id($_item.projectId!));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$PlannedItemsTable, List<PlannedItem>>
      _plannedItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.plannedItems,
          aliasName:
              $_aliasNameGenerator(db.tasks.id, db.plannedItems.relatedTaskId));

  $$PlannedItemsTableProcessedTableManager get plannedItemsRefs {
    final manager = $$PlannedItemsTableTableManager($_db, $_db.plannedItems)
        .filter((f) => f.relatedTaskId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_plannedItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$LoggedItemsTable, List<LoggedItem>>
      _loggedItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.loggedItems,
          aliasName:
              $_aliasNameGenerator(db.tasks.id, db.loggedItems.relatedTaskId));

  $$LoggedItemsTableProcessedTableManager get loggedItemsRefs {
    final manager = $$LoggedItemsTableTableManager($_db, $_db.loggedItems)
        .filter((f) => f.relatedTaskId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_loggedItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$TasksTableFilterComposer extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get progress => $composableBuilder(
      column: $table.progress, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get approvalStatus => $composableBuilder(
      column: $table.approvalStatus,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rejectionReason => $composableBuilder(
      column: $table.rejectionReason,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get assigneesJson => $composableBuilder(
      column: $table.assigneesJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get milestonesJson => $composableBuilder(
      column: $table.milestonesJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get githubLink => $composableBuilder(
      column: $table.githubLink, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get figmaLink => $composableBuilder(
      column: $table.figmaLink, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get taskType => $composableBuilder(
      column: $table.taskType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recurrencePattern => $composableBuilder(
      column: $table.recurrencePattern,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get nextOccurrence => $composableBuilder(
      column: $table.nextOccurrence,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get plannedHours => $composableBuilder(
      column: $table.plannedHours, builder: (column) => ColumnFilters(column));

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.projectId,
        referencedTable: $db.projects,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProjectsTableFilterComposer(
              $db: $db,
              $table: $db.projects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> plannedItemsRefs(
      Expression<bool> Function($$PlannedItemsTableFilterComposer f) f) {
    final $$PlannedItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.plannedItems,
        getReferencedColumn: (t) => t.relatedTaskId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlannedItemsTableFilterComposer(
              $db: $db,
              $table: $db.plannedItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> loggedItemsRefs(
      Expression<bool> Function($$LoggedItemsTableFilterComposer f) f) {
    final $$LoggedItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.loggedItems,
        getReferencedColumn: (t) => t.relatedTaskId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LoggedItemsTableFilterComposer(
              $db: $db,
              $table: $db.loggedItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$TasksTableOrderingComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get progress => $composableBuilder(
      column: $table.progress, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get approvalStatus => $composableBuilder(
      column: $table.approvalStatus,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rejectionReason => $composableBuilder(
      column: $table.rejectionReason,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get assigneesJson => $composableBuilder(
      column: $table.assigneesJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get milestonesJson => $composableBuilder(
      column: $table.milestonesJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get githubLink => $composableBuilder(
      column: $table.githubLink, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get figmaLink => $composableBuilder(
      column: $table.figmaLink, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get taskType => $composableBuilder(
      column: $table.taskType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recurrencePattern => $composableBuilder(
      column: $table.recurrencePattern,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get nextOccurrence => $composableBuilder(
      column: $table.nextOccurrence,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get plannedHours => $composableBuilder(
      column: $table.plannedHours,
      builder: (column) => ColumnOrderings(column));

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.projectId,
        referencedTable: $db.projects,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProjectsTableOrderingComposer(
              $db: $db,
              $table: $db.projects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get progress =>
      $composableBuilder(column: $table.progress, builder: (column) => column);

  GeneratedColumn<String> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<String> get approvalStatus => $composableBuilder(
      column: $table.approvalStatus, builder: (column) => column);

  GeneratedColumn<String> get rejectionReason => $composableBuilder(
      column: $table.rejectionReason, builder: (column) => column);

  GeneratedColumn<String> get assigneesJson => $composableBuilder(
      column: $table.assigneesJson, builder: (column) => column);

  GeneratedColumn<String> get milestonesJson => $composableBuilder(
      column: $table.milestonesJson, builder: (column) => column);

  GeneratedColumn<String> get githubLink => $composableBuilder(
      column: $table.githubLink, builder: (column) => column);

  GeneratedColumn<String> get figmaLink =>
      $composableBuilder(column: $table.figmaLink, builder: (column) => column);

  GeneratedColumn<String> get taskType =>
      $composableBuilder(column: $table.taskType, builder: (column) => column);

  GeneratedColumn<String> get recurrencePattern => $composableBuilder(
      column: $table.recurrencePattern, builder: (column) => column);

  GeneratedColumn<DateTime> get nextOccurrence => $composableBuilder(
      column: $table.nextOccurrence, builder: (column) => column);

  GeneratedColumn<double> get plannedHours => $composableBuilder(
      column: $table.plannedHours, builder: (column) => column);

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.projectId,
        referencedTable: $db.projects,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProjectsTableAnnotationComposer(
              $db: $db,
              $table: $db.projects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> plannedItemsRefs<T extends Object>(
      Expression<T> Function($$PlannedItemsTableAnnotationComposer a) f) {
    final $$PlannedItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.plannedItems,
        getReferencedColumn: (t) => t.relatedTaskId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlannedItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.plannedItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> loggedItemsRefs<T extends Object>(
      Expression<T> Function($$LoggedItemsTableAnnotationComposer a) f) {
    final $$LoggedItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.loggedItems,
        getReferencedColumn: (t) => t.relatedTaskId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LoggedItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.loggedItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$TasksTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TasksTable,
    Task,
    $$TasksTableFilterComposer,
    $$TasksTableOrderingComposer,
    $$TasksTableAnnotationComposer,
    $$TasksTableCreateCompanionBuilder,
    $$TasksTableUpdateCompanionBuilder,
    (Task, $$TasksTableReferences),
    Task,
    PrefetchHooks Function(
        {bool projectId, bool plannedItemsRefs, bool loggedItemsRefs})> {
  $$TasksTableTableManager(_$AppDatabase db, $TasksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> projectId = const Value.absent(),
            Value<int> progress = const Value.absent(),
            Value<String> priority = const Value.absent(),
            Value<DateTime> startDate = const Value.absent(),
            Value<DateTime> endDate = const Value.absent(),
            Value<String?> approvalStatus = const Value.absent(),
            Value<String?> rejectionReason = const Value.absent(),
            Value<String> assigneesJson = const Value.absent(),
            Value<String> milestonesJson = const Value.absent(),
            Value<String?> githubLink = const Value.absent(),
            Value<String?> figmaLink = const Value.absent(),
            Value<String> taskType = const Value.absent(),
            Value<String?> recurrencePattern = const Value.absent(),
            Value<DateTime?> nextOccurrence = const Value.absent(),
            Value<double> plannedHours = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TasksCompanion(
            id: id,
            name: name,
            projectId: projectId,
            progress: progress,
            priority: priority,
            startDate: startDate,
            endDate: endDate,
            approvalStatus: approvalStatus,
            rejectionReason: rejectionReason,
            assigneesJson: assigneesJson,
            milestonesJson: milestonesJson,
            githubLink: githubLink,
            figmaLink: figmaLink,
            taskType: taskType,
            recurrencePattern: recurrencePattern,
            nextOccurrence: nextOccurrence,
            plannedHours: plannedHours,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String projectId,
            Value<int> progress = const Value.absent(),
            required String priority,
            required DateTime startDate,
            required DateTime endDate,
            Value<String?> approvalStatus = const Value.absent(),
            Value<String?> rejectionReason = const Value.absent(),
            required String assigneesJson,
            Value<String> milestonesJson = const Value.absent(),
            Value<String?> githubLink = const Value.absent(),
            Value<String?> figmaLink = const Value.absent(),
            Value<String> taskType = const Value.absent(),
            Value<String?> recurrencePattern = const Value.absent(),
            Value<DateTime?> nextOccurrence = const Value.absent(),
            Value<double> plannedHours = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TasksCompanion.insert(
            id: id,
            name: name,
            projectId: projectId,
            progress: progress,
            priority: priority,
            startDate: startDate,
            endDate: endDate,
            approvalStatus: approvalStatus,
            rejectionReason: rejectionReason,
            assigneesJson: assigneesJson,
            milestonesJson: milestonesJson,
            githubLink: githubLink,
            figmaLink: figmaLink,
            taskType: taskType,
            recurrencePattern: recurrencePattern,
            nextOccurrence: nextOccurrence,
            plannedHours: plannedHours,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$TasksTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {projectId = false,
              plannedItemsRefs = false,
              loggedItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (plannedItemsRefs) db.plannedItems,
                if (loggedItemsRefs) db.loggedItems
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (projectId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.projectId,
                    referencedTable: $$TasksTableReferences._projectIdTable(db),
                    referencedColumn:
                        $$TasksTableReferences._projectIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (plannedItemsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$TasksTableReferences._plannedItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$TasksTableReferences(db, table, p0)
                                .plannedItemsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.relatedTaskId == item.id),
                        typedResults: items),
                  if (loggedItemsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$TasksTableReferences._loggedItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$TasksTableReferences(db, table, p0)
                                .loggedItemsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.relatedTaskId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$TasksTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TasksTable,
    Task,
    $$TasksTableFilterComposer,
    $$TasksTableOrderingComposer,
    $$TasksTableAnnotationComposer,
    $$TasksTableCreateCompanionBuilder,
    $$TasksTableUpdateCompanionBuilder,
    (Task, $$TasksTableReferences),
    Task,
    PrefetchHooks Function(
        {bool projectId, bool plannedItemsRefs, bool loggedItemsRefs})>;
typedef $$DailyLogsTableCreateCompanionBuilder = DailyLogsCompanion Function({
  required String id,
  required DateTime date,
  required String userId,
  Value<bool> isFinalized,
  Value<int> rowid,
});
typedef $$DailyLogsTableUpdateCompanionBuilder = DailyLogsCompanion Function({
  Value<String> id,
  Value<DateTime> date,
  Value<String> userId,
  Value<bool> isFinalized,
  Value<int> rowid,
});

final class $$DailyLogsTableReferences
    extends BaseReferences<_$AppDatabase, $DailyLogsTable, DailyLog> {
  $$DailyLogsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _userIdTable(_$AppDatabase db) => db.users
      .createAlias($_aliasNameGenerator(db.dailyLogs.userId, db.users.id));

  $$UsersTableProcessedTableManager? get userId {
    if ($_item.userId == null) return null;
    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id($_item.userId!));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$PlannedItemsTable, List<PlannedItem>>
      _plannedItemsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.plannedItems,
              aliasName: $_aliasNameGenerator(
                  db.dailyLogs.id, db.plannedItems.dailyLogId));

  $$PlannedItemsTableProcessedTableManager get plannedItemsRefs {
    final manager = $$PlannedItemsTableTableManager($_db, $_db.plannedItems)
        .filter((f) => f.dailyLogId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_plannedItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$LoggedItemsTable, List<LoggedItem>>
      _loggedItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.loggedItems,
          aliasName:
              $_aliasNameGenerator(db.dailyLogs.id, db.loggedItems.dailyLogId));

  $$LoggedItemsTableProcessedTableManager get loggedItemsRefs {
    final manager = $$LoggedItemsTableTableManager($_db, $_db.loggedItems)
        .filter((f) => f.dailyLogId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_loggedItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$DailyLogsTableFilterComposer
    extends Composer<_$AppDatabase, $DailyLogsTable> {
  $$DailyLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isFinalized => $composableBuilder(
      column: $table.isFinalized, builder: (column) => ColumnFilters(column));

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> plannedItemsRefs(
      Expression<bool> Function($$PlannedItemsTableFilterComposer f) f) {
    final $$PlannedItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.plannedItems,
        getReferencedColumn: (t) => t.dailyLogId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlannedItemsTableFilterComposer(
              $db: $db,
              $table: $db.plannedItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> loggedItemsRefs(
      Expression<bool> Function($$LoggedItemsTableFilterComposer f) f) {
    final $$LoggedItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.loggedItems,
        getReferencedColumn: (t) => t.dailyLogId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LoggedItemsTableFilterComposer(
              $db: $db,
              $table: $db.loggedItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$DailyLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyLogsTable> {
  $$DailyLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isFinalized => $composableBuilder(
      column: $table.isFinalized, builder: (column) => ColumnOrderings(column));

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DailyLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyLogsTable> {
  $$DailyLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<bool> get isFinalized => $composableBuilder(
      column: $table.isFinalized, builder: (column) => column);

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> plannedItemsRefs<T extends Object>(
      Expression<T> Function($$PlannedItemsTableAnnotationComposer a) f) {
    final $$PlannedItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.plannedItems,
        getReferencedColumn: (t) => t.dailyLogId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlannedItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.plannedItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> loggedItemsRefs<T extends Object>(
      Expression<T> Function($$LoggedItemsTableAnnotationComposer a) f) {
    final $$LoggedItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.loggedItems,
        getReferencedColumn: (t) => t.dailyLogId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LoggedItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.loggedItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$DailyLogsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DailyLogsTable,
    DailyLog,
    $$DailyLogsTableFilterComposer,
    $$DailyLogsTableOrderingComposer,
    $$DailyLogsTableAnnotationComposer,
    $$DailyLogsTableCreateCompanionBuilder,
    $$DailyLogsTableUpdateCompanionBuilder,
    (DailyLog, $$DailyLogsTableReferences),
    DailyLog,
    PrefetchHooks Function(
        {bool userId, bool plannedItemsRefs, bool loggedItemsRefs})> {
  $$DailyLogsTableTableManager(_$AppDatabase db, $DailyLogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<bool> isFinalized = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DailyLogsCompanion(
            id: id,
            date: date,
            userId: userId,
            isFinalized: isFinalized,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required DateTime date,
            required String userId,
            Value<bool> isFinalized = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DailyLogsCompanion.insert(
            id: id,
            date: date,
            userId: userId,
            isFinalized: isFinalized,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$DailyLogsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {userId = false,
              plannedItemsRefs = false,
              loggedItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (plannedItemsRefs) db.plannedItems,
                if (loggedItemsRefs) db.loggedItems
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (userId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.userId,
                    referencedTable:
                        $$DailyLogsTableReferences._userIdTable(db),
                    referencedColumn:
                        $$DailyLogsTableReferences._userIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (plannedItemsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$DailyLogsTableReferences
                            ._plannedItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DailyLogsTableReferences(db, table, p0)
                                .plannedItemsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.dailyLogId == item.id),
                        typedResults: items),
                  if (loggedItemsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$DailyLogsTableReferences
                            ._loggedItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DailyLogsTableReferences(db, table, p0)
                                .loggedItemsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.dailyLogId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$DailyLogsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DailyLogsTable,
    DailyLog,
    $$DailyLogsTableFilterComposer,
    $$DailyLogsTableOrderingComposer,
    $$DailyLogsTableAnnotationComposer,
    $$DailyLogsTableCreateCompanionBuilder,
    $$DailyLogsTableUpdateCompanionBuilder,
    (DailyLog, $$DailyLogsTableReferences),
    DailyLog,
    PrefetchHooks Function(
        {bool userId, bool plannedItemsRefs, bool loggedItemsRefs})>;
typedef $$PlannedItemsTableCreateCompanionBuilder = PlannedItemsCompanion
    Function({
  required String id,
  required String dailyLogId,
  required String name,
  Value<String> description,
  Value<String> quadrant,
  Value<int> durationMinutes,
  Value<String?> relatedTaskId,
  Value<DateTime?> startTime,
  Value<bool> isCompleted,
  Value<int> rowid,
});
typedef $$PlannedItemsTableUpdateCompanionBuilder = PlannedItemsCompanion
    Function({
  Value<String> id,
  Value<String> dailyLogId,
  Value<String> name,
  Value<String> description,
  Value<String> quadrant,
  Value<int> durationMinutes,
  Value<String?> relatedTaskId,
  Value<DateTime?> startTime,
  Value<bool> isCompleted,
  Value<int> rowid,
});

final class $$PlannedItemsTableReferences
    extends BaseReferences<_$AppDatabase, $PlannedItemsTable, PlannedItem> {
  $$PlannedItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DailyLogsTable _dailyLogIdTable(_$AppDatabase db) =>
      db.dailyLogs.createAlias(
          $_aliasNameGenerator(db.plannedItems.dailyLogId, db.dailyLogs.id));

  $$DailyLogsTableProcessedTableManager? get dailyLogId {
    if ($_item.dailyLogId == null) return null;
    final manager = $$DailyLogsTableTableManager($_db, $_db.dailyLogs)
        .filter((f) => f.id($_item.dailyLogId!));
    final item = $_typedResult.readTableOrNull(_dailyLogIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $TasksTable _relatedTaskIdTable(_$AppDatabase db) =>
      db.tasks.createAlias(
          $_aliasNameGenerator(db.plannedItems.relatedTaskId, db.tasks.id));

  $$TasksTableProcessedTableManager? get relatedTaskId {
    if ($_item.relatedTaskId == null) return null;
    final manager = $$TasksTableTableManager($_db, $_db.tasks)
        .filter((f) => f.id($_item.relatedTaskId!));
    final item = $_typedResult.readTableOrNull(_relatedTaskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$LoggedItemsTable, List<LoggedItem>>
      _loggedItemsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.loggedItems,
              aliasName: $_aliasNameGenerator(
                  db.plannedItems.id, db.loggedItems.plannedItemId));

  $$LoggedItemsTableProcessedTableManager get loggedItemsRefs {
    final manager = $$LoggedItemsTableTableManager($_db, $_db.loggedItems)
        .filter((f) => f.plannedItemId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_loggedItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$PlannedItemsTableFilterComposer
    extends Composer<_$AppDatabase, $PlannedItemsTable> {
  $$PlannedItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get quadrant => $composableBuilder(
      column: $table.quadrant, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get durationMinutes => $composableBuilder(
      column: $table.durationMinutes,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startTime => $composableBuilder(
      column: $table.startTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnFilters(column));

  $$DailyLogsTableFilterComposer get dailyLogId {
    final $$DailyLogsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.dailyLogId,
        referencedTable: $db.dailyLogs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DailyLogsTableFilterComposer(
              $db: $db,
              $table: $db.dailyLogs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$TasksTableFilterComposer get relatedTaskId {
    final $$TasksTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.relatedTaskId,
        referencedTable: $db.tasks,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TasksTableFilterComposer(
              $db: $db,
              $table: $db.tasks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> loggedItemsRefs(
      Expression<bool> Function($$LoggedItemsTableFilterComposer f) f) {
    final $$LoggedItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.loggedItems,
        getReferencedColumn: (t) => t.plannedItemId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LoggedItemsTableFilterComposer(
              $db: $db,
              $table: $db.loggedItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$PlannedItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $PlannedItemsTable> {
  $$PlannedItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get quadrant => $composableBuilder(
      column: $table.quadrant, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get durationMinutes => $composableBuilder(
      column: $table.durationMinutes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startTime => $composableBuilder(
      column: $table.startTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnOrderings(column));

  $$DailyLogsTableOrderingComposer get dailyLogId {
    final $$DailyLogsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.dailyLogId,
        referencedTable: $db.dailyLogs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DailyLogsTableOrderingComposer(
              $db: $db,
              $table: $db.dailyLogs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$TasksTableOrderingComposer get relatedTaskId {
    final $$TasksTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.relatedTaskId,
        referencedTable: $db.tasks,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TasksTableOrderingComposer(
              $db: $db,
              $table: $db.tasks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PlannedItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlannedItemsTable> {
  $$PlannedItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get quadrant =>
      $composableBuilder(column: $table.quadrant, builder: (column) => column);

  GeneratedColumn<int> get durationMinutes => $composableBuilder(
      column: $table.durationMinutes, builder: (column) => column);

  GeneratedColumn<DateTime> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => column);

  $$DailyLogsTableAnnotationComposer get dailyLogId {
    final $$DailyLogsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.dailyLogId,
        referencedTable: $db.dailyLogs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DailyLogsTableAnnotationComposer(
              $db: $db,
              $table: $db.dailyLogs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$TasksTableAnnotationComposer get relatedTaskId {
    final $$TasksTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.relatedTaskId,
        referencedTable: $db.tasks,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TasksTableAnnotationComposer(
              $db: $db,
              $table: $db.tasks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> loggedItemsRefs<T extends Object>(
      Expression<T> Function($$LoggedItemsTableAnnotationComposer a) f) {
    final $$LoggedItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.loggedItems,
        getReferencedColumn: (t) => t.plannedItemId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LoggedItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.loggedItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$PlannedItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PlannedItemsTable,
    PlannedItem,
    $$PlannedItemsTableFilterComposer,
    $$PlannedItemsTableOrderingComposer,
    $$PlannedItemsTableAnnotationComposer,
    $$PlannedItemsTableCreateCompanionBuilder,
    $$PlannedItemsTableUpdateCompanionBuilder,
    (PlannedItem, $$PlannedItemsTableReferences),
    PlannedItem,
    PrefetchHooks Function(
        {bool dailyLogId, bool relatedTaskId, bool loggedItemsRefs})> {
  $$PlannedItemsTableTableManager(_$AppDatabase db, $PlannedItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlannedItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlannedItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlannedItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> dailyLogId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<String> quadrant = const Value.absent(),
            Value<int> durationMinutes = const Value.absent(),
            Value<String?> relatedTaskId = const Value.absent(),
            Value<DateTime?> startTime = const Value.absent(),
            Value<bool> isCompleted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PlannedItemsCompanion(
            id: id,
            dailyLogId: dailyLogId,
            name: name,
            description: description,
            quadrant: quadrant,
            durationMinutes: durationMinutes,
            relatedTaskId: relatedTaskId,
            startTime: startTime,
            isCompleted: isCompleted,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String dailyLogId,
            required String name,
            Value<String> description = const Value.absent(),
            Value<String> quadrant = const Value.absent(),
            Value<int> durationMinutes = const Value.absent(),
            Value<String?> relatedTaskId = const Value.absent(),
            Value<DateTime?> startTime = const Value.absent(),
            Value<bool> isCompleted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PlannedItemsCompanion.insert(
            id: id,
            dailyLogId: dailyLogId,
            name: name,
            description: description,
            quadrant: quadrant,
            durationMinutes: durationMinutes,
            relatedTaskId: relatedTaskId,
            startTime: startTime,
            isCompleted: isCompleted,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$PlannedItemsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {dailyLogId = false,
              relatedTaskId = false,
              loggedItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (loggedItemsRefs) db.loggedItems],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (dailyLogId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.dailyLogId,
                    referencedTable:
                        $$PlannedItemsTableReferences._dailyLogIdTable(db),
                    referencedColumn:
                        $$PlannedItemsTableReferences._dailyLogIdTable(db).id,
                  ) as T;
                }
                if (relatedTaskId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.relatedTaskId,
                    referencedTable:
                        $$PlannedItemsTableReferences._relatedTaskIdTable(db),
                    referencedColumn: $$PlannedItemsTableReferences
                        ._relatedTaskIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (loggedItemsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$PlannedItemsTableReferences
                            ._loggedItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PlannedItemsTableReferences(db, table, p0)
                                .loggedItemsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.plannedItemId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$PlannedItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PlannedItemsTable,
    PlannedItem,
    $$PlannedItemsTableFilterComposer,
    $$PlannedItemsTableOrderingComposer,
    $$PlannedItemsTableAnnotationComposer,
    $$PlannedItemsTableCreateCompanionBuilder,
    $$PlannedItemsTableUpdateCompanionBuilder,
    (PlannedItem, $$PlannedItemsTableReferences),
    PlannedItem,
    PrefetchHooks Function(
        {bool dailyLogId, bool relatedTaskId, bool loggedItemsRefs})>;
typedef $$LoggedItemsTableCreateCompanionBuilder = LoggedItemsCompanion
    Function({
  required String id,
  required String dailyLogId,
  required String name,
  Value<String> description,
  required DateTime startTime,
  Value<DateTime?> endTime,
  Value<bool> isUnplanned,
  Value<String?> plannedItemId,
  Value<String?> relatedTaskId,
  Value<String> remarksJson,
  Value<int> rowid,
});
typedef $$LoggedItemsTableUpdateCompanionBuilder = LoggedItemsCompanion
    Function({
  Value<String> id,
  Value<String> dailyLogId,
  Value<String> name,
  Value<String> description,
  Value<DateTime> startTime,
  Value<DateTime?> endTime,
  Value<bool> isUnplanned,
  Value<String?> plannedItemId,
  Value<String?> relatedTaskId,
  Value<String> remarksJson,
  Value<int> rowid,
});

final class $$LoggedItemsTableReferences
    extends BaseReferences<_$AppDatabase, $LoggedItemsTable, LoggedItem> {
  $$LoggedItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DailyLogsTable _dailyLogIdTable(_$AppDatabase db) =>
      db.dailyLogs.createAlias(
          $_aliasNameGenerator(db.loggedItems.dailyLogId, db.dailyLogs.id));

  $$DailyLogsTableProcessedTableManager? get dailyLogId {
    if ($_item.dailyLogId == null) return null;
    final manager = $$DailyLogsTableTableManager($_db, $_db.dailyLogs)
        .filter((f) => f.id($_item.dailyLogId!));
    final item = $_typedResult.readTableOrNull(_dailyLogIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $PlannedItemsTable _plannedItemIdTable(_$AppDatabase db) =>
      db.plannedItems.createAlias($_aliasNameGenerator(
          db.loggedItems.plannedItemId, db.plannedItems.id));

  $$PlannedItemsTableProcessedTableManager? get plannedItemId {
    if ($_item.plannedItemId == null) return null;
    final manager = $$PlannedItemsTableTableManager($_db, $_db.plannedItems)
        .filter((f) => f.id($_item.plannedItemId!));
    final item = $_typedResult.readTableOrNull(_plannedItemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $TasksTable _relatedTaskIdTable(_$AppDatabase db) =>
      db.tasks.createAlias(
          $_aliasNameGenerator(db.loggedItems.relatedTaskId, db.tasks.id));

  $$TasksTableProcessedTableManager? get relatedTaskId {
    if ($_item.relatedTaskId == null) return null;
    final manager = $$TasksTableTableManager($_db, $_db.tasks)
        .filter((f) => f.id($_item.relatedTaskId!));
    final item = $_typedResult.readTableOrNull(_relatedTaskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$LoggedItemsTableFilterComposer
    extends Composer<_$AppDatabase, $LoggedItemsTable> {
  $$LoggedItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startTime => $composableBuilder(
      column: $table.startTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endTime => $composableBuilder(
      column: $table.endTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isUnplanned => $composableBuilder(
      column: $table.isUnplanned, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get remarksJson => $composableBuilder(
      column: $table.remarksJson, builder: (column) => ColumnFilters(column));

  $$DailyLogsTableFilterComposer get dailyLogId {
    final $$DailyLogsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.dailyLogId,
        referencedTable: $db.dailyLogs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DailyLogsTableFilterComposer(
              $db: $db,
              $table: $db.dailyLogs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PlannedItemsTableFilterComposer get plannedItemId {
    final $$PlannedItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.plannedItemId,
        referencedTable: $db.plannedItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlannedItemsTableFilterComposer(
              $db: $db,
              $table: $db.plannedItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$TasksTableFilterComposer get relatedTaskId {
    final $$TasksTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.relatedTaskId,
        referencedTable: $db.tasks,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TasksTableFilterComposer(
              $db: $db,
              $table: $db.tasks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LoggedItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $LoggedItemsTable> {
  $$LoggedItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startTime => $composableBuilder(
      column: $table.startTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endTime => $composableBuilder(
      column: $table.endTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isUnplanned => $composableBuilder(
      column: $table.isUnplanned, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get remarksJson => $composableBuilder(
      column: $table.remarksJson, builder: (column) => ColumnOrderings(column));

  $$DailyLogsTableOrderingComposer get dailyLogId {
    final $$DailyLogsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.dailyLogId,
        referencedTable: $db.dailyLogs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DailyLogsTableOrderingComposer(
              $db: $db,
              $table: $db.dailyLogs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PlannedItemsTableOrderingComposer get plannedItemId {
    final $$PlannedItemsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.plannedItemId,
        referencedTable: $db.plannedItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlannedItemsTableOrderingComposer(
              $db: $db,
              $table: $db.plannedItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$TasksTableOrderingComposer get relatedTaskId {
    final $$TasksTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.relatedTaskId,
        referencedTable: $db.tasks,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TasksTableOrderingComposer(
              $db: $db,
              $table: $db.tasks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LoggedItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LoggedItemsTable> {
  $$LoggedItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<DateTime> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<DateTime> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<bool> get isUnplanned => $composableBuilder(
      column: $table.isUnplanned, builder: (column) => column);

  GeneratedColumn<String> get remarksJson => $composableBuilder(
      column: $table.remarksJson, builder: (column) => column);

  $$DailyLogsTableAnnotationComposer get dailyLogId {
    final $$DailyLogsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.dailyLogId,
        referencedTable: $db.dailyLogs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DailyLogsTableAnnotationComposer(
              $db: $db,
              $table: $db.dailyLogs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PlannedItemsTableAnnotationComposer get plannedItemId {
    final $$PlannedItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.plannedItemId,
        referencedTable: $db.plannedItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlannedItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.plannedItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$TasksTableAnnotationComposer get relatedTaskId {
    final $$TasksTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.relatedTaskId,
        referencedTable: $db.tasks,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TasksTableAnnotationComposer(
              $db: $db,
              $table: $db.tasks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LoggedItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LoggedItemsTable,
    LoggedItem,
    $$LoggedItemsTableFilterComposer,
    $$LoggedItemsTableOrderingComposer,
    $$LoggedItemsTableAnnotationComposer,
    $$LoggedItemsTableCreateCompanionBuilder,
    $$LoggedItemsTableUpdateCompanionBuilder,
    (LoggedItem, $$LoggedItemsTableReferences),
    LoggedItem,
    PrefetchHooks Function(
        {bool dailyLogId, bool plannedItemId, bool relatedTaskId})> {
  $$LoggedItemsTableTableManager(_$AppDatabase db, $LoggedItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LoggedItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LoggedItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LoggedItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> dailyLogId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<DateTime> startTime = const Value.absent(),
            Value<DateTime?> endTime = const Value.absent(),
            Value<bool> isUnplanned = const Value.absent(),
            Value<String?> plannedItemId = const Value.absent(),
            Value<String?> relatedTaskId = const Value.absent(),
            Value<String> remarksJson = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LoggedItemsCompanion(
            id: id,
            dailyLogId: dailyLogId,
            name: name,
            description: description,
            startTime: startTime,
            endTime: endTime,
            isUnplanned: isUnplanned,
            plannedItemId: plannedItemId,
            relatedTaskId: relatedTaskId,
            remarksJson: remarksJson,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String dailyLogId,
            required String name,
            Value<String> description = const Value.absent(),
            required DateTime startTime,
            Value<DateTime?> endTime = const Value.absent(),
            Value<bool> isUnplanned = const Value.absent(),
            Value<String?> plannedItemId = const Value.absent(),
            Value<String?> relatedTaskId = const Value.absent(),
            Value<String> remarksJson = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LoggedItemsCompanion.insert(
            id: id,
            dailyLogId: dailyLogId,
            name: name,
            description: description,
            startTime: startTime,
            endTime: endTime,
            isUnplanned: isUnplanned,
            plannedItemId: plannedItemId,
            relatedTaskId: relatedTaskId,
            remarksJson: remarksJson,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$LoggedItemsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {dailyLogId = false,
              plannedItemId = false,
              relatedTaskId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (dailyLogId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.dailyLogId,
                    referencedTable:
                        $$LoggedItemsTableReferences._dailyLogIdTable(db),
                    referencedColumn:
                        $$LoggedItemsTableReferences._dailyLogIdTable(db).id,
                  ) as T;
                }
                if (plannedItemId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.plannedItemId,
                    referencedTable:
                        $$LoggedItemsTableReferences._plannedItemIdTable(db),
                    referencedColumn:
                        $$LoggedItemsTableReferences._plannedItemIdTable(db).id,
                  ) as T;
                }
                if (relatedTaskId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.relatedTaskId,
                    referencedTable:
                        $$LoggedItemsTableReferences._relatedTaskIdTable(db),
                    referencedColumn:
                        $$LoggedItemsTableReferences._relatedTaskIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$LoggedItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LoggedItemsTable,
    LoggedItem,
    $$LoggedItemsTableFilterComposer,
    $$LoggedItemsTableOrderingComposer,
    $$LoggedItemsTableAnnotationComposer,
    $$LoggedItemsTableCreateCompanionBuilder,
    $$LoggedItemsTableUpdateCompanionBuilder,
    (LoggedItem, $$LoggedItemsTableReferences),
    LoggedItem,
    PrefetchHooks Function(
        {bool dailyLogId, bool plannedItemId, bool relatedTaskId})>;
typedef $$ChatSessionsTableCreateCompanionBuilder = ChatSessionsCompanion
    Function({
  required String id,
  required String userId,
  required String title,
  required DateTime lastModified,
  Value<int> rowid,
});
typedef $$ChatSessionsTableUpdateCompanionBuilder = ChatSessionsCompanion
    Function({
  Value<String> id,
  Value<String> userId,
  Value<String> title,
  Value<DateTime> lastModified,
  Value<int> rowid,
});

final class $$ChatSessionsTableReferences
    extends BaseReferences<_$AppDatabase, $ChatSessionsTable, ChatSession> {
  $$ChatSessionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _userIdTable(_$AppDatabase db) => db.users
      .createAlias($_aliasNameGenerator(db.chatSessions.userId, db.users.id));

  $$UsersTableProcessedTableManager? get userId {
    if ($_item.userId == null) return null;
    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id($_item.userId!));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$ChatMessagesTable, List<ChatMessage>>
      _chatMessagesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.chatMessages,
              aliasName: $_aliasNameGenerator(
                  db.chatSessions.id, db.chatMessages.sessionId));

  $$ChatMessagesTableProcessedTableManager get chatMessagesRefs {
    final manager = $$ChatMessagesTableTableManager($_db, $_db.chatMessages)
        .filter((f) => f.sessionId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_chatMessagesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ChatSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $ChatSessionsTable> {
  $$ChatSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastModified => $composableBuilder(
      column: $table.lastModified, builder: (column) => ColumnFilters(column));

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> chatMessagesRefs(
      Expression<bool> Function($$ChatMessagesTableFilterComposer f) f) {
    final $$ChatMessagesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.chatMessages,
        getReferencedColumn: (t) => t.sessionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChatMessagesTableFilterComposer(
              $db: $db,
              $table: $db.chatMessages,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ChatSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $ChatSessionsTable> {
  $$ChatSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastModified => $composableBuilder(
      column: $table.lastModified,
      builder: (column) => ColumnOrderings(column));

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ChatSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChatSessionsTable> {
  $$ChatSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<DateTime> get lastModified => $composableBuilder(
      column: $table.lastModified, builder: (column) => column);

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> chatMessagesRefs<T extends Object>(
      Expression<T> Function($$ChatMessagesTableAnnotationComposer a) f) {
    final $$ChatMessagesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.chatMessages,
        getReferencedColumn: (t) => t.sessionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChatMessagesTableAnnotationComposer(
              $db: $db,
              $table: $db.chatMessages,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ChatSessionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ChatSessionsTable,
    ChatSession,
    $$ChatSessionsTableFilterComposer,
    $$ChatSessionsTableOrderingComposer,
    $$ChatSessionsTableAnnotationComposer,
    $$ChatSessionsTableCreateCompanionBuilder,
    $$ChatSessionsTableUpdateCompanionBuilder,
    (ChatSession, $$ChatSessionsTableReferences),
    ChatSession,
    PrefetchHooks Function({bool userId, bool chatMessagesRefs})> {
  $$ChatSessionsTableTableManager(_$AppDatabase db, $ChatSessionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChatSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChatSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChatSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<DateTime> lastModified = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ChatSessionsCompanion(
            id: id,
            userId: userId,
            title: title,
            lastModified: lastModified,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String userId,
            required String title,
            required DateTime lastModified,
            Value<int> rowid = const Value.absent(),
          }) =>
              ChatSessionsCompanion.insert(
            id: id,
            userId: userId,
            title: title,
            lastModified: lastModified,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ChatSessionsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({userId = false, chatMessagesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (chatMessagesRefs) db.chatMessages],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (userId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.userId,
                    referencedTable:
                        $$ChatSessionsTableReferences._userIdTable(db),
                    referencedColumn:
                        $$ChatSessionsTableReferences._userIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (chatMessagesRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$ChatSessionsTableReferences
                            ._chatMessagesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ChatSessionsTableReferences(db, table, p0)
                                .chatMessagesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.sessionId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ChatSessionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ChatSessionsTable,
    ChatSession,
    $$ChatSessionsTableFilterComposer,
    $$ChatSessionsTableOrderingComposer,
    $$ChatSessionsTableAnnotationComposer,
    $$ChatSessionsTableCreateCompanionBuilder,
    $$ChatSessionsTableUpdateCompanionBuilder,
    (ChatSession, $$ChatSessionsTableReferences),
    ChatSession,
    PrefetchHooks Function({bool userId, bool chatMessagesRefs})>;
typedef $$ChatMessagesTableCreateCompanionBuilder = ChatMessagesCompanion
    Function({
  required String id,
  required String sessionId,
  required String content,
  required String sender,
  required DateTime timestamp,
  Value<int> rowid,
});
typedef $$ChatMessagesTableUpdateCompanionBuilder = ChatMessagesCompanion
    Function({
  Value<String> id,
  Value<String> sessionId,
  Value<String> content,
  Value<String> sender,
  Value<DateTime> timestamp,
  Value<int> rowid,
});

final class $$ChatMessagesTableReferences
    extends BaseReferences<_$AppDatabase, $ChatMessagesTable, ChatMessage> {
  $$ChatMessagesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ChatSessionsTable _sessionIdTable(_$AppDatabase db) =>
      db.chatSessions.createAlias(
          $_aliasNameGenerator(db.chatMessages.sessionId, db.chatSessions.id));

  $$ChatSessionsTableProcessedTableManager? get sessionId {
    if ($_item.sessionId == null) return null;
    final manager = $$ChatSessionsTableTableManager($_db, $_db.chatSessions)
        .filter((f) => f.id($_item.sessionId!));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ChatMessagesTableFilterComposer
    extends Composer<_$AppDatabase, $ChatMessagesTable> {
  $$ChatMessagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sender => $composableBuilder(
      column: $table.sender, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnFilters(column));

  $$ChatSessionsTableFilterComposer get sessionId {
    final $$ChatSessionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sessionId,
        referencedTable: $db.chatSessions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChatSessionsTableFilterComposer(
              $db: $db,
              $table: $db.chatSessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ChatMessagesTableOrderingComposer
    extends Composer<_$AppDatabase, $ChatMessagesTable> {
  $$ChatMessagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sender => $composableBuilder(
      column: $table.sender, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnOrderings(column));

  $$ChatSessionsTableOrderingComposer get sessionId {
    final $$ChatSessionsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sessionId,
        referencedTable: $db.chatSessions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChatSessionsTableOrderingComposer(
              $db: $db,
              $table: $db.chatSessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ChatMessagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChatMessagesTable> {
  $$ChatMessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get sender =>
      $composableBuilder(column: $table.sender, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  $$ChatSessionsTableAnnotationComposer get sessionId {
    final $$ChatSessionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sessionId,
        referencedTable: $db.chatSessions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChatSessionsTableAnnotationComposer(
              $db: $db,
              $table: $db.chatSessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ChatMessagesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ChatMessagesTable,
    ChatMessage,
    $$ChatMessagesTableFilterComposer,
    $$ChatMessagesTableOrderingComposer,
    $$ChatMessagesTableAnnotationComposer,
    $$ChatMessagesTableCreateCompanionBuilder,
    $$ChatMessagesTableUpdateCompanionBuilder,
    (ChatMessage, $$ChatMessagesTableReferences),
    ChatMessage,
    PrefetchHooks Function({bool sessionId})> {
  $$ChatMessagesTableTableManager(_$AppDatabase db, $ChatMessagesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChatMessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChatMessagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChatMessagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> sessionId = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<String> sender = const Value.absent(),
            Value<DateTime> timestamp = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ChatMessagesCompanion(
            id: id,
            sessionId: sessionId,
            content: content,
            sender: sender,
            timestamp: timestamp,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String sessionId,
            required String content,
            required String sender,
            required DateTime timestamp,
            Value<int> rowid = const Value.absent(),
          }) =>
              ChatMessagesCompanion.insert(
            id: id,
            sessionId: sessionId,
            content: content,
            sender: sender,
            timestamp: timestamp,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ChatMessagesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({sessionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (sessionId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.sessionId,
                    referencedTable:
                        $$ChatMessagesTableReferences._sessionIdTable(db),
                    referencedColumn:
                        $$ChatMessagesTableReferences._sessionIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ChatMessagesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ChatMessagesTable,
    ChatMessage,
    $$ChatMessagesTableFilterComposer,
    $$ChatMessagesTableOrderingComposer,
    $$ChatMessagesTableAnnotationComposer,
    $$ChatMessagesTableCreateCompanionBuilder,
    $$ChatMessagesTableUpdateCompanionBuilder,
    (ChatMessage, $$ChatMessagesTableReferences),
    ChatMessage,
    PrefetchHooks Function({bool sessionId})>;
typedef $$ActivityTemplatesTableCreateCompanionBuilder
    = ActivityTemplatesCompanion Function({
  required String id,
  required String name,
  required String category,
  Value<int> defaultDuration,
  Value<String?> description,
  Value<String> status,
  Value<String?> createdBy,
  Value<bool> isSystem,
  Value<int> rowid,
});
typedef $$ActivityTemplatesTableUpdateCompanionBuilder
    = ActivityTemplatesCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> category,
  Value<int> defaultDuration,
  Value<String?> description,
  Value<String> status,
  Value<String?> createdBy,
  Value<bool> isSystem,
  Value<int> rowid,
});

class $$ActivityTemplatesTableFilterComposer
    extends Composer<_$AppDatabase, $ActivityTemplatesTable> {
  $$ActivityTemplatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get defaultDuration => $composableBuilder(
      column: $table.defaultDuration,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSystem => $composableBuilder(
      column: $table.isSystem, builder: (column) => ColumnFilters(column));
}

class $$ActivityTemplatesTableOrderingComposer
    extends Composer<_$AppDatabase, $ActivityTemplatesTable> {
  $$ActivityTemplatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get defaultDuration => $composableBuilder(
      column: $table.defaultDuration,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSystem => $composableBuilder(
      column: $table.isSystem, builder: (column) => ColumnOrderings(column));
}

class $$ActivityTemplatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActivityTemplatesTable> {
  $$ActivityTemplatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get defaultDuration => $composableBuilder(
      column: $table.defaultDuration, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<bool> get isSystem =>
      $composableBuilder(column: $table.isSystem, builder: (column) => column);
}

class $$ActivityTemplatesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ActivityTemplatesTable,
    ActivityTemplate,
    $$ActivityTemplatesTableFilterComposer,
    $$ActivityTemplatesTableOrderingComposer,
    $$ActivityTemplatesTableAnnotationComposer,
    $$ActivityTemplatesTableCreateCompanionBuilder,
    $$ActivityTemplatesTableUpdateCompanionBuilder,
    (
      ActivityTemplate,
      BaseReferences<_$AppDatabase, $ActivityTemplatesTable, ActivityTemplate>
    ),
    ActivityTemplate,
    PrefetchHooks Function()> {
  $$ActivityTemplatesTableTableManager(
      _$AppDatabase db, $ActivityTemplatesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActivityTemplatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActivityTemplatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActivityTemplatesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<int> defaultDuration = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> createdBy = const Value.absent(),
            Value<bool> isSystem = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ActivityTemplatesCompanion(
            id: id,
            name: name,
            category: category,
            defaultDuration: defaultDuration,
            description: description,
            status: status,
            createdBy: createdBy,
            isSystem: isSystem,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String category,
            Value<int> defaultDuration = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> createdBy = const Value.absent(),
            Value<bool> isSystem = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ActivityTemplatesCompanion.insert(
            id: id,
            name: name,
            category: category,
            defaultDuration: defaultDuration,
            description: description,
            status: status,
            createdBy: createdBy,
            isSystem: isSystem,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ActivityTemplatesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ActivityTemplatesTable,
    ActivityTemplate,
    $$ActivityTemplatesTableFilterComposer,
    $$ActivityTemplatesTableOrderingComposer,
    $$ActivityTemplatesTableAnnotationComposer,
    $$ActivityTemplatesTableCreateCompanionBuilder,
    $$ActivityTemplatesTableUpdateCompanionBuilder,
    (
      ActivityTemplate,
      BaseReferences<_$AppDatabase, $ActivityTemplatesTable, ActivityTemplate>
    ),
    ActivityTemplate,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$ProjectsTableTableManager get projects =>
      $$ProjectsTableTableManager(_db, _db.projects);
  $$TasksTableTableManager get tasks =>
      $$TasksTableTableManager(_db, _db.tasks);
  $$DailyLogsTableTableManager get dailyLogs =>
      $$DailyLogsTableTableManager(_db, _db.dailyLogs);
  $$PlannedItemsTableTableManager get plannedItems =>
      $$PlannedItemsTableTableManager(_db, _db.plannedItems);
  $$LoggedItemsTableTableManager get loggedItems =>
      $$LoggedItemsTableTableManager(_db, _db.loggedItems);
  $$ChatSessionsTableTableManager get chatSessions =>
      $$ChatSessionsTableTableManager(_db, _db.chatSessions);
  $$ChatMessagesTableTableManager get chatMessages =>
      $$ChatMessagesTableTableManager(_db, _db.chatMessages);
  $$ActivityTemplatesTableTableManager get activityTemplates =>
      $$ActivityTemplatesTableTableManager(_db, _db.activityTemplates);
}
