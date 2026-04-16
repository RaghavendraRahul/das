import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_pm/src/features/dashboard/dashboard_providers.dart';
import 'package:project_pm/src/features/dashboard/widgets/project_overview_stats.dart';
import 'package:project_pm/src/features/dashboard/widgets/work_statistics_chart.dart';
import 'package:project_pm/src/features/dashboard/widgets/project_working_report.dart';
import 'package:project_pm/src/features/dashboard/widgets/daily_execution_rings_card.dart';

import 'package:project_pm/src/routes/app_router.dart';
import 'package:project_pm/src/features/projects/providers/api_providers.dart';
import 'package:project_pm/src/core/providers/user_providers.dart';
import 'package:project_pm/src/features/auth/auth_state_providers.dart';
import '../notifications/services/notification_polling_service.dart';
import '../notifications/widgets/notification_popup_overlay.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Sidebar-Matched Theme Colors  (base: #05263E)
// ─────────────────────────────────────────────────────────────────────────────
const _kSidebarBlue = Color(0xFF05263E);

/// All section backgrounds directly matched to sidebar palette.
/// No borders — just clean, distinct background colors per zone.
class _C {
  // ── Page / Shell background ─────────────────────────────────────────────────
  //    Light: very soft blue-white  |  Dark: deepest navy
  static const pageBgLight  = Color(0xFFE8F0FA);
  static const pageBgDark   = Color(0xFF050E1C);

  // ── Section: Work Statistics Chart ─────────────────────────────────────────
  //    Light: light sky tint        |  Dark: navy-steel
  static const workStatLight = Color(0xFFEBF3FB);
  static const workStatDark  = Color(0xFF091625);

  // ── Section: Daily Execution Rings ─────────────────────────────────────────
  //    Light: icy periwinkle        |  Dark: deep ocean
  static const ringsLight   = Color(0xFFEEF5FC);
  static const ringsDark    = Color(0xFF0B1B2F);

  // ── Section: Project Working Report ────────────────────────────────────────
  //    Light: slate blue            |  Dark: darkest midnight
  static const reportLight  = Color(0xFFE5EEF8);
  static const reportDark   = Color(0xFF070F1C);

  // ── Filter bar / toggle container background ────────────────────────────────
  static const controlLight = Color(0xFFDCEAF7);   // cool blue-grey
  static const controlDark  = Color(0xFF0C1C30);
}

@RoutePage()
class DashboardPage extends HookConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPage = useState(1);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedProjectType = useState<String>('my');
    final projectsAsync = ref.watch(paginatedDashboardProjectsProvider(
        page: currentPage.value, filter: selectedProjectType.value));
    final allProjectsAsync = ref.watch(
        filteredDashboardStatsProvider(filter: selectedProjectType.value));
    final selectedStatusFilter = useState<String?>(null);
    final dashboardDateRange = ref.watch(dashboardDateRangeProvider);
    final currentUserAsync = ref.watch(currentUserProvider);
    final isEmployee = currentUserAsync.value?.role == 'EMPLOYEE';
    final notifications = ref.watch(notificationPollingProvider);
    final notificationService = ref.read(notificationPollingProvider.notifier);

    final pageBg = isDark ? _C.pageBgDark : _C.pageBgLight;

    return Stack(
      children: [
        // ── Full-page solid background ─────────────────────────────────────
        Container(color: pageBg),

        // ── Main Scaffold (transparent) ────────────────────────────────────
        Scaffold(
          backgroundColor: Colors.transparent,
          body: projectsAsync.when(
            skipLoadingOnReload: true,
            skipLoadingOnRefresh: true,
            data: (paginatedResponse) {
              final statsProjects = allProjectsAsync.valueOrNull ?? [];

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Filter Row ─────────────────────────────────────────
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final isNarrow = constraints.maxWidth < 600;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (!isNarrow) const Spacer(),
                            // Project Type Toggle
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: isDark ? _C.controlDark : _C.controlLight,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _ProjectTypeButton(
                                    label: isNarrow ? 'My' : 'My Projects',
                                    icon: Icons.person_outline,
                                    isSelected: selectedProjectType.value == 'my',
                                    onTap: () => selectedProjectType.value = 'my',
                                  ),
                                  if (!isEmployee)
                                    _ProjectTypeButton(
                                      label: isNarrow ? 'Team' : 'Team Projects',
                                      icon: Icons.groups_outlined,
                                      isSelected: selectedProjectType.value == 'team',
                                      onTap: () => selectedProjectType.value = 'team',
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
                      },
                    ),

                    const SizedBox(height: 16),

                    // ── Active Filter Chips ────────────────────────────────
                    if (selectedStatusFilter.value != null || dashboardDateRange != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            if (selectedStatusFilter.value != null)
                              InputChip(
                                label: Text('Filter: ${selectedStatusFilter.value}'),
                                onDeleted: () => selectedStatusFilter.value = null,
                                deleteIcon: const Icon(Icons.close, size: 18),
                                backgroundColor: _kSidebarBlue.withOpacity(0.1),
                                labelStyle: const TextStyle(
                                    color: _kSidebarBlue, fontWeight: FontWeight.bold),
                              ),
                            if (dashboardDateRange != null)
                              InputChip(
                                label: Text(
                                  'Period: ${DateFormat('MMM d').format(dashboardDateRange.start)} – ${DateFormat('MMM d').format(dashboardDateRange.end)}',
                                ),
                                onDeleted: () =>
                                    ref.read(dashboardDateRangeProvider.notifier).state = null,
                                deleteIcon: const Icon(Icons.close, size: 18),
                                backgroundColor: Colors.amber.withOpacity(0.1),
                                labelStyle: const TextStyle(
                                    color: Colors.orange, fontWeight: FontWeight.bold),
                              ),
                          ],
                        ),
                      ),

                    // ── Overview Stat Cards ────────────────────────────────
                    ProjectOverviewStats(projects: statsProjects),

                    const SizedBox(height: 24),

                    // ── Work Statistics Chart ──────────────────────────────
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final isNarrow = constraints.maxWidth < 700;
                        return SizedBox(
                          height: isNarrow ? null : 440,
                          width: double.infinity,
                          child: _SectionCard(
                            bg: isDark ? _C.workStatDark : _C.workStatLight,
                            child: WorkStatisticsChart(
                              selectedStatus: selectedStatusFilter.value,
                              onStatusSelected: (status) {
                                selectedStatusFilter.value = status;
                              },
                              onNavigateToProject: (_) {
                                context.navigateTo(const ProjectPlanRoute());
                              },
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    // ── Daily Execution Rings ──────────────────────────────
                    _SectionCard(
                      bg: isDark ? _C.ringsDark : _C.ringsLight,
                      child: const DailyExecutionRingsCard(),
                    ),

                    const SizedBox(height: 20),

                    // ── Project Working Report ─────────────────────────────
                    _SectionCard(
                      bg: isDark ? _C.reportDark : _C.reportLight,
                      child: ProjectWorkingReport(
                        filter: selectedProjectType.value,
                      ),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              );
            },
            loading: () => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 120,
                    width: 200,
                    decoration: BoxDecoration(
                      color: isDark ? _C.workStatDark : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Image.asset(
                        'assets/images/logo.jpeg',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ).animate().fadeIn(duration: 400.ms).scale(
                        begin: const Offset(0.9, 0.9),
                        end: const Offset(1, 1),
                        curve: Curves.easeOutBack,
                      ),
                  const SizedBox(height: 24),
                  Text(
                    'Loading Dashboard...',
                    style: TextStyle(
                      color: isDark ? Colors.white70 : _kSidebarBlue,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                  ).animate().fadeIn(delay: 200.ms),
                ],
              ),
            ),
            error: (err, stack) {
              debugPrint('❌ Dashboard error: $err');
              final is401Error = err.toString().contains('401') ||
                  err.toString().toLowerCase().contains('unauthorized');

              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      is401Error ? Icons.lock_outline : Icons.error_outline,
                      size: 64,
                      color: is401Error ? Colors.orange.shade300 : Colors.red.shade300,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      is401Error ? 'Authentication Required' : 'Error loading dashboard',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        is401Error
                            ? 'Your session has expired. Please log in again from the HRM portal.'
                            : '$err',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: is401Error ? Colors.orange.shade300 : Colors.red.shade300,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (is401Error)
                      ElevatedButton.icon(
                        onPressed: () {
                          ref.read(authNotifierProvider.notifier).logout();
                          context.router.replaceNamed('/login');
                        },
                        icon: const Icon(Icons.login),
                        label: const Text('Go to Login'),
                      )
                    else
                      ElevatedButton.icon(
                        onPressed: () {
                          ref.invalidate(paginatedDashboardProjectsProvider(
                              page: currentPage.value,
                              filter: selectedProjectType.value));
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                      ),
                  ],
                ),
              );
            },
          ),
        ),

        // ── Notification Popup ─────────────────────────────────────────────
        if (notifications.isNotEmpty && !notifications.last.isRead) ...[
          NotificationPopupOverlay(
            notification: notifications.last,
            onDismiss: () {
              notificationService.markAsRead(notifications.last.id);
            },
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Section Card — clean background, no borders, gentle rounding
// ─────────────────────────────────────────────────────────────────────────────
class _SectionCard extends StatelessWidget {
  final Widget child;
  final Color bg;

  const _SectionCard({required this.child, required this.bg});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.hardEdge,
      child: child,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Date Range Filter Button
// ─────────────────────────────────────────────────────────────────────────────
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

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          gradient: hasRange
              ? const LinearGradient(
                  colors: [_kSidebarBlue, Color(0xFF1A6CB8)],
                )
              : null,
          color: hasRange ? null : (isDark ? _C.controlDark : _C.controlLight),
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
                  : (isDark ? Colors.white60 : const Color(0xFF05263E)),
            ),
            const SizedBox(width: 8),
            Text(
              hasRange
                  ? '${DateFormat('MMM d').format(selectedRange!.start)} – ${DateFormat('MMM d').format(selectedRange!.end)}'
                  : 'Overall data',
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

// ─────────────────────────────────────────────────────────────────────────────
// Project Type Toggle Button
// ─────────────────────────────────────────────────────────────────────────────
class _ProjectTypeButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ProjectTypeButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final inactiveColor = isDark ? Colors.white60 : const Color(0xFF05263E);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [_kSidebarBlue, Color(0xFF1A6CB8)],
                )
              : null,
          color: isSelected ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 15,
              color: isSelected ? Colors.white : inactiveColor,
            ),
            const SizedBox(width: 7),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                color: isSelected ? Colors.white : inactiveColor,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
