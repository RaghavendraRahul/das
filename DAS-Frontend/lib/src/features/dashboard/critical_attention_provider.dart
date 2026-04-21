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
    // Skip completed projects
    if (p.isCompleted) continue;

    final dueDate = p.project.dueDate;
    if (dueDate != null) {
      // A. Overdue
      if (dueDate.isBefore(now)) {
        items.add(CriticalItem(
          id: p.project.id,
          projectId: p.project.id,
          title: p.project.name,
          subtitle: 'Overdue (${formatDate(dueDate)})',
          type: CriticalItemType.critical,
          deadline: dueDate,
        ));
      } 
      // B. At Risk (Approaching within 3 days)
      else if (dueDate.difference(now).inDays <= 3) {
        items.add(CriticalItem(
          id: p.project.id,
          projectId: p.project.id,
          title: p.project.name,
          subtitle: 'At Risk (${formatDate(dueDate)})',
          type: CriticalItemType.critical,
          deadline: dueDate,
        ));
      }
    }
  }

  // Sort by deadline: most urgent first
  items.sort((a, b) => a.deadline.compareTo(b.deadline));

  return items;
}
