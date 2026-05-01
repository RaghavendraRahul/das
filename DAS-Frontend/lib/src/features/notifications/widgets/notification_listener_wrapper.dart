import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_pm/src/features/notifications/services/realtime_notification_service.dart';
import 'package:project_pm/src/features/projects/providers/api_providers.dart';
import 'package:project_pm/src/features/projects/project_providers.dart';
import 'package:project_pm/src/core/providers/user_providers.dart';
import 'package:project_pm/src/features/quick_notes/notes_provider.dart';
import 'package:project_pm/src/features/today/services/instruction_service.dart';
import 'package:project_pm/src/features/dashboard/dashboard_providers.dart';

class NotificationListenerWrapper extends ConsumerWidget {
  final Widget? child;
  const NotificationListenerWrapper({super.key, this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(notificationStreamProvider, (previous, next) {
      next.whenData((notification) {
        if (notification.isEmpty) return;

        final title = notification['title'] ?? 'Notification';
        final message = notification['message'] ?? '';
        final type = notification['type']?.toString() ?? 'info';

        // --- Provider Invalidation Logic ---

        // Project/Task related
        if (type.contains('PROJECT') ||
            type.contains('TASK') ||
            type.contains('SUBTASK') ||
            type.contains('APPROVAL')) {
          ref.invalidate(apiTasksProvider);
          ref.invalidate(apiProjectsProvider);
          ref.invalidate(projectsWithTasksProvider);
          ref.invalidate(currentProjectProvider);
          ref.invalidate(paginatedDashboardProjectsProvider);
          ref.invalidate(projectsPageProjectsProvider);
          ref.invalidate(apiPaginatedProjectsProvider);
          
          // ADDED: Invalidate statistics providers for dynamic updates
          ref.invalidate(filteredDashboardStatsProvider);
          ref.invalidate(dashboardProjectsProvider);

          // Also invalidate catalog if project/task changes
          ref.invalidate(apiCatalogProjectsProvider);
          ref.invalidate(apiCatalogTasksProvider);
        }

        // Quick Notes
        if (type.contains('STICKY_NOTE')) {
          ref.invalidate(stickyNotesProvider);
        }

        // Catalog / Planner
        if (type.contains('CATALOG')) {
          ref.invalidate(apiCatalogProvider);
          ref.invalidate(apiCatalogProjectsProvider);
          ref.invalidate(apiCatalogTasksProvider);
        }

        // Today's Plan / Activity Log
        if (type.contains('TODAY_PLAN') || type.contains('ACTIVITY_LOG')) {
          ref.invalidate(apiTodayPlanProvider);
          ref.invalidate(apiActivityLogsProvider);
          ref.invalidate(apiActiveTaskProvider);
          ref.invalidate(apiPendingItemsProvider);
          // Also invalidate week/month views
          ref.invalidate(apiWeekPlansProvider);
          ref.invalidate(apiMonthPlansProvider);
        }

        // Team Instructions (Inbox)
        if (type.contains('INSTRUCTION')) {
          ref.invalidate(receivedInstructionsProvider);
        }

        // User Profile / Role / Department updates
        if (type.contains('USER_UPDATED') ||
            type.contains('DEPARTMENT_UPDATED')) {
          // Invalidate user info to trigger a re-fetch of name/role/permissions
          // We assume currentUserProvider or similar exists in user_providers.dart
          try {
            ref.invalidate(currentUserProvider);
            ref.invalidate(allUsersProvider);
          } catch (_) {}
        }

        // Work Sessions
        if (type.contains('SESSION_UPDATED')) {
          // Refresh dashboard stats or session lists if applicable
        }

        // Determine color/icon based on type
        Color color = Colors.blue;
        IconData icon = Icons.notifications;

        if (type.contains('ERROR') || type.contains('REJECTED')) {
          color = Colors.red;
          icon = Icons.error_outline;
        } else if (type.contains('SUCCESS') ||
            type.contains('APPROVED') ||
            type.contains('COMPLETED')) {
          color = Colors.green;
          icon = Icons.check_circle_outline;
        } else if (type.contains('WARNING')) {
          color = Colors.orange;
          icon = Icons.warning_amber_rounded;
        } else if (type.contains('CREATED') || type.contains('ASSIGNED')) {
          color = Colors.indigo;
          icon = Icons.assignment_ind;
        } else if (type.contains('INSTRUCTION')) {
          color = Colors.purple;
          icon = Icons.mark_chat_unread;
        } else if (type.contains('STICKY_NOTE')) {
          color = Colors.amber.shade700;
          icon = Icons.note_alt_outlined;
        } else if (type.contains('TODAY_PLAN') ||
            type.contains('ACTIVITY_LOG')) {
          color = Colors.teal;
          icon = Icons.today;
        } else if (type.contains('CATALOG')) {
          color = Colors.cyan;
          icon = Icons.inventory_2_outlined;
        } else if (type.contains('USER_UPDATED')) {
          color = Colors.blueGrey;
          icon = Icons.person_search;
        } else if (type.contains('SESSION_UPDATED')) {
          color = Colors.lime.shade800;
          icon = Icons.access_time_filled;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(icon, color: Colors.white, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      if (message.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          message,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.white70),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            backgroundColor: color.withValues(alpha: 0.95),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin:
                const EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            duration: const Duration(seconds: 7),
            dismissDirection: DismissDirection.horizontal,
            showCloseIcon: true,
            closeIconColor: Colors.white,
          ),
        );
      });
    });

    return child ?? const SizedBox();
  }
}
