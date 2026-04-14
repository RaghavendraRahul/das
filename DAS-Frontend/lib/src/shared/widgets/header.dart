import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:project_pm/src/core/theme/theme_provider.dart';
import 'package:project_pm/src/features/notifications/services/notification_polling_service.dart';
import 'package:project_pm/src/features/projects/project_providers.dart';
import 'package:auto_route/auto_route.dart';
import 'package:project_pm/src/routes/app_router.dart';

class AppHeader extends ConsumerWidget {
  final String title;
  final String subtitle;
  final Widget? customTitleWidget;
  final VoidCallback? onMenuTap; // For mobile hamburger menu

  const AppHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.customTitleWidget,
    this.onMenuTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeNotifierProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 24,
        vertical: isMobile ? 8 : 12, // Reduced padding for premium, denser layout
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF05263E).withOpacity(isDark ? 0.95 : 1.0),
            const Color(0xFF05263E).withOpacity(isDark ? 0.8 : 0.9),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.4 : 0.1),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(isDark ? 0.1 : 0.15),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Hamburger menu for mobile
          if (onMenuTap != null) ...[
            IconButton(
              onPressed: onMenuTap,
              icon: const Icon(
                Icons.menu,
                color: Colors.white,
              ),
              tooltip: 'Menu',
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (customTitleWidget != null)
                  customTitleWidget!
                else
                  Text(
                    title,
                    style: GoogleFonts.outfit( // Switched to Outfit for premium look
                      fontWeight: FontWeight.w700,
                      fontSize: isMobile ? 18 : 22,
                      letterSpacing: -0.2,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: isMobile ? 11 : 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(0.7),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),

          // Actions - hide some on mobile
          if (!isMobile)
            Row(
              children: [
                // Critical Attention Button
                _CriticalAttentionButton(isDark: isDark),
                const SizedBox(width: 8),

                // Notification Bell
                _NotificationButton(isDark: isDark),
                const SizedBox(width: 16),

                // Theme Switcher - 3 buttons like React
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(isDark ? 0.08 : 0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.white.withOpacity(isDark ? 0.1 : 0.2),
                    ),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: Row(
                    children: [
                      _ThemeButton(
                        icon: FontAwesomeIcons.sun,
                        isActive: currentTheme == AppThemeMode.light,
                        onTap: () => ref
                            .read(themeNotifierProvider.notifier)
                            .setTheme(AppThemeMode.light),
                        tooltip: 'Light Mode',
                        isDark: isDark,
                      ),
                      _ThemeButton(
                        icon: FontAwesomeIcons.moon,
                        isActive: currentTheme == AppThemeMode.dark,
                        onTap: () => ref
                            .read(themeNotifierProvider.notifier)
                            .setTheme(AppThemeMode.dark),
                        tooltip: 'Dark Mode',
                        isDark: isDark,
                      ),
                      _ThemeButton(
                        icon: FontAwesomeIcons.laptop,
                        isActive: currentTheme == AppThemeMode.system,
                        onTap: () => ref
                            .read(themeNotifierProvider.notifier)
                            .setTheme(AppThemeMode.system),
                        tooltip: 'System Theme',
                        isDark: isDark,
                      ),
                    ],
                  ),
                )
              ],
            )
          else
            // Just notification bell on mobile
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _CriticalAttentionButton(isDark: isDark),
                const SizedBox(width: 8),
                _NotificationButton(isDark: isDark),
              ],
            ),
        ],
      ),
    );
  }
}

class _ThemeButton extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;
  final String tooltip;
  final bool isDark;

  const _ThemeButton({
    required this.icon,
    required this.isActive,
    required this.onTap,
    required this.tooltip,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isActive
                ? (isDark ? Colors.white.withOpacity(0.15) : Colors.white)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          child: Icon(
            icon,
            size: 14,
            color: isActive
                ? (isDark ? Colors.white : const Color(0xFF05263E))
                : Colors.white.withOpacity(0.5),
          ),
        ),
      ),
    );
  }
}

class _NotificationButton extends ConsumerStatefulWidget {
  final bool isDark;

  const _NotificationButton({required this.isDark});

  @override
  ConsumerState<_NotificationButton> createState() =>
      _NotificationButtonState();
}

class _NotificationButtonState extends ConsumerState<_NotificationButton> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    super.dispose();
  }

  void _toggleDropdown() {
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
    } else {
      _closeDropdown();
    }
  }

  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    // final notifications = ref.read(notificationPollingProvider); // Unused

    return OverlayEntry(
      builder: (context) => Positioned(
        width: 360,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(-(360.0 - size.width), size.height + 8), // Align right
          child: Material(
            elevation: 8,
            color: Colors.transparent,
            child: Container(
              constraints: const BoxConstraints(maxHeight: 400),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: widget.isDark
                      ? Colors.grey.shade700
                      : Colors.grey.shade200,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Notifications',
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            ref
                                .read(notificationPollingProvider.notifier)
                                .markAllAsRead(); // Add this method if missing or loop
                            // Optimistic update logic is in polling service
                            _closeDropdown(); // Close on action? Or keep open? Keep open to see update.
                            setState(
                                () {}); // Rebuild button but overlay needs rebuild too?
                            // Actually, OverlayEntry builder context might not rebuild if provider changes unless we wrap it in Consumer.
                            // Better: Wrap the overlay content in Consumer.
                          },
                          child: const Text('Mark all as read'),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),

                  // content
                  Flexible(
                    child: Consumer(
                      builder: (context, ref, _) {
                        final notifs = ref.watch(notificationPollingProvider);
                        if (notifs.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              children: [
                                Icon(FontAwesomeIcons.bellSlash,
                                    color: Colors.grey.shade400, size: 32),
                                const SizedBox(height: 16),
                                Text(
                                  'No new notifications',
                                  style: TextStyle(color: Colors.grey.shade500),
                                ),
                              ],
                            ),
                          );
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemCount: notifs.length > 5
                              ? 5
                              : notifs.length, // Show max 5
                          itemBuilder: (context, index) {
                            final n = notifs[index];
                            return _NotificationItem(
                              notification: n,
                              isDark: widget.isDark,
                              onTap: () async {
                                final notifier = ref
                                    .read(notificationPollingProvider.notifier);

                                // Mark as read and close dropdown
                                await notifier.markAsRead(n.id);
                                _closeDropdown();

                                if (!mounted) return;
                                final router = context.router;

                                // Common navigation logic
                                switch (n.notificationType) {
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
                                    if (n.referenceId != null) {
                                      // Find project ID for any task/subtask related notification
                                      String? projectId;

                                      // Try to find project context
                                      try {
                                        final projects = await ref.read(
                                            projectsWithTasksProvider.future);

                                        if (n.referenceType == 'project') {
                                          projectId =
                                              'api_project_${n.referenceId}';
                                        } else if (n.referenceType == 'task' ||
                                            n.referenceType == 'subtask') {
                                          final isSubtask =
                                              n.referenceType == 'subtask';
                                          final targetId = isSubtask
                                              ? n.referenceId.toString()
                                              : 'api_project_task_${n.referenceId}';

                                          for (final p in projects) {
                                            bool matchFound = false;
                                            if (isSubtask) {
                                              // Check subtasks within project tasks
                                              for (final t in p.tasks) {
                                                if (t.task.id.contains(
                                                    'task_${n.referenceId}')) {
                                                  matchFound = true;
                                                  break;
                                                }
                                              }
                                            } else {
                                              if (p.tasks.any((t) =>
                                                  t.task.id == targetId)) {
                                                matchFound = true;
                                              }
                                            }

                                            if (matchFound) {
                                              projectId = p.project.id;
                                              break;
                                            }
                                          }
                                        }

                                        // Fallback for approval responses if point directly to project/task
                                        if (projectId == null &&
                                            (n.notificationType ==
                                                    'APPROVAL_APPROVED' ||
                                                n.notificationType ==
                                                    'APPROVAL_REJECTED')) {
                                          // Our backend change now sends the actual reference_type/id
                                          // Handle cases where reference_type might be 'approval' still for old records
                                          if (n.referenceType == 'project') {
                                            projectId =
                                                'api_project_${n.referenceId}';
                                          } else if (n.referenceType ==
                                              'task') {
                                            projectId =
                                                'api_project_task_${n.referenceId}';
                                          }
                                        }
                                      } catch (_) {}

                                      if (projectId != null) {
                                        ref
                                            .read(selectedProjectIdProvider
                                                .notifier)
                                            .state = projectId;
                                        router.push(const ProjectPlanRoute());
                                      } else {
                                        // Fallback to general projects if specific one not found
                                        router.push(const ProjectsRoute());
                                      }
                                    }
                                    break;

                                  case 'PROJECT_CREATED':
                                  case 'PROJECT_UPDATED':
                                    if (n.referenceId != null) {
                                      ref
                                              .read(selectedProjectIdProvider
                                                  .notifier)
                                              .state =
                                          'api_project_${n.referenceId}';
                                      router.push(const ProjectPlanRoute());
                                    } else {
                                      router.push(const ProjectsRoute());
                                    }
                                    break;

                                  case 'INSTRUCTION_RECEIVED':
                                    router.push(const DashboardRoute());
                                    break;

                                  default:
                                    // Default to notification page if specific route not found
                                    router.push(const NotificationsRoute());
                                }
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),

                  const Divider(height: 1),
                  // Footer
                  InkWell(
                    onTap: () {
                      _closeDropdown();
                      context.router.push(const NotificationsRoute());
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      alignment: Alignment.center,
                      child: const Text(
                        'View all notifications',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final notifications = ref.watch(notificationPollingProvider);
    final unreadCount = notifications.where((n) => !n.isRead).length;

    return CompositedTransformTarget(
      link: _layerLink,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          IconButton(
            onPressed: _toggleDropdown,
            icon: const Icon(
              FontAwesomeIcons.bell,
              color: Colors.white,
            ),
            tooltip: 'Notifications',
          ),
          if (unreadCount > 0)
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: Colors.red.shade500,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF05263E),
                    width: 2,
                  ),
                ),
                // Could add number here if space permits
              ),
            ),
        ],
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final dynamic
      notification; // Typed as dynamic to avoid import issues here if possible, but better import model
  final bool isDark;
  final VoidCallback onTap;

  const _NotificationItem({
    required this.notification,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Determine icon based on type
    IconData iconData = FontAwesomeIcons.bell;
    Color iconColor = Colors.blue;

    if (notification.notificationType == 'TASK_ASSIGNED') {
      iconData = FontAwesomeIcons.tasks;
      iconColor = Colors.orange;
    } else if (notification.notificationType == 'APPROVAL_REQUESTED') {
      iconData = FontAwesomeIcons.clipboardCheck;
      iconColor = Colors.purple;
    } else if (notification.notificationType == 'TASK_COMPLETED') {
      iconData = FontAwesomeIcons.checkCircle;
      iconColor = Colors.green;
    }

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: !notification.isRead
              ? (isDark
                  ? Colors.blue.shade900.withOpacity(0.2)
                  : Colors.blue.shade50)
              : null,
          border: Border(
            bottom: BorderSide(
              color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!notification.isRead)
              Container(
                margin: const EdgeInsets.only(top: 6, right: 8),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.blue.shade500,
                  shape: BoxShape.circle,
                ),
              )
            else
              const SizedBox(width: 16), // Spacing for read items

            // Icon
            Container(
              margin: const EdgeInsets.only(right: 12),
              child: Icon(iconData, size: 16, color: iconColor),
            ),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: TextStyle(
                      fontWeight: !notification.isRead
                          ? FontWeight.bold
                          : FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    notification.message,
                    style: TextStyle(
                      fontSize: 12,
                      color:
                          isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.timeAgo,
                    style: TextStyle(
                      fontSize: 11,
                      color:
                          isDark ? Colors.grey.shade500 : Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CriticalAttentionButton extends ConsumerStatefulWidget {
  final bool isDark;

  const _CriticalAttentionButton({required this.isDark});

  @override
  ConsumerState<_CriticalAttentionButton> createState() =>
      _CriticalAttentionButtonState();
}

class _CriticalAttentionButtonState
    extends ConsumerState<_CriticalAttentionButton>
    with SingleTickerProviderStateMixin {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
    _opacityAnimation = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _overlayEntry?.remove();
    _overlayEntry = null;
    super.dispose();
  }

  void _toggleDropdown() {
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
    } else {
      _closeDropdown();
    }
  }

  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) setState(() {});
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: 360,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(-(360.0 - size.width), size.height + 8), // Align right
          child: Material(
            elevation: 8,
            color: Colors.transparent,
            child: Container(
              constraints: const BoxConstraints(maxHeight: 400),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: widget.isDark
                      ? Colors.red.withOpacity(0.5)
                      : Colors.red.shade200,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: widget.isDark
                          ? Colors.red.shade900.withOpacity(0.3)
                          : Colors.red.shade50,
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(11)),
                      border: Border(
                          bottom:
                              BorderSide(color: Colors.red.withOpacity(0.2))),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.warning_rounded,
                                color: Colors.red, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Attention Required',
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: widget.isDark
                                    ? Colors.red.shade200
                                    : Colors.red.shade800,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: Icon(Icons.close,
                              size: 20,
                              color: widget.isDark
                                  ? Colors.red.shade200
                                  : Colors.red.shade800),
                          onPressed: _closeDropdown,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ),

                  // Content
                  Flexible(
                    child: Consumer(
                      builder: (context, ref, _) {
                        final projectsAsync =
                            ref.watch(projectsWithTasksProvider);
                        final projects = projectsAsync.valueOrNull ?? [];

                        final List<Map<String, dynamic>> criticalItems = [];

                        // Extract specific actionable tasks instead of plain strings
                        for (var p in projects) {
                          for (var t in p.tasks) {
                            if (t.progress < 100) {
                              if (t.task.priority == "High" &&
                                  t.endDate.isBefore(DateTime.now())) {
                                criticalItems.add({
                                  'type': 'Overdue',
                                  'title': t.task.name,
                                  'subtitle': p.project.name,
                                  'projectId': p.project.id,
                                  'color': Colors.red.shade700,
                                  'icon': Icons.timer_off_outlined,
                                });
                              } else if (t.endDate
                                          .difference(DateTime.now())
                                          .inDays <
                                      3 &&
                                  t.endDate.isAfter(DateTime.now()) &&
                                  t.progress < 50) {
                                criticalItems.add({
                                  'type': 'At Risk',
                                  'title': t.task.name,
                                  'subtitle': p.project.name,
                                  'projectId': p.project.id,
                                  'color': Colors.orange.shade700,
                                  'icon': Icons.warning_amber_rounded,
                                });
                              }
                            }
                          }
                        }

                        if (criticalItems.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              children: [
                                Icon(Icons.check_circle_outline,
                                    color: Colors.green.shade400, size: 32),
                                const SizedBox(height: 16),
                                Text(
                                  'Everything is on track',
                                  style: TextStyle(color: Colors.grey.shade500),
                                ),
                              ],
                            ),
                          );
                        }

                        return Scrollbar(
                          child: ListView.separated(
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            itemCount: criticalItems.length,
                            separatorBuilder: (context, index) =>
                                const Divider(height: 1),
                            itemBuilder: (context, index) {
                              final item = criticalItems[index];
                              return InkWell(
                                onTap: () {
                                  _closeDropdown();
                                  ref
                                      .read(selectedProjectIdProvider.notifier)
                                      .state = item['projectId'];
                                  this
                                      .context
                                      .router
                                      .push(const ProjectPlanRoute());
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  color: !widget.isDark &&
                                          item['type'] == 'Overdue'
                                      ? Colors.red.shade50.withOpacity(0.5)
                                      : Colors.transparent,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: (item['color'] as Color)
                                              .withOpacity(0.1),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(item['icon'],
                                            size: 16, color: item['color']),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    item['title'],
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14,
                                                      color: widget.isDark
                                                          ? Colors.white
                                                          : Colors.black87,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 6,
                                                      vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        (item['color'] as Color)
                                                            .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ),
                                                  child: Text(
                                                    item['type'],
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: item['color'],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              "Project: ${item['subtitle']}",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: widget.isDark
                                                    ? Colors.grey.shade400
                                                    : Colors.grey.shade600,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 6),
                                            Row(
                                              children: [
                                                Text(
                                                  "Action needed to proceed",
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    fontStyle: FontStyle.italic,
                                                    color: widget.isDark
                                                        ? Colors.blue.shade300
                                                        : Colors.blue.shade700,
                                                  ),
                                                ),
                                                const Spacer(),
                                                Icon(Icons.arrow_forward_ios,
                                                    size: 10,
                                                    color:
                                                        Colors.blue.shade400),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final projectsAsync = ref.watch(projectsWithTasksProvider);
    final projects = projectsAsync.valueOrNull ?? [];

    int criticalCount = 0;

    // Explicitly count actionable tasks so the badge perfectly matches the dropdown logic
    for (var p in projects) {
      for (var t in p.tasks) {
        // Any task that reaches 100% progress (Completed) is IGNORED and will NOT trigger the siren.
        if (t.progress < 100) {
          if (t.task.priority == "High" && t.endDate.isBefore(DateTime.now())) {
            criticalCount++;
          } else if (t.endDate.difference(DateTime.now()).inDays < 3 &&
              t.endDate.isAfter(DateTime.now()) &&
              t.progress < 50) {
            criticalCount++;
          }
        }
      }
    }

    final hasRisks = criticalCount > 0;

    return CompositedTransformTarget(
      link: _layerLink,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          IconButton(
            onPressed: hasRisks
                ? _toggleDropdown
                : () {
                    // Optionally show a quick message if no risks exists
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('No critical attention required.'),
                        duration: Duration(seconds: 2)));
                  },
            icon: hasRisks
                ? AnimatedBuilder(
                    animation: _opacityAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: 1.0 + (_opacityAnimation.value * 0.25),
                        child: Icon(
                          Icons.warning_rounded,
                          size: 28,
                          color: Color.lerp(Colors.red.shade100,
                              Colors.redAccent, _opacityAnimation.value),
                        ),
                      );
                    },
                  )
                : Icon(
                    Icons.warning_amber_rounded,
                    size: 28,
                    color: Colors.white.withOpacity(0.6),
                  ),
            tooltip: 'Critical Attention',
          ),
          if (hasRisks)
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: Colors.red.shade500,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF05263E),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    criticalCount.toString(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
