import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:project_pm/src/features/today/widgets/task_config_modal.dart';
import 'package:project_pm/src/features/projects/providers/api_providers.dart';
import 'package:project_pm/src/core/database/database.dart';
import 'package:intl/intl.dart';

// ── Figma colour palette for month event chips ──────────────────────────────
class _ChipPalette {
  final Color bg;
  final Color text;
  final Color border;
  final Color subText;

  const _ChipPalette(
      {required this.bg, required this.text, required this.border, required this.subText});
}

List<_ChipPalette> _lightPalettes = const [
  _ChipPalette(
      bg: Color(0xFFEFF6FF),
      text: Color(0xFF1D4ED8),
      border: Color(0xFFBFDBFE),
      subText: Color(0xFF2563EB)), // Blue
  _ChipPalette(
      bg: Color(0xFFFFF7ED),
      text: Color(0xFFC2410C),
      border: Color(0xFFFED7AA),
      subText: Color(0xFFEA580C)), // Orange
  _ChipPalette(
      bg: Color(0xFFECFDF5),
      text: Color(0xFF065F46),
      border: Color(0xFFA7F3D0),
      subText: Color(0xFF059669)), // Green
  _ChipPalette(
      bg: Color(0xFFF5F3FF),
      text: Color(0xFF5B21B6),
      border: Color(0xFFDDD6FE),
      subText: Color(0xFF7C3AED)), // Purple
  _ChipPalette(
      bg: Color(0xFFECFEFF),
      text: Color(0xFF0E7490),
      border: Color(0xFFA5F3FC),
      subText: Color(0xFF0891B2)), // Cyan
  _ChipPalette(
      bg: Color(0xFFFFFBEB),
      text: Color(0xFF92400E),
      border: Color(0xFFFDE68A),
      subText: Color(0xFFB45309)), // Amber
  _ChipPalette(
      bg: Color(0xFFFFF1F2),
      text: Color(0xFF9F1239),
      border: Color(0xFFFECDD3),
      subText: Color(0xFFE11D48)), // Rose
  _ChipPalette(
      bg: Color(0xFFEEF2FF),
      text: Color(0xFF3730A3),
      border: Color(0xFFC7D2FE),
      subText: Color(0xFF4338CA)), // Indigo
];

List<_ChipPalette> _darkPalettes = const [
  _ChipPalette(
      bg: Color(0xFF172554),
      text: Color(0xFF93C5FD),
      border: Color(0xFF1E3A6E),
      subText: Color(0xFF60A5FA)), // Blue
  _ChipPalette(
      bg: Color(0xFF431407),
      text: Color(0xFFFDBA74),
      border: Color(0xFF5A1D09),
      subText: Color(0xFFFB923C)), // Orange
  _ChipPalette(
      bg: Color(0xFF022C22),
      text: Color(0xFF6EE7B7),
      border: Color(0xFF064E3B),
      subText: Color(0xFF34D399)), // Green
  _ChipPalette(
      bg: Color(0xFF2E1065),
      text: Color(0xFFC4B5FD),
      border: Color(0xFF3B0F85),
      subText: Color(0xFFA78BFA)), // Purple
  _ChipPalette(
      bg: Color(0xFF062D3D),
      text: Color(0xFF67E8F9),
      border: Color(0xFF083D52),
      subText: Color(0xFF22D3EE)), // Cyan
  _ChipPalette(
      bg: Color(0xFF362001),
      text: Color(0xFFFCD34D),
      border: Color(0xFF4A2D02),
      subText: Color(0xFFFBBF24)), // Amber
  _ChipPalette(
      bg: Color(0xFF4C0519),
      text: Color(0xFFFDA4AF),
      border: Color(0xFF6B0724),
      subText: Color(0xFFFB7185)), // Rose
  _ChipPalette(
      bg: Color(0xFF1E1B4B),
      text: Color(0xFFA5B4FC),
      border: Color(0xFF2D2B6B),
      subText: Color(0xFF818CF8)), // Indigo
];

_ChipPalette _chipColor(String title, bool isDark) {
  final palettes = isDark ? _darkPalettes : _lightPalettes;
  final idx = title.isNotEmpty
      ? (title.hashCode.abs() % palettes.length)
      : 0;
  return palettes[idx];
}

// ─────────────────────────────────────────────────────────────────────────────

class MonthView extends HookConsumerWidget {
  final Function(DateTime)? onDateSelected;

  const MonthView({super.key, this.onDateSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Local state for the currently displayed month
    final now = DateTime.now();
    final currentMonth = useState(DateTime(now.year, now.month));
    final selectedDate = useState<DateTime?>(null); // Selection state
    // Optimistic state for dragged items
    final optimisticTasks = useState<List<Map<String, dynamic>>>([]);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Helper to calculate start/end of the month grid
    final firstDayOfMonth =
        DateTime(currentMonth.value.year, currentMonth.value.month, 1);
    final lastDayOfMonth =
        DateTime(currentMonth.value.year, currentMonth.value.month + 1, 0);

    // Find the previous Sunday (or today if it's Sunday) to start the grid
    final firstDayOfGrid =
        firstDayOfMonth.subtract(Duration(days: firstDayOfMonth.weekday % 7));

    // Find next Saturday to end the grid
    final endDayOfGrid = lastDayOfMonth
        .add(Duration(days: 7 - (lastDayOfMonth.weekday % 7) - 1));

    final difference = endDayOfGrid.difference(firstDayOfGrid).inDays + 1;
    final numberOfWeeks = (difference / 7).ceil();

    final daysInGrid = List.generate(difference, (index) {
      return firstDayOfGrid.add(Duration(days: index));
    });

    // Navigation handlers
    void prevMonth() {
      currentMonth.value =
          DateTime(currentMonth.value.year, currentMonth.value.month - 1);
    }

    void nextMonth() {
      currentMonth.value =
          DateTime(currentMonth.value.year, currentMonth.value.month + 1);
    }

    void goToToday() {
      currentMonth.value = DateTime.now();
    }

    // Hover state for displaying the Add button
    final hoveredDate = useState<DateTime?>(null);

    // Watch planned items from Django backend API
    final monthDataAsync = ref.watch(apiMonthPlansProvider(
        currentMonth.value.year, currentMonth.value.month));

    // ── Figma theme tokens ──
    const headerBg = Color(0xFFF8FAFC);
    const gridBorder = Color(0xFFEEF0F4);
    const todayBlue = Color(0xFF2563EB);
    const navy = Color(0xFF1E3A6E);

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDark ? Colors.grey.shade800 : gridBorder,
        ),
      ),
      color: isDark ? const Color(0xFF1F2937) : Colors.white,
      child: Column(
        children: [
          // ── Header ─────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12)),
              border: Border(
                bottom: BorderSide(
                    color: isDark ? Colors.grey.shade800 : gridBorder),
              ),
            ),
            child: Row(
              children: [
                // Month + Year title
                Text(
                  DateFormat('MMMM yyyy').format(currentMonth.value),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF111827),
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(width: 16),

                // Prev arrow
                _NavBtn(
                  icon: Icons.chevron_left_rounded,
                  onTap: prevMonth,
                  isDark: isDark,
                ),
                const SizedBox(width: 4),

                // Today pill
                GestureDetector(
                  onTap: goToToday,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: navy.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(20),
                      border:
                          Border.all(color: navy.withOpacity(0.2)),
                    ),
                    child: Text(
                      'Today',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white70 : navy,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 4),

                // Next arrow
                _NavBtn(
                  icon: Icons.chevron_right_rounded,
                  onTap: nextMonth,
                  isDark: isDark,
                ),
              ],
            ),
          ),

          // ── Weekday labels ─────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : headerBg,
              border: Border(
                bottom: BorderSide(
                    color: isDark ? Colors.grey.shade800 : gridBorder),
              ),
            ),
            child: Row(
              children: ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT']
                  .map((day) => Expanded(
                        child: Center(
                          child: Text(
                            day,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? Colors.grey.shade500
                                  : const Color(0xFF9CA3AF),
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),

          // ── Calendar Grid ──────────────────────────────────────
          Expanded(
            child: LayoutBuilder(builder: (context, constraints) {
              final weeks = numberOfWeeks > 0 ? numberOfWeeks : 6;
              // Ensure a minimum height for cells so tasks are visible and error banners are avoided
              final cellHeight = (constraints.maxHeight / weeks).clamp(110.0, 500.0);

              return GridView.builder(
                physics: const ClampingScrollPhysics(), // Allow scrolling if grid exceeds available height
                itemCount: daysInGrid.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisExtent: cellHeight,
                ),
                itemBuilder: (context, index) {
                  final date = daysInGrid[index];
                  final isCurrentMonth = date.month == currentMonth.value.month;
                  final isToday = DateUtils.isSameDay(date, DateTime.now());
                  final isSelected = selectedDate.value != null &&
                      DateUtils.isSameDay(date, selectedDate.value);
                  final isHovered = hoveredDate.value != null &&
                      DateUtils.isSameDay(date, hoveredDate.value!);

                  // Get items for this day from backend API response
                  final dayDateStr =
                      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                  final apiDays =
                      (monthDataAsync.value?['days'] as List?) ?? [];
                  final dayData =
                      apiDays.cast<Map<String, dynamic>>().firstWhere(
                            (d) => d['date'] == dayDateStr,
                            orElse: () => <String, dynamic>{'items': []},
                          );
                  final itemsForDay = (dayData['items'] as List?)
                          ?.cast<Map<String, dynamic>>() ??
                      [];

                  final optimisticItemsForDay = optimisticTasks.value
                      .where((item) => item['date'] == dayDateStr)
                      .toList();

                  final allItemsForDay = [
                    ...itemsForDay,
                    ...optimisticItemsForDay
                  ];

                  return MouseRegion(
                    onEnter: (_) => hoveredDate.value = date,
                    onExit: (_) => hoveredDate.value = null,
                    child: DragTarget<Map<String, dynamic>>(
                      onWillAcceptWithDetails: (data) => true,
                      onAcceptWithDetails: (details) {
                        final data = details.data;
                        final catalogId = data['catalog_id'] as int?;
                        final isCatalogItem =
                            data['type'] == 'catalog_item' && catalogId != null;

                        // Open TaskConfigModal pre-filled
                        showDialog(
                          context: context,
                          builder: (ctx) => TaskConfigModal(
                            taskObject: data['taskObject'] as Task?,
                            projectObject: data['projectObject'] as Project?,
                            initialTitle: data['name'] as String?,
                            initialDescription: data['description'] as String?,
                            initialDuration: data['duration'] is int
                                ? data['duration'] as int
                                : (data['duration'] as num?)?.toInt() ?? 60,
                            onConfirm: ({
                              required String name,
                              required int duration,
                              String? description,
                              List<String>? selectedMilestoneIds,
                              String? quadrant,
                            }) async {
                              final apiService =
                                  ref.read(taskApiServiceProvider);
                              final planDate =
                                  '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

                              // Save to backend API only
                              try {
                                // 1. ADD OPTIMISTIC ITEM
                                final optimisticItem = {
                                  'id': -1, // Temporary
                                  'custom_title': name,
                                  'custom_description': description ?? '',
                                  'planned_duration_minutes': duration,
                                  'catalog_type':
                                      isCatalogItem ? 'CATALOG' : 'CUSTOM',
                                  'status': 'PLANNED',
                                  'date': planDate,
                                  'quadrant': 'Q2',
                                };

                                final currentOptimistic = [
                                  ...optimisticTasks.value
                                ];
                                currentOptimistic.add(optimisticItem);
                                optimisticTasks.value = currentOptimistic;

                                // 2. CALL API
                                if (isCatalogItem) {
                                  await apiService.addItemToTodayPlan(
                                    itemType: 'catalog',
                                    catalogId: catalogId,
                                    planDate: planDate,
                                    plannedDurationMinutes: duration,
                                    description: description,
                                    quadrant: 'Q2',
                                  );
                                } else {
                                  await apiService.addItemToTodayPlan(
                                    itemType: 'custom',
                                    title: name,
                                    planDate: planDate,
                                    description: description,
                                    plannedDurationMinutes: duration,
                                    quadrant: 'Q2',
                                  );
                                }

                                // 3. REFRESH & CLEAR
                                ref.invalidate(apiTodayPlanProvider);
                                final _ = await ref.refresh(
                                    apiMonthPlansProvider(
                                            currentMonth.value.year,
                                            currentMonth.value.month)
                                        .future);

                                final newOptimistic = [
                                  ...optimisticTasks.value
                                ];
                                newOptimistic.removeWhere(
                                    (item) => item == optimisticItem);
                                optimisticTasks.value = newOptimistic;
                              } catch (e) {
                                debugPrint('API save error: $e');
                                // Rollback
                                final currentOptimistic = [
                                  ...optimisticTasks.value
                                ];
                                currentOptimistic.removeWhere((item) =>
                                    item['custom_title'] == name &&
                                    item['date'] == planDate);
                                optimisticTasks.value = currentOptimistic;
                              }
                            },
                          ),
                        );
                      },
                      builder: (context, candidateData, rejectedData) {
                        final isDragHover = candidateData.isNotEmpty;

                        final dayColor = isDragHover
                            ? todayBlue.withOpacity(isDark ? 0.15 : 0.05)
                            : null;

                        return InkWell(
                          onTap: () {
                            if (onDateSelected != null) {
                              onDateSelected!(date);
                            } else {
                              selectedDate.value = date;
                            }
                            if (allItemsForDay.isNotEmpty) {
                              _showDayTasksModal(context, date, allItemsForDay, isDark);
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: dayColor ??
                                  (isDark
                                      ? const Color(0xFF0F172A)
                                      : Colors.white),
                              border: Border(
                                right: BorderSide(
                                    color: isDark
                                        ? Colors.grey.shade800
                                        : gridBorder),
                                bottom: BorderSide(
                                    color: isDark
                                        ? Colors.grey.shade800
                                        : gridBorder),
                              ),
                            ),
                            child: Stack(
                              children: [
                                // ── Day Number ──────────────
                                Positioned(
                                  top: 6,
                                  left: 0,
                                  right: 0,
                                  child: Center(
                                    child: Container(
                                      width: 28,
                                      height: 28,
                                      decoration: BoxDecoration(
                                        color: isToday
                                            ? todayBlue
                                            : Colors.transparent,
                                        shape: BoxShape.circle,
                                        border: (isSelected && !isToday)
                                            ? Border.all(
                                                color: todayBlue, width: 2)
                                            : null,
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        '${date.day}',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: isToday
                                              ? Colors.white
                                              : (!isCurrentMonth
                                                  ? (isDark
                                                      ? Colors.grey.shade700
                                                      : Colors.grey.shade400)
                                                  : (isDark
                                                      ? Colors.white
                                                      : const Color(
                                                          0xFF374151))),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                // ── Event chips ─────────────
                                Positioned(
                                  top: 36,
                                  left: 2,
                                  right: 2,
                                  bottom: 4, // Leave small padding at bottom
                                  child: ClipRect(
                                    child: SingleChildScrollView(
                                      physics: const NeverScrollableScrollPhysics(),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          ...allItemsForDay.take(4).map((item) {
                                            final title = (item['custom_title'] as String?)?.isNotEmpty == true
                                                ? item['custom_title'] as String
                                                : (item['catalog_name'] as String?) ?? 'Untitled';

                                            final chip = _chipColor(title, isDark);

                                            return Container(
                                              width: double.infinity,
                                              margin: const EdgeInsets.only(bottom: 2),
                                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: chip.bg,
                                                borderRadius: BorderRadius.circular(4),
                                                border: Border.all(
                                                  color: chip.border,
                                                  width: 0.5,
                                                ),
                                              ),
                                              child: Text(
                                                title,
                                                style: TextStyle(
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.w600,
                                                  color: chip.text,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            );
                                          }),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                // ── Overflow count badge ────
                                if (allItemsForDay.length > 4)
                                  Positioned(
                                    bottom: 3,
                                    right: 3,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 1),
                                      decoration: BoxDecoration(
                                        color: isDark
                                            ? Colors.grey.shade800
                                            : const Color(0xFFF3F4F6),
                                        borderRadius:
                                            BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        '+${allItemsForDay.length - 3}',
                                        style: TextStyle(
                                          fontSize: 8,
                                          fontWeight: FontWeight.w700,
                                          color: isDark
                                              ? Colors.grey.shade400
                                              : const Color(0xFF6B7280),
                                        ),
                                      ),
                                    ),
                                  ),

                                // ── Hover Add Button ────────
                                if (isHovered && isCurrentMonth)
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: InkWell(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (ctx) => TaskConfigModal(
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
                                                    '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                                                await apiService.addItemToTodayPlan(
                                                  itemType: 'custom',
                                                  title: name,
                                                  planDate: planDate,
                                                  description: description,
                                                  plannedDurationMinutes:
                                                      duration,
                                                  quadrant: 'Q2',
                                                );
                                                ref.invalidate(
                                                    apiTodayPlanProvider);
                                                ref.invalidate(
                                                    apiMonthPlansProvider(
                                                        currentMonth.value.year,
                                                        currentMonth
                                                            .value.month));
                                              } catch (e) {
                                                debugPrint(
                                                    'API save error: $e');
                                              }
                                            },
                                          ),
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(3),
                                        decoration: BoxDecoration(
                                          color: todayBlue,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          boxShadow: [
                                            BoxShadow(
                                              color: todayBlue.withOpacity(
                                                  0.3),
                                              blurRadius: 4,
                                              offset: const Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          Icons.add_rounded,
                                          color: Colors.white,
                                          size: 14,
                                        ),
                                      ),
                                    ),
                                  ),

                                // ── Drag feedback ───────────
                                if (isDragHover)
                                  Center(
                                    child: Icon(
                                        Icons.add_circle_outline_rounded,
                                        color:
                                            todayBlue.withOpacity(0.5),
                                        size: 28),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showDayTasksModal(BuildContext context, DateTime date, List<dynamic> items, bool isDark) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(
            'Tasks for ${date.day}/${date.month}/${date.year}',
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          content: SizedBox(
            width: 400,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (ctx, index) {
                final item = items[index];
                final title = (item['custom_title'] as String?)?.isNotEmpty == true
                    ? item['custom_title'] as String
                    : (item['catalog_name'] as String?) ?? 'Untitled';
                
                final duration = item['planned_duration_minutes'] as int? ?? 0;
                final desc = item['description'] as String? ?? '';
                
                final chip = _chipColor(title, isDark);

                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: chip.bg,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: chip.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: chip.text,
                        ),
                      ),
                      if (desc.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          'Planned Remark:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: isDark ? Colors.blue.shade300 : Colors.blue.shade700,
                          ),
                        ),
                        Text(
                          desc,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.grey.shade300 : Colors.black87,
                          ),
                        ),
                      ],
                      if (duration > 0) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.access_time_rounded, size: 12, color: chip.subText),
                            const SizedBox(width: 4),
                            Text(
                              '$duration min',
                              style: TextStyle(
                                fontSize: 11,
                                color: chip.subText,
                              ),
                            ),
                          ],
                        )
                      ]
                    ],
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                'Close',
                style: TextStyle(color: isDark ? Colors.blue.shade300 : Colors.blue.shade600),
              ),
            ),
          ],
        );
      },
    );
  }
}


/// Navigation arrow button (matching week view)
class _NavBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isDark;

  const _NavBtn(
      {required this.icon, required this.onTap, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: isDark ? Colors.grey.shade800 : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isDark ? Colors.grey.shade700 : const Color(0xFFE5E7EB),
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
