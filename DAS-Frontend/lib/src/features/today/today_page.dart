import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:project_pm/src/core/providers/user_providers.dart';
import 'package:project_pm/src/features/today/today_providers.dart';
import 'package:project_pm/src/features/today/widgets/day_log.dart';
import 'package:project_pm/src/features/today/widgets/day_planner.dart';
import 'package:project_pm/src/features/today/widgets/activity_catalog.dart';
import 'package:project_pm/src/features/today/widgets/calendar_popup.dart';
import 'package:project_pm/src/features/today/widgets/month_view.dart';
import 'package:project_pm/src/features/today/widgets/week_view.dart';
import 'package:project_pm/src/features/today/modals/send_instructions_modal.dart';
import 'package:project_pm/src/features/today/widgets/instruction_inbox_view.dart';
import 'package:project_pm/src/features/today/services/instruction_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

@RoutePage()
class TodayPage extends ConsumerStatefulWidget {
  const TodayPage({super.key});

  @override
  ConsumerState<TodayPage> createState() => _TodayPageState();
}

enum CalendarViewMode { today, week, month, instructions }

class _TodayPageState extends ConsumerState<TodayPage> {
  bool _isCatalogOpen = false;
  CalendarViewMode? _currentView = CalendarViewMode.today;
  int _lastSeenId = 0;
  bool _isShowingOutbox = false;

  @override
  void initState() {
    super.initState();
    _currentView = CalendarViewMode.today;
    _loadLastSeenId();
    // Skip database on web
    if (kIsWeb) return;
  }

  Future<void> _loadLastSeenId() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _lastSeenId = prefs.getInt('last_seen_instruction_id') ?? 0;
      });
    }
  }

  Future<void> _saveLastSeenId(int maxId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('last_seen_instruction_id', maxId);
    if (mounted) {
      setState(() {
        _lastSeenId = maxId;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentView = _currentView ?? CalendarViewMode.today;
    final selectedDate = ref.watch(selectedDateProvider);

    final instructionsAsync = ref.watch(receivedInstructionsProvider);

    final int maxInstructionId = instructionsAsync.maybeWhen(
      data: (list) => list.isEmpty
          ? 0
          : list.map((e) => e.id).reduce((a, b) => a > b ? a : b),
      orElse: () => 0,
    );

    final int badgeCount = instructionsAsync.maybeWhen(
      data: (list) => list.where((e) => e.id > _lastSeenId).length,
      orElse: () => 0,
    );

    // Auto-clear logic: if we are already viewing instructions, and there's a new one, mark it as seen
    if (currentView == CalendarViewMode.instructions && badgeCount > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _saveLastSeenId(maxInstructionId);
      });
    }

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF111827) : const Color(0xFFF9FAFB),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Header Section
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Planner",
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 16),
                Consumer(
                  builder: (context, ref, _) {
                  final user = ref.watch(currentUserProvider).valueOrNull;
                  final isAdmin = user?.role == 'ADMIN';

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // 1. Navigation Views (Today, Week, Month)
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1F2937) : const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _PillButton(
                              label: 'Today',
                              icon: Icons.calendar_today_rounded,
                              isSelected: currentView == CalendarViewMode.today,
                              onTap: () {
                                ref.read(selectedDateProvider.notifier).setDate(DateTime.now());
                                setState(() => _currentView = CalendarViewMode.today);
                              },
                            ),
                            _PillButton(
                              label: 'Week',
                              icon: Icons.calendar_view_week_rounded,
                              isSelected: currentView == CalendarViewMode.week,
                              onTap: () => setState(() => _currentView = CalendarViewMode.week),
                            ),
                            _PillButton(
                              label: 'Month',
                              icon: Icons.calendar_month_rounded,
                              isSelected: currentView == CalendarViewMode.month,
                              onTap: () => setState(() => _currentView = CalendarViewMode.month),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),

                      // 2. Catalog
                      _PillButton(
                        label: 'Catalog',
                        icon: Icons.menu_open_rounded,
                        isSelected: _isCatalogOpen,
                        onTap: () => setState(() => _isCatalogOpen = !_isCatalogOpen),
                        showShadow: false,
                        backgroundColor: isDark ? const Color(0xFF374151) : const Color(0xFFF3F4F6),
                      ),
                      const SizedBox(width: 12),

                      // 3. Send Instructions - ADMIN ONLY
                      if (isAdmin) ...[
                        _PillButton(
                          label: 'Send Instructions',
                          icon: Icons.group_rounded,
                          isSelected: false,
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => const SendInstructionsModal(),
                            );
                          },
                          showShadow: false,
                          backgroundColor: isDark ? const Color(0xFF374151) : const Color(0xFFF3F4F6),
                        ),
                        const SizedBox(width: 12),
                      ],

                      // 4. Instructions Inbox - ALL USERS (with badge)
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          _PillButton(
                            label: 'Instructions',
                            icon: Icons.inbox_rounded,
                            isSelected: currentView == CalendarViewMode.instructions,
                            onTap: () {
                              setState(() {
                                _currentView = _currentView == CalendarViewMode.instructions
                                    ? CalendarViewMode.today
                                    : CalendarViewMode.instructions;
                                _isShowingOutbox = false;
                              });
                            },
                            showShadow: false,
                            backgroundColor: isDark ? const Color(0xFF374151) : const Color(0xFFF3F4F6),
                          ),
                          if (badgeCount > 0)
                            Positioned(
                              top: -6,
                              right: -6,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                                child: Text(
                                  '$badgeCount',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(width: 12),

                      // 5. Calendar Popup Icon
                      _IconButton(
                        icon: Icons.calendar_month_rounded,
                        onTap: () {
                          showDialog(
                            context: context,
                            barrierColor: Colors.black26,
                            builder: (ctx) => Dialog(
                              backgroundColor: isDark ? const Color(0xFF1F2937) : Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: SizedBox(
                                width: 380,
                                height: 520,
                                child: CalendarPopup(
                                  onDateSelected: () {
                                    setState(() => _currentView = CalendarViewMode.today);
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                  },
                ),
              ],
            ),
          ),

          // Main Content Area (3 Columns)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Activity Catalog
                  if (_isCatalogOpen)
                    const SizedBox(
                      width: 280,
                      child: ActivityCatalog(),
                    ),
                  if (_isCatalogOpen) const SizedBox(width: 20),

                  // 2. Today's Plan (Center Column)
                  Expanded(
                    flex: 1,
                    child: _buildCurrentView(currentView),
                  ),

                  // 3. Activity Log (Right Column)
                  if (currentView == CalendarViewMode.today) ...[
                    const SizedBox(width: 20),
                    const Expanded(
                      flex: 1,
                      child: DayLog(),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );

  }

  Widget _buildCurrentView(CalendarViewMode currentView) {
    switch (currentView) {
      case CalendarViewMode.month:
        return const MonthView();
      case CalendarViewMode.week:
        return WeekView(
          onToggleCatalog: () =>
              setState(() => _isCatalogOpen = !_isCatalogOpen),
        );
      case CalendarViewMode.today:
        return const DayPlanner();
      case CalendarViewMode.instructions:
        final user = ref.watch(currentUserProvider).valueOrNull;
        final isAdmin = user?.role == 'ADMIN';

        return Column(
          children: [
            if (isAdmin)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Row(
                  children: [
                    _SubToggleButton(
                      label: 'INBOX',
                      isActive: !_isShowingOutbox,
                      onPressed: () => setState(() => _isShowingOutbox = false),
                      icon: Icons.inbox,
                    ),
                    const SizedBox(width: 12),
                    _SubToggleButton(
                      label: 'OUTBOX',
                      isActive: _isShowingOutbox,
                      onPressed: () => setState(() => _isShowingOutbox = true),
                      icon: Icons.outbox,
                    ),
                  ],
                ),
              ),
            Expanded(
              child: InstructionInboxView(
                isOutbox: isAdmin && _isShowingOutbox,
              ),
            ),
          ],
        );
    }
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}

class _PillButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final bool showShadow;
  final Color? backgroundColor;

  const _PillButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    this.showShadow = false,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? const Color(0xFF374151) : Colors.white)
              : (backgroundColor ?? Colors.transparent),
          borderRadius: BorderRadius.circular(10),
          boxShadow: showShadow && !isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected
                  ? (isDark ? Colors.blue.shade400 : Colors.blue.shade600)
                  : (isDark ? Colors.grey.shade400 : Colors.grey.shade600),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? (isDark ? Colors.white : const Color(0xFF1F2937))
                    : (isDark ? Colors.grey.shade400 : Colors.grey.shade600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _IconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1F2937) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Icon(
          icon,
          size: 20,
          color: isDark ? Colors.blue.shade400 : Colors.blue.shade600,
        ),
      ),
    );
  }
}

class _SubToggleButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onPressed;
  final IconData icon;

  const _SubToggleButton({
    required this.label,
    required this.isActive,
    required this.onPressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? (isDark ? Colors.blue.withOpacity(0.2) : Colors.blue.shade50)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isActive
                ? Colors.blue.withOpacity(0.5)
                : (isDark ? Colors.grey.shade800 : Colors.grey.shade200),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isActive
                  ? Colors.blue
                  : (isDark ? Colors.grey.shade500 : Colors.grey.shade600),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                color: isActive
                    ? Colors.blue
                    : (isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
