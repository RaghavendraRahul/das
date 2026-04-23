import 'package:flutter/material.dart';

enum SearchResultType {
  project,
  task,
  subtask,
  employee,
  catalog;

  static SearchResultType fromString(String value) {
    switch (value.toUpperCase()) {
      case 'PROJECT':
        return SearchResultType.project;
      case 'TASK':
        return SearchResultType.task;
      case 'SUBTASK':
        return SearchResultType.subtask;
      case 'EMPLOYEE':
        return SearchResultType.employee;
      case 'CATALOG':
        return SearchResultType.catalog;
      default:
        return SearchResultType.project;
    }
  }

  IconData get icon {
    switch (this) {
      case SearchResultType.project:
        return Icons.folder_copy_rounded;
      case SearchResultType.task:
        return Icons.assignment_rounded;
      case SearchResultType.subtask:
        return Icons.subdirectory_arrow_right_rounded;
      case SearchResultType.employee:
        return Icons.person_search_rounded;
      case SearchResultType.catalog:
        return Icons.library_books_rounded;
    }
  }

  Color get color {
    switch (this) {
      case SearchResultType.project:
        return const Color(0xFF2196F3);
      case SearchResultType.task:
        return const Color(0xFF4CAF50);
      case SearchResultType.subtask:
        return const Color(0xFF9C27B0);
      case SearchResultType.employee:
        return const Color(0xFFFF9800);
      case SearchResultType.catalog:
        return const Color(0xFF607D8B);
    }
  }
}

class GlobalSearchResult {
  final int id;
  final SearchResultType type;
  final String title;
  final String subtitle;
  final String status;
  final String priority;

  GlobalSearchResult({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.priority,
  });

  factory GlobalSearchResult.fromJson(Map<String, dynamic> json) {
    return GlobalSearchResult(
      id: json['id'],
      type: SearchResultType.fromString(json['type']),
      title: json['title'] ?? 'Untitled',
      subtitle: json['subtitle'] ?? '',
      status: json['status'] ?? '',
      priority: json['priority'] ?? '',
    );
  }
}
