import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../features/dashboard/critical_attention_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:project_pm/src/core/theme/theme_provider.dart';
import 'package:project_pm/src/features/notifications/services/notification_polling_service.dart';
import 'package:project_pm/src/features/projects/project_providers.dart';
import 'package:auto_route/auto_route.dart';
import 'package:project_pm/src/routes/app_router.dart';
import 'package:project_pm/src/features/dashboard/dashboard_providers.dart';
import 'package:project_pm/src/features/dashboard/global_search_providers.dart';
import 'package:project_pm/src/features/dashboard/models/search_result.dart';
import 'package:project_pm/src/shared/widgets/global_search_overlay.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:project_pm/src/core/providers/user_providers.dart';

class AppHeader extends HookConsumerWidget {
  final String title;
  final String subtitle;
  final Widget? customTitleWidget;
  final VoidCallback? onMenuTap; // For mobile hamburger menu
  final Widget? actions;

  const AppHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.customTitleWidget,
    this.onMenuTap,
    this.actions,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeNotifierProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textController =
        useTextEditingController(text: ref.read(globalSearchQueryProvider));
    useListenable(textController);
    
    final layerLink = useMemoized(() => LayerLink());
    final overlayState = useState<OverlayEntry?>(null);
    final focusNode = useFocusNode();
    final debounceTimer = useRef<Timer?>(null);

    final userAsync = ref.watch(currentUserProvider);
    final currentUser = userAsync.valueOrNull;

    // Navigation and Logic Helpers
    void handleNavigation(dynamic item) {
      if (item is GlobalSearchResult) {
         ref.read(searchHistoryServiceProvider).addToHistory(item.title);
         final router = AutoRouter.of(context);
         
         // Clear search state before navigating
         textController.clear();
         ref.read(globalSearchQueryProvider.notifier).state = '';
         ref.read(globalSearchVisibleProvider.notifier).state = false;
         ref.read(globalSearchIndexProvider.notifier).state = 0;
         
         switch (item.type) {
            case SearchResultType.project:
              ref.read(selectedProjectIdProvider.notifier).state = 'api_project_${item.id}';
              router.push(const ProjectPlanRoute());
              break;
            case SearchResultType.task:
            case SearchResultType.subtask:
              ref.read(selectedProjectIdProvider.notifier).state = 'api_project_${item.id}';
              router.push(const ProjectPlanRoute());
              break;
            case SearchResultType.catalog:
              router.navigate(const TodayRoute());
              break;
            case SearchResultType.employee:
              // For employees, we might want to navigate to Team Overview or Admin Employee View if we have the user object
              // For now, take them to the team overview
              router.push(const TeamOverviewRoute());
              break;
         }
      } else if (item is String) {
         textController.text = item;
         ref.read(globalSearchQueryProvider.notifier).state = item;
      }
    }

    void closeOverlay() {
      if (overlayState.value == null) return;
      overlayState.value?.remove();
      overlayState.value = null;
      ref.read(isSearchFocusedProvider.notifier).state = false;
      ref.read(globalSearchVisibleProvider.notifier).state = false;
    }

    void showOverlay() {
      if (overlayState.value != null) return;
      
      final entry = OverlayEntry(
        builder: (context) => Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: closeOverlay,
                behavior: HitTestBehavior.opaque,
                child: Container(color: Colors.transparent),
              ),
            ),
            GlobalSearchOverlay(
              layerLink: layerLink,
              controller: textController,
              onClose: closeOverlay,
            ),
          ],
        ),
      );

      overlayState.value = entry;
      Overlay.of(context).insert(entry);
      ref.read(isSearchFocusedProvider.notifier).state = true;
      ref.read(globalSearchVisibleProvider.notifier).state = true;
    }

    // Update shared items list whenever results or history changes
    final query = ref.watch(globalSearchQueryProvider);
    final resultsAsync = ref.watch(globalSearchResultsProvider);
    final historyAsync = ref.watch(searchHistoryListProvider);

    useEffect(() {
      final items = query.isEmpty 
          ? (historyAsync.value ?? [])
          : (resultsAsync.value ?? []);
      
      Future.microtask(() {
        if (ref.context.mounted) {
           ref.read(globalSearchItemsProvider.notifier).state = items;
           ref.read(globalSearchIndexProvider.notifier).state = 0;
        }
      });
      return null;
    }, [query, resultsAsync.value, historyAsync.value]);

    // Handle visibility changes from external sources
    ref.listen(globalSearchVisibleProvider, (prev, next) {
      if (next == false && overlayState.value != null) {
        closeOverlay();
      }
    });

    // Clean Keyboard Listener Logic using FocusNode.onKeyEvent
    // This avoids "Tried to make a child into a parent of itself" assertion errors
    useEffect(() {
      focusNode.onKeyEvent = (node, event) {
        if (event is! KeyDownEvent) return KeyEventResult.ignored;
        
        final items = ref.read(globalSearchItemsProvider);
        final index = ref.read(globalSearchIndexProvider);

        if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
          if (overlayState.value == null) showOverlay();
          ref.read(globalSearchIndexProvider.notifier).state = (index + 1) % (items.isEmpty ? 1 : items.length);
          return KeyEventResult.handled;
        } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
          if (overlayState.value == null) showOverlay();
          ref.read(globalSearchIndexProvider.notifier).state = (index - 1 + items.length) % (items.isEmpty ? 1 : items.length);
          return KeyEventResult.handled;
        } else if (event.logicalKey == LogicalKeyboardKey.enter) {
          if (items.isNotEmpty && index < items.length) {
            handleNavigation(items[index]);
          }
          return KeyEventResult.handled;
        } else if (event.logicalKey == LogicalKeyboardKey.escape) {
          closeOverlay();
          focusNode.unfocus();
          return KeyEventResult.handled;
        }
        
        return KeyEventResult.ignored;
      };
      return null;
    }, [focusNode, overlayState.value, resultsAsync.value, historyAsync.value]);

    final shortcuts = <ShortcutActivator, VoidCallback>{
      LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyK): () {
        focusNode.requestFocus();
        showOverlay();
      },
      LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.keyK): () {
        focusNode.requestFocus();
        showOverlay();
      },
    };
    
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.transparent : Colors.white,
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 12 : 16,
              vertical: isMobile ? 2 : 2,
            ),
            child: SafeArea(
              bottom: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 4,
                    child: CallbackShortcuts(
                      bindings: shortcuts,
                      child: Row(
                        children: [
                          if (onMenuTap != null) ...[
                            IconButton(
                              onPressed: onMenuTap,
                              icon: Icon(Icons.menu,
                                  color: isDark ? Colors.white : const Color(0xFF05263E), size: 20),
                            ),
                            const SizedBox(width: 4),
                          ],
                          if (!isMobile)
                            CompositedTransformTarget(
                              link: layerLink,
                              child: Container(
                                height: 38,
                                width: 400,
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: (ref.watch(isSearchFocusedProvider))
                                        ? Colors.blue.withAlpha(150)
                                        : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                                    width: (ref.watch(isSearchFocusedProvider)) ? 1.5 : 1.0,
                                  ),
                                  boxShadow: (ref.watch(isSearchFocusedProvider))
                                      ? [BoxShadow(color: Colors.blue.withAlpha(20), blurRadius: 8, spreadRadius: 2)]
                                      : null,
                                ),
                                child: TextField(
                                  controller: textController,
                                  focusNode: focusNode,
                                  onTap: showOverlay,
                                  onChanged: (value) {
                                    if (overlayState.value == null) showOverlay();
                                    ref.read(globalSearchIndexProvider.notifier).state = 0;
                                    // Debounce: wait 350ms after user stops typing
                                    debounceTimer.value?.cancel();
                                    debounceTimer.value = Timer(const Duration(milliseconds: 350), () {
                                      ref.read(globalSearchQueryProvider.notifier).state = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Search anything... (Ctrl + K)',
                                    hintStyle: TextStyle(
                                      color: isDark ? const Color(0xFFE2E8F0).withAlpha(150) : const Color(0xFF64748B),
                                      fontSize: 13,
                                    ),
                                    prefixIcon: Icon(Icons.search,
                                        color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF64748B), 
                                        size: 16),
                                    suffixIcon: textController.text.isNotEmpty
                                        ? MouseRegion(
                                            cursor: SystemMouseCursors.click,
                                            child: GestureDetector(
                                              onTap: () {
                                                textController.clear();
                                                ref.read(globalSearchQueryProvider.notifier).state = '';
                                              },
                                              child: Icon(Icons.close_rounded,
                                                  color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8), 
                                                  size: 16),
                                            ),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.only(right: 12.0),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text("⌘ K", style: TextStyle(fontSize: 10, color: isDark ? Colors.white38 : Colors.black26, fontWeight: FontWeight.bold)),
                                              ],
                                            ),
                                          ),
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    contentPadding:
                                        const EdgeInsets.symmetric(vertical: 10),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  if (!isMobile) const Spacer(flex: 1),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _CriticalAttentionButton(isDark: isDark),
                      _NotificationButton(isDark: isDark),
                      const SizedBox(width: 12),
                      /* // Theme toggle button removed as per user request
                      Container(
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                        ),
                        padding: const EdgeInsets.all(4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
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
                              icon: FontAwesomeIcons.desktop,
                              isActive: currentTheme == AppThemeMode.system,
                              onTap: () => ref
                                  .read(themeNotifierProvider.notifier)
                                  .setTheme(AppThemeMode.system),
                              tooltip: 'System Theme',
                              isDark: isDark,
                            ),
                          ],
                        ),
                      ),
                      */
                      if (currentUser != null && !isMobile) ...[
                        const SizedBox(width: 16),
                        Text(
                          currentUser.name,
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : const Color(0xFF05263E),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (customTitleWidget != null ||
              title.isNotEmpty ||
              subtitle.isNotEmpty ||
              actions != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (customTitleWidget != null)
                    customTitleWidget!
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w700,
                            fontSize: isMobile ? 24 : 32,
                            letterSpacing: -0.5,
                            color: isDark ? Colors.white : const Color(0xFF05263E),
                          ),
                        ),
                        if (subtitle.isNotEmpty) ...[
                          const SizedBox(height: 0),
                          Text(
                            subtitle,
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              color: isDark ? Colors.white70 : const Color(0xFF05263E).withAlpha(160),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  if (actions != null) actions!,
                ],
              ),
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
                ? (isDark ? Colors.white.withValues(alpha: 0.12) : Colors.white)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isActive && !isDark
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Icon(
            icon,
            size: 14,
            color: isActive
                ? (isDark ? Colors.white : Colors.blue.shade600)
                : (isDark ? Colors.white.withValues(alpha: 0.4) : const Color(0xFF94A3B8)),
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
  ConsumerState<_NotificationButton> createState() => _NotificationButtonState();
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
            child: ModalBarrier(dismissible: true, onDismiss: _closeDropdown, color: Colors.transparent),
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
                    border: Border.all(color: widget.isDark ? Colors.grey.shade700 : Colors.grey.shade200),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 5))],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Notifications', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    ref.read(notificationPollingProvider.notifier).markAllAsRead();
                                    _closeDropdown();
                                  },
                                  child: const Text('Mark all as read'),
                                ),
                                const SizedBox(width: 8),
                                IconButton(icon: const Icon(Icons.close, size: 20), onPressed: _closeDropdown, padding: EdgeInsets.zero, constraints: const BoxConstraints()),
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
                                    Icon(FontAwesomeIcons.bellSlash, color: Colors.grey.shade400, size: 32),
                                    const SizedBox(height: 16),
                                    Text('No new notifications', style: TextStyle(color: Colors.grey.shade500)),
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
                                    final router = context.router;
                                    await ref.read(notificationPollingProvider.notifier).markAsRead(n.id);
                                    _closeDropdown();
                                    switch (n.notificationType) {
                                      case 'APPROVAL_REQUESTED': router.push(const ApprovalsRoute()); break;
                                      case 'PROJECT_CREATED':
                                      case 'PROJECT_UPDATED':
                                        if (n.referenceId != null) {
                                          ref.read(selectedProjectIdProvider.notifier).state = n.referenceId.toString();
                                          router.push(const ProjectPlanRoute());
                                        } else { router.push(const ProjectsRoute()); }
                                        break;
                                      default: router.push(const NotificationsRoute());
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
                        onTap: () { _closeDropdown(); context.router.push(const NotificationsRoute()); },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          alignment: Alignment.center,
                          child: const Text('View all notifications', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
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
          IconButton(onPressed: _toggleDropdown, icon: Icon(FontAwesomeIcons.bell, color: widget.isDark ? Colors.white : const Color(0xFF0B1B2F), size: 18), tooltip: 'Notifications'),
          if (unreadCount > 0)
            Positioned(
              right: 8, top: 8,
              child: Container(
                width: 14, height: 14,
                decoration: BoxDecoration(color: Colors.red.shade500, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                child: Center(child: Text(unreadCount > 9 ? '9+' : unreadCount.toString(), style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold))),
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
  const _NotificationItem({required this.notification, required this.isDark, required this.onTap});
  @override
  Widget build(BuildContext context) {
    IconData iconData = FontAwesomeIcons.bell;
    Color iconColor = Colors.blue;
    if (notification.notificationType == 'TASK_ASSIGNED') { iconData = FontAwesomeIcons.listCheck; iconColor = Colors.orange; }
    else if (notification.notificationType == 'APPROVAL_REQUESTED') { iconData = FontAwesomeIcons.clipboardCheck; iconColor = Colors.purple; }
    else if (notification.notificationType == 'TASK_COMPLETED') { iconData = FontAwesomeIcons.circleCheck; iconColor = Colors.green; }
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: !notification.isRead ? (isDark ? Colors.blue.shade900.withValues(alpha: 0.2) : Colors.blue.shade50.withValues(alpha: 0.8)) : Colors.transparent,
          border: Border(bottom: BorderSide(color: isDark ? Colors.grey.shade800 : Colors.grey.shade100)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!notification.isRead) Container(margin: const EdgeInsets.only(top: 6, right: 8), width: 8, height: 8, decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle)) else const SizedBox(width: 16),
            Icon(iconData, size: 16, color: iconColor),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(notification.title, style: TextStyle(fontWeight: !notification.isRead ? FontWeight.bold : FontWeight.w500, fontSize: 13)),
                  const SizedBox(height: 2),
                  Text(notification.message, style: TextStyle(fontSize: 12, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(notification.timeAgo, style: TextStyle(fontSize: 11, color: isDark ? Colors.grey.shade500 : Colors.grey.shade400)),
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
  ConsumerState<_CriticalAttentionButton> createState() => _CriticalAttentionButtonState();
}

class _CriticalAttentionButtonState extends ConsumerState<_CriticalAttentionButton> with SingleTickerProviderStateMixin {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600))..repeat(reverse: true);
    _opacityAnimation = Tween<double>(begin: 0.2, end: 1.0).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
  }
  @override
  void dispose() { _animationController.dispose(); _overlayEntry?.remove(); _overlayEntry = null; super.dispose(); }
  void _toggleDropdown() {
    if (_overlayEntry == null) { _overlayEntry = _createOverlayEntry(); Overlay.of(context).insert(_overlayEntry!); }
    else { _closeDropdown(); }
  }
  void _closeDropdown() { _overlayEntry?.remove(); _overlayEntry = null; if (mounted) setState(() {}); }
  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(child: ModalBarrier(dismissible: true, onDismiss: _closeDropdown, color: Colors.transparent)),
          Positioned(
            width: 360,
            child: CompositedTransformFollower(
              link: _layerLink, showWhenUnlinked: false, offset: Offset(-(360.0 - size.width), size.height + 8),
              child: Material(
                elevation: 8, borderRadius: BorderRadius.circular(12),
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 400),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: widget.isDark ? Colors.grey.shade700 : Colors.grey.shade200),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 5))],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              const Icon(Icons.warning_rounded, color: Colors.white, size: 18),
                              const SizedBox(width: 8),
                              Text('Critical Attention', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                            ]),
                            IconButton(icon: const Icon(Icons.close, size: 20, color: Colors.white), onPressed: _closeDropdown, padding: EdgeInsets.zero, constraints: const BoxConstraints()),
                          ],
                        ),
                      ),
                      const Divider(height: 1),
                      Flexible(
                        child: Consumer(
                          builder: (context, ref, _) {
                            final criticalItemsAsync = ref.watch(criticalItemsProvider);
                            final criticalItems = criticalItemsAsync.value ?? [];
                            if (criticalItems.isEmpty) return const SizedBox(height: 120, child: Center(child: Text('No critical attention items present', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500))));
                            return ListView.separated(
                              shrinkWrap: true, padding: EdgeInsets.zero, itemCount: criticalItems.length,
                              separatorBuilder: (context, index) => const Divider(height: 1),
                              itemBuilder: (context, index) {
                                final item = criticalItems[index];
                                return ListTile(
                                  leading: const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 20),
                                  title: Text(item.title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                                  subtitle: Text(item.subtitle, style: TextStyle(fontSize: 12, color: widget.isDark ? Colors.grey.shade400 : Colors.grey.shade600)),
                                  dense: true,
                                  onTap: () { _closeDropdown(); if (item.projectId.isNotEmpty) { ref.read(selectedProjectIdProvider.notifier).state = item.projectId; context.router.push(const ProjectPlanRoute()); } },
                                );
                              },
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
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    final criticalItems = ref.watch(criticalItemsProvider).value ?? [];
    final hasItems = criticalItems.isNotEmpty;

    return CompositedTransformTarget(
      link: _layerLink,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (hasItems)
            FadeTransition(
              opacity: _opacityAnimation,
              child: IconButton(
                onPressed: _toggleDropdown,
                icon: const FaIcon(FontAwesomeIcons.triangleExclamation, color: Colors.red, size: 20),
                tooltip: 'Critical Attention',
              ),
            )
          else
            IconButton(
              onPressed: _toggleDropdown,
              icon: FaIcon(
                FontAwesomeIcons.triangleExclamation,
                color: widget.isDark ? Colors.white24 : Colors.black12,
                size: 20,
              ),
              tooltip: 'Critical Attention',
            ),
          Positioned(
            right: 6, top: 6,
            child: Container(
              width: 16, height: 16,
              decoration: BoxDecoration(color: Colors.red.shade700, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 1.5)),
              child: Center(child: Text(criticalItems.length > 9 ? '9+' : criticalItems.length.toString(), style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold))),
            ),
          ),
        ],
      ),
    );
  }
}
