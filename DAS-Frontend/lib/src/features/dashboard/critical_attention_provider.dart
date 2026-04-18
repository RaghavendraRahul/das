import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../projects/project_providers.dart';

part 'critical_attention_provider.g.dart';

enum CriticalItemType { critical }

class CriticalItem {
  final String id;
  final String projectId;
  final String title;
  final String subtitle;
  final CriticalItemType type;
  final DateTime deadline;

  CriticalItem({
    required this.id,
    required this.projectId,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.deadline,
  });

  IconData get icon => Icons.warning_rounded;
  Color get color => Colors.red;
  String get typeLabel => 'Critical';
}

@riverpod
Future<List<CriticalItem>> criticalItems(CriticalItemsRef ref) async {
  final projectsAsync = await ref.watch(projectsWithTasksProvider.future);
  final List<CriticalItem> items = [];
  final now = DateTime.now();

  String formatDate(DateTime d) {
    const m = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return "${m[d.month-1]} ${d.day}";
  }

  for (final p in projectsAsync) {
    for (final t in p.tasks) {
      // Skip completed tasks
      if (t.progress >= 100) continue;

      // A. Overdue (Any priority)
      if (t.task.endDate.isBefore(now)) {
        items.add(CriticalItem(
          id: t.task.id,
          projectId: p.project.id,
          title: t.task.name,
          subtitle: 'Overdue (${formatDate(t.task.endDate)}) • Project: ${p.project.name}',
          type: CriticalItemType.critical,
          deadline: t.task.endDate,
        ));
      } 
      // B. At Risk (Approaching within 3 days, low progress)
      else if (t.task.endDate.difference(now).inDays < 3 && 
               t.task.endDate.isAfter(now) && 
               t.progress < 50) {
        items.add(CriticalItem(
          id: t.task.id,
          projectId: p.project.id,
          title: t.task.name,
          subtitle: 'At Risk (${formatDate(t.task.endDate)}) • Project: ${p.project.name}',
          type: CriticalItemType.critical,
          deadline: t.task.endDate,
        ));
      }
    }
  }

  // Sort by deadline: most urgent first
  items.sort((a, b) => a.deadline.compareTo(b.deadline));

  return items;
}
