import 'package:flutter/material.dart';
import 'package:project_pm/src/core/models/project_with_tasks.dart';

class FocusItem {
  final String title;
  final String subtitle;
  final String priority;
  final Color color;
  final String? taskId;
  final String? projectId;
  final String projectName;
  final String description;
  final int progress;
  final List<String> assignees;

  FocusItem({
    required this.title,
    required this.subtitle,
    required this.priority,
    required this.color,
    this.taskId,
    this.projectId,
    this.projectName = '',
    this.description = '',
    this.progress = 0,
    this.assignees = const [],
  });
}

class Risk {
  final String message;
  final bool isCritical;

  Risk({required this.message, required this.isCritical});
}

class DashboardService {
  List<Risk> analyzeRisks(List<ProjectWithTasks> projects) {
    if (projects.isEmpty) return [];

    final risks = <Risk>[];

    for (var p in projects) {
      final criticalTasks = p.tasks
          .where((t) =>
              t.task.priority == "High" &&
              t.endDate.isBefore(DateTime.now()) &&
              t.progress < 100)
          .toList();
      if (criticalTasks.isNotEmpty) {
        risks.add(Risk(
            message:
                "Project '${p.project.name}' has ${criticalTasks.length} overdue critical tasks.",
            isCritical: true));
      }

      final upcomingDeadline = p.tasks
          .where((t) =>
              t.endDate.difference(DateTime.now()).inDays < 3 &&
              t.endDate.isAfter(DateTime.now()) &&
              t.progress < 50)
          .toList();

      if (upcomingDeadline.isNotEmpty) {
        risks.add(Risk(
            message:
                "Approaching deadline for ${upcomingDeadline.length} tasks in '${p.project.name}' with low progress.",
            isCritical: false));
      }
    }
    return risks;
  }

  List<FocusItem> identifyFocusItems(List<ProjectWithTasks> projects) {
    final items = <FocusItem>[];

    // 1. Overdue & High Priority
    for (var p in projects) {
      final urgent = p.tasks
          .where((t) =>
              t.task.priority == 'High' &&
              t.endDate.isBefore(DateTime.now()) &&
              t.progress < 100)
          .toList();

      for (var t in urgent.take(3)) {
        if (items.length >= 3) break;
        items.add(FocusItem(
          title: t.task.name,
          subtitle: "Overdue - High Priority",
          priority: "High",
          color: Colors.red,
          taskId: t.task.id,
          projectId: p.project.id,
          projectName: p.project.name,
          description: "This task is overdue and requires immediate attention",
          progress: t.progress.toInt(),
          assignees: [], // TODO: Extract from task assignees
        ));
      }
    }

    // 2. Due Today
    if (items.length < 3) {
      for (var p in projects) {
        final dueToday = p.tasks.where((t) {
          final now = DateTime.now();
          return t.endDate.year == now.year &&
              t.endDate.month == now.month &&
              t.endDate.day == now.day &&
              t.progress < 100;
        }).toList();

        for (var t in dueToday) {
          if (items.length >= 3) break;
          items.add(FocusItem(
            title: t.task.name,
            subtitle: "Due Today",
            priority: t.task.priority,
            color: Colors.blue,
            taskId: t.task.id,
            projectId: p.project.id,
            projectName: p.project.name,
            description: "This task is due today",
            progress: t.progress.toInt(),
            assignees: [],
          ));
        }
      }
    }

    if (items.isEmpty) {
      return [];
    }

    return items;
  }
}
