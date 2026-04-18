import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../features/dashboard/critical_attention_provider.dart';
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
        vertical: isMobile ? 8 : 12,
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
                    style: GoogleFonts.outfit(
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
                      color: Colors.white.withOpacity(0.9),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          if (!isMobile)
            Row(
              children: [
                _CriticalAttentionButton(isDark: isDark),
                const SizedBox(width: 8),
                _NotificationButton(isDark: isDark),
                const SizedBox(width: 16),
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
    if (mounted) setState(() {});
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: ModalBarrier(
              dismissible: true,
              onDismiss: _closeDropdown,
              color: Colors.transparent,
            ),
          ),
          Positioned(
            width: 360,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(-(360.0 - size.width), size.height + 8),
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(12),
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
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    ref
                                        .read(notificationPollingProvider.notifier)
                                        .markAllAsRead();
                                    _closeDropdown();
                                  },
                                  child: const Text('Mark all as read'),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: const Icon(Icons.close, size: 20),
                                  onPressed: _closeDropdown,
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1),
                      Flexible(
                        child: Consumer(
                          builder: (context, ref, _) {
                            final notifs = ref.watch(notificationPollingProvider);
                            if (notifs.isEmpty) {
                              return Padding(
                                padding: const EdgeInsets.all(32),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
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
                            return ListView.separated(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              itemCount: notifs.length > 5 ? 5 : notifs.length,
                              separatorBuilder: (context, index) => const Divider(height: 1),
                              itemBuilder: (context, index) {
                                final n = notifs[index];
                                return _NotificationItem(
                                  notification: n,
                                  isDark: widget.isDark,
                                  onTap: () async {
                                    await ref
                                        .read(notificationPollingProvider.notifier)
                                        .markAsRead(n.id);
                                    _closeDropdown();
                                    if (!mounted) return;
                                    final router = context.router;
                                    switch (n.notificationType) {
                                      case 'APPROVAL_REQUESTED':
                                        router.push(const ApprovalsRoute());
                                        break;
                                      case 'PROJECT_CREATED':
                                      case 'PROJECT_UPDATED':
                                        if (n.referenceId != null) {
                                          ref.read(selectedProjectIdProvider.notifier).state = 'api_project_${n.referenceId}';
                                          router.push(const ProjectPlanRoute());
                                        } else {
                                          router.push(const ProjectsRoute());
                                        }
                                        break;
                                      default:
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
        ],
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
                child: Center(
                  child: Text(
                    unreadCount > 9 ? '9+' : unreadCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final dynamic notification;
  final bool isDark;
  final VoidCallback onTap;

  const _NotificationItem({
    required this.notification,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
              const SizedBox(width: 16),
            Icon(iconData, size: 16, color: iconColor),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: TextStyle(
                      fontWeight: !notification.isRead ? FontWeight.bold : FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    notification.message,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.timeAgo,
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? Colors.grey.shade500 : Colors.grey.shade400,
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
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: ModalBarrier(
              dismissible: true,
              onDismiss: _closeDropdown,
              color: Colors.transparent,
            ),
          ),
          Positioned(
            width: 320,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(-(320.0 - size.width), size.height + 8),
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(12),
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
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: widget.isDark ? Colors.red.shade900 : Colors.red.shade50,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.warning_rounded, color: Colors.red, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Critical Attention',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: widget.isDark ? Colors.white : Colors.red.shade900,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.close, size: 18),
                              onPressed: _closeDropdown,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                      ),
                      Consumer(
                        builder: (context, ref, _) {
                          final criticalItemsAsync = ref.watch(criticalItemsProvider);
                          return criticalItemsAsync.when(
                            data: (items) {
                              if (items.isEmpty) {
                                return const Padding(
                                  padding: EdgeInsets.all(24),
                                  child: Text('No critical tasks found', style: TextStyle(color: Colors.grey)),
                                );
                              }
                              return Flexible(
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  itemCount: items.length,
                                  separatorBuilder: (context, index) => const Divider(height: 1),
                                  itemBuilder: (context, index) {
                                    final item = items[index];
                                    return ListTile(
                                      leading: Icon(item.icon, color: item.color, size: 20),
                                      title: Text(item.title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                                      subtitle: Text(item.subtitle, style: const TextStyle(fontSize: 11)),
                                      onTap: () {
                                        _closeDropdown();
                                        ref.read(selectedProjectIdProvider.notifier).state = item.projectId;
                                        context.router.push(const ProjectPlanRoute());
                                      },
                                    );
                                  },
                                ),
                              );
                            },
                            loading: () => const SizedBox(height: 100, child: Center(child: CircularProgressIndicator())),
                            error: (err, stack) => Center(child: Text('Error: $err')),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final criticalItemsAsync = ref.watch(criticalItemsProvider);
    final criticalItems = criticalItemsAsync.valueOrNull ?? [];
    final criticalCount = criticalItems.length;

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
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('No critical attention required.'),
                        duration: Duration(seconds: 2)));
                  },
            icon: hasRisks
                ? AnimatedBuilder(
                    animation: _opacityAnimation,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: (_opacityAnimation.value - 0.5) * 0.4,
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
