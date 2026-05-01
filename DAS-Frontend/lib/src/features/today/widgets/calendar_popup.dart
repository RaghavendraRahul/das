import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:project_pm/src/features/today/today_providers.dart';
import 'package:project_pm/src/features/projects/providers/api_providers.dart';

class CalendarPopup extends HookConsumerWidget {
  final VoidCallback? onDateSelected;

  const CalendarPopup({super.key, this.onDateSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // State for current month in view
    final currentMonth = useState(DateTime.now());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Fetch data for the currently visible month
    final monthDataAsync = ref.watch(apiMonthPlansProvider(
        currentMonth.value.year, currentMonth.value.month));

    // Helper to get daily status
    Color? getDayBackgroundColor(DateTime date) {
      final dayDateStr = DateFormat('yyyy-MM-dd').format(date);
      final apiDays = (monthDataAsync.value?['days'] as List?) ?? [];

      final dayData = apiDays.cast<Map<String, dynamic>>().firstWhere(
            (d) => d['date'] == dayDateStr,
            orElse: () => <String, dynamic>{'items': []},
          );

      // total_minutes = planned items
      // completed_minutes = planned items that are marked done
      final totalMinutes = dayData['total_minutes'] as int? ?? 0;
      final completedMinutes = dayData['completed_minutes'] as int? ?? 0;

      // Color Coding Logic
      if (completedMinutes >= 480) {
        // >= 8 hours completed -> Dark Green (Complete Day)
        return isDark ? Colors.green.shade900 : Colors.green.shade300;
      } else if (totalMinutes > 0) {
        // Has plan but < 8 hours completed -> Dark Red (Incomplete Day)
        return isDark ? Colors.red.shade900 : Colors.red.shade300;
      }
      return null; // No color for no plan
    }

    // Get selected date
    final selectedDate = ref.watch(selectedDateProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          SizedBox(
            height: 380.0,
            child: CalendarCarousel<Event>(
              onDayPressed: (DateTime date, List<Event> events) {
                ref.read(selectedDateProvider.notifier).setDate(date);
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
                onDateSelected?.call();
              },
              weekendTextStyle: TextStyle(
                color: isDark ? Colors.red.shade200 : Colors.red,
              ),
              thisMonthDayBorderColor: Colors.grey,
              headerTextStyle: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              weekdayTextStyle: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w600),

              // Disable default selection styles to use custom builder
              selectedDayButtonColor: Colors.transparent,
              todayButtonColor: Colors.transparent,
              todayBorderColor: Colors.transparent,
              selectedDayBorderColor: Colors.transparent,

              customDayBuilder: (
                bool isSelectable,
                int index,
                bool isSelectedDay,
                bool isToday,
                bool isPrevMonthDay,
                TextStyle textStyle,
                bool isNextMonthDay,
                bool isThisMonthDay,
                DateTime day,
              ) {
                // Determine Status Color
                final statusColor = getDayBackgroundColor(day);

                // Determine Border Color (Selection or Today)
                Color? borderColor;
                double borderWidth = 0;
                BoxDecoration? decoration;

                if (isSelectedDay) {
                  borderColor = Colors.blue;
                  borderWidth = 2.0;
                } else if (isToday) {
                  // Special highlight for 'Today'
                  borderColor = Colors.blue;
                  borderWidth = 2.0; // Thicker border for visibility
                  // Optional: add a light tint if not selected
                  if (statusColor == null) {
                    decoration = BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.blue, width: 2.0));
                  }
                }

                return Center(
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: decoration ??
                        BoxDecoration(
                          color: statusColor ?? Colors.transparent,
                          shape: BoxShape.circle,
                          border: borderColor != null
                              ? Border.all(
                                  color: borderColor, width: borderWidth)
                              : null,
                        ),
                    alignment: Alignment.center,
                    child: Text(
                      '${day.day}',
                      style: TextStyle(
                        color: isToday || statusColor != null
                            ? (isDark ? Colors.white : Colors.black87)
                            : (isDark ? Colors.grey : Colors.black87),
                        fontWeight: isToday || isSelectedDay
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
              weekFormat: false,
              height: 380.0,
              selectedDateTime: selectedDate,
              targetDateTime: currentMonth.value,
              customGridViewPhysics: const NeverScrollableScrollPhysics(),
              showHeader: true,
              minSelectedDate: DateTime(2020),
              maxSelectedDate: DateTime(2030),
              onCalendarChanged: (DateTime date) {
                currentMonth.value = date;
              },
            ),
          ),
          const Divider(),
          Expanded(child: Consumer(
            builder: (context, ref, _) {
              // Extract tasks for selected date
              final dayDateStr = DateFormat('yyyy-MM-dd').format(selectedDate);
              final apiDays = (monthDataAsync.value?['days'] as List?) ?? [];
              final dayData = apiDays.cast<Map<String, dynamic>>().firstWhere(
                    (d) => d['date'] == dayDateStr,
                    orElse: () => <String, dynamic>{'items': []},
                  );
              final itemsForDay =
                  (dayData['items'] as List?)?.cast<Map<String, dynamic>>() ??
                      [];

              if (itemsForDay.isEmpty) {
                return Center(
                  child: Text(
                    'No plans for ${DateFormat('MMM d').format(selectedDate)}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                );
              }

              return ListView.builder(
                itemCount: itemsForDay.length,
                itemBuilder: (context, index) {
                  final task = itemsForDay[index];
                  final title = task['custom_title'] ??
                      task['catalog_name'] ??
                      'Untitled Task';
                  final duration =
                      task['planned_duration_minutes'] ?? task['duration'] ?? 0;

                  return ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.circle,
                        size: 8,
                        color: isDark ? Colors.white70 : Colors.black54),
                    title: Text(title,
                        style: TextStyle(
                            color: isDark ? Colors.white : Colors.black87)),
                    trailing: Text('${duration}m',
                        style: const TextStyle(color: Colors.grey)),
                  );
                },
              );
            },
          )),
        ],
      ),
    );
  }
}
