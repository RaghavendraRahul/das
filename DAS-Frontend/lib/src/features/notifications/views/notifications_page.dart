import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../routes/app_router.dart';
import '../../projects/project_providers.dart';
import '../../notifications/services/notification_polling_service.dart';

@RoutePage()
class NotificationsPage extends ConsumerWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationPollingProvider);
    final notificationService = ref.read(notificationPollingProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: () {
              // Mark all as read
              for (var n in notifications) {
                if (!n.isRead) {
                  notificationService.markAsRead(n.id);
                }
              }
            },
            child: const Text('Mark all as read'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    FontAwesomeIcons.bellSlash,
                    size: 48,
                    color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No notifications yet',
                    style: TextStyle(
                      color:
                          isDark ? Colors.grey.shade500 : Colors.grey.shade600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          : ListView.separated(
              itemCount: notifications.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: notification.isRead
                        ? (isDark ? Colors.grey.shade800 : Colors.grey.shade200)
                        : Colors.blue.withOpacity(0.1),
                    child: Icon(
                      _getIconForType(notification.notificationType),
                      color: notification.isRead
                          ? (isDark
                              ? Colors.grey.shade500
                              : Colors.grey.shade500)
                          : Colors.blue,
                      size: 18,
                    ),
                  ),
                  title: Text(
                    notification.title,
                    style: TextStyle(
                      fontWeight: notification.isRead
                          ? FontWeight.normal
                          : FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(notification.message),
                      const SizedBox(height: 4),
                      Text(
                        notification.timeAgo,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? Colors.grey.shade500
                              : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  tileColor: notification.isRead
                      ? null
                      : (isDark
                          ? Colors.blue.withOpacity(0.05)
                          : Colors.blue.withOpacity(0.02)),
                  onTap: () async {
                    await notificationService.markAsRead(notification.id);
                    if (!context.mounted) return;
                    final router = context.router;

                    // Common navigation logic
                    switch (notification.notificationType) {
                      case 'APPROVAL_REQUESTED':
                        router.push(const ApprovalsRoute());
                        break;

                      case 'APPROVAL_APPROVED':
                      case 'APPROVAL_REJECTED':
                      case 'TASK_CREATED':
                      case 'TASK_ASSIGNED':
                      case 'TASK_COMPLETED':
                      case 'TASK_UPDATED':
                      case 'SUBTASK_CREATED':
                      case 'SUBTASK_COMPLETED':
                        if (notification.referenceId != null) {
                          String? projectId;

                          // Try to find project context
                          try {
                            final projects = await ref
                                .read(projectsWithTasksProvider.future);

                            if (notification.referenceType == 'project') {
                              projectId =
                                  'api_project_${notification.referenceId}';
                            } else if (notification.referenceType == 'task' ||
                                notification.referenceType == 'subtask') {
                              final isSubtask =
                                  notification.referenceType == 'subtask';
                              final targetId = isSubtask
                                  ? notification.referenceId.toString()
                                  : 'api_project_task_${notification.referenceId}';

                              for (final p in projects) {
                                bool matchFound = false;
                                if (isSubtask) {
                                  for (final t in p.tasks) {
                                    if (t.task.id.contains(
                                        'task_${notification.referenceId}')) {
                                      matchFound = true;
                                      break;
                                    }
                                  }
                                } else {
                                  if (p.tasks
                                      .any((t) => t.task.id == targetId)) {
                                    matchFound = true;
                                  }
                                }

                                if (matchFound) {
                                  projectId = p.project.id;
                                  break;
                                }
                              }
                            }

                            // Fallback for approval responses
                            if (projectId == null &&
                                (notification.notificationType ==
                                        'APPROVAL_APPROVED' ||
                                    notification.notificationType ==
                                        'APPROVAL_REJECTED')) {
                              if (notification.referenceType == 'project') {
                                projectId =
                                    'api_project_${notification.referenceId}';
                              } else if (notification.referenceType == 'task') {
                                projectId =
                                    'api_project_task_${notification.referenceId}';
                              }
                            }
                          } catch (_) {}

                          if (projectId != null) {
                            ref.read(selectedProjectIdProvider.notifier).state =
                                projectId;
                            router.push(const ProjectPlanRoute());
                          } else {
                            router.push(const ProjectsRoute());
                          }
                        }
                        break;

                      case 'PROJECT_CREATED':
                      case 'PROJECT_UPDATED':
                        if (notification.referenceId != null) {
                          ref.read(selectedProjectIdProvider.notifier).state =
                              'api_project_${notification.referenceId}';
                          router.push(const ProjectPlanRoute());
                        } else {
                          router.push(const ProjectsRoute());
                        }
                        break;

                      case 'INSTRUCTION_RECEIVED':
                        router.push(const DashboardRoute());
                        break;

                      default:
                        // Stay on page or default action
                        break;
                    }
                  },
                );
              },
            ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'TASK_ASSIGNED':
        return FontAwesomeIcons.tasks;
      case 'TASK_COMPLETED':
        return FontAwesomeIcons.checkCircle;
      case 'APPROVAL_REQUESTED':
        return FontAwesomeIcons.clipboardCheck;
      case 'PROJECT_CREATED':
        return FontAwesomeIcons.folderPlus;
      case 'URGENT':
        return FontAwesomeIcons.triangleExclamation;
      default:
        return FontAwesomeIcons.bell;
    }
  }
}
