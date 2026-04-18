import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:project_pm/src/features/dashboard/dashboard_providers.dart';
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
            final picked = await showDateRangePicker(
              context: context,
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
              initialDateRange: dashboardDateRange,
            );
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
      borderRadius: BorderRadius.circular(10),
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
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.calendar_month_outlined,
              size: 16,
              color: hasRange
                  ? Colors.white
                  : (isDark ? Colors.white60 : const Color(0xFF0B1B2F).withOpacity(0.6)),
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
    final inactiveColor = isDark ? Colors.white54 : const Color(0xFF64748B);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? (isDark ? Colors.white.withOpacity(0.12) : Colors.white) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isSelected && !isDark
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
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
                  ? (isDark ? const Color(0xFF0B1B2F) : const Color(0xFF0B1B2F))
                  : inactiveColor,
            ),
          ),
        ),
      ),
    );
  }
}
