import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_pm/src/features/dashboard/dashboard_providers.dart';
import 'package:project_pm/src/features/dashboard/dashboard_state.dart';

import 'package:project_pm/src/features/dashboard/widgets/project_overview_stats.dart';
import 'package:project_pm/src/features/dashboard/widgets/work_statistics_chart.dart';
import 'package:project_pm/src/features/dashboard/widgets/project_working_report.dart';
import 'package:project_pm/src/features/dashboard/widgets/daily_execution_rings_card.dart';

import 'package:project_pm/src/core/database/database.dart';
import 'package:project_pm/src/routes/app_router.dart';
import 'package:project_pm/src/features/projects/providers/api_providers.dart';
import 'package:project_pm/src/core/providers/user_providers.dart';
import 'package:project_pm/src/features/auth/auth_state_providers.dart';
import 'package:project_pm/src/features/dashboard/widgets/dashboard_header_actions.dart';
import '../notifications/services/notification_polling_service.dart';
import '../notifications/widgets/notification_popup_overlay.dart';
import '../projects/project_providers.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Sidebar-Matched Theme Colors  (base: #05263E)
// ─────────────────────────────────────────────────────────────────────────────
const _kSidebarBlue = Color(0xFF05263E);

/// All section backgrounds directly matched to sidebar palette.
/// No borders — just clean, distinct background colors per zone.
class _C {

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
}


@RoutePage()
class DashboardPage extends HookConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPage = useState(1);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedProjectType = ref.watch(dashboardProjectTypeProvider);
    final searchQuery = ref.watch(dashboardSearchQueryProvider);

    // Reset pagination when search or project type changes
    useEffect(() {
      currentPage.value = 1;
      return null;
    }, [selectedProjectType, searchQuery]);

    final projectsAsync = ref.watch(paginatedDashboardProjectsProvider(
        page: currentPage.value, filter: selectedProjectType, search: searchQuery));
    final allProjectsAsync = ref.watch(
        filteredDashboardStatsProvider(filter: selectedProjectType));
    final selectedStatusFilter = useState<String?>(null);
    final dashboardDateRange = ref.watch(dashboardDateRangeProvider);
    final currentUserAsync = ref.watch(currentUserProvider);
    final notifications = ref.watch(notificationPollingProvider);
    final notificationService = ref.read(notificationPollingProvider.notifier);


    return currentUserAsync.when(
      data: (user) {
        if (user == null) return const Center(child: Text('User not found'));

        return Stack(
          children: [
            // ── Main Page Content ──────────────────────────────────────────
            Scaffold(
              backgroundColor: Colors.transparent,
              body: projectsAsync.when(
                skipLoadingOnReload: true,
                skipLoadingOnRefresh: true,
                data: (paginatedResponse) {
                  final statsProjects = allProjectsAsync.valueOrNull ?? [];

                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── INTERNAL PAGE HEADER (Brought down from global header) ─────
                        Padding(
                          padding: const EdgeInsets.only(top: 4, bottom: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Dashboard',
                                    style: GoogleFonts.outfit(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 26,
                                      letterSpacing: -0.5,
                                      color: isDark ? Colors.white : const Color(0xFF0B1B2F),
                                    ),
                                  ),
                                  Text(
                                    'Your intelligent command center for the all projects',
                                    style: GoogleFonts.outfit(
                                      fontSize: 12,
                                      color: (isDark ? Colors.white : const Color(0xFF0B1B2F)).withValues(alpha: 0.6),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const DashboardHeaderActions(),
                            ],
                          ),
                        ),

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
                                    backgroundColor: _kSidebarBlue.withValues(alpha: 0.1),
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
                                    backgroundColor: Colors.amber.withValues(alpha: 0.1),
                                    labelStyle: const TextStyle(
                                        color: Colors.orange, fontWeight: FontWeight.bold),
                                  ),
                              ],
                            ),
                          ),

                        // ── Global Discovery Search Results ────────────────────────────────
                        if (searchQuery.isNotEmpty) ...[
                          Row(
                            children: [
                              Icon(Icons.search_rounded, 
                                color: isDark ? Colors.white70 : const Color(0xFF0B1B2F), 
                                size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Global Discovery',
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  color: isDark ? Colors.white : const Color(0xFF0B1B2F),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '${paginatedResponse.count} results',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: Colors.grey.shade500,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          if (paginatedResponse.results.isEmpty)
                            _SectionCard(
                              bg: isDark ? _C.workStatDark : Colors.white,
                              child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            child: Column(
                              children: [
                                Icon(Icons.search_off_rounded, 
                                  size: 48, 
                                  color: Colors.grey.withValues(alpha: 0.3)),
                                const SizedBox(height: 16),
                                Text(
                                  'No project found for "$searchQuery"',
                                  style: GoogleFonts.inter(
                                    color: Colors.grey.shade500,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Try searching for project name or description',
                                  style: GoogleFonts.inter(
                                    color: Colors.grey.shade400,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                            )
                          else
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: paginatedResponse.results.length,
                              separatorBuilder: (context, index) => const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final projectWithTasks = paginatedResponse.results[index];
                                return _SearchResultItem(
                                  project: projectWithTasks.project, 
                                  isDark: isDark
                                );
                              },
                            ),
                          const SizedBox(height: 32),
                          const Divider(height: 1),
                          const SizedBox(height: 32),
                        ],

                        // ── Overview Stat Cards ────────────────────────────────
                        ProjectOverviewStats(
                          projects: statsProjects,
                          searchQuery: searchQuery,
                        ),

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
                                    context.navigateTo(const ProjectOverviewRoute());
                                  },
                                ),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 12),

                        // ── Daily Execution Rings ──────────────────────────────
                        _SectionCard(
                          bg: isDark ? _C.ringsDark : _C.ringsLight,
                          child: const DailyExecutionRingsCard(),
                        ),

                        const SizedBox(height: 12),

                        // ── Project Working Report ─────────────────────────────
                        _SectionCard(
                          bg: isDark ? _C.reportDark : _C.reportLight,
                          child: ProjectWorkingReport(
                            filter: selectedProjectType,
                            searchQuery: searchQuery,
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
                                  filter: selectedProjectType));
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

            // ── Notification Popup ──────────────────────────────────────────
            if (notifications.isNotEmpty && !notifications.last.isRead)
              NotificationPopupOverlay(
                notification: notifications.last,
                onDismiss: () {
                  notificationService.markAsRead(notifications.last.id);
                },
              ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text('Unexpected Error: $e')),
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
        borderRadius: BorderRadius.circular(24),
      ),
      clipBehavior: Clip.hardEdge,
      child: child,
    );
  }
}

class _SearchResultItem extends ConsumerWidget {
  final Project project;
  final bool isDark;

  const _SearchResultItem({required this.project, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        ref.read(selectedProjectIdProvider.notifier).state = project.id;
        context.router.navigate(const ProjectOverviewRoute());
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
            width: 1.5,
          ),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.shade400,
                    const Color(0xFF0D1B2A),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.rocket_launch_rounded, size: 26, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : const Color(0xFF0B1B2F),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _StatusBadge(status: project.status),
                      const SizedBox(width: 8),
                      Icon(Icons.calendar_today_rounded, size: 12, color: Colors.grey.shade500),
                      const SizedBox(width: 4),
                      Text(
                        project.dueDate != null 
                            ? 'Due: ${DateFormat('MMM dd').format(project.dueDate!)}'
                            : 'No deadline',
                        style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status.toUpperCase()) {
      case 'COMPLETED':
        color = Colors.green;
        break;
      case 'ONGOING':
        color = Colors.blue;
        break;
      case 'PENDING':
        color = Colors.orange;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status,
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Date Range Filter Button
// ─────────────────────────────────────────────────────────────────────────────
