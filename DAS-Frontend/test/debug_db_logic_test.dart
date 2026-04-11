import 'package:drift/drift.dart' hide isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_pm/src/core/database/database.dart';
import 'package:project_pm/src/features/today/today_repository.dart';
import 'package:uuid/uuid.dart';

// Create a concrete implementation for testing if needed, or just use TodayRepository directly
// Since TodayRepository is not abstract, we can use it directly with the DB.

void main() {
  late AppDatabase db;
  late TodayRepository repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = TodayRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('Test PlanActivityModal logic', () async {
    const userId = 'u1';
    final date = DateTime(2023, 10, 27);
    final startDateTime = DateTime(2023, 10, 27, 10, 0);

    // 1. Seed User
    await db.into(db.users).insert(UsersCompanion.insert(
          id: userId,
          name: 'Test User',
          avatarUrl: '',
          email: 'test@test.com',
          role: 'ADMIN',
        ));

    // 2. Ensure Daily Log
    final logId = await repo.ensureDailyLogExists(date, userId);
    print('Log ID: $logId');

    final log = await (db.select(db.dailyLogs)
          ..where((t) => t.id.equals(logId)))
        .getSingle();
    expect(log.userId, userId);
    // Verify date is midnight
    expect(log.date, DateTime(date.year, date.month, date.day));

    // 3. Add Planned Item
    await repo.addPlannedItem(
      logId,
      PlannedItemsCompanion(
        id: Value(const Uuid().v4()),
        dailyLogId: Value(logId),
        name: const Value('Test Activity'),
        // description: Value(''),
        startTime: Value(startDateTime),
      ),
    );

    // 4. Verify Fetch
    final rangeStream = repo.watchPlannedItemsForRange(
      DateTime(2023, 10, 1),
      DateTime(2023, 10, 31),
      userId,
    );

    final result = await rangeStream.first;
    print('Result keys: ${result.keys}');

    expect(result.isNotEmpty, true);
    final items = result[DateTime(2023, 10, 27)];
    expect(items, isNotNull);
    expect(items!.length, 1);
    expect(items.first.name, 'Test Activity');
  });
}
