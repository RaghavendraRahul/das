import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:project_pm/src/core/networking/api_client.dart';

// ─── Models ───────────────────────────────────────────────────────────────────

class ProjectHoursData {
  final int id;
  final String projectName;
  final int totalMinutes;
  final double hours;
  final double percentage;

  const ProjectHoursData({
    required this.id,
    required this.projectName,
    required this.totalMinutes,
    required this.hours,
    required this.percentage,
  });

  factory ProjectHoursData.fromJson(Map<String, dynamic> j) => ProjectHoursData(
        id: j['id'] ?? 0,
        projectName: j['name'] ?? 'Unknown',
        totalMinutes: j['minutes'] ?? 0,
        hours: (j['hours'] ?? 0).toDouble(),
        percentage: (j['percentage'] ?? 0).toDouble(),
      );

  String get display => '${hours.toStringAsFixed(1)}h';
}

class WorkingHoursReport {
  final double totalHours;
  final int totalMinutes;
  final List<ProjectHoursData> projects;

  const WorkingHoursReport({
    required this.totalHours,
    required this.totalMinutes,
    required this.projects,
  });

  factory WorkingHoursReport.fromJson(Map<String, dynamic> j) {
    return WorkingHoursReport(
      totalHours: (j['total_hours'] ?? 0).toDouble(),
      totalMinutes: j['total_minutes'] ?? 0,
      projects: (j['projects'] as List? ?? [])
          .map((e) => ProjectHoursData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  String get totalDisplay => '${totalHours.toStringAsFixed(1)}h';
}

class TaskBreakdown {
  final int id;
  final String title;
  final int minutes;
  final int completionPercentage;
  final List<SubTaskBreakdown> subtasks;

  const TaskBreakdown({
    required this.id,
    required this.title,
    required this.minutes,
    required this.completionPercentage,
    required this.subtasks,
  });

  factory TaskBreakdown.fromJson(Map<String, dynamic> j) => TaskBreakdown(
        id: j['id'] ?? 0,
        title: j['title'] ?? 'Unknown',
        minutes: j['minutes'] ?? 0,
        completionPercentage: j['completion_percentage'] ?? 0,
        subtasks: (j['subtasks'] as List? ?? [])
            .map((e) => SubTaskBreakdown.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  String get minutesDisplay => '${(minutes / 60).toStringAsFixed(1)}h';
}

class SubTaskBreakdown {
  final int id;
  final String title;
  final String status;
  final int weight;

  const SubTaskBreakdown({
    required this.id,
    required this.title,
    required this.status,
    required this.weight,
  });

  factory SubTaskBreakdown.fromJson(Map<String, dynamic> j) => SubTaskBreakdown(
        id: j['id'] ?? 0,
        title: j['title'] ?? 'Unknown',
        status: j['status'] ?? 'TODO',
        weight: j['weight'] ?? 0,
      );
}

class TeamActivityStatus {
  final String date;
  final int dailyTargetHours;
  final int totalUsers;
  final int filledCount;
  final int filledPct;
  final int notFilledCount;
  final int notFilledPct;

  const TeamActivityStatus({
    required this.date,
    required this.dailyTargetHours,
    required this.totalUsers,
    required this.filledCount,
    required this.filledPct,
    required this.notFilledCount,
    required this.notFilledPct,
  });

  factory TeamActivityStatus.fromJson(Map<String, dynamic> j) =>
      TeamActivityStatus(
        date: j['date'] ?? '',
        dailyTargetHours: j['daily_target_hours'] ?? 9,
        totalUsers: j['total_users'] ?? 0,
        filledCount: (j['filled'] as Map?)?['count'] ?? 0,
        filledPct: (j['filled'] as Map?)?['percentage'] ?? 0,
        notFilledCount: (j['not_filled'] as Map?)?['count'] ?? 0,
        notFilledPct: (j['not_filled'] as Map?)?['percentage'] ?? 0,
      );
}

// ─── Providers ────────────────────────────────────────────────────────────────

final _workingHoursParamsProvider = StateProvider<({String? from, String? to})>(
  (ref) => (
    from: DateFormat('yyyy-MM-dd').format(DateTime.now()),
    to: DateFormat('yyyy-MM-dd').format(DateTime.now())
  ),
);

final projectWorkingHoursProvider =
    FutureProvider.autoDispose<WorkingHoursReport>((ref) async {
  ref.keepAlive(); // Cache component
  final dio = ref.watch(dioProvider);
  final params = ref.watch(_workingHoursParamsProvider);
  final qp = <String, String>{};
  if (params.from != null) qp['startDate'] = params.from!;
  if (params.to != null) qp['endDate'] = params.to!;
  final res = await dio.get('project-working-hours/',
      queryParameters: qp.isEmpty ? null : qp);
  return WorkingHoursReport.fromJson(res.data as Map<String, dynamic>);
});

final drillDownProvider = FutureProvider.autoDispose
    .family<List<TaskBreakdown>, int>((ref, projectId) async {
  ref.keepAlive(); // Cache drill-downs
  final dio = ref.watch(dioProvider);
  final params = ref.watch(_workingHoursParamsProvider);
  final qp = <String, String>{};
  if (params.from != null) qp['startDate'] = params.from!;
  if (params.to != null) qp['endDate'] = params.to!;
  final res = await dio.get('project-working-hours/$projectId/drilldown/',
      queryParameters: qp.isEmpty ? null : qp);
  return (res.data as List).map((e) => TaskBreakdown.fromJson(e)).toList();
});

final teamActivityStatusProvider =
    FutureProvider.autoDispose<TeamActivityStatus>((ref) async {
  ref.keepAlive(); // Cache component
  final dio = ref.watch(dioProvider);
  final res = await dio.get('team-activity-status/today/');
  return TeamActivityStatus.fromJson(res.data as Map<String, dynamic>);
});

// ─── Chart Colors ─────────────────────────────────────────────────────────────

const _chartColors = [
  Color(0xFF4F46E5), // Indigo 600
  Color(0xFF0D9488), // Teal 600
  Color(0xFFD97706), // Amber 600
  Color(0xFFE11D48), // Rose 600
  Color(0xFF0891B2), // Cyan 600
  Color(0xFF7C3AED), // Violet 600
  Color(0xFF2563EB), // Blue 600
  Color(0xFF059669), // Emerald 600
];

final List<BoxShadow> _softShadow = [
  BoxShadow(
    color: Colors.black.withOpacity(0.04),
    blurRadius: 10,
    offset: const Offset(0, 4),
  ),
  BoxShadow(
    color: Colors.black.withOpacity(0.02),
    blurRadius: 4,
    offset: const Offset(0, 1),
  ),
];

Color _colorForIndex(int i) => _chartColors[i % _chartColors.length];

class _ChartPalette {
  static LinearGradient getGradient(int i, [bool isDimmed = false]) {
    final baseColor = _chartColors[i % _chartColors.length];
    return LinearGradient(
      colors: [
        baseColor.withOpacity(isDimmed ? 0.4 : 1.0),
        baseColor.withOpacity(isDimmed ? 0.2 : 0.7),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PROJECT WORKING HOURS CARD
// ─────────────────────────────────────────────────────────────────────────────

class ProjectWorkingHoursCard extends ConsumerStatefulWidget {
  const ProjectWorkingHoursCard({super.key});

  @override
  ConsumerState<ProjectWorkingHoursCard> createState() =>
      _ProjectWorkingHoursCardState();
}

class _ProjectWorkingHoursCardState
    extends ConsumerState<ProjectWorkingHoursCard> {
  int? _hoveredIndex;
  DateTime? _fromDate = DateTime.now();
  DateTime? _toDate = DateTime.now();

  final _apiDateFmt = DateFormat('yyyy-MM-dd');
  final _displayDateFmt = DateFormat('dd-MM-yyyy');

  Future<void> _pickDate(bool isFrom) async {
    final picked = await showDatePicker(
      context: context,
      initialDate:
          isFrom ? (_fromDate ?? DateTime.now()) : (_toDate ?? DateTime.now()),
      firstDate: DateTime(2023),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (picked == null) return;
    setState(() {
      if (isFrom) {
        _fromDate = picked;
        if (_toDate != null && _fromDate!.isAfter(_toDate!)) {
          _toDate = _fromDate;
        }
      } else {
        _toDate = picked;
        if (_fromDate != null && _toDate!.isBefore(_fromDate!)) {
          _fromDate = _toDate;
        }
      }
    });
    ref.read(_workingHoursParamsProvider.notifier).state = (
      from: _fromDate != null ? _apiDateFmt.format(_fromDate!) : null,
      to: _toDate != null ? _apiDateFmt.format(_toDate!) : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final reportAsync = ref.watch(projectWorkingHoursProvider);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Working Hours Report',
                    style: GoogleFonts.outfit(
                      fontSize: 20, // Slightly smaller than the main chart but still Heroic
                      fontWeight: FontWeight.w900,
                      color: isDark ? Colors.white : const Color(0xFF111827),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.indigo.shade600,
                          Colors.indigo.shade300,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
              reportAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
                data: (r) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.indigo.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    r.totalDisplay,
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Colors.indigo.shade600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Date range pickers
          Row(
            children: [
              Expanded(
                  child: _DatePicker(
                label: _fromDate != null
                    ? _displayDateFmt.format(_fromDate!)
                    : 'dd-mm-yyyy',
                onTap: () => _pickDate(true),
              )),
              const SizedBox(width: 8),
              Expanded(
                  child: _DatePicker(
                label: _toDate != null
                    ? _displayDateFmt.format(_toDate!)
                    : 'dd-mm-yyyy',
                onTap: () => _pickDate(false),
              )),
            ],
          ),
          const SizedBox(height: 10),

          // Chart fills remaining space
          Expanded(
            child: reportAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                  child: Text('Error: $e',
                      style: const TextStyle(color: Colors.red))),
              data: (report) {
                if (report.projects.isEmpty) {
                  return const Center(
                      child: Text('No data for selected period',
                          style: TextStyle(color: Colors.grey)));
                }
                return _DonutWithLegend(
                  report: report,
                  hoveredIndex: _hoveredIndex,
                  onHover: (i) => setState(() => _hoveredIndex = i),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DatePicker extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _DatePicker({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(
            color: isDark ? const Color(0xFF4B5563) : const Color(0xFFD1D5DB),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: isDark ? Colors.white70 : const Color(0xFF6B7280),
                ),
              ),
            ),
            const Icon(Icons.calendar_month_outlined,
                size: 16, color: Color(0xFF9CA3AF)),
          ],
        ),
      ),
    );
  }
}

class _DonutWithLegend extends ConsumerStatefulWidget {
  final WorkingHoursReport report;
  final int? hoveredIndex;
  final void Function(int?) onHover;

  const _DonutWithLegend({
    required this.report,
    required this.hoveredIndex,
    required this.onHover,
  });

  @override
  ConsumerState<_DonutWithLegend> createState() => _DonutWithLegendState();
}

class _DonutWithLegendState extends ConsumerState<_DonutWithLegend> {
  int? _touchedIndex;

  void _showDrillDown(ProjectHoursData project) {
    showDialog(
      context: context,
      builder: (context) => ProjectDrillDownDialog(project: project),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final projects = List<ProjectHoursData>.from(widget.report.projects);
    // Sort projects by hours to find the most dominant project
    projects.sort((a, b) => b.totalMinutes.compareTo(a.totalMinutes));

    final totalMinutes = widget.report.totalMinutes;
    if (totalMinutes == 0) return const SizedBox.shrink();

    // ── Outer Ring: All Projects ──────────────────────────────
    final outerSections = projects.asMap().entries.map((e) {
      final i = e.key;
      final p = e.value;
      final isTouched = _touchedIndex == i;
      
      // Find original index for color consistency
      final originalIdx = widget.report.projects.indexOf(p);

      return PieChartSectionData(
        value: p.totalMinutes.toDouble(),
        color: _colorForIndex(originalIdx),
        gradient: _ChartPalette.getGradient(originalIdx, _touchedIndex != null && !isTouched),
        radius: isTouched ? 38 : 34,
        showTitle: false,
        borderSide: BorderSide(
          color: isDark ? const Color(0xFF1F2937) : Colors.white,
          width: 2,
        ),
      );
    }).toList();

    // ── Inner Ring: Top Project vs Others (Concentration) ──────
    final topProject = projects.first;
    final othersMinutes = totalMinutes - topProject.totalMinutes;
    
    final innerSections = [
      // Top Project segment
      PieChartSectionData(
        value: topProject.totalMinutes.toDouble(),
        color: _colorForIndex(widget.report.projects.indexOf(topProject)),
        radius: 12,
        showTitle: false,
        borderSide: BorderSide(
          color: isDark ? const Color(0xFF1F2937).withOpacity(0.5) : Colors.white60,
          width: 4,
        ),
      ),
      // Others segment (Combined)
      if (othersMinutes > 0)
        PieChartSectionData(
          value: othersMinutes.toDouble(),
          color: isDark ? const Color(0xFF374151) : const Color(0xFFF3F4F6),
          radius: 8,
          showTitle: false,
        ),
    ];

    return Column(
      children: [
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // ── Concentric Layout ─────────────────────────────
              // Inner Ring (Summary Context)
              PieChart(
                PieChartData(
                  sections: innerSections,
                  centerSpaceRadius: 42,
                  sectionsSpace: 0,
                  startDegreeOffset: 270,
                ),
                swapAnimationDuration: const Duration(milliseconds: 800),
                swapAnimationCurve: Curves.easeInOutBack,
              ),
              
              // Outer Ring (Detailed Breakdown)
              PieChart(
                PieChartData(
                  sections: outerSections,
                  centerSpaceRadius: 62,
                  sectionsSpace: 3,
                  startDegreeOffset: 270,
                  pieTouchData: PieTouchData(
                    touchCallback: (event, response) {
                      if (!event.isInterestedForInteractions ||
                          response == null ||
                          response.touchedSection == null) {
                        setState(() => _touchedIndex = null);
                        return;
                      }
                      final index = response.touchedSection!.touchedSectionIndex;
                      setState(() => _touchedIndex = index);

                      if (event is FlTapUpEvent) {
                        if (index >= 0 && index < projects.length) {
                          _showDrillDown(projects[index]);
                        }
                      }
                    },
                  ),
                ),
                swapAnimationDuration: const Duration(milliseconds: 1000),
                swapAnimationCurve: Curves.elasticOut,
              ),

              // ── Central Info Display ──────────────────────────
              _CentralInfo(
                isDark: isDark,
                touchedProject: (_touchedIndex != null && _touchedIndex! >= 0 && _touchedIndex! < projects.length)
                    ? projects[_touchedIndex!]
                    : null,
                totalProjects: projects.length,
                totalDisplay: widget.report.totalDisplay,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // ── Professional Legend Wrap ───────────────────────────
        _Legend(
          projects: widget.report.projects,
          selectedIndex: (_touchedIndex != null && _touchedIndex! >= 0 && _touchedIndex! < projects.length)
              ? widget.report.projects.indexOf(projects[_touchedIndex!])
              : null,
          onTap: (p) => _showDrillDown(p),
        ),
      ],
    );
  }
}

class _CentralInfo extends StatelessWidget {
  final bool isDark;
  final ProjectHoursData? touchedProject;
  final int totalProjects;
  final String totalDisplay;

  const _CentralInfo({
    required this.isDark,
    this.touchedProject,
    required this.totalProjects,
    required this.totalDisplay,
  });

  @override
  Widget build(BuildContext context) {
    if (touchedProject != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _colorForIndex(touchedProject!.id).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              touchedProject!.display,
              style: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : const Color(0xFF111827),
              ),
            ),
          ),
          const SizedBox(height: 2),
          SizedBox(
            width: 80,
            child: Text(
              touchedProject!.projectName,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white60 : const Color(0xFF6B7280),
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          totalDisplay,
          style: GoogleFonts.outfit(
            fontSize: 26,
            fontWeight: FontWeight.w900,
            color: isDark ? Colors.white : const Color(0xFF111827),
          ),
        ),
        Text(
          '$totalProjects Projects',
          style: GoogleFonts.inter(
            fontSize: 10,
            letterSpacing: 0.5,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white38 : const Color(0xFF9CA3AF),
          ),
        ),
      ],
    );
  }
}

class _Legend extends StatelessWidget {
  final List<ProjectHoursData> projects;
  final int? selectedIndex;
  final ValueChanged<ProjectHoursData> onTap;

  const _Legend({
    required this.projects,
    this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Wrap(
      spacing: 12,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: projects.asMap().entries.map((e) {
        final i = e.key;
        final p = e.value;
        final isSelected = selectedIndex == i;

        return InkWell(
          onTap: () => onTap(p),
          borderRadius: BorderRadius.circular(8),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isSelected
                  ? _colorForIndex(i).withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? _colorForIndex(i).withOpacity(0.3) : Colors.transparent,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    gradient: _ChartPalette.getGradient(i),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: _colorForIndex(i).withOpacity(0.4),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  p.projectName,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isDark
                        ? (isSelected ? Colors.white : Colors.white70)
                        : (isSelected ? const Color(0xFF111827) : const Color(0xFF4B5563)),
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  p.display,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: isDark ? Colors.white38 : const Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class ProjectDrillDownDialog extends ConsumerWidget {
  final ProjectHoursData project;
  const ProjectDrillDownDialog({super.key, required this.project});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final breakdownAsync = ref.watch(drillDownProvider(project.id));

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 500,
        constraints: const BoxConstraints(maxHeight: 600),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project.projectName,
                        style: GoogleFonts.outfit(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Detailed Working Hours Breakdown',
                        style: GoogleFonts.inter(
                            fontSize: 12, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const Divider(height: 32),
            Expanded(
              child: breakdownAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
                data: (tasks) {
                  if (tasks.isEmpty) {
                    return const Center(
                        child: Text('No detailed task data found'));
                  }
                  return ListView.separated(
                    itemCount: tasks.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  task.title,
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Text(
                                task.minutesDisplay,
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.blue.shade700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          LinearProgressIndicator(
                            value: task.completionPercentage / 100,
                            backgroundColor: Colors.grey.shade200,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              task.completionPercentage == 100
                                  ? Colors.green
                                  : Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Completion: ${task.completionPercentage}%',
                            style: GoogleFonts.inter(
                                fontSize: 10, color: Colors.grey.shade500),
                          ),
                          if (task.subtasks.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Column(
                                children: task.subtasks.map((st) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 4),
                                    child: Row(
                                      children: [
                                        Icon(
                                          st.status == 'DONE'
                                              ? Icons.check_circle
                                              : Icons.radio_button_unchecked,
                                          size: 14,
                                          color: st.status == 'DONE'
                                              ? Colors.green
                                              : Colors.grey,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            st.title,
                                            style: GoogleFonts.inter(
                                                fontSize: 12,
                                                color: Colors.grey.shade700),
                                          ),
                                        ),
                                        Text(
                                          '${st.weight}%',
                                          style: GoogleFonts.inter(
                                              fontSize: 10,
                                              color: Colors.grey.shade400),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TEAM ACTIVITY STATUS CARD
// ─────────────────────────────────────────────────────────────────────────────

class TeamActivityStatusCard extends ConsumerWidget {
  const TeamActivityStatusCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final statusAsync = ref.watch(teamActivityStatusProvider);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Team Activity Status',
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Daily Capacity Target: 9 Hours',
            style:
                GoogleFonts.inter(fontSize: 12, color: const Color(0xFF9CA3AF)),
          ),
          const SizedBox(height: 20),
          statusAsync.when(
            loading: () => const SizedBox(
                height: 130, child: Center(child: CircularProgressIndicator())),
            error: (e, _) => SizedBox(
              height: 80,
              child: Center(
                  child: Text('Error: $e',
                      style: const TextStyle(color: Colors.red))),
            ),
            data: (s) => _ActivityStatusBody(status: s),
          ),
        ],
      ),
    );
  }
}

class _ActivityStatusBody extends StatelessWidget {
  final TeamActivityStatus status;
  const _ActivityStatusBody({required this.status});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final total = status.totalUsers;
    final filledPct = total > 0 ? status.filledCount / total : 0.0;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Donut ring (orange)
        SizedBox(
          width: 110,
          height: 110,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: const Size(110, 110),
                painter: _RingPainter(filledFraction: filledPct),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$total',
                    style: GoogleFonts.outfit(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF111827),
                    ),
                  ),
                  Text(
                    'Users',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: isDark ? Colors.white60 : const Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 20),
        // Legend rows
        Expanded(
          child: Column(
            children: [
              _StatusRow(
                color: const Color(0xFF16A34A),
                label: 'Filled (≥ 9h)',
                count: status.filledCount,
                pct: status.filledPct,
                bgColor: const Color(0xFFF0FDF4),
              ),
              const SizedBox(height: 8),
              _StatusRow(
                color: const Color(0xFFF97316),
                label: 'Not Filled (< 9h)',
                count: status.notFilledCount,
                pct: status.notFilledPct,
                bgColor: const Color(0xFFFFF7ED),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatusRow extends StatelessWidget {
  final Color color;
  final String label;
  final int count;
  final int pct;
  final Color bgColor;

  const _StatusRow({
    required this.color,
    required this.label,
    required this.count,
    required this.pct,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.inter(
                  fontSize: 12, color: const Color(0xFF374151)),
            ),
          ),
          Text(
            '$count',
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF111827),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '$pct%',
            style:
                GoogleFonts.inter(fontSize: 11, color: const Color(0xFF9CA3AF)),
          ),
        ],
      ),
    );
  }
}

/// Custom painter for the orange ring
class _RingPainter extends CustomPainter {
  final double filledFraction;
  const _RingPainter({required this.filledFraction});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;
    const strokeWidth = 14.0;

    // Background ring
    final bgPaint = Paint()
      ..color = const Color(0xFFF3F4F6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // Filled arc — orange for not-filled, green for filled
    if (filledFraction > 0) {
      final filledPaint = Paint()
        ..color = const Color(0xFF16A34A)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        2 * math.pi * filledFraction,
        false,
        filledPaint,
      );
    }

    // Orange arc for not-filled portion
    final notFilledPaint = Paint()
      ..color = const Color(0xFFF97316)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final notFilledFraction = 1.0 - filledFraction;
    if (notFilledFraction > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2 + 2 * math.pi * filledFraction,
        2 * math.pi * notFilledFraction,
        false,
        notFilledPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.filledFraction != filledFraction;
}
