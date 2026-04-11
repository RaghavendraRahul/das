import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

class Users extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get avatarUrl => text()();
  TextColumn get email => text()();
  TextColumn get role => text()(); // Enum as string
  TextColumn get reportingManagerId => text().nullable()();
  TextColumn get department => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Projects extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get context => text()(); // Description/Context
  TextColumn get approvalStatus => text().nullable()();
  TextColumn get rejectionReason => text().nullable()();
  TextColumn get status => text()();
  DateTimeColumn get dueDate => dateTime().nullable()();
  DateTimeColumn get completedDate => dateTime().nullable()();
  RealColumn get plannedHours => real().withDefault(const Constant(0.0))();

  @override
  Set<Column> get primaryKey => {id};
}

class Tasks extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get projectId => text().references(Projects, #id)();
  IntColumn get progress => integer().withDefault(const Constant(0))();
  TextColumn get priority => text()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  TextColumn get approvalStatus => text().nullable()();
  TextColumn get rejectionReason => text().nullable()();
  TextColumn get assigneesJson => text()(); // Storing list of User IDs as JSON
  TextColumn get milestonesJson => text().withDefault(const Constant('[]'))();
  TextColumn get githubLink => text().nullable()();
  TextColumn get figmaLink => text().nullable()();
  TextColumn get taskType => text().withDefault(const Constant('standard'))();
  TextColumn get recurrencePattern => text().nullable()();
  DateTimeColumn get nextOccurrence => dateTime().nullable()();
  RealColumn get plannedHours => real().withDefault(const Constant(0.0))();

  @override
  Set<Column> get primaryKey => {id};
}

class DailyLogs extends Table {
  TextColumn get id => text()();
  DateTimeColumn get date => dateTime()();
  TextColumn get userId => text().references(Users, #id)();
  BoolColumn get isFinalized => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class PlannedItems extends Table {
  TextColumn get id => text()();
  TextColumn get dailyLogId => text().references(DailyLogs, #id)();
  TextColumn get name => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  TextColumn get quadrant =>
      text().withDefault(const Constant('q4'))(); // q1, q2, q3, q4, inbox
  IntColumn get durationMinutes => integer().withDefault(const Constant(0))();
  TextColumn get relatedTaskId => text().nullable().references(Tasks, #id)();
  DateTimeColumn get startTime => dateTime().nullable()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class LoggedItems extends Table {
  TextColumn get id => text()();
  TextColumn get dailyLogId => text().references(DailyLogs, #id)();
  TextColumn get name => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime().nullable()();
  BoolColumn get isUnplanned => boolean().withDefault(const Constant(false))();
  TextColumn get plannedItemId =>
      text().nullable().references(PlannedItems, #id)();
  TextColumn get relatedTaskId => text().nullable().references(Tasks, #id)();
  TextColumn get remarksJson => text().withDefault(const Constant('[]'))();

  @override
  Set<Column> get primaryKey => {id};
}

// --- Chat Tables ---

class ChatSessions extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().references(Users, #id)();
  TextColumn get title => text()();
  DateTimeColumn get lastModified => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class ChatMessages extends Table {
  TextColumn get id => text()();
  TextColumn get sessionId => text().references(ChatSessions, #id)();
  TextColumn get content => text()();
  TextColumn get sender => text()(); // 'user', 'ai'
  DateTimeColumn get timestamp => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class ActivityTemplates extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get category => text()();
  IntColumn get defaultDuration => integer().withDefault(const Constant(60))();
  TextColumn get description => text().nullable()();
  TextColumn get status => text()
      .withDefault(const Constant('pending'))(); // approved, pending, rejected
  TextColumn get createdBy => text().nullable()();
  BoolColumn get isSystem => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [
  Users,
  Projects,
  Tasks,
  DailyLogs,
  PlannedItems,
  LoggedItems,
  ChatSessions,
  ChatMessages,
  ActivityTemplates,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? _openConnection());

  @override
  int get schemaVersion => 14; // Bumped for Project completedDate column

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.createTable(dailyLogs);
          await m.createTable(plannedItems);
          await m.createTable(loggedItems);
        }
        if (from < 3) {
          await m.addColumn(tasks, tasks.milestonesJson);
        }
        if (from < 4) {
          await m.createTable(chatSessions);
          await m.createTable(chatMessages);
        }
        if (from < 5) {
          await m.addColumn(tasks, tasks.githubLink);
          await m.addColumn(tasks, tasks.figmaLink);
        }
        if (from < 6) {
          await m.createTable(activityTemplates);
        }
        if (from < 7) {
          await m.addColumn(plannedItems, plannedItems.startTime);
        }
        if (from < 8) {
          await m.addColumn(plannedItems, plannedItems.isCompleted);
        }
        if (from < 9) {
          await m.addColumn(tasks, tasks.taskType);
          await m.addColumn(tasks, tasks.recurrencePattern);
          await m.addColumn(tasks, tasks.nextOccurrence);
        }
        if (from < 10) {
          await m.addColumn(projects, projects.dueDate);
        }
        if (from < 11) {
          await m.addColumn(projects, projects.plannedHours);
        }
        if (from < 12) {
          // Add approval_status and rejection_reason to tasks and projects
          // Use try/catch for each since some columns may already exist
          try { await m.addColumn(tasks, tasks.approvalStatus); } catch (_) {}
          try { await m.addColumn(tasks, tasks.rejectionReason); } catch (_) {}
          try { await m.addColumn(projects, projects.approvalStatus); } catch (_) {}
          try { await m.addColumn(projects, projects.rejectionReason); } catch (_) {}
        }
        if (from < 13) {
          // Add plannedHours to tasks
          try {
            await m.addColumn(tasks, tasks.plannedHours);
          } catch (_) {}
        }
        if (from < 14) {
          // Add completedDate to projects
          try {
            await m.addColumn(projects, projects.completedDate);
          } catch (_) {}
        }
      },
    );
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'pm_database',
      native: const DriftNativeOptions(
        shareAcrossIsolates: true,
      ),
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.dart.js'),
      ),
    );
  }
}
