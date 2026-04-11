import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:project_pm/src/core/database/database.dart';
import 'package:project_pm/src/features/today/widgets/task_config_modal.dart';
import 'package:project_pm/src/features/projects/providers/api_providers.dart';

class WeekView extends HookConsumerWidget {
  final VoidCallback onToggleCatalog;

  const WeekView({
    super.key,
    required this.onToggleCatalog,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Current date logic
    final currentWeekStart = useState(_startOfWeek(DateTime.now()));

    // Optimistic state for dragged items
    final optimisticTasks = useState<List<Map<String, dynamic>>>([]);

    // Helpers to navigate
    void prevWeek() {
      currentWeekStart.value =
          currentWeekStart.value.subtract(const Duration(days: 7));
    }

    void nextWeek() {
      currentWeekStart.value =
          currentWeekStart.value.add(const Duration(days: 7));
    }

    void goToToday() {
      currentWeekStart.value = _startOfWeek(DateTime.now());
    }

    // Data - fetch from Django backend API
    final startDateStr =
        '${currentWeekStart.value.year}-${currentWeekStart.value.month.toString().padLeft(2, '0')}-${currentWeekStart.value.day.toString().padLeft(2, '0')}';
    final weekDataAsync = ref.watch(apiWeekPlansProvider(startDateStr));

    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Formatting
    final weekEnd = currentWeekStart.value.add(const Duration(days: 5)); // Sat
    final dateRangeText =
        "${DateFormat('MMM d').format(currentWeekStart.value)} - ${DateFormat('MMM d, yyyy').format(weekEnd)}";

    return Column(
      children: [
        // Header — Figma theme
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            border: Border(
              bottom: BorderSide(
                color: isDark ? Colors.grey.shade800 : const Color(0xFFEEF0F4),
              ),
            ),
          ),
          child: Row(
            children: [
              // Menu toggle
              IconButton(
                onPressed: onToggleCatalog,
                icon: const Icon(Icons.menu_rounded),
                color: isDark ? Colors.grey.shade400 : const Color(0xFF6B7280),
                iconSize: 20,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 16),

              // Prev arrow
              _NavArrow(
                icon: Icons.chevron_left_rounded,
                onTap: prevWeek,
                isDark: isDark,
              ),
              const SizedBox(width: 4),

              // Date range (bold, Figma style)
              Text(
                dateRangeText,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF111827),
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(width: 4),

              // Next arrow
              _NavArrow(
                icon: Icons.chevron_right_rounded,
                onTap: nextWeek,
                isDark: isDark,
              ),
              const SizedBox(width: 12),

              // Today pill
              GestureDetector(
                onTap: goToToday,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E3A6E).withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF1E3A6E).withValues(alpha: 0.2),
                    ),
                  ),
                  child: Text(
                    'Today',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? Colors.white70
                          : const Color(0xFF1E3A6E),
                    ),
                  ),
                ),
              ),

              const Spacer(),

              // Calendar icon
              Icon(
                Icons.calendar_month_outlined,
                size: 18,
                color: isDark ? Colors.grey.shade400 : const Color(0xFF9CA3AF),
              ),
            ],
          ),
        ),

        // Week Grid
        Expanded(
          child: SingleChildScrollView(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Time Labels Column — Figma theme
                Container(
                  width: 64,
                  color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF9FAFB),
                  child: Column(
                    children: [
                      const SizedBox(height: 50), // Header spacer
                      ...List.generate(9, (index) {
                        final hour = 9 + index;
                        return SizedBox(
                          height: 100,
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Transform.translate(
                              offset: const Offset(0, -9),
                              child: Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: Text(
                                  _formatHour(hour),
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: isDark
                                        ? Colors.grey.shade600
                                        : const Color(0xFF9CA3AF),
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  color: isDark ? Colors.grey.shade800 : const Color(0xFFEEF0F4),
                ),

                // Days Columns
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final dayWidth = constraints.maxWidth / 6;
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(6, (dayIndex) {
                          final dayDate = currentWeekStart.value
                              .add(Duration(days: dayIndex));
                          final isToday = _isSameDay(dayDate, DateTime.now());

                          // Get items from backend API response
                          final dayDateStr =
                              '${dayDate.year}-${dayDate.month.toString().padLeft(2, '0')}-${dayDate.day.toString().padLeft(2, '0')}';
                          final days =
                              (weekDataAsync.value?['days'] as List?) ?? [];
                          final dayData = days
                              .cast<Map<String, dynamic>>()
                              .firstWhere(
                                (d) => d['date'] == dayDateStr,
                                orElse: () => <String, dynamic>{'items': []},
                              );
                          // Combine backend items with optimistic items for this day
                          final backendItems = (dayData['items'] as List?)
                                  ?.cast<Map<String, dynamic>>() ??
                              [];

                          final optimisticItemsForDay = optimisticTasks.value
                              .where((item) => item['date'] == dayDateStr)
                              .toList();

                          final itemsForDay = [
                            ...backendItems,
                            ...optimisticItemsForDay
                          ];

                          if (optimisticItemsForDay.isNotEmpty) {
                            debugPrint(
                                '📅 WEEK VIEW Day $dayDateStr: Backend=${backendItems.length}, Optimistic=${optimisticItemsForDay.length}, Total=${itemsForDay.length}');
                          }

                          return SizedBox(
                            width: dayWidth,
                            height:
                                950, // Total height for 9 hours * 100px/hour + 50px header
                            child: Stack(
                              key:
                                  ValueKey('$dayDateStr-${itemsForDay.length}'),
                              children: [
                                // Background Lines with headers — Figma theme
                                Column(
                                  children: [
                                    // Day Header — Figma style
                                    Container(
                                      height: 50,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: isDark
                                            ? const Color(0xFF1E293B)
                                            : Colors.white,
                                        border: Border(
                                          bottom: BorderSide(
                                            color: isDark
                                                ? Colors.grey.shade800
                                                : const Color(0xFFEEF0F4),
                                          ),
                                          right: BorderSide(
                                            color: isDark
                                                ? Colors.grey.shade800
                                                : const Color(0xFFEEF0F4),
                                          ),
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            DateFormat('EEE')
                                                .format(dayDate)
                                                .toUpperCase(),
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w700,
                                              color: isToday
                                                  ? const Color(0xFF2563EB)
                                                  : (isDark
                                                      ? Colors.grey.shade500
                                                      : const Color(0xFF9CA3AF)),
                                              letterSpacing: 0.8,
                                            ),
                                          ),
                                          const SizedBox(height: 3),
                                          // Date number with today circle
                                          isToday
                                              ? Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    Container(
                                                      width: 28,
                                                      height: 28,
                                                      decoration:
                                                          const BoxDecoration(
                                                        color: Color(0xFF2563EB),
                                                        shape: BoxShape.circle,
                                                      ),
                                                    ),
                                                    Text(
                                                      dayDate.day.toString(),
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : Text(
                                                  dayDate.day.toString(),
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: isDark
                                                        ? Colors.white
                                                        : const Color(
                                                            0xFF374151),
                                                  ),
                                                ),
                                        ],
                                      ),
                                    ),
                                    // Hour slots (Droppable)
                                    ...List.generate(9, (index) {
                                      final hour = 9 + index;
                                      return DragTarget<Map<String, dynamic>>(
                                        onWillAcceptWithDetails: (details) =>
                                            true,
                                        onAcceptWithDetails: (details) async {
                                          final data = details.data;
                                          final catalogId =
                                              data['catalog_id'] as int?;
                                          final isCatalogItem =
                                              data['type'] == 'catalog_item' &&
                                                  catalogId != null;

                                          showDialog(
                                            context: context,
                                            builder: (ctx) => TaskConfigModal(
                                              taskObject:
                                                  data['taskObject'] as Task?,
                                              projectObject:
                                                  data['projectObject']
                                                      as Project?,
                                              initialTitle:
                                                  data['name'] as String?,
                                              initialDescription:
                                                  data['description']
                                                      as String?,
                                              initialDuration:
                                                  data['duration'] as int?,
                                              onConfirm: ({
                                                required String name,
                                                required int duration,
                                                String? description,
                                                List<String>?
                                                    selectedMilestoneIds,
                                                String? quadrant,
                                              }) async {
                                                final apiService = ref.read(
                                                    taskApiServiceProvider);
                                                final planDate =
                                                    '${dayDate.year}-${dayDate.month.toString().padLeft(2, '0')}-${dayDate.day.toString().padLeft(2, '0')}';
                                                final startTimeStr =
                                                    '${hour.toString().padLeft(2, '0')}:00';

                                                // Save to backend API only
                                                try {
                                                  // 1. ADD OPTIMISTIC ITEM
                                                  final optimisticItem = {
                                                    'id': -1, // Temporary ID
                                                    'custom_title': name,
                                                    'custom_description':
                                                        description ?? '',
                                                    'planned_duration_minutes':
                                                        duration,
                                                    'scheduled_start_time':
                                                        startTimeStr,
                                                    'catalog_type':
                                                        isCatalogItem
                                                            ? 'CATALOG'
                                                            : 'CUSTOM',
                                                    'status': 'PLANNED',
                                                    'date': planDate,
                                                    'quadrant': 'Q2',
                                                  };

                                                  // Add to local state
                                                  optimisticTasks.value = [
                                                    ...optimisticTasks.value,
                                                    optimisticItem
                                                  ];

                                                  debugPrint(
                                                      '✅ WEEK VIEW: Added optimistic item, count: ${optimisticTasks.value.length}');
                                                  debugPrint(
                                                      '   Item: ${optimisticItem['custom_title']} at ${optimisticItem['date']} ${optimisticItem['scheduled_start_time']}');

                                                  // 2. CALL API
                                                  if (isCatalogItem) {
                                                    await apiService.addItemToTodayPlan(
                                                      itemType: 'catalog',
                                                      catalogId: catalogId,
                                                      planDate: planDate,
                                                      scheduledStartTime:
                                                          startTimeStr,
                                                      plannedDurationMinutes:
                                                          duration,
                                                      description: description,
                                                      quadrant: 'Q2',
                                                    );
                                                  } else {
                                                    await apiService.addItemToTodayPlan(
                                                      itemType: 'custom',
                                                      title: name,
                                                      planDate: planDate,
                                                      description: description,
                                                      scheduledStartTime:
                                                          startTimeStr,
                                                      plannedDurationMinutes:
                                                          duration,
                                                      quadrant: 'Q2',
                                                    );
                                                  }

                                                  // 3. REFRESH & CLEAR OPTIMISTIC
                                                  // Invalidate and wait for refresh to complete
                                                  // We refresh both today and week providers to be safe
                                                  debugPrint(
                                                      '🔄 WEEK VIEW: Refreshing provider for $startDateStr');
                                                  ref.invalidate(
                                                      apiTodayPlanProvider);
                                                  // Wait for the week provider to refresh before clearing optimistic state
                                                  final _ = await ref.refresh(
                                                      apiWeekPlansProvider(
                                                              startDateStr)
                                                          .future);
                                                  debugPrint(
                                                      '✅ WEEK VIEW: Provider refreshed');

                                                  // Clear specific optimistic item (or all if simpler, here we filter)
                                                  // For simplicity in this fix, we clear the one we added
                                                  // or just reset state if we assume one-at-a-time (safer to filter)
                                                  optimisticTasks.value =
                                                      optimisticTasks.value
                                                          .where((item) =>
                                                              item !=
                                                              optimisticItem)
                                                          .toList();
                                                  debugPrint(
                                                      '🧹 WEEK VIEW: Cleared optimistic item, remaining: ${optimisticTasks.value.length}');
                                                } catch (e) {
                                                  debugPrint(
                                                      'API save error: $e');
                                                  // Rollback optimistic update on error
                                                  optimisticTasks.value = optimisticTasks
                                                      .value
                                                      .where((item) => !(item[
                                                                  'custom_title'] ==
                                                              name &&
                                                          item['scheduled_start_time'] ==
                                                              startTimeStr &&
                                                          item['date'] ==
                                                              planDate))
                                                      .toList();
                                                }
                                              },
                                            ),
                                          );
                                        },
                                        builder: (context, candidateData,
                                            rejectedData) {
                                          return GestureDetector(
                                            onTap: () {
                                              // Quick-add dialog for tapping on empty slot
                                              showDialog(
                                                context: context,
                                                builder: (ctx) =>
                                                    TaskConfigModal(
                                                  onConfirm: ({
                                                    required String name,
                                                    required int duration,
                                                    String? description,
                                                    List<String>?
                                                        selectedMilestoneIds,
                                                    String? quadrant,
                                                  }) async {
                                                    // Save to backend API only
                                                    try {
                                                      final apiService = ref.read(
                                                          taskApiServiceProvider);
                                                      final planDate =
                                                          '${dayDate.year}-${dayDate.month.toString().padLeft(2, '0')}-${dayDate.day.toString().padLeft(2, '0')}';
                                                      final startTimeStr =
                                                          '${hour.toString().padLeft(2, '0')}:00';
                                                      await apiService.addItemToTodayPlan(
                                                        itemType: 'custom',
                                                        title: name,
                                                        planDate: planDate,
                                                        description:
                                                            description,
                                                        scheduledStartTime:
                                                            startTimeStr,
                                                        plannedDurationMinutes:
                                                            duration,
                                                        quadrant: 'Q2',
                                                      );
                                                      ref.invalidate(
                                                          apiTodayPlanProvider);
                                                      ref.invalidate(
                                                          apiWeekPlansProvider(
                                                              startDateStr));
                                                    } catch (e) {
                                                      debugPrint(
                                                          'API save error: $e');
                                                    }
                                                  },
                                                ),
                                              );
                                            },
                                            child: Container(
                                              height: 100,
                                              decoration: BoxDecoration(
                                                color: candidateData.isNotEmpty
                                                    ? const Color(0xFF2563EB)
                                                        .withValues(alpha: 0.05)
                                                    : (isDark
                                                        ? const Color(
                                                            0xFF0F172A)
                                                        : Colors.white),
                                                border: Border(
                                                  bottom: BorderSide(
                                                    color: isDark
                                                        ? Colors.grey.shade800
                                                        : const Color(
                                                            0xFFEEF0F4),
                                                  ),
                                                  right: BorderSide(
                                                    color: isDark
                                                        ? Colors.grey.shade800
                                                        : const Color(
                                                            0xFFEEF0F4),
                                                  ),
                                                ),
                                              ),
                                              child: candidateData.isNotEmpty
                                                  ? Center(
                                                      child: Icon(
                                                        Icons
                                                            .add_circle_outline,
                                                        color: const Color(
                                                                0xFF2563EB)
                                                            .withValues(
                                                                alpha: 0.5),
                                                        size: 20,
                                                      ),
                                                    )
                                                  : null,
                                            ),
                                          );
                                        },
                                      );
                                    }),
                                  ],
                                ),

                                // Events from backend API
                                ...itemsForDay.asMap().entries.map((entry) {
                                  final itemIdx = entry.key;
                                  final item = entry.value;
                                  // Parse scheduled_start_time (HH:MM:SS or HH:MM)
                                  final startTimeStr =
                                      item['scheduled_start_time'] as String?;
                                  int startHour = 9;
                                  int startMinute = 0;
                                  if (startTimeStr != null &&
                                      startTimeStr.isNotEmpty) {
                                    final parts = startTimeStr.split(':');
                                    startHour = int.tryParse(parts[0]) ?? 9;
                                    startMinute = parts.length > 1
                                        ? (int.tryParse(parts[1]) ?? 0)
                                        : 0;
                                  }
                                  if (startHour < 9) startHour = 9;

                                  final durationMinutes =
                                      (item['planned_duration_minutes'] as num?)
                                              ?.toInt() ??
                                          60;

                                  final minutesFrom9 =
                                      (startHour - 9) * 60 + startMinute;
                                  const pixelsPerMinute = 100.0 / 60.0;
                                  final topOffset =
                                      50.0 + (minutesFrom9 * pixelsPerMinute);

                                  final height =
                                      (durationMinutes * pixelsPerMinute);

                                  return Positioned(
                                    top: topOffset,
                                    left: 2,
                                    right: 2,
                                    height: height,
                                    child: _EventCard(
                                      item: item,
                                      isDark: isDark,
                                      colorIndex: itemIdx,
                                    ),
                                  );
                                }),
                              ],
                            ),
                          );
                        }),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  DateTime _startOfWeek(DateTime date) {
    // Find monday
    return date.subtract(Duration(days: date.weekday - 1));
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _formatHour(int hour) {
    final amPm = hour >= 12 ? 'PM' : 'AM';
    final h = hour > 12 ? hour - 12 : hour;
    return '$h $amPm';
  }
}

class _EventCard extends HookConsumerWidget {
  final Map<String, dynamic> item;
  final bool isDark;
  final int colorIndex;

  const _EventCard({
    required this.item,
    required this.isDark,
    this.colorIndex = 0,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isHovered = useState(false);
    final title = (item['custom_title'] as String?)?.isNotEmpty == true
        ? item['custom_title'] as String
        : (item['catalog_name'] as String?) ?? 'Untitled';
    final description = (item['custom_description'] as String?) ?? '';
    final durationMinutes =
        (item['planned_duration_minutes'] as num?)?.toInt() ?? 60;

    final durationText =
        "${(durationMinutes / 60).toStringAsFixed(1).replaceAll('.0', '')}h";

    // Derive event colour from quadrant, catalog_type, category, or fallback to index
    final quadrant = (item['quadrant'] as String? ?? '').toUpperCase();
    final catalogType = (item['catalog_type'] as String? ?? '').toUpperCase();
    final category = (item['catalog_category'] as String? ?? '').toUpperCase();

    // Pick accent colour — uses category data if available, otherwise cycles palette by index
    final _EventTheme theme = _eventTheme(
      quadrant: quadrant,
      catalogType: catalogType,
      category: category,
      isDark: isDark,
      fallbackIndex: colorIndex,
      title: title,
    );

    return MouseRegion(
      onEnter: (_) => isHovered.value = true,
      onExit: (_) => isHovered.value = false,
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          // Show details dialog
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text(title),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (description.isNotEmpty) Text(description),
                  const SizedBox(height: 8),
                  Text('Duration: ${durationMinutes}min'),
                  if (item['quadrant'] != null)
                    Text('Quadrant: ${item['quadrant']}'),
                  if (item['status'] != null) Text('Status: ${item['status']}'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Close'),
                ),
              ],
            ),
          );
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            final height = constraints.maxHeight;
            final showDescription = height > 55 && description.isNotEmpty;
            final showDuration = height > 30;
            final showCategoryLabel = height > 26;

            return ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Container(
                decoration: BoxDecoration(
                  color: isHovered.value
                      ? theme.bgHover
                      : theme.bg,
                  boxShadow: isHovered.value
                      ? [
                          BoxShadow(
                            color: theme.accent.withValues(alpha: 0.12),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          )
                        ]
                      : null,
                ),
                child: Row(
                  children: [
                    // Left accent stripe — Figma signature
                    Container(
                      width: 3,
                      color: theme.accent,
                    ),
                    // Card content
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(6, 5, 5, 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Category label (STRATEGY / CLIENT / TEAM …)
                            if (showCategoryLabel && theme.label.isNotEmpty) ...[
                              Text(
                                theme.label,
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                  color: theme.accent,
                                  letterSpacing: 0.6,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.clip,
                              ),
                              const SizedBox(height: 2),
                            ],
                            // Title
                            Text(
                              title,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: theme.text,
                                height: 1.2,
                              ),
                              maxLines: showDescription ? 1 : 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (showDescription) ...[
                              const SizedBox(height: 2),
                              Expanded(
                                child: Text(
                                  description,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: theme.subText,
                                    height: 1.3,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                            if (!showDescription && showDuration) const Spacer(),
                            if (showDuration)
                              Row(
                                children: [
                                  Icon(Icons.access_time_rounded,
                                      size: 9, color: theme.subText),
                                  const SizedBox(width: 3),
                                  Text(
                                    durationText,
                                    style: TextStyle(
                                      fontSize: 9,
                                      color: theme.subText,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Derive event colour palette from quadrant / catalog type / category
  _EventTheme _eventTheme({
    required String quadrant,
    required String catalogType,
    required String category,
    required bool isDark,
    int fallbackIndex = 0,
    String title = '',
  }) {
    final cat = category.isNotEmpty
        ? category
        : (catalogType.isNotEmpty ? catalogType : quadrant);

    switch (cat) {
      case 'Q1':
      case 'URGENT':
        return _EventTheme(
          accent: const Color(0xFFEF4444),
          bg: isDark ? const Color(0xFF3B1515) : const Color(0xFFFFF5F5),
          bgHover: isDark ? const Color(0xFF4A1A1A) : const Color(0xFFFFEBEB),
          text: isDark ? const Color(0xFFFCA5A5) : const Color(0xFF991B1B),
          subText: isDark ? const Color(0xFFF87171) : const Color(0xFFB91C1C),
          label: 'URGENT',
        );
      case 'Q2':
      case 'STRATEGY':
        return _EventTheme(
          accent: const Color(0xFF3B82F6),
          bg: isDark ? const Color(0xFF172554) : const Color(0xFFEFF6FF),
          bgHover: isDark ? const Color(0xFF1E3A6E) : const Color(0xFFDBEAFE),
          text: isDark ? const Color(0xFF93C5FD) : const Color(0xFF1D4ED8),
          subText: isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB),
          label: 'STRATEGY',
        );
      case 'CLIENT':
        return _EventTheme(
          accent: const Color(0xFFF97316),
          bg: isDark ? const Color(0xFF431407) : const Color(0xFFFFF7ED),
          bgHover: isDark ? const Color(0xFF5A1D09) : const Color(0xFFFFEDD5),
          text: isDark ? const Color(0xFFFDBA74) : const Color(0xFFC2410C),
          subText: isDark ? const Color(0xFFFB923C) : const Color(0xFFEA580C),
          label: 'CLIENT',
        );
      case 'TEAM':
        return _EventTheme(
          accent: const Color(0xFF10B981),
          bg: isDark ? const Color(0xFF022C22) : const Color(0xFFECFDF5),
          bgHover: isDark ? const Color(0xFF064E3B) : const Color(0xFFD1FAE5),
          text: isDark ? const Color(0xFF6EE7B7) : const Color(0xFF065F46),
          subText: isDark ? const Color(0xFF34D399) : const Color(0xFF059669),
          label: 'TEAM',
        );
      case 'INTERNAL':
        return _EventTheme(
          accent: const Color(0xFF8B5CF6),
          bg: isDark ? const Color(0xFF2E1065) : const Color(0xFFF5F3FF),
          bgHover: isDark ? const Color(0xFF3B0F85) : const Color(0xFFEDE9FE),
          text: isDark ? const Color(0xFFC4B5FD) : const Color(0xFF5B21B6),
          subText: isDark ? const Color(0xFFA78BFA) : const Color(0xFF7C3AED),
          label: 'INTERNAL',
        );
      case 'ADMIN':
        return _EventTheme(
          accent: const Color(0xFF6B7280),
          bg: isDark ? const Color(0xFF1F2937) : const Color(0xFFF9FAFB),
          bgHover: isDark ? const Color(0xFF374151) : const Color(0xFFF3F4F6),
          text: isDark ? const Color(0xFFD1D5DB) : const Color(0xFF374151),
          subText: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
          label: 'ADMIN',
        );
      case 'Q3':
      case 'ROUTINE':
        return _EventTheme(
          accent: const Color(0xFFF59E0B),
          bg: isDark ? const Color(0xFF362001) : const Color(0xFFFFFBEB),
          bgHover: isDark ? const Color(0xFF4A2D02) : const Color(0xFFFEF3C7),
          text: isDark ? const Color(0xFFFCD34D) : const Color(0xFF92400E),
          subText: isDark ? const Color(0xFFFBBF24) : const Color(0xFFB45309),
          label: 'ROUTINE',
        );
      case 'EDUCATION':
        return _EventTheme(
          accent: const Color(0xFF06B6D4),
          bg: isDark ? const Color(0xFF062D3D) : const Color(0xFFECFEFF),
          bgHover: isDark ? const Color(0xFF083D52) : const Color(0xFFCFFAFE),
          text: isDark ? const Color(0xFF67E8F9) : const Color(0xFF0E7490),
          subText: isDark ? const Color(0xFF22D3EE) : const Color(0xFF0891B2),
          label: 'EDUCATION',
        );
      default:
        // No category data — cycle through palette using title hash for stability
        // Same title always gets the same color across the week
        final palettes = _defaultPalettes(isDark);
        final idx = title.isNotEmpty
            ? (title.hashCode.abs() % palettes.length)
            : (fallbackIndex % palettes.length);
        return palettes[idx];
    }
  }

  /// 8 distinct Figma-palette themes for auto-cycling
  static List<_EventTheme> _defaultPalettes(bool isDark) {
    return [
      // 0 — Blue (Strategy)
      _EventTheme(
        accent: const Color(0xFF3B82F6),
        bg: isDark ? const Color(0xFF172554) : const Color(0xFFEFF6FF),
        bgHover: isDark ? const Color(0xFF1E3A6E) : const Color(0xFFDBEAFE),
        text: isDark ? const Color(0xFF93C5FD) : const Color(0xFF1D4ED8),
        subText: isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB),
        label: '',
      ),
      // 1 — Orange (Client)
      _EventTheme(
        accent: const Color(0xFFF97316),
        bg: isDark ? const Color(0xFF431407) : const Color(0xFFFFF7ED),
        bgHover: isDark ? const Color(0xFF5A1D09) : const Color(0xFFFFEDD5),
        text: isDark ? const Color(0xFFFDBA74) : const Color(0xFFC2410C),
        subText: isDark ? const Color(0xFFFB923C) : const Color(0xFFEA580C),
        label: '',
      ),
      // 2 — Green (Team)
      _EventTheme(
        accent: const Color(0xFF10B981),
        bg: isDark ? const Color(0xFF022C22) : const Color(0xFFECFDF5),
        bgHover: isDark ? const Color(0xFF064E3B) : const Color(0xFFD1FAE5),
        text: isDark ? const Color(0xFF6EE7B7) : const Color(0xFF065F46),
        subText: isDark ? const Color(0xFF34D399) : const Color(0xFF059669),
        label: '',
      ),
      // 3 — Purple (Internal)
      _EventTheme(
        accent: const Color(0xFF8B5CF6),
        bg: isDark ? const Color(0xFF2E1065) : const Color(0xFFF5F3FF),
        bgHover: isDark ? const Color(0xFF3B0F85) : const Color(0xFFEDE9FE),
        text: isDark ? const Color(0xFFC4B5FD) : const Color(0xFF5B21B6),
        subText: isDark ? const Color(0xFFA78BFA) : const Color(0xFF7C3AED),
        label: '',
      ),
      // 4 — Cyan (Education)
      _EventTheme(
        accent: const Color(0xFF06B6D4),
        bg: isDark ? const Color(0xFF062D3D) : const Color(0xFFECFEFF),
        bgHover: isDark ? const Color(0xFF083D52) : const Color(0xFFCFFAFE),
        text: isDark ? const Color(0xFF67E8F9) : const Color(0xFF0E7490),
        subText: isDark ? const Color(0xFF22D3EE) : const Color(0xFF0891B2),
        label: '',
      ),
      // 5 — Amber (Routine)
      _EventTheme(
        accent: const Color(0xFFF59E0B),
        bg: isDark ? const Color(0xFF362001) : const Color(0xFFFFFBEB),
        bgHover: isDark ? const Color(0xFF4A2D02) : const Color(0xFFFEF3C7),
        text: isDark ? const Color(0xFFFCD34D) : const Color(0xFF92400E),
        subText: isDark ? const Color(0xFFFBBF24) : const Color(0xFFB45309),
        label: '',
      ),
      // 6 — Rose / Red
      _EventTheme(
        accent: const Color(0xFFE11D48),
        bg: isDark ? const Color(0xFF4C0519) : const Color(0xFFFFF1F2),
        bgHover: isDark ? const Color(0xFF6B0724) : const Color(0xFFFFE4E6),
        text: isDark ? const Color(0xFFFDA4AF) : const Color(0xFF9F1239),
        subText: isDark ? const Color(0xFFFB7185) : const Color(0xFFBE123C),
        label: '',
      ),
      // 7 — Indigo
      _EventTheme(
        accent: const Color(0xFF6366F1),
        bg: isDark ? const Color(0xFF1E1B4B) : const Color(0xFFEEF2FF),
        bgHover: isDark ? const Color(0xFF2D2B6B) : const Color(0xFFE0E7FF),
        text: isDark ? const Color(0xFFA5B4FC) : const Color(0xFF3730A3),
        subText: isDark ? const Color(0xFF818CF8) : const Color(0xFF4338CA),
        label: '',
      ),
    ];
  }
}

/// Colour palette for one event card
class _EventTheme {
  final Color accent;
  final Color bg;
  final Color bgHover;
  final Color text;
  final Color subText;
  final String label;

  const _EventTheme({
    required this.accent,
    required this.bg,
    required this.bgHover,
    required this.text,
    required this.subText,
    required this.label,
  });
}

/// Small navigation arrow button
class _NavArrow extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isDark;

  const _NavArrow(
      {required this.icon, required this.onTap, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: isDark
              ? Colors.grey.shade800
              : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isDark
                ? Colors.grey.shade700
                : const Color(0xFFE5E7EB),
          ),
        ),
        child: Icon(
          icon,
          size: 18,
          color: isDark ? Colors.grey.shade300 : const Color(0xFF374151),
        ),
      ),
    );
  }
}
