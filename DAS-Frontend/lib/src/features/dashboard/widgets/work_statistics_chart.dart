import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:project_pm/src/features/dashboard/dashboard_providers.dart';
import '../dashboard_state.dart';


// ─────────────────────────────────────────────────────────────────────────────
// Colour palette shared across charts
// ─────────────────────────────────────────────────────────────────────────────
const _palette = [
  [Color(0xFF05263E), Color(0xFF1E88E5)], // Brand Blue
  [Color(0xFF2563EB), Color(0xFF60A5FA)], // Royal Blue
  [Color(0xFF3B82F6), Color(0xFF93C5FD)], // Sky Blue
  [Color(0xFF64748B), Color(0xFF94A3B8)], // Slate Blue
  [Color(0xFF0EA5E9), Color(0xFF7DD3FC)], // Cyan Blue
  [Color(0xFF4F46E5), Color(0xFF818CF8)], // Indigo Blue
];

final List<BoxShadow> _premiumShadow = [
  BoxShadow(
    color: Colors.black.withValues(alpha: 0.12),
    blurRadius: 32,
    offset: const Offset(0, 16),
  ),
  BoxShadow(
    color: Colors.black.withValues(alpha: 0.04),
    blurRadius: 8,
    offset: const Offset(0, 2),
  ),
];

final List<BoxShadow> _softShadow = [
  BoxShadow(
    color: Colors.black.withValues(alpha: 0.04),
    blurRadius: 10,
    offset: const Offset(0, 4),
  ),
  BoxShadow(
    color: Colors.black.withValues(alpha: 0.02),
    blurRadius: 4,
    offset: const Offset(0, 1),
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
// Root widget
// ─────────────────────────────────────────────────────────────────────────────
class WorkStatisticsChart extends HookConsumerWidget {
  final String? selectedStatus;
  final Function(String?)? onStatusSelected;
  final String? searchQuery;
  final Function(String viewMode)? onNavigateToProject;

  const WorkStatisticsChart({
    super.key,
    this.selectedStatus,
    this.onStatusSelected,
    this.searchQuery,
    this.onNavigateToProject,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(usersForStatsProvider);
    final statsAsync = ref.watch(projectWorkStatsProvider);

    // Auto-selection removed as per new "Selection-First" policy. 
    // The dropdown will now default to "Select User" and no metrics will show until picked.
    // Cascading resets and logic are now managed internally by ProjectAnalyticsController

    // ── Loading / error shells ────────────────────────────────────────────────
    return usersAsync.when(
      loading: () => const _ShellBox(child: CircularProgressIndicator()),
      error: (e, _) => _ShellBox(child: Text('Error: $e')),
      data: (users) {
        return statsAsync.when(
          loading: () =>
              const _ShellBox(child: CircularProgressIndicator()),
          error: (e, _) =>
              _ShellBox(child: Text('Error loading stats: $e')),
          data: (stats) => _Body(
            users: users.cast<Map<String, dynamic>>(),
            stats: stats,
          ),
        );
      },
    );
  }
}

class _Body extends HookConsumerWidget {
  final List<Map<String, dynamic>> users;
  final Map<String, dynamic> stats;

  const _Body({required this.users, required this.stats});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedProjectId = ref.watch(projectAnalyticsControllerProvider.select((s) => s.selectedProjectId));

    final List<dynamic> projects = stats['projects'] ?? [];
    final Map<String, dynamic>? selProject = selectedProjectId != null
        ? projects
            .cast<Map<String, dynamic>>()
            .where((p) => p['id'] == selectedProjectId)
            .firstOrNull
        : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(
            users: users, 
            stats: stats,
            onRefresh: () => ref.invalidate(projectWorkStatsProvider),
          ),
          const SizedBox(height: 12), // Reduced spacing
          _KpiRow(stats: stats, isDark: isDark),
          const SizedBox(height: 12), // Reduced spacing
          Expanded(
            child: _DonutSection(
              stats: stats,
              selectedProject: selProject,
              isDark: isDark,
            ),
          ),

        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Header — Title + Selectors
// ─────────────────────────────────────────────────────────────────────────────
class _Header extends ConsumerWidget {
  final List<Map<String, dynamic>> users;
  final Map<String, dynamic> stats;
  final VoidCallback onRefresh;

  const _Header({required this.users, required this.stats, required this.onRefresh});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final analyticsState = ref.watch(projectAnalyticsControllerProvider);
    final selectedUserId = analyticsState.selectedUserId;
    final selectedProjectId = analyticsState.selectedProjectId;
    final selectedClientId = analyticsState.selectedClientId;
    final controller = ref.read(projectAnalyticsControllerProvider.notifier);
    
    // Use the proper API-driven providers
    final projectsAsync = ref.watch(statsProjectsProvider);
    final allProjects = projectsAsync.value ?? [];
    
    final clientsAsync = ref.watch(clientsForStatsProvider);
    final allClients = clientsAsync.value ?? [];

    String projectLabel = 'All Projects';
    if (projectsAsync.isLoading) {
      projectLabel = 'Loading projects…';
    } else if (selectedProjectId != null) {
      final found = allProjects.cast<Map<String, dynamic>?>().where(
        (p) => p?['id'] == selectedProjectId,
      ).firstOrNull;
      if (found != null) {
        projectLabel = found['name'] as String;
      } else {
        projectLabel = 'All Projects';
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Project Analytics',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: isDark ? const Color(0xFFB0DFFF) : const Color(0xFF05263E),
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        const Spacer(),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            // Client Dropdown
            Container(
              height: 32,
              width: 140, // Added fixed width for visibility
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0B1A2E) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? const Color(0xFF162D4A) : const Color(0xFFD4E2F0),
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int?>(
                  value: allClients.any((c) => c['id'] == selectedClientId) ? selectedClientId : null,
                  hint: Text(clientsAsync.isLoading ? 'Loading...' : 'Select Client',
                      style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: isDark ? const Color(0xFFE0F2FE) : const Color(0xFF4B6A8A))),
                  icon: Icon(Icons.keyboard_arrow_down_rounded,
                      size: 16, color: isDark ? const Color(0xFF7EC8F4) : Colors.grey.shade500),
                  isDense: true,
                  isExpanded: true, // Added isExpanded
                  dropdownColor: isDark ? const Color(0xFF0B1A2E) : Colors.white,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white : const Color(0xFF0D1B2A),
                  ),
                  items: [
                    const DropdownMenuItem<int?>(
                      value: null,
                      child: Text('All Clients', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                    ),
                    ...allClients.map((c) => DropdownMenuItem<int?>(
                          value: c['id'] as int,
                          child: Text((c['client_name'] ?? c['name'] ?? 'Unknown') as String),
                        )),
                  ],
                  onChanged: (val) {
                    controller.setClient(val);
                  },
                ),
              ),
            ),
            _SelectorPill(
              label: projectLabel,
              icon: Icons.assignment_outlined,
              isDark: isDark,
              onTap: projectsAsync.isLoading
                  ? () {} 
                  : () => _showProjectPicker(context, ref, allProjects, controller),
            ),
            Container(
              height: 32,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0B1A2E) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? const Color(0xFF162D4A) : const Color(0xFFD4E2F0),
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int?>(
                  value: users.any((u) => u['id'] == selectedUserId)
                      ? selectedUserId
                      : null,
                  hint: Text('Select User',
                      style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: isDark ? const Color(0xFFE0F2FE) : const Color(0xFF4B6A8A))),
                  icon: Icon(Icons.keyboard_arrow_down_rounded,
                      size: 16, color: isDark ? const Color(0xFF7EC8F4) : Colors.grey.shade500),
                  isDense: true,
                  dropdownColor:
                      isDark ? const Color(0xFF0B1A2E) : Colors.white,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white : const Color(0xFF0D1B2A),
                  ),
                  items: [
                    DropdownMenuItem<int?>(
                      value: null,
                      child: Text('All Users', style: TextStyle(color: isDark ? Colors.blue.shade300 : Colors.blue.shade700, fontWeight: FontWeight.bold)),
                    ),
                    ...users.map((u) => DropdownMenuItem<int?>(
                          value: u['id'] as int,
                          child: Text(u['name'] as String),
                        )),
                  ],
                  onChanged: (val) {
                    controller.setUser(val);
                  },
                ),
              ),
            ),
            IconButton(
              onPressed: onRefresh,
              icon: const Icon(Icons.refresh),
              iconSize: 18,
              color: Colors.grey.shade600,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ],
    );
  }

  void _showProjectPicker(
      BuildContext context, WidgetRef ref, List<dynamic> projects, ProjectAnalyticsController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ProjectPickerSheet(
        projects: projects,
        onSelect: (id) {
          controller.setProject(id);
          Navigator.pop(context);
        },
      ),
    );
  }
}

class _KpiRow extends StatelessWidget {
  final Map<String, dynamic> stats;
  final bool isDark;
 
  const _KpiRow({required this.stats, required this.isDark});
 
  @override
  Widget build(BuildContext context) {
    final planned = (stats['totals']?['planned_hours'] ?? stats['total_planned_hours'] ?? 0.0).toDouble();
    final achieved = (stats['totals']?['achieved_hours'] ?? stats['total_achieved_hours'] ?? 0.0).toDouble();
    final remaining = (planned - achieved).clamp(0.0, double.infinity);
 
    return LayoutBuilder(builder: (context, constraints) {
      const double spacing = 20;
      // Narrow the row by adding horizontal padding
      const double horizontalPadding = 60;
      final double cardWidth = (constraints.maxWidth - (horizontalPadding * 2) - (spacing * 2)) / 3;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _StatCard(
              title: 'Planned Hours',
              value: '${planned.toStringAsFixed(1)}',
              color: const Color(0xFF05263E),
              icon: Icons.timer_rounded,
              width: cardWidth,
              isDark: isDark,
            ),
            const SizedBox(width: spacing),
            _StatCard(
              title: 'Achieved Hours',
              value: '${achieved.toStringAsFixed(1)}',
              color: const Color(0xFF05263E),
              icon: Icons.check_circle_rounded,
              width: cardWidth,
              isDark: isDark,
            ),
            const SizedBox(width: spacing),
            _StatCard(
              title: 'Remaining Hours',
              value: '${remaining.toStringAsFixed(1)}',
              color: const Color(0xFF05263E),
              icon: Icons.pending_actions_rounded,
              width: cardWidth,
              isDark: isDark,
            ),
          ],
        ),
      );
    });
  }
}

class _StatCard extends HookWidget {
  final String title;
  final String value;
  final Color color;
  final IconData icon;
  final double width;
  final bool isDark;

  const _StatCard({
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
    required this.width,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final isHovered = useState(false);

    return MouseRegion(
      onEnter: (_) => isHovered.value = true,
      onExit: (_) => isHovered.value = false,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: width,
        height: 74, // Refined height for no overflow but smaller size
        padding: const EdgeInsets.symmetric(horizontal: 12),
        transform: Matrix4.diagonal3Values(
            isHovered.value ? 1.02 : 1.0, isHovered.value ? 1.02 : 1.0, 1.0),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0B1A2E) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: isHovered.value ? _premiumShadow : [
            BoxShadow(
              color: const Color(0xFF05263E).withValues(alpha: isDark ? 0.15 : 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: isHovered.value
                ? color.withValues(alpha: 0.4)
                : (isDark ? const Color(0xFF162D4A) : const Color(0xFFD4E2F0)),
            width: 1,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -10,
              bottom: -10,
              child: Icon(
                icon,
                size: 60,
                color: color.withValues(alpha: 0.04),
              ),
            ),
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 16, color: color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.white70 : Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Flexible(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                value,
                                style: GoogleFonts.outfit(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  color: isDark ? (color == const Color(0xFF05263E) ? const Color(0xFFD1E9FF) : color) : color,
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'hours',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: isDark ? Colors.white54 : Colors.grey.shade400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

 
// ─────────────────────────────────────────────────────────────────────────────
// Donut Section — Planned Tasks  |  Achieved Progress
// ─────────────────────────────────────────────────────────────────────────────
class _DonutSection extends StatelessWidget {
  final Map<String, dynamic> stats;
  final Map<String, dynamic>? selectedProject;
  final bool isDark;
 
  const _DonutSection({
    required this.stats,
    required this.selectedProject,
    required this.isDark,
  });
 
  @override
  Widget build(BuildContext context) {
    final List<_Slice> plannedSlices;
    final String plannedCenter;
    final String plannedSub;
 
    final tasks = (stats['tasks'] as List? ?? []).cast<Map<String, dynamic>>();
    
    plannedSlices = tasks.asMap().entries.map((e) {
      final h = (e.value['planned_hours'] as num? ?? 0).toDouble();
      return _Slice(
        value: h,
        color: _palette[e.key % _palette.length][0],
        label: e.value['name'] as String? ?? 'Task ${e.key + 1}',
      );
    }).where((s) => s.value > 0).toList();
 
    final totalPlanned = (stats['totals']?['planned_hours'] ?? stats['total_planned_hours'] ?? 0.0).toDouble();
    plannedCenter = '${totalPlanned.toStringAsFixed(0)}h';
    
    final totalT = tasks.length;
    final workedT = tasks.where((t) => (t['achieved_hours'] as num? ?? 0) > 0).length;
    
    plannedSub = selectedProject != null 
        ? '$workedT/$totalT Tasks Worked'
        : '$totalT Active Tasks';

    final double planned = totalPlanned;
    final double achieved = (stats['totals']?['achieved_hours'] ?? stats['total_achieved_hours'] ?? 0.0).toDouble();
    final double remaining = (planned - achieved).clamp(0.0, double.infinity);
    final double achievedRate = planned > 0 ? (achieved / planned * 100).clamp(0, 100) : 0;
 
    final List<_Slice> achievedSlices;
    achievedSlices = tasks.asMap().entries.map((e) {
      final ah = (e.value['achieved_hours'] as num? ?? 0).toDouble();
      return _Slice(
        value: ah,
        color: _palette[e.key % _palette.length][0],
        label: e.value['name'] as String? ?? 'Task ${e.key + 1}',
      );
    }).where((s) => s.value > 0).toList();

    // Add remaining slice if there is a gap
    if (remaining > 0) {
      achievedSlices.add(
        _Slice(
          value: remaining,
          color: const Color(0xFFF59E0B).withValues(alpha: isDark ? 0.2 : 0.1), // Match Remaining card color
          label: 'Remaining',
        ),
      );
    }
 
    return LayoutBuilder(builder: (context, constraints) {
      final isWide = constraints.maxWidth > 700;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Work Distribution & Progress',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: isDark ? const Color(0xFFB0DFFF) : const Color(0xFF05263E),
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16), // Tighter header spacing
          Expanded(
            child: isWide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: _DonutChart(
                          title: 'Planned Hours',
                          centerText: plannedCenter,
                          subLabel: plannedSub,
                          slices: plannedSlices,
                          hasData: plannedSlices.isNotEmpty,
                          isDark: isDark,
                          accentColor: const Color(0xFF6366F1),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _DonutChart(
                          title: 'Achieved Hours',
                          centerText: '${achievedRate.toStringAsFixed(0)}%',
                          subLabel: '${achieved.toStringAsFixed(1)}h Recorded',
                          slices: achievedSlices,
                          hasData: achievedSlices.isNotEmpty,
                          isDark: isDark,
                          accentColor: const Color(0xFF10B981), // Emerald
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Expanded(
                        child: _DonutChart(
                          title: 'Planned Hours',
                          centerText: plannedCenter,
                          subLabel: plannedSub,
                          slices: plannedSlices,
                          hasData: plannedSlices.isNotEmpty,
                          isDark: isDark,
                          accentColor: const Color(0xFF6366F1),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: _DonutChart(
                          title: 'Achieved Hours',
                          centerText: '${achievedRate.toStringAsFixed(0)}%',
                          subLabel: '${achieved.toStringAsFixed(1)}h Recorded',
                          slices: achievedSlices,
                          hasData: achievedSlices.isNotEmpty,
                          isDark: isDark,
                          accentColor: const Color(0xFF10B981), // Emerald
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      );
    });
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Single donut chart with legend
// ─────────────────────────────────────────────────────────────────────────────
class _DonutChart extends HookWidget {
  final String title;
  final String centerText;
  final String subLabel;
  final List<_Slice> slices;
  final bool hasData;
  final bool isDark;
  final Color accentColor;

  const _DonutChart({
    required this.title,
    required this.centerText,
    required this.subLabel,
    required this.slices,
    required this.hasData,
    required this.isDark,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final hoveredIndex = useState<int>(-1);
    
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.03) : const Color(0xFFF5F8FC),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? const Color(0xFF162D4A) : const Color(0xFFD4E2F0),
        ),
      ),
      child: LayoutBuilder(builder: (context, constraints) {
        final double chartSize = (constraints.maxHeight - 60).clamp(100.0, 300.0);
        final double radius = (chartSize / 14).clamp(10.0, 24.0);
        final double innerRadius = (chartSize / 2.5).clamp(45.0, 110.0);

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: accentColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: accentColor.withValues(alpha: 0.4),
                        blurRadius: 4,
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  title.toUpperCase(),
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: isDark ? const Color(0xFFD1E9FF) : const Color(0xFF05263E),
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outer Glow / Glass layer
                  Container(
                    width: chartSize + (radius * 2.5),
                    height: chartSize + (radius * 2.5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark ? Colors.white.withValues(alpha: 0.01) : Colors.black.withValues(alpha: 0.01),
                    ),
                  ),
                  // Smarter Background Track
                  SizedBox(
                    height: chartSize,
                    width: chartSize,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 0,
                        centerSpaceRadius: innerRadius,
                        sections: [
                          PieChartSectionData(
                            value: 1,
                            title: '',
                            color: isDark ? Colors.white.withValues(alpha: 0.02) : Colors.black.withValues(alpha: 0.01),
                            radius: radius,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: chartSize,
                    width: chartSize,
                    child: PieChart(
                      PieChartData(
                        pieTouchData: PieTouchData(
                          touchCallback: (FlTouchEvent event, pieTouchResponse) {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              hoveredIndex.value = -1;
                              return;
                            }
                            hoveredIndex.value = pieTouchResponse.touchedSection!.touchedSectionIndex;
                          },
                        ),
                        sectionsSpace: 4,
                        centerSpaceRadius: innerRadius,
                        startDegreeOffset: -90,
                        sections: hasData
                            ? slices.asMap().entries.map((e) {
                                final s = e.value;
                                final isHovered = e.key == hoveredIndex.value;
                                return PieChartSectionData(
                                  value: s.value,
                                  title: '',
                                  radius: isHovered ? radius * 1.2 : radius,
                                  gradient: LinearGradient(
                                    colors: [s.color, s.color.withValues(alpha: 0.7)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderSide: BorderSide(
                                    color: isDark ? Colors.black26 : Colors.white24,
                                    width: 1,
                                  ),
                                );
                              }).toList()
                            : [
                                PieChartSectionData(
                                  value: 100,
                                  title: '',
                                  color: isDark
                                      ? Colors.white.withOpacity(0.05)
                                      : Colors.grey.shade100,
                                  radius: radius,
                                ),
                              ],
                      ),
                    ),
                  ),
                  // Center Content Glass
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: innerRadius * 1.8,
                    height: innerRadius * 1.8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark ? Colors.black12 : Colors.white,
                      border: hoveredIndex.value != -1 && hasData && hoveredIndex.value < slices.length
                          ? Border.all(
                              color: _palette[hoveredIndex.value % _palette.length][0].withValues(alpha: 0.3),
                              width: 2,
                            )
                          : null,
                      boxShadow: [
                        BoxShadow(
                          color: hoveredIndex.value != -1 && hasData && hoveredIndex.value < slices.length
                              ? _palette[hoveredIndex.value % _palette.length][0].withValues(alpha: 0.15)
                              : Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (hoveredIndex.value != -1 && hasData && hoveredIndex.value < slices.length) ...[
                          Flexible(
                            flex: 2,
                            child: Text(
                              slices[hoveredIndex.value].label,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                fontSize: chartSize / 15,
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white : const Color(0xFF0D1B2A),
                                height: 1.1,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Flexible(
                            flex: 1,
                            child: Text(
                              '${slices[hoveredIndex.value].value.toStringAsFixed(1)}h',
                              style: GoogleFonts.outfit(
                                fontSize: chartSize / 6,
                                fontWeight: FontWeight.w900,
                                color: _palette[hoveredIndex.value % _palette.length][0],
                                letterSpacing: -0.5,
                              ),
                            ),
                          ),
                        ] else ...[
                          Flexible(
                            flex: 2,
                            child: FittedBox(
                              child: Text(
                                centerText,
                                style: GoogleFonts.outfit(
                                  fontSize: chartSize / 5,
                                  fontWeight: FontWeight.w900,
                                  color: isDark ? Colors.white : const Color(0xFF0D1B2A),
                                  letterSpacing: -1,
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Text(
                              'TOTAL',
                              style: GoogleFonts.inter(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: isDark ? const Color(0xFFB0C8E0) : const Color(0xFF4B6A8A),
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: accentColor.withValues(alpha: 0.1),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.auto_graph_rounded, size: 14, color: accentColor),
                  const SizedBox(width: 8),
                  Text(
                    subLabel,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: accentColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _Slice {
  final double value;
  final Color color;
  final String label;
  const _Slice({required this.value, required this.color, required this.label});
}

// ─────────────────────────────────────────────────────────────────────────────
// Project Picker Sheet
// ─────────────────────────────────────────────────────────────────────────────
class _ProjectPickerSheet extends HookWidget {
  final List<dynamic> projects;
  final Function(int?) onSelect;

  const _ProjectPickerSheet({required this.projects, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final search = useTextEditingController();
    useListenable(search); // Rebuild when typing for suffix icon visibility
    final filtered = useState(projects);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, -5),
          )
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Text(
                  'Select Project',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: search,
                  style: const TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Search your projects…',
                    hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                    prefixIcon: const Icon(Icons.search_rounded, size: 20),
                    suffixIcon: search.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close_rounded, size: 18),
                            onPressed: () {
                              search.clear();
                              filtered.value = projects;
                            },
                          )
                        : null,
                    filled: true,
                    fillColor:
                        isDark ? const Color(0xFF1F2937) : Colors.grey.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                  onChanged: (v) {
                    filtered.value = projects
                        .where((p) => p['name']
                            .toString()
                            .toLowerCase()
                            .contains(v.toLowerCase()))
                        .toList();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _PickerTile(
                  title: 'All Projects',
                  icon: Icons.dashboard_rounded,
                  onTap: () => onSelect(null),
                  isDark: isDark,
                  isBold: true,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Divider(height: 1),
                ),
                ...filtered.value.map((p) => _PickerTile(
                      title: p['name'] as String,
                      icon: Icons.folder_rounded,
                      onTap: () => onSelect(p['id'] as int),
                      isDark: isDark,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PickerTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool isDark;
  final bool isBold;

  const _PickerTile({
    required this.title,
    required this.icon,
    required this.onTap,
    required this.isDark,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18, color: Colors.blue.shade600),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
          color: isDark ? Colors.white : const Color(0xFF1F2937),
        ),
      ),
      trailing:
          Icon(Icons.chevron_right_rounded, size: 20, color: Colors.grey.shade400),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared UI Shells & Helpers
// ─────────────────────────────────────────────────────────────────────────────


class _SelectorPill extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isDark;
  final VoidCallback onTap;

  const _SelectorPill({
    required this.label,
    required this.icon,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 32, // Matched with User Dropdown height
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1F2937) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? Colors.white10 : Colors.grey.shade200,
          ),
          boxShadow: isDark ? [] : _softShadow,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: isDark ? Colors.blue.shade300 : Colors.blue.shade600),
            const SizedBox(width: 8),
            Flexible(
        child: Text(
          label.length > 20 ? '${label.substring(0, 18)}…' : label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : const Color(0xFF1F2937),
          ),
        ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.keyboard_arrow_down_rounded,
                size: 18, color: Colors.grey.shade500),
          ],
        ),
      ),
    );
  }
}


class _ShellBox extends StatelessWidget {
  final Widget child;
  const _ShellBox({required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Center(
          child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey.shade50.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(24),
              ),
              child: child)),
    );
  }
}
