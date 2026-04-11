import 'package:project_pm/src/core/database/database.dart';

class DailyLogWithDetails {
  final DailyLog dailyLog;
  final List<PlannedItem> plannedItems;
  final List<LoggedItem> loggedItems;

  DailyLogWithDetails({
    required this.dailyLog,
    required this.plannedItems,
    required this.loggedItems,
  });
}
