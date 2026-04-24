import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../dashboard_state.dart';

import 'package:project_pm/src/core/providers/user_providers.dart';

// ─────────────────────────────────────────────────────────────────────────────
// PROPER STATE MANAGEMENT: Dashboard header actions widget
// ─────────────────────────────────────────────────────────────────────────────

/// The main action set for the Dashboard header.
/// Highly stable because it's its own independent widget tree.
class DashboardHeaderActions extends ConsumerWidget {
  const DashboardHeaderActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedProjectType = ref.watch(dashboardProjectTypeProvider);
    final dashboardDateRange = ref.watch(dashboardDateRangeProvider);
    final currentUserAsync = ref.watch(currentUserProvider);
    final isEmployee = currentUserAsync.value?.role == 'EMPLOYEE';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Project Type Toggle — PILL SEGMENTED STYLE
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0C1C30) : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ProjectTypeButton(
                label: 'My Project',
                isSelected: selectedProjectType == 'my',
                onTap: () => ref.read(dashboardProjectTypeProvider.notifier).state = 'my',
              ),
              _ProjectTypeButton(
                label: 'Team Project',
                isSelected: !isEmployee && selectedProjectType == 'team',
                onTap: isEmployee ? null : () => ref.read(dashboardProjectTypeProvider.notifier).state = 'team',
                isDisabled: isEmployee,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        _DateRangeFilterButton(
          selectedRange: dashboardDateRange,
          onTap: () async {
            final picked = await _showCompactDateRangePicker(context, dashboardDateRange);
            if (picked != null) {
              ref.read(dashboardDateRangeProvider.notifier).state = picked;
            }
          },
        ),
      ],
    );
  }
}

// ── Re-using the specialized buttons here ─────────────────────────────────────

class _DateRangeFilterButton extends StatelessWidget {
  final DateTimeRange? selectedRange;
  final VoidCallback onTap;

  const _DateRangeFilterButton({
    required this.selectedRange,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasRange = selectedRange != null;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const kSidebarBlue = Color(0xFF05263E);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          gradient: hasRange
              ? const LinearGradient(
                  colors: [kSidebarBlue, Color(0xFF1A6CB8)],
                )
              : null,
          color: hasRange ? null : (isDark ? const Color(0xFF0C1C30) : const Color(0xFFF1F5F9)),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.calendar_month_outlined,
              size: 16,
              color: hasRange
                  ? Colors.white
                  : (isDark ? Colors.white60 : const Color(0xFF0B1B2F).withValues(alpha: 0.6)),
            ),
            const SizedBox(width: 8),
            Text(
              hasRange
                  ? '${DateFormat('MMM d').format(selectedRange!.start)} – ${DateFormat('MMM d').format(selectedRange!.end)}'
                  : 'Overall Project',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: hasRange
                    ? Colors.white
                    : (isDark ? Colors.white70 : const Color(0xFF05263E)),
              ),
            ),
            if (hasRange) ...[
              const SizedBox(width: 4),
              const Icon(Icons.arrow_drop_down, size: 16, color: Colors.white),
            ],
          ],
        ),
      ),
    );
  }
}

class _ProjectTypeButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool isDisabled;

  const _ProjectTypeButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isDisabled) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final inactiveColor = isDark ? Colors.white70 : const Color(0xFF64748B);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? (isDark ? Colors.white.withValues(alpha: 0.12) : Colors.white) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isSelected && !isDark
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected
                  ? (isDark ? Colors.white : const Color(0xFF0B1B2F))
                  : inactiveColor,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Custom Compact Date Range Picker ──────────────────────────────────────────

Future<DateTimeRange?> _showCompactDateRangePicker(BuildContext context, DateTimeRange? currentRange) {
  return showDialog<DateTimeRange>(
    context: context,
    builder: (ctx) {
      DateTime? start = currentRange?.start;
      DateTime? end = currentRange?.end;
      
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Select Date Range', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            backgroundColor: Theme.of(context).cardColor,
            content: SizedBox(
              width: 320,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildDateRow(
                    context, 
                    label: 'Start Date', 
                    date: start, 
                    onTap: () async {
                      final d = await showDatePicker(
                        context: context,
                        initialDate: start ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                        initialEntryMode: DatePickerEntryMode.calendarOnly,
                      );
                      if (d != null) {
                        setState(() {
                          start = d;
                          if (end != null && end!.isBefore(start!)) end = start;
                        });
                      }
                    }
                  ),
                  const SizedBox(height: 12),
                  _buildDateRow(
                    context, 
                    label: 'End Date', 
                    date: end, 
                    onTap: () async {
                      final d = await showDatePicker(
                        context: context,
                        initialDate: end ?? start ?? DateTime.now(),
                        firstDate: start ?? DateTime(2020),
                        lastDate: DateTime(2030),
                        initialEntryMode: DatePickerEntryMode.calendarOnly,
                      );
                      if (d != null) {
                        setState(() {
                          end = d;
                          if (start != null && start!.isAfter(end!)) start = end;
                        });
                      }
                    }
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, null),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: (start != null && end != null) 
                  ? () => Navigator.pop(ctx, DateTimeRange(start: start!, end: end!))
                  : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1D4ED8), 
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Save'),
              ),
            ],
          );
        }
      );
    }
  );
}

Widget _buildDateRow(BuildContext context, {required String label, required DateTime? date, required VoidCallback onTap}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(8),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isDark ? Colors.white24 : Colors.black12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
          Row(
            children: [
              Text(
                date != null ? DateFormat('MMM d, yyyy').format(date) : 'Select',
                style: TextStyle(
                  color: date != null ? (isDark ? Colors.white : Colors.black) : Colors.grey,
                  fontWeight: date != null ? FontWeight.bold : FontWeight.normal,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.calendar_today, size: 14, color: isDark ? Colors.white54 : Colors.black54),
            ],
          ),
        ],
      ),
    ),
  );
}
