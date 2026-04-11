import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:project_pm/src/core/networking/api_client.dart';

part 'daily_performance_providers.g.dart';

// ─── Models ───────────────────────────────────────────────────────────────────

class PerformanceTaskData {
  final int id;
  final String name;
  final int plannedMinutes;
  final String status;
  final bool isUnplanned;
  final int totalWorkedMinutes;

  PerformanceTaskData({
    required this.id,
    required this.name,
    required this.plannedMinutes,
    required this.status,
    required this.isUnplanned,
    required this.totalWorkedMinutes,
  });

  factory PerformanceTaskData.fromJson(Map<String, dynamic> json) {
    return PerformanceTaskData(
      id: json['id'] as int? ?? 0,
      name: json['name']?.toString() ?? '',
      plannedMinutes: (json['planned_minutes'] as num?)?.toInt() ?? 0,
      status: json['status']?.toString() ?? '',
      isUnplanned: json['is_unplanned'] as bool? ?? false,
      totalWorkedMinutes: (json['total_worked_minutes'] as num?)?.toInt() ?? 0,
    );
  }
}

class DailyPerformanceData {
  final String date;
  final String user;
  final PlannedSummary plannedSummary;
  final ActualSummary actualSummary;
  final PerformanceMetrics metrics;
  final List<PerformanceTaskData> tasks;

  DailyPerformanceData({
    required this.date,
    required this.user,
    required this.plannedSummary,
    required this.actualSummary,
    required this.metrics,
    required this.tasks,
  });

  factory DailyPerformanceData.fromJson(Map<String, dynamic> json) {
    return DailyPerformanceData(
      date: json['date'] ?? '',
      user: json['user'] ?? '',
      plannedSummary: PlannedSummary.fromJson(json['planned_summary'] ?? {}),
      actualSummary: ActualSummary.fromJson(json['actual_summary'] ?? {}),
      metrics: PerformanceMetrics.fromJson(json['metrics'] ?? {}),
      tasks: (json['tasks'] as List<dynamic>?)
              ?.map((e) => PerformanceTaskData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class PlannedSummary {
  final int totalTasks;
  final double totalPlannedHours;
  final int plannedTasksCount;
  final int unplannedTasksCount;

  PlannedSummary({
    required this.totalTasks,
    required this.totalPlannedHours,
    required this.plannedTasksCount,
    required this.unplannedTasksCount,
  });

  factory PlannedSummary.fromJson(Map<String, dynamic> json) {
    return PlannedSummary(
      totalTasks: (json['total_tasks'] as num?)?.toInt() ?? 0,
      totalPlannedHours: (json['total_planned_hours'] as num?)?.toDouble() ?? 0.0,
      plannedTasksCount: (json['planned_tasks']?['count'] as num?)?.toInt() ?? 0,
      unplannedTasksCount: (json['unplanned_tasks']?['count'] as num?)?.toInt() ?? 0,
    );
  }
}

class ActualSummary {
  final double totalHoursWorked;
  final int completedPlannedCount;
  final int completedUnplannedCount;

  ActualSummary({
    required this.totalHoursWorked,
    required this.completedPlannedCount,
    required this.completedUnplannedCount,
  });

  factory ActualSummary.fromJson(Map<String, dynamic> json) {
    return ActualSummary(
      totalHoursWorked: (json['total_hours_worked'] as num?)?.toDouble() ?? 0.0,
      completedPlannedCount: (json['planned_work']?['count'] as num?)?.toInt() ?? 0,
      completedUnplannedCount: (json['unplanned_work']?['count'] as num?)?.toInt() ?? 0,
    );
  }
}

class PerformanceMetrics {
  final double taskCompletionRate;
  final double timeEfficiencyPercentage;
  final String status;

  PerformanceMetrics({
    required this.taskCompletionRate,
    required this.timeEfficiencyPercentage,
    required this.status,
  });

  factory PerformanceMetrics.fromJson(Map<String, dynamic> json) {
    return PerformanceMetrics(
      taskCompletionRate: (json['task_completion_rate'] as num?)?.toDouble() ?? 0.0,
      timeEfficiencyPercentage: (json['time_efficiency_percentage'] as num?)?.toDouble() ?? 0.0,
      status: json['status']?.toString() ?? 'Unknown',
    );
  }
}

// ─── Providers ────────────────────────────────────────────────────────────────

@riverpod
Future<DailyPerformanceData> dailyPerformance(DailyPerformanceRef ref, {String? date}) async {
  // Advanced state management: 0 delay load times on UI refresh
  ref.keepAlive();
  
  final dio = ref.watch(dioProvider);
  
  // Example path construction:
  // If date is provided: /api/daily-performance/<date>/
  // Otherwise: /api/daily-performance/
  final path = date != null ? 'daily-performance/$date/' : 'daily-performance/';
  
  final res = await dio.get(path);
  return DailyPerformanceData.fromJson(res.data);
}
