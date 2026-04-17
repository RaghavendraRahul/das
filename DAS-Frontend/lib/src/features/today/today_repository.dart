import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:project_pm/src/core/database/database.dart';
import 'package:project_pm/src/core/models/daily_log_with_details.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

import 'package:project_pm/src/features/projects/services/task_api_service.dart';
import '../../core/database/database_provider.dart';
import '../projects/providers/api_providers.dart';
import 'today_api_service.dart';

part 'today_repository.g.dart';

@Riverpod(keepAlive: true)
TodayRepository todayRepository(TodayRepositoryRef ref) {
  if (kIsWeb) {
    return MockTodayRepository();
  }
  return TodayRepository(ref.watch(databaseProvider),
      ref.watch(taskApiServiceProvider), ref.watch(todayApiServiceProvider));
}

class TodayRepository {
  final AppDatabase? _db; // Allow null for mock
  final TaskApiService? _api;
  final TodayApiService? _todayApi;

  TodayRepository(this._db, [this._api, this._todayApi]);

  Stream<DailyLogWithDetails?> watchDailyLog(DateTime date, String userId) {
    final db = _db!;
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final query = db.select(db.dailyLogs)
      ..where((tbl) =>
          tbl.userId.equals(userId) &
          tbl.date.isBiggerOrEqualValue(startOfDay) &
          tbl.date.isSmallerThanValue(endOfDay));

    return query.watchSingleOrNull().switchMap((log) {
      if (log == null) return Stream.value(null);

      final plannedQuery = db.select(db.plannedItems)
        ..where((tbl) => tbl.dailyLogId.equals(log.id))
        ..orderBy([(t) => OrderingTerm(expression: t.orderIndex)]);
      final loggedQuery = db.select(db.loggedItems)
        ..where((tbl) => tbl.dailyLogId.equals(log.id));

      return Rx.combineLatest2(
        plannedQuery.watch(),
        loggedQuery.watch(),
        (List<PlannedItem> planned, List<LoggedItem> logged) {
          return DailyLogWithDetails(
            dailyLog: log,
            plannedItems: planned,
            loggedItems: logged,
          );
        },
      );
    });
  }

  /// Watch all planned items for a given date range (inclusive start, exclusive end)
  /// Returns a Map<DateTime, List<PlannedItem>> keyed by the day
  Stream<Map<DateTime, List<PlannedItem>>> watchPlannedItemsForRange(
      DateTime start, DateTime end, String userId) {
    final db = _db!;

    // We need to join DailyLogs with PlannedItems
    final query = db.select(db.dailyLogs).join([
      innerJoin(db.plannedItems,
          db.plannedItems.dailyLogId.equalsExp(db.dailyLogs.id))
    ])
      ..where(db.dailyLogs.userId.equals(userId) &
          db.dailyLogs.date.isBiggerOrEqualValue(start) &
          db.dailyLogs.date.isSmallerThanValue(end));

    return query.watch().map((rows) {
      final Map<DateTime, List<PlannedItem>> result = {};

      for (final row in rows) {
        final log = row.readTable(db.dailyLogs);
        final item = row.readTable(db.plannedItems);

        // Normalize date to YMD
        final date = DateTime(log.date.year, log.date.month, log.date.day);

        if (!result.containsKey(date)) {
          result[date] = [];
        }
        result[date]!.add(item);
      }
      return result;
    });
  }

  Future<String> ensureDailyLogExists(DateTime date, String userId) async {
    final db = _db!;
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final existing = await (db.select(db.dailyLogs)
          ..where((tbl) =>
              tbl.userId.equals(userId) &
              tbl.date.isBiggerOrEqualValue(startOfDay) &
              tbl.date.isSmallerThanValue(endOfDay)))
        .getSingleOrNull();

    if (existing != null) {
      return existing.id;
    } else {
      final newId = const Uuid().v4();
      await db.into(db.dailyLogs).insert(DailyLogsCompanion(
            id: Value(newId),
            date: Value(startOfDay),
            userId: Value(userId),
            isFinalized: const Value(false),
          ));
      return newId;
    }
  }

  Future<void> addPlannedItem(String logId, PlannedItemsCompanion item,
      {bool skipBackendSync = false}) async {
    final db = _db!;

    // 1. Calculate next order index
    final lastItem = await (db.select(db.plannedItems)
          ..where((tbl) => tbl.dailyLogId.equals(logId))
          ..orderBy(
              [(t) => OrderingTerm(expression: t.orderIndex, mode: OrderingMode.desc)])
          ..limit(1))
        .getSingleOrNull();

    final nextOrder = (lastItem?.orderIndex ?? -1) + 1;

    // 2. Insert with order index
    final itemWithOrder = item.copyWith(
      orderIndex: Value(nextOrder),
    );

    await db.into(db.plannedItems).insert(itemWithOrder);

    // Sync to backend using TodayApiService
    if (!skipBackendSync && _todayApi != null) {
      try {
        final dailyLog = await (_db!.select(_db!.dailyLogs)
              ..where((tbl) => tbl.id.equals(logId)))
            .getSingle();

        await _todayApi!.createPlannedActivity(
          activityName: item.name.value,
          description: item.description.value,
          planDate: dailyLog.date,
          scheduledStartTime: item.startTime.value!,
          plannedDurationMinutes: item.durationMinutes.value,
          quadrant: item.quadrant.value,
        );

        debugPrint("✅ Successfully synced planned activity to backend");
      } catch (e) {
        debugPrint("❌ Failed to sync planned activity to backend: $e");
        // Don't rethrow - allow optimistic local save
      }
    }
  }

  Future<void> updatePlannedItem(
      String itemId, PlannedItemsCompanion item) async {
    await (_db!.update(_db!.plannedItems)
          ..where((tbl) => tbl.id.equals(itemId)))
        .write(item);
  }

  Future<void> deletePlannedItem(String itemId) async {
    await (_db!.delete(_db!.plannedItems)
          ..where((tbl) => tbl.id.equals(itemId)))
        .go();
  }

  Future<void> updateItemsOrder(List<String> sortedItemIds) async {
    final db = _db!;
    await db.transaction(() async {
      for (int i = 0; i < sortedItemIds.length; i++) {
        await (db.update(db.plannedItems)..where((t) => t.id.equals(sortedItemIds[i])))
            .write(PlannedItemsCompanion(orderIndex: Value(i)));
      }
    });

    // Sync to backend if service available
    if (_todayApi != null) {
      try {
        final List<Map<String, dynamic>> items = [];
        for (int i = 0; i < sortedItemIds.length; i++) {
          items.add({
            'id': sortedItemIds[i],
            'order_index': i,
          });
        }
        // backend uses integer IDs sometimes, but drift uses strings (UUIDs)
        // I need to check how backend IDs are handled. 
        // In this project, IDs are usually UUID strings.
        await _todayApi!.reorderTodayPlan(items);
      } catch (e) {
        debugPrint("Error syncing order to backend: $e");
      }
    }
  }

  Future<void> startTask(String logId, String name, String description,
      {String? relatedTaskId, String? plannedItemId}) async {
    // Check for duplicates if this is a planned item
    if (plannedItemId != null) {
      final existing = await (_db!.select(_db!.loggedItems)
            ..where((tbl) => tbl.plannedItemId.equals(plannedItemId)))
          .getSingleOrNull();

      if (existing != null) {
        debugPrint("⚠️ Task already added to activity log");
        throw Exception("This task has already been added to the activity log");
      }
    }

    // 1. Start local log
    final newId = const Uuid().v4();
    await _db!.into(_db!.loggedItems).insert(LoggedItemsCompanion(
          id: Value(newId),
          dailyLogId: Value(logId),
          name: Value(name),
          description: Value(description),
          startTime: Value(DateTime.now()),
          isUnplanned: Value(plannedItemId == null),
          relatedTaskId: Value(relatedTaskId),
          plannedItemId: Value(plannedItemId),
        ));

    // 2. Sync to backend
    if (_api != null && plannedItemId != null) {
      try {
        await _api!.startWorkLog(
          plannedItemId: plannedItemId,
          name: name,
          description: description,
          relatedTaskId: relatedTaskId,
        );
      } catch (e) {
        debugPrint("Failed to start backend work log: $e");
      }
    }
  }

  Future<void> stopTask(String itemId) async {
    await (_db!.update(_db!.loggedItems)..where((tbl) => tbl.id.equals(itemId)))
        .write(LoggedItemsCompanion(
      endTime: Value(DateTime.now()),
    ));

    // Sync stop to backend
    if (_api != null) {
      try {
        // We need to look up if this was checked as completed?
        // simple stopTask implies incomplete or just pausing
        await _api!.stopWorkLog(logId: itemId, isCompleted: false);
      } catch (e) {
        debugPrint("Failed to stop backend work log: $e");
      }
    }
  }

  Future<void> stopTaskWithReview(String logId, String itemId, bool isCompleted,
      int? newRemainingMinutes) async {
    final now = DateTime.now();

    // 1. Stop the running task
    await (_db!.update(_db!.loggedItems)..where((tbl) => tbl.id.equals(itemId)))
        .write(LoggedItemsCompanion(
      endTime: Value(now),
    ));

    // Sync stop to backend
    if (_api != null) {
      try {
        await _api!.stopWorkLog(logId: itemId, isCompleted: isCompleted);
      } catch (e) {
        debugPrint("Failed to stop backend work log: $e");
      }
    }

    // 2. Get the logged item to find the planned item ID
    final loggedItem = await (_db!.select(_db!.loggedItems)
          ..where((tbl) => tbl.id.equals(itemId)))
        .getSingleOrNull();

    if (loggedItem == null || loggedItem.plannedItemId == null) return;

    final plannedId = loggedItem.plannedItemId!;

    // 3. Update planned item status
    await (_db!.update(_db!.plannedItems)
          ..where((tbl) => tbl.id.equals(plannedId)))
        .write(PlannedItemsCompanion(
      isCompleted: Value(isCompleted),
    ));

    // 4. If pending and new remaining time is provided, update the planned duration
    if (!isCompleted && newRemainingMinutes != null) {
      // Calculate total time spent INCLUDING the just-finished task
      final allLogs = await (_db!.select(_db!.loggedItems)
            ..where((tbl) => tbl.plannedItemId.equals(plannedId)))
          .get();

      int totalSpentMinutes = 0;
      for (var log in allLogs) {
        final end = log.endTime ?? now;
        totalSpentMinutes += end.difference(log.startTime).inMinutes;
      }

      final newTotalDuration = totalSpentMinutes + newRemainingMinutes;

      await (_db!.update(_db!.plannedItems)
            ..where((tbl) => tbl.id.equals(plannedId)))
          .write(PlannedItemsCompanion(
        durationMinutes: Value(newTotalDuration),
      ));
    }
  }

  Future<({int plannedMinutes, int spentMinutes})> getTaskProgress(
      String plannedItemId) async {
    final plannedItem = await (_db!.select(_db!.plannedItems)
          ..where((tbl) => tbl.id.equals(plannedItemId)))
        .getSingle();

    final logs = await (_db!.select(_db!.loggedItems)
          ..where((tbl) => tbl.plannedItemId.equals(plannedItemId)))
        .get();

    int totalSpentMinutes = 0;
    final now = DateTime.now();
    for (var log in logs) {
      final end = log.endTime ?? now;
      totalSpentMinutes += end.difference(log.startTime).inMinutes;
    }

    return (
      plannedMinutes: plannedItem.durationMinutes,
      spentMinutes: totalSpentMinutes
    );
  }

  Future<void> updateLoggedItemRemarks(
      String itemId, List<String> remarks) async {
    final remarksJson = jsonEncode(remarks);
    await (_db!.update(_db!.loggedItems)..where((tbl) => tbl.id.equals(itemId)))
        .write(LoggedItemsCompanion(
      remarksJson: Value(remarksJson),
    ));
  }

  Future<void> finalizePlan(String logId) async {
    await (_db!.update(_db!.dailyLogs)..where((tbl) => tbl.id.equals(logId)))
        .write(const DailyLogsCompanion(
      isFinalized: Value(true),
    ));
  }
}

/// Mock Implementation for Web
class MockTodayRepository implements TodayRepository {
  // Singleton-like behavior for the session
  static final _logSubject = BehaviorSubject<DailyLogWithDetails?>.seeded(
    DailyLogWithDetails(
      dailyLog: DailyLog(
        id: 'l1',
        date: DateTime.now(),
        userId: 'u1',
        isFinalized: false,
      ),
      plannedItems: [],
      loggedItems: [],
    ),
  );

  @override
  AppDatabase? get _db => null;

  @override
  TaskApiService? get _api => null;

  @override
  TodayApiService? get _todayApi => null;

  @override
  Stream<DailyLogWithDetails?> watchDailyLog(DateTime date, String userId) =>
      _logSubject.stream;

  @override
  Stream<Map<DateTime, List<PlannedItem>>> watchPlannedItemsForRange(
      DateTime start, DateTime end, String userId) {
    return _logSubject.stream.map((details) {
      if (details == null) return {};
      // For mock, we only have one log. If it's in range, return it.
      final logDate = details.dailyLog.date;
      final normalizedLogDate =
          DateTime(logDate.year, logDate.month, logDate.day);

      if (normalizedLogDate.isAfter(start.subtract(const Duration(days: 1))) &&
          normalizedLogDate.isBefore(end)) {
        return {normalizedLogDate: details.plannedItems};
      }
      return {};
    });
  }

  @override
  Future<String> ensureDailyLogExists(DateTime date, String userId) async {
    // For mock, just return existing ID
    return _logSubject.value!.dailyLog.id;
  }

  @override
  Future<void> addPlannedItem(String logId, PlannedItemsCompanion item,
      {bool skipBackendSync = false}) async {
    final current = _logSubject.value!;
    final newItem = PlannedItem(
      id: item.id.value,
      dailyLogId: item.dailyLogId.value,
      name: item.name.value,
      description: item.description.value,
      durationMinutes: item.durationMinutes.value,
      quadrant: item.quadrant.value,
      orderIndex: item.orderIndex.present ? item.orderIndex.value : 0,
      relatedTaskId:
          item.relatedTaskId.present ? item.relatedTaskId.value : null,
      startTime: item.startTime.present ? item.startTime.value : null,
      isCompleted: item.isCompleted.present ? item.isCompleted.value : false,
    );
    _logSubject.add(DailyLogWithDetails(
      dailyLog: current.dailyLog,
      plannedItems: [...current.plannedItems, newItem],
      loggedItems: current.loggedItems,
    ));
  }

  @override
  Future<void> updatePlannedItem(
      String itemId, PlannedItemsCompanion item) async {
    final current = _logSubject.value!;
    final updatedItems = current.plannedItems.map((i) {
      if (i.id == itemId) {
        return PlannedItem(
          id: i.id,
          dailyLogId: i.dailyLogId,
          name: item.name.present ? item.name.value : i.name,
          description:
              item.description.present ? item.description.value : i.description,
          durationMinutes: item.durationMinutes.present
              ? item.durationMinutes.value
              : i.durationMinutes,
          quadrant: item.quadrant.present ? item.quadrant.value : i.quadrant,
          orderIndex: item.orderIndex.present ? item.orderIndex.value : i.orderIndex,
          relatedTaskId: item.relatedTaskId.present
              ? item.relatedTaskId.value
              : i.relatedTaskId,
          startTime:
              item.startTime.present ? item.startTime.value : i.startTime,
          isCompleted:
              item.isCompleted.present ? item.isCompleted.value : i.isCompleted,
        );
      }
      return i;
    }).toList();
    _logSubject.add(DailyLogWithDetails(
      dailyLog: current.dailyLog,
      plannedItems: updatedItems,
      loggedItems: current.loggedItems,
    ));
  }

  @override
  Future<void> deletePlannedItem(String itemId) async {
    final current = _logSubject.value!;
    _logSubject.add(DailyLogWithDetails(
      dailyLog: current.dailyLog,
      plannedItems: current.plannedItems.where((i) => i.id != itemId).toList(),
      loggedItems: current.loggedItems,
    ));
  }

  @override
  Future<void> startTask(String logId, String name, String description,
      {String? relatedTaskId, String? plannedItemId}) async {
    final current = _logSubject.value!;
    final newLog = LoggedItem(
      id: const Uuid().v4(),
      dailyLogId: logId,
      name: name,
      description: description,
      startTime: DateTime.now(),
      isUnplanned: plannedItemId == null,
      relatedTaskId: relatedTaskId,
      plannedItemId: plannedItemId,
      remarksJson: '[]',
    );
    _logSubject.add(DailyLogWithDetails(
      dailyLog: current.dailyLog,
      plannedItems: current.plannedItems,
      loggedItems: [...current.loggedItems, newLog],
    ));
  }

  @override
  Future<void> stopTask(String itemId) async {
    final current = _logSubject.value!;
    final updatedLogs = current.loggedItems.map((i) {
      if (i.id == itemId) {
        return LoggedItem(
          id: i.id,
          dailyLogId: i.dailyLogId,
          name: i.name,
          description: i.description,
          startTime: i.startTime,
          endTime: DateTime.now(),
          isUnplanned: i.isUnplanned,
          plannedItemId: i.plannedItemId,
          relatedTaskId: i.relatedTaskId,
          remarksJson: i.remarksJson,
        );
      }
      return i;
    }).toList();
    _logSubject.add(DailyLogWithDetails(
      dailyLog: current.dailyLog,
      plannedItems: current.plannedItems,
      loggedItems: updatedLogs,
    ));
  }

  @override
  Future<void> stopTaskWithReview(String logId, String itemId, bool isCompleted,
      int? newRemainingMinutes) async {
    await stopTask(itemId);
    // Mock update planned item
    if (isCompleted) {
      // Find and update
    }
  }

  @override
  Future<({int plannedMinutes, int spentMinutes})> getTaskProgress(
      String plannedItemId) async {
    // Mock return
    return (plannedMinutes: 60, spentMinutes: 15);
  }

  @override
  Future<void> updateLoggedItemRemarks(
      String itemId, List<String> remarks) async {
    final current = _logSubject.value!;
    final remarksJson = jsonEncode(remarks);
    final updatedLogs = current.loggedItems.map((i) {
      if (i.id == itemId) {
        return LoggedItem(
          id: i.id,
          dailyLogId: i.dailyLogId,
          name: i.name,
          description: i.description,
          startTime: i.startTime,
          endTime: i.endTime,
          isUnplanned: i.isUnplanned,
          plannedItemId: i.plannedItemId,
          relatedTaskId: i.relatedTaskId,
          remarksJson: remarksJson,
        );
      }
      return i;
    }).toList();
    _logSubject.add(DailyLogWithDetails(
      dailyLog: current.dailyLog,
      plannedItems: current.plannedItems,
      loggedItems: updatedLogs,
    ));
  }

  @override
  Future<void> updateItemsOrder(List<String> sortedItemIds) async {
    final current = _logSubject.value!;
    final itemsMap = {for (var item in current.plannedItems) item.id: item};
    final updatedItems = sortedItemIds.map((id) => itemsMap[id]!).toList();
    
    _logSubject.add(DailyLogWithDetails(
      dailyLog: current.dailyLog,
      plannedItems: updatedItems,
      loggedItems: current.loggedItems,
    ));
  }

  @override
  Future<void> finalizePlan(String logId) async {
    final current = _logSubject.value!;
    _logSubject.add(DailyLogWithDetails(
      dailyLog: current.dailyLog.copyWith(isFinalized: true),
      plannedItems: current.plannedItems,
      loggedItems: current.loggedItems,
    ));
  }
}
