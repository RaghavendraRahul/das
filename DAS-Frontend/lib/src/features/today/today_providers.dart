import 'package:project_pm/src/core/models/daily_log_with_details.dart';
import 'package:project_pm/src/features/today/today_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:project_pm/src/core/database/database.dart';
import 'package:project_pm/src/core/providers/user_providers.dart';

part 'today_providers.g.dart';

@Riverpod(keepAlive: true)
class SelectedDate extends _$SelectedDate {
  @override
  DateTime build() => DateTime.now();

  void setDate(DateTime date) {
    state = date;
  }
}

@Riverpod(keepAlive: true)
class SelectedQuadrant extends _$SelectedQuadrant {
  @override
  String? build() => null;

  void select(String? quadrant) {
    state = quadrant;
  }
}

@Riverpod(keepAlive: true)
Stream<DailyLogWithDetails?> todayLog(TodayLogRef ref) {
  final repository = ref.watch(todayRepositoryProvider);
  final userId = ref.watch(currentUserIdProvider);
  final date = ref.watch(selectedDateProvider);

  if (userId == null) return Stream.value(null);
  return repository.watchDailyLog(date, userId);
}

@riverpod
Stream<Map<DateTime, List<PlannedItem>>> monthPlannedItems(
    MonthPlannedItemsRef ref, DateTime month) {
  final repository = ref.watch(todayRepositoryProvider);
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return Stream.value({});

  // Watch from first day of grid (needs calculation or just conservative range)
  // For simplicity, watch the whole month plus padding for grid
  final start =
      DateTime(month.year, month.month, 1).subtract(const Duration(days: 7));
  final end =
      DateTime(month.year, month.month + 1, 1).add(const Duration(days: 14));

  return repository.watchPlannedItemsForRange(start, end, userId);
}

@riverpod
Stream<Map<DateTime, List<PlannedItem>>> weekPlannedItems(
    WeekPlannedItemsRef ref, DateTime startOfWeek) {
  final repository = ref.watch(todayRepositoryProvider);
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return Stream.value({});

  final end = startOfWeek.add(const Duration(days: 7));
  return repository.watchPlannedItemsForRange(startOfWeek, end, userId);
}
