import 'package:auto_route/auto_route.dart';
import 'package:project_pm/src/routes/app_router.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:project_pm/src/core/providers/user_providers.dart';
import 'package:project_pm/src/features/projects/models/project_model.dart';
import 'package:project_pm/src/features/projects/models/task_model.dart';
import 'package:project_pm/src/features/projects/providers/api_providers.dart';
import '../dashboard_providers.dart';
import '../dashboard_state.dart';
import '../../projects/project_providers.dart';

// Enums removed in favor of direct String-based state management via providers

class ProjectWorkingReport extends HookConsumerWidget {
  final String filter;
  final String? searchQuery;
  const ProjectWorkingReport({super.key, required this.filter, this.searchQuery});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Watch drill-down state
    final selectedMonth = ref.watch(workingReportDetailMonthProvider);

    // View state from global providers
    final currentView = ref.watch(workingReportViewProvider);
    final currentScope = ref.watch(workingReportScopeProvider);
    final selectedYear = ref.watch(workingReportYearProvider);

    // Get current user role to hide team toggle for employees
    final currentUserAsync = ref.watch(currentUserProvider);
    final isEmployee = currentUserAsync.value?.role == 'EMPLOYEE';

    // Link global selected user stats to charts (Proper State Management)
    final selectedUserId = ref.watch(selectedStatsUserIdProvider);

    // Effective filter for API calls
    final effectiveFilter = isEmployee
        ? 'my'
        : (currentScope.toLowerCase() == 'my' ? 'my' : 'team');


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (selectedMonth == null)
              _MainTitleSection(isDark: isDark)
            else
              _DrillDownHeader(
                title: selectedMonth,
                onBack: () => ref.read(workingReportDetailMonthProvider.notifier).state = null,
                isDark: isDark,
              ),

            if (selectedMonth == null)
              _HeaderSection(
                currentView: currentView,
                selectedYear: selectedYear,
                isEmployee: isEmployee,
                currentScope: currentScope,
                onScopeChanged: (val) => ref.read(workingReportScopeProvider.notifier).state = val,
                onViewChanged: (val) => ref.read(workingReportViewProvider.notifier).state = val,
                onYearChanged: (val) => ref.read(workingReportYearProvider.notifier).state = val,
                isDark: isDark,
              ),
          ],
        ),
        const SizedBox(height: 12),
        _ReportCard(
          isDark: isDark,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),

              // Body Section with Animated Switcher
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                switchInCurve: Curves.easeInOut,
                switchOutCurve: Curves.easeInOut,
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.05),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: selectedMonth != null
                    ? (ref.watch(workingReportDrillDownTypeProvider) == 'Projects'
                        ? _MonthlyProjectDetailView(
                            monthYear: selectedMonth,
                            isDark: isDark,
                            scope: effectiveFilter,
                            userId: selectedUserId,
                            searchQuery: searchQuery,
                          )
                        : _MonthlyTaskDetailView(
                            monthYear: selectedMonth,
                            isDark: isDark,
                            scope: effectiveFilter,
                            userId: selectedUserId,
                            searchQuery: searchQuery,
                          ))
                    : SizedBox(
                        key: const ValueKey('chart_view'),
                        height: 340,
                        child: currentView == 'Projects'
                            ? _ConnectedProjectChart(
                                selectedYear: selectedYear,
                                isDark: isDark,
                                filter: effectiveFilter,
                                userId: selectedUserId,
                              )
                            : (currentView == 'Tasks'
                                ? _ConnectedTaskChart(
                                    selectedYear: selectedYear,
                                    isDark: isDark,
                                    filter: effectiveFilter,
                                    userId: selectedUserId,
                                  )
                                : _ConnectedHoursChart(
                                    selectedYear: selectedYear,
                                    isDark: isDark,
                                    filter: effectiveFilter,
                                    userId: selectedUserId,
                                  )),
                      ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ],
    );

  }
}

// ─────────────────────────────────────────────────────────────────────────────
// UI Components
// ─────────────────────────────────────────────────────────────────────────────

class _MainTitleSection extends StatelessWidget {
  final bool isDark;
  const _MainTitleSection({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF05263E).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF05263E).withValues(alpha: 0.1)),
          ),
          child: Icon(
            Icons.trending_up,
            size: 18,
            color: isDark ? const Color(0xFF7EC8F4) : const Color(0xFF05263E),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          "Project Working Status",
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: isDark ? const Color(0xFFB0DFFF) : const Color(0xFF05263E),
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }
}

class _ReportCard extends StatelessWidget {
  final Widget child;
  final bool isDark;
  const _ReportCard({required this.child, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.transparent, // Background handled by _SectionCard wrapper
      ),
      padding: const EdgeInsets.all(24),
      child: child,
    );
  }
}

class _HeaderSection extends StatelessWidget {
  final String currentView;
  final int selectedYear;
  final bool isEmployee;
  final String currentScope;
  final ValueChanged<String> onScopeChanged;
  final ValueChanged<String> onViewChanged;
  final ValueChanged<int> onYearChanged;
  final bool isDark;

  const _HeaderSection({
    required this.currentView,
    required this.selectedYear,
    required this.isEmployee,
    required this.currentScope,
    required this.onScopeChanged,
    required this.onViewChanged,
    required this.onYearChanged,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8, // Tighter grouping between sections
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        // Controls Block
        Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            if (!isEmployee)
              _SegmentedControl<String>(
                value: currentScope,
                items: const {
                  'My': _SegmentItem(label: 'My', icon: Icons.person_outline),
                  'Team': _SegmentItem(label: 'Team', icon: Icons.groups_outlined),
                },
                onChanged: onScopeChanged,
                isDark: isDark,
              ),
            _SegmentedControl<String>(
              value: currentView,
              items: const {
                'Projects': _SegmentItem(label: 'Projects', icon: Icons.pie_chart_outline),
                'Tasks': _SegmentItem(label: 'Tasks', icon: Icons.check_circle_outline),
                // 'Hours': _SegmentItem(label: 'Hours', icon: Icons.access_time), // Removed as per request
              },
              onChanged: onViewChanged,
              isDark: isDark,
            ),
            _ModernYearPicker(
              selectedYear: selectedYear,
              onChanged: onYearChanged,
              isDark: isDark,
            ),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Custom Modern UI Widgets
// ─────────────────────────────────────────────────────────────────────────────

class _SegmentItem {
  final String label;
  final IconData icon;
  const _SegmentItem({required this.label, required this.icon});
}

class _SegmentedControl<T> extends StatelessWidget {
  final T value;
  final Map<T, _SegmentItem> items;
  final ValueChanged<T> onChanged;
  final bool isDark;

  const _SegmentedControl({
    required this.value,
    required this.items,
    required this.onChanged,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2D2D2D) : const Color(0xFFF1F5F9), // Slate grey bg
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? const Color(0xFF3F3F3F) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: items.entries.map((entry) {
          final isSelected = value == entry.key;
          return GestureDetector(
            onTap: () => onChanged(entry.key),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              margin: const EdgeInsets.symmetric(horizontal: 2), // spacing between segments
              decoration: BoxDecoration(
                color: isSelected 
                  ? (isDark ? const Color(0xFF424242) : Colors.white) // White pill in light mode
                  : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                boxShadow: isSelected && !isDark
                    ? [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                children: [
                  Icon(
                    entry.value.icon,
                    size: 13,
                    color: isSelected
                        ? (isDark ? Colors.white : Colors.black)
                        : (isDark ? Colors.white70 : const Color(0xFF64748B)),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    entry.value.label,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w600, // SemiBold
                      color: isSelected
                          ? (isDark ? Colors.white : Colors.black)
                          : (isDark ? Colors.white.withValues(alpha: 0.5) : const Color(0xFF64748B)),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ModernYearPicker extends StatelessWidget {
  final int selectedYear;
  final ValueChanged<int> onChanged;
  final bool isDark;

  const _ModernYearPicker({
    required this.selectedYear,
    required this.onChanged,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      initialValue: selectedYear,
      onSelected: onChanged,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 10,
      offset: const Offset(0, 45),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: null, // Let context menu handle it
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: isDark ? const Color(0xFF3F3F3F) : const Color(0xFFE2E8F0)),
              borderRadius: BorderRadius.circular(24),
              color: isDark ? const Color(0xFF2D2D2D) : const Color(0xFFF1F5F9),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  selectedYear.toString(),
                  style: GoogleFonts.inter(
                    fontSize: 10, 
                    fontWeight: FontWeight.w600, // SemiBold
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(width: 6),
                Icon(Icons.keyboard_arrow_down_rounded, 
                  size: 14, 
                  color: isDark ? Colors.white70 : Colors.black87),
              ],
            ),
          ),
        ),
      ),
      itemBuilder: (context) {
        final currentYear = DateTime.now().year;
        return List.generate(4, (index) {
          final year = currentYear - index;
          return PopupMenuItem(
            value: year,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              year.toString(),
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
          );
        });
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Connected Chart Widgets (Logic Preserved)
// ─────────────────────────────────────────────────────────────────────────────

class _ConnectedProjectChart extends ConsumerWidget {
  final int selectedYear;
  final bool isDark;
  final String filter;
  final int? userId;

  const _ConnectedProjectChart(
      {required this.selectedYear, required this.isDark, required this.filter, this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chartDataAsync = ref.watch(projectCompletionChartProvider(
        ProjectChartParams(year: selectedYear, filter: filter, userId: userId)));

    return chartDataAsync.when(
      data: (Map<String, dynamic> data) {
        final List<dynamic> rawDataList = data['data'] ?? [];
        final List<FlSpot> spots = [];
        final Map<int, String> xLabels = {};
        double maxY = 0;

        if (rawDataList.isEmpty) {
          final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
          for (int i = 0; i < months.length; i++) {
            spots.add(FlSpot(i.toDouble(), 0));
            xLabels[i] = '${months[i]} $selectedYear';
          }
        } else {
          for (int i = 0; i < rawDataList.length; i++) {
            final item = rawDataList[i];
            final count = (item['count'] as num).toDouble();
            spots.add(FlSpot(i.toDouble(), count));
            xLabels[i] = item['month_year']?.toString() ?? '';
            if (count > maxY) maxY = count;
          }
        }

        double maxX = spots.length.toDouble() - 1;
        if (maxX < 0) maxX = 0;

        return _buildLineChart(
          context: context,
          spots: spots,
          xLabels: xLabels,
          maxY: (maxY + 5).toDouble(),
          maxX: maxX,
          isDark: isDark,
          color: Colors.orange.shade600,
          labelSuffix: 'Projects',
          tooltipColor: isDark ? const Color(0xFF374151) : Colors.white,
          onSpotTapped: (index) {
            final monthStr = xLabels[index] ?? '';
            // Update provider to trigger in-place drill-down
            ref.read(workingReportDrillDownTypeProvider.notifier).state = 'Projects';
            ref.read(workingReportDetailMonthProvider.notifier).state = monthStr;
          },

        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Error loading chart: $e', style: GoogleFonts.inter(fontSize: 12))),
    );
  }
}

class _ConnectedTaskChart extends ConsumerWidget {
  final int selectedYear;
  final bool isDark;
  final String filter;
  final int? userId;

  const _ConnectedTaskChart({
    required this.selectedYear, 
    required this.isDark, 
    required this.filter,
    this.userId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startDate = '$selectedYear-01-01';
    final endDate = '$selectedYear-12-31';
    final chartDataAsync = ref.watch(taskCompletionChartProvider(
        TaskChartParams(
            startDate: startDate, endDate: endDate, filter: filter, userId: userId)));

    return chartDataAsync.when(
      data: (Map<String, dynamic> data) {
        final List<dynamic> rawDataList = data['data'] ?? [];
        final List<FlSpot> spots = [];
        final Map<int, String> xLabels = {};
        double maxY = 0;

        if (rawDataList.isEmpty) {
          final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
          for (int i = 0; i < months.length; i++) {
            spots.add(FlSpot(i.toDouble(), 0));
            xLabels[i] = '${months[i]} $selectedYear';
          }
        } else {
          for (int i = 0; i < rawDataList.length; i++) {
            final item = rawDataList[i];
            final count = (item['count'] as num).toDouble();
            spots.add(FlSpot(i.toDouble(), count));
            xLabels[i] = item['month_year']?.toString() ?? item['date']?.toString() ?? '';
            if (count > maxY) maxY = count;
          }
        }

        double maxX = spots.length.toDouble() - 1;
        if (maxX < 0) maxX = 0;

        return _buildLineChart(
          context: context,
          spots: spots,
          xLabels: xLabels,
          maxY: (maxY + 5).toDouble(),
          maxX: maxX,
          isDark: isDark,
          color: Colors.blue.shade600,
          labelSuffix: 'Tasks',
          onSpotTapped: (index) {
            final monthStr = xLabels[index] ?? '';
            ref.read(workingReportDrillDownTypeProvider.notifier).state = 'Tasks';
            ref.read(workingReportDetailMonthProvider.notifier).state = monthStr;
          },
          tooltipColor: isDark ? const Color(0xFF374151) : Colors.white,
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Error loading chart: $e', style: GoogleFonts.inter(fontSize: 12))),
    );
  }
}

class _ConnectedHoursChart extends ConsumerWidget {
  final int selectedYear;
  final bool isDark;
  final String filter;
  final int? userId;

  const _ConnectedHoursChart({
    required this.selectedYear,
    required this.isDark,
    required this.filter,
    this.userId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final params = ProjectChartParams(year: selectedYear, filter: filter, userId: userId);
    final hoursAsync = ref.watch(hoursCompletionChartProvider(params));

    return hoursAsync.when(
      data: (List<dynamic> data) => _HoursLineChart(
        data: List<Map<String, dynamic>>.from(data),
        isDark: isDark,
        selectedYear: selectedYear,
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text("Error loading hours: $err", style: GoogleFonts.inter(fontSize: 12))),
    );
  }
}

class _HoursLineChart extends ConsumerWidget {
  final List<Map<String, dynamic>> data;
  final bool isDark;
  final int selectedYear;

  const _HoursLineChart({
    required this.data, 
    required this.isDark, 
    required this.selectedYear,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<FlSpot> spots = [];
    final Map<int, String> xLabels = {};
    double maxY = 0;

    if (data.isEmpty) {
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      for (int i = 0; i < months.length; i++) {
        spots.add(FlSpot(i.toDouble(), 0));
        xLabels[i] = '${months[i]} $selectedYear';
      }
    } else {
      for (int i = 0; i < data.length; i++) {
        final item = data[i];
        final achieved = (item['achieved'] as num).toDouble();
        spots.add(FlSpot(i.toDouble(), achieved));
        xLabels[i] = item['month']?.toString() ?? '';
        if (achieved > maxY) maxY = achieved;
      }
    }

    return _buildLineChart(
      spots: spots,
      xLabels: xLabels,
      maxY: (maxY + (maxY * 0.15)).clamp(10, double.infinity),
      maxX: (data.length - 1).toDouble().clamp(0, 11),
      isDark: isDark,
      color: const Color(0xFF6366F1), // Indigo
      labelSuffix: 'Hrs',
      tooltipColor: isDark ? const Color(0xFF374151) : Colors.white,
      context: context,
      onSpotTapped: (index) {
        final monthStr = xLabels[index] ?? '';
        ref.read(workingReportDrillDownTypeProvider.notifier).state = 'Tasks';
        ref.read(workingReportDetailMonthProvider.notifier).state = monthStr;
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Month Detail Sheet
// ─────────────────────────────────────────────────────────────────────────────

class _DrillDownHeader extends ConsumerWidget {
  final String title;
  final VoidCallback onBack;
  final bool isDark;

  const _DrillDownHeader({
    required this.title,
    required this.onBack,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onBack,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade200),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.arrow_back_ios_new_rounded, 
                size: 16, 
                color: isDark ? Colors.white70 : Colors.grey.shade700),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ref.watch(workingReportDrillDownTypeProvider) == 'Projects' 
                  ? "Completed Projects" 
                  : "Completed Tasks",
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade500,
                letterSpacing: 0.5,
              ),
            ),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : const Color(0xFF0D1B2A),
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MonthlyProjectDetailView extends ConsumerWidget {
  final String monthYear;
  final bool isDark;
  final String scope;
  final int? userId;
  final String? searchQuery;

  const _MonthlyProjectDetailView({
    required this.monthYear,
    required this.isDark,
    required this.scope,
    this.userId,
    this.searchQuery,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsAsync = ref.watch(monthlyCompletedProjectsProvider(MonthlyReportParams(
      monthYear: monthYear,
      userId: userId,
      scope: scope,
      search: searchQuery,
    )));

    return SizedBox(
      height: 340,
      child: projectsAsync.when(
        data: (projects) {
          if (projects.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.assignment_turned_in_rounded, size: 48, color: Colors.grey.withValues(alpha: 0.2)),
                  const SizedBox(height: 16),
                  Text(
                    "No projects completed in $monthYear",
                    style: GoogleFonts.inter(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: projects.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final project = projects[index];
              return _ProjectDetailCard(project: project, isDark: isDark);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error loading projects: $e', style: GoogleFonts.inter(fontSize: 12))),
      ),
    );
  }
}

class _ProjectDetailCard extends ConsumerWidget {
  final ProjectModel project;
  final bool isDark;

  const _ProjectDetailCard({required this.project, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final completedAt = project.completedDate != null 
        ? DateFormat('MMM dd, yyyy').format(project.completedDate!)
        : 'Recently';

    return InkWell(
      onTap: () {
        ref.read(selectedProjectIdProvider.notifier).state = 'api_project_${project.id}';
        context.router.navigate(const ProjectPlanRoute());
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.04) : const Color(0xFFF5F8FC),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? const Color(0xFF162D4A) : const Color(0xFFD4E2F0),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.check_circle_outline_rounded, size: 24, color: Colors.orange),
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
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : const Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.calendar_today_rounded, size: 12, color: Colors.grey.shade500),
                      const SizedBox(width: 6),
                      Text(
                        'Completed: $completedAt',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
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

// ─────────────────────────────────────────────────────────────────────────────
// Line Chart Builder (Refined)
// ─────────────────────────────────────────────────────────────────────────────

Widget _buildLineChart({
  required BuildContext context,
  required List<FlSpot> spots,
  required Map<int, String> xLabels,
  required double maxY,
  required double maxX,
  required bool isDark,
  required Color color,
  required String labelSuffix,
  required Color tooltipColor,
  Function(int index)? onSpotTapped,
}) {
  return LineChart(
    LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: maxY > 20 ? (maxY / 5) : 5,
        getDrawingHorizontalLine: (value) => FlLine(
          color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade100,
          strokeWidth: 1.5,
        ),
      ),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) => Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(
                value.toInt().toString(),
                style: GoogleFonts.inter(
                    fontSize: 10,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w600),
              ),
            ),
            reservedSize: 32,
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: (value, meta) {
              final intIndex = value.toInt();
              if (intIndex < 0 || !xLabels.containsKey(intIndex)) {
                return const SizedBox.shrink();
              }
              
              String label = xLabels[intIndex]!;
              String displayLabel = label;
              
              if (label.contains(' ')) {
                final parts = label.split(' ');
                if (parts.length >= 2) {
                  final month = parts[0];
                  final shortMonth = month.length > 3 ? month.substring(0, 3) : month;
                  displayLabel = shortMonth;
                }
              }
              
              return SideTitleWidget(
                meta: meta,
                space: 10,
                child: Text(
                  displayLabel,
                  style: GoogleFonts.inter(
                      fontSize: 10,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w600),
                ),
              );
            },
            reservedSize: 28,
          ),
        ),

        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: maxX > 0 ? maxX : 1,
      minY: 0,
      maxY: maxY == 0 ? 5 : maxY,
      lineBarsData: [
        LineChartBarData(
          spots: spots.isEmpty ? [const FlSpot(0, 0)] : spots,
          isCurved: true,
          color: color,
          barWidth: 4,
          isStrokeCapRound: true,
          shadow: Shadow(color: color.withValues(alpha: 0.2), blurRadius: 10, offset: const Offset(0, 5)),
          dotData: FlDotData(
            show: spots.length < 30,
            getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
              radius: 5,
              color: color,
              strokeWidth: 2.5,
              strokeColor: isDark ? const Color(0xFF111827) : Colors.white,
            ),
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [color.withValues(alpha: 0.2), color.withValues(alpha: 0.0)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
      lineTouchData: LineTouchData(
        handleBuiltInTouches: true,
        touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {
          if (!event.isInterestedForInteractions ||
              touchResponse == null ||
              touchResponse.lineBarSpots == null) {
            return;
          }
          if (event is FlTapDownEvent || event is FlTapUpEvent) {
            final spotIndex = touchResponse.lineBarSpots!.first.x.toInt();
            if (onSpotTapped != null) {
              onSpotTapped(spotIndex);
            }
          }
        },
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (LineBarSpot spot) => tooltipColor,
          tooltipBorderRadius: BorderRadius.circular(10),
          tooltipPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          tooltipMargin: 12,
          getTooltipItems: (List<LineBarSpot> touchedSpots) {
            return touchedSpots.map((LineBarSpot spot) {
              final int index = spot.x.toInt();
              final String label = xLabels[index] ?? '';
              return LineTooltipItem(
                  '$label\n',
                  GoogleFonts.inter(
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: '${spot.y.toInt()} $labelSuffix\n',
                      style: GoogleFonts.outfit(
                        color: isDark ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                    TextSpan(
                      text: 'Tap to view list',
                      style: GoogleFonts.inter(
                        color: Colors.blue.shade400,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ]);
            }).toList();

          },
        ),
      ),
    ),
  );
}

class _MonthlyTaskDetailView extends ConsumerWidget {
  final String monthYear;
  final bool isDark;
  final String scope;
  final int? userId;
  final String? searchQuery;

  const _MonthlyTaskDetailView({
    required this.monthYear,
    required this.isDark,
    required this.scope,
    this.userId,
    this.searchQuery,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(monthlyCompletedTasksProvider(MonthlyReportParams(
      monthYear: monthYear,
      userId: userId,
      scope: scope,
      search: searchQuery,
    )));

    return Column(
      children: [
        tasksAsync.when(
          data: (tasks) {
            if (tasks.isEmpty) {
              return SizedBox(
                height: 200,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.assignment_turned_in_outlined, 
                        size: 48, 
                        color: isDark ? Colors.white24 : Colors.grey.shade300),
                      const SizedBox(height: 16),
                      Text(
                        "No tasks completed in $monthYear",
                        style: GoogleFonts.inter(
                          color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: tasks.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) => _TaskDetailCard(
                task: tasks[index],
                isDark: isDark,
              ),
            );
          },
          loading: () => const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (err, stack) => const SizedBox(
            height: 200,
            child: Center(child: Text('Error loading tasks')),
          ),
        ),
      ],
    );
  }
}

class _TaskDetailCard extends StatelessWidget {
  final TaskModel task;
  final bool isDark;

  const _TaskDetailCard({
    required this.task,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade100,
        ),
        boxShadow: [
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
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.check_circle_outline, color: Colors.blue, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF0D1B2A),
                  ),
                ),
                if (task.projectName != null)
                  Text(
                    task.projectName!,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Done',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

