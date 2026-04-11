import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:project_pm/src/features/dashboard/dashboard_providers.dart';
import 'package:project_pm/src/features/dashboard/widgets/project_overview_stats.dart';
import 'package:project_pm/src/features/dashboard/widgets/work_statistics_chart.dart';
import 'package:project_pm/src/features/dashboard/widgets/project_working_report.dart';
import 'package:project_pm/src/features/dashboard/widgets/daily_execution_rings_card.dart';


import 'package:project_pm/src/routes/app_router.dart';
import 'package:project_pm/src/features/projects/providers/api_providers.dart';
import 'package:project_pm/src/core/providers/user_providers.dart';
import 'package:project_pm/src/features/auth/auth_state_providers.dart';
// Notification imports
import '../notifications/services/notification_polling_service.dart';
import '../notifications/widgets/notification_popup_overlay.dart';

@RoutePage()
class DashboardPage extends HookConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPage = useState(1);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedProjectType = useState<String>('my'); // 'my' or 'team'
    final projectsAsync = ref.watch(paginatedDashboardProjectsProvider(
        page: currentPage.value, filter: selectedProjectType.value));

    // NEW: Watch all projects for stats (global data)
    final allProjectsAsync = ref.watch(
        filteredDashboardStatsProvider(filter: selectedProjectType.value));

    final selectedStatusFilter = useState<String?>(null);
    final dashboardDateRange = ref.watch(dashboardDateRangeProvider);

    // Get current user role to hide team section for employees
    final currentUserAsync = ref.watch(currentUserProvider);
    final isEmployee = currentUserAsync.value?.role == 'EMPLOYEE';

    // Listen to notification service to trigger overlays
    final notifications = ref.watch(notificationPollingProvider);
    final notificationService = ref.read(notificationPollingProvider.notifier);

    return Stack(
      children: [
        Scaffold(
          backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
          body: projectsAsync.when(
            skipLoadingOnReload: true,
            skipLoadingOnRefresh: true,
            data: (paginatedResponse) {
              // Get aggregated projects for stats
              final statsProjects = allProjectsAsync.valueOrNull ?? [];

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 2. Header Actions - Responsive
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final isNarrow = constraints.maxWidth < 600;

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (!isNarrow) const Spacer(),
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? const Color(0xFF1E293B)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isDark ? Colors.white10 : const Color(0xFF0F518B).withValues(alpha: 0.1),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: isDark ? Colors.black.withValues(alpha: 0.2) : const Color(0xFF0F518B).withValues(alpha: 0.05),
                                    blurRadius: 15,
                                    spreadRadius: 1,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _ProjectTypeButton(
                                    label: isNarrow ? 'My' : 'My Projects',
                                    icon: Icons.person_outline,
                                    isSelected:
                                        selectedProjectType.value == 'my',
                                    onTap: () =>
                                        selectedProjectType.value = 'my',
                                  ),
                                  if (!isEmployee)
                                    _ProjectTypeButton(
                                      label: isNarrow ? 'Team' : 'Team Projects',
                                      icon: Icons.groups_outlined,
                                      isSelected:
                                          selectedProjectType.value == 'team',
                                      onTap: () =>
                                          selectedProjectType.value = 'team',
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
                                  ref
                                      .read(dashboardDateRangeProvider.notifier)
                                      .state = picked;
                                }
                              },
                            ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 16),

                    // Active Filter Chip
                    if (selectedStatusFilter.value != null || dashboardDateRange != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            if (selectedStatusFilter.value != null)
                              InputChip(
                                label: Text(
                                    'Filter: ${selectedStatusFilter.value}'),
                                onDeleted: () =>
                                    selectedStatusFilter.value = null,
                                deleteIcon: const Icon(Icons.close, size: 18),
                                backgroundColor: Theme.of(context)
                                    .primaryColor
                                    .withValues(alpha: 0.1),
                                labelStyle: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            if (dashboardDateRange != null)
                              InputChip(
                                label: Text(
                                  'Period: ${DateFormat('MMM d').format(dashboardDateRange.start)} - ${DateFormat('MMM d').format(dashboardDateRange.end)}',
                                ),
                                onDeleted: () => ref
                                    .read(dashboardDateRangeProvider.notifier)
                                    .state = null,
                                deleteIcon: const Icon(Icons.close, size: 18),
                                backgroundColor: Colors.amber.withValues(alpha: 0.1),
                                labelStyle: const TextStyle(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold),
                              ),
                          ],
                        ),
                      ),

                    // 3. Overview Stats
                    ProjectOverviewStats(
                      projects: statsProjects,
                    ),

                    const SizedBox(height: 24),

                    // 6. Analytics Row - Expanded (Full Width)
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final isNarrow = constraints.maxWidth < 700;

                        return SizedBox(
                          height: isNarrow ? null : 440,
                          width: double.infinity,
                          child: Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(
                                color: isDark ? Colors.white10 : Colors.grey.shade100,
                                width: 1.5,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(isNarrow ? 16.0 : 20.0),
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
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 24),
                    
                    // NEW: Activity Rings Execution Flow Segment
                    const DailyExecutionRingsCard(),

                    const SizedBox(height: 24),

                    // 7. Project Working Report
                    ProjectWorkingReport(
                      filter: selectedProjectType.value,
                    ),

                    const SizedBox(height: 24),
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
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
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
                      color: Theme.of(context).primaryColor.withValues(alpha: 0.7),
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
                    Icon(is401Error ? Icons.lock_outline : Icons.error_outline,
                        size: 64,
                        color: is401Error
                            ? Colors.orange.shade300
                            : Colors.red.shade300),
                    const SizedBox(height: 16),
                    Text(
                      is401Error
                          ? 'Authentication Required'
                          : 'Error loading dashboard',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        is401Error
                            ? 'Your session has expired or is invalid. Please log in again from the HRM portal.'
                            : '$err',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: is401Error
                                ? Colors.orange.shade300
                                : Colors.red.shade300),
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

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: hasRange
              ? Colors.amber.withValues(alpha: 0.1)
              : Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF374151)
                  : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: hasRange ? Border.all(color: Colors.orange.shade300) : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.calendar_month_outlined,
              size: 18,
              color: hasRange ? Colors.orange : Colors.grey.shade600,
            ),
            const SizedBox(width: 8),
            Text(
              hasRange
                  ? '${DateFormat('MMM d').format(selectedRange!.start)} - ${DateFormat('MMM d').format(selectedRange!.end)}'
                  : 'Overall data',
              style: TextStyle(
                color: hasRange ? Colors.orange : Colors.grey.shade700,
                fontWeight: hasRange ? FontWeight.bold : FontWeight.normal,
                fontSize: 13,
              ),
            ),
            if (hasRange) ...[
              const SizedBox(width: 4),
              const Icon(Icons.arrow_drop_down, size: 18, color: Colors.orange),
            ],
          ],
        ),
      ),
    );
  }
}

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

    final activeBgColor = const Color(0xFF0F518B);
    final activeTextColor = Colors.white;
    final inactiveTextColor = isDark ? Colors.grey.shade400 : const Color(0xFF6B7280);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? activeBgColor : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? activeTextColor : inactiveTextColor,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? activeTextColor : inactiveTextColor,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

