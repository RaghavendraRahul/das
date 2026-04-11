import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/utils/user_color_service.dart';

import 'package:project_pm/src/core/database/database.dart';
import 'package:project_pm/src/features/projects/providers/api_providers.dart';

@RoutePage()
class AdminEmployeeViewPage extends HookConsumerWidget {
  final User employee;

  const AdminEmployeeViewPage({super.key, required this.employee});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTab = useState(0);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    const tabs = [
      _TabConfig(label: 'Dashboard', icon: FontAwesomeIcons.chartPie),
      _TabConfig(label: 'Planner', icon: FontAwesomeIcons.calendarDay),
      _TabConfig(label: 'Quick Notes', icon: FontAwesomeIcons.noteSticky),
    ];

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF111827) : const Color(0xFFF9FAFB),
      body: Column(
        children: [
          // ── Header Banner ──────────────────────────────────────────────
          _AdminViewBanner(employee: employee, isDark: isDark),

          // ── Tab Bar ────────────────────────────────────────────────────
          Container(
            color: isDark ? const Color(0xFF1F2937) : Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: List.generate(tabs.length, (i) {
                final isSelected = selectedTab.value == i;
                return GestureDetector(
                  onTap: () => selectedTab.value = i,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 14),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: isSelected
                              ? const Color(0xFF3B82F6)
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          tabs[i].icon,
                          size: 13,
                          color: isSelected
                              ? const Color(0xFF3B82F6)
                              : (isDark
                                  ? Colors.grey.shade400
                                  : Colors.grey.shade500),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          tabs[i].label,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                            color: isSelected
                                ? const Color(0xFF3B82F6)
                                : (isDark
                                    ? Colors.grey.shade400
                                    : Colors.grey.shade600),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),

          // ── Divider ────────────────────────────────────────────────────
          Divider(
            height: 1,
            color: isDark ? const Color(0xFF374151) : Colors.grey.shade200,
          ),

          // ── Content ────────────────────────────────────────────────────
          Expanded(
            child: IndexedStack(
              index: selectedTab.value,
              children: [
                _EmployeeDashboardTab(employee: employee, isDark: isDark),
                _EmployeePlannerTab(employee: employee, isDark: isDark),
                _EmployeeNotesTab(employee: employee, isDark: isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Header Banner
// ─────────────────────────────────────────────────────────────────────────────

class _AdminViewBanner extends StatelessWidget {
  final User employee;
  final bool isDark;

  const _AdminViewBanner({required this.employee, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final initials = employee.name.isNotEmpty
        ? employee.name
            .split(' ')
            .take(2)
            .map((p) => p.isNotEmpty ? p[0] : '')
            .join()
            .toUpperCase()
        : '?';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E40AF), Color(0xFF312E81)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Back Button
          IconButton(
            onPressed: () => context.router.maybePop(),
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            tooltip: 'Back to Team Overview',
          ),
          const SizedBox(width: 8),

          // Avatar
          CircleAvatar(
            radius: 22,
            backgroundColor: UserColorService.getColorForUser(employee.id),
            backgroundImage: employee.avatarUrl.isNotEmpty
                ? NetworkImage(employee.avatarUrl)
                : null,
            child: employee.avatarUrl.isEmpty
                ? Text(initials,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14))
                : null,
          ),
          const SizedBox(width: 12),

          // Name + Role
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  employee.name,
                  style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  employee.email,
                  style: GoogleFonts.inter(
                      color: Colors.white.withOpacity(0.8), fontSize: 12),
                ),
              ],
            ),
          ),

          // Read-only badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.2),
              border:
                  Border.all(color: Colors.amber.withOpacity(0.6), width: 1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.visibility_rounded,
                    color: Colors.amber, size: 12),
                const SizedBox(width: 4),
                Text(
                  'Admin View  •  Read Only',
                  style: GoogleFonts.inter(
                    color: Colors.amber,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Dashboard Tab — Employee Projects
// ─────────────────────────────────────────────────────────────────────────────

class _EmployeeDashboardTab extends HookConsumerWidget {
  final User employee;
  final bool isDark;

  const _EmployeeDashboardTab({required this.employee, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPage = useState(1);
    final projectsAsync = ref.watch(adminEmployeeProjectsProvider(
        userId: employee.id, page: currentPage.value));
    final dashboardAsync =
        ref.watch(adminEmployeeDashboardProvider(employee.id));

    Future<void> refreshData() {
      return Future.wait([
        ref.refresh(adminEmployeeProjectsProvider(
                userId: employee.id, page: currentPage.value)
            .future),
        ref.refresh(adminEmployeeDashboardProvider(employee.id).future),
      ]);
    }

    return projectsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => RefreshIndicator(
        onRefresh: refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: 400,
            child: _ErrorView(message: e.toString()),
          ),
        ),
      ),
      data: (paginatedData) {
        final projects = paginatedData.results;
        return dashboardAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => _ErrorView(message: e.toString()),
          data: (dashboardData) {
            final stats =
                dashboardData['statistics'] as Map<String, dynamic>? ?? {};
            final activeTasks = stats['active_tasks']?.toString() ?? '0';
            final completedTasks = stats['completed_tasks']?.toString() ?? '0';

            return RefreshIndicator(
              onRefresh: refreshData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionHeader(
                      title: "${employee.name.split(' ').first}'s Projects",
                      subtitle: '${paginatedData.count} project(s) in total',
                      isDark: isDark,
                    ),
                    const SizedBox(height: 16),
                    // Stats row
                    Row(
                      children: [
                        _MiniStatCard(
                          label: 'Total Projects',
                          value: '${paginatedData.count}',
                          color: const Color(0xFF3B82F6),
                          icon: FontAwesomeIcons.briefcase,
                          isDark: isDark,
                        ),
                        const SizedBox(width: 16),
                        _MiniStatCard(
                          label: 'Active Tasks',
                          value: activeTasks,
                          color: const Color(0xFFF59E0B),
                          icon: FontAwesomeIcons.barsProgress,
                          isDark: isDark,
                        ),
                        const SizedBox(width: 16),
                        _MiniStatCard(
                          label: 'Completed Tasks',
                          value: completedTasks,
                          color: const Color(0xFF10B981),
                          icon: FontAwesomeIcons.checkDouble,
                          isDark: isDark,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Project list
                    if (projects.isEmpty)
                      SizedBox(
                        height: 200,
                        child: _EmptyState(
                          icon: FontAwesomeIcons.folderOpen,
                          title: 'No Projects Found',
                          subtitle: '${employee.name} has no projects.',
                        ),
                      )
                    else
                      ...projects.map((pwt) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _ProjectRow(project: pwt, isDark: isDark),
                          )),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Planner Tab — Employee Today Plan
// ─────────────────────────────────────────────────────────────────────────────

class _EmployeePlannerTab extends HookConsumerWidget {
  final User employee;
  final bool isDark;

  const _EmployeePlannerTab({required this.employee, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync =
        ref.watch(adminEmployeeDashboardProvider(employee.id));

    Future<void> refreshData() {
      return ref.refresh(adminEmployeeDashboardProvider(employee.id).future);
    }

    Color quadrantColor(String? q) => switch (q) {
          'Q1' => const Color(0xFFEF4444),
          'Q2' => const Color(0xFF3B82F6),
          'Q3' => const Color(0xFFF59E0B),
          'Q4' => const Color(0xFF6B7280),
          _ => const Color(0xFF8B5CF6),
        };

    String quadrantLabel(String? q) => switch (q) {
          'Q1' => 'Start First',
          'Q2' => 'Schedule',
          'Q3' => 'Delegate',
          'Q4' => 'Routine',
          _ => 'Other',
        };

    return dashboardAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => RefreshIndicator(
        onRefresh: refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: 400,
            child: _ErrorView(message: e.toString()),
          ),
        ),
      ),
      data: (data) {
        final planItems =
            (data['todays_plan'] as List?)?.cast<Map<String, dynamic>>() ?? [];
        final activityLogs =
            (data['activity_logs'] as List?)?.cast<Map<String, dynamic>>() ??
                [];
        final pendingTasks =
            (data['pending_tasks'] as List?)?.cast<Map<String, dynamic>>() ??
                [];

        return RefreshIndicator(
          onRefresh: refreshData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionHeader(
                    title: "${employee.name.split(' ').first}'s Planner",
                    subtitle: _dateStr(DateTime.now()),
                    isDark: isDark),

                // ── Todays Plan ──────────────────────────────
                const SizedBox(height: 24),
                _SubHeader(title: "Today's Plan", isDark: isDark),
                const SizedBox(height: 12),
                if (planItems.isEmpty)
                  const _EmptyState(
                    icon: FontAwesomeIcons.calendarXmark,
                    title: 'No Plans Today',
                    subtitle: 'No tasks planned for today.',
                    compact: true,
                  )
                else ...[
                  Text(
                    'Total planned: ${_formatDuration(planItems)}  •  ${planItems.length} task(s)',
                    style: GoogleFonts.inter(
                        fontSize: 13,
                        color: isDark
                            ? Colors.grey.shade400
                            : Colors.grey.shade600),
                  ),
                  const SizedBox(height: 16),
                  ..._groupItems(planItems).entries.map((entry) {
                    final q = entry.key;
                    final items = entry.value;
                    final color = quadrantColor(q);
                    final label = quadrantLabel(q);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                  color: color, shape: BoxShape.circle),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '$q — $label',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                color: color,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ...items.map((item) => _PlanItemCard(
                              item: item,
                              barColor: color,
                              isDark: isDark,
                            )),
                        const SizedBox(height: 16),
                      ],
                    );
                  }),
                ],

                // ── Activity Log ──────────────────────────────
                const SizedBox(height: 24),
                Divider(
                    color:
                        isDark ? Colors.grey.shade800 : Colors.grey.shade200),
                const SizedBox(height: 24),
                _SubHeader(title: 'Activity Log', isDark: isDark),
                const SizedBox(height: 12),
                if (activityLogs.isEmpty)
                  const _EmptyState(
                      icon: FontAwesomeIcons.clock,
                      title: 'No Activity Logged',
                      subtitle: 'No activity recorded today.',
                      compact: true)
                else
                  ...activityLogs
                      .map((log) => _ActivityLogItem(log: log, isDark: isDark)),

                // ── Pending Tasks ──────────────────────────────
                const SizedBox(height: 24),
                Divider(
                    color:
                        isDark ? Colors.grey.shade800 : Colors.grey.shade200),
                const SizedBox(height: 24),
                _SubHeader(title: 'Pending / Rollover Tasks', isDark: isDark),
                const SizedBox(height: 12),
                if (pendingTasks.isEmpty)
                  const _EmptyState(
                      icon: FontAwesomeIcons.hourglassHalf,
                      title: 'No Pending Tasks',
                      subtitle: 'Everything seems on track.',
                      compact: true)
                else
                  ...pendingTasks.map(
                      (task) => _PendingTaskItem(task: task, isDark: isDark)),

                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }

  String _dateStr(DateTime d) =>
      '${_weekday(d.weekday)}, ${d.day} ${_month(d.month)} ${d.year}';

  String _formatDuration(List<Map<String, dynamic>> items) {
    final totalMinutes = items.fold<int>(
        0, (s, i) => s + ((i['planned_duration_minutes'] as int?) ?? 0));
    final hrs = totalMinutes ~/ 60;
    final mins = totalMinutes % 60;
    return '${hrs}h ${mins}m';
  }

  Map<String, List<Map<String, dynamic>>> _groupItems(
      List<Map<String, dynamic>> items) {
    final grouped = <String, List<Map<String, dynamic>>>{};
    for (final item in items) {
      final q = item['quadrant'] as String? ?? 'OTHER';
      grouped.putIfAbsent(q, () => []).add(item);
    }
    return grouped;
  }

  String _weekday(int d) =>
      const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][d - 1];
  String _month(int m) => const [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ][m - 1];
}

// ─────────────────────────────────────────────────────────────────────────────
// Quick Notes Tab — Employee Sticky Notes
// ─────────────────────────────────────────────────────────────────────────────

class _EmployeeNotesTab extends HookConsumerWidget {
  final User employee;
  final bool isDark;

  const _EmployeeNotesTab({required this.employee, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(adminEmployeeStickyNotesProvider(employee.id));

    Future<void> refreshData() {
      return ref.refresh(adminEmployeeStickyNotesProvider(employee.id).future);
    }

    Color hexToColor(String? hex) {
      if (hex == null || hex.isEmpty) return const Color(0xFFFEF3C7);
      try {
        if (hex.startsWith('0x')) return Color(int.parse(hex));
        if (hex.startsWith('#')) {
          return Color(int.parse(hex.replaceAll('#', '0xFF')));
        }
        return Color(int.parse(hex));
      } catch (_) {
        return const Color(0xFFFEF3C7);
      }
    }

    return notesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => RefreshIndicator(
        onRefresh: refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: 400,
            child: _ErrorView(message: e.toString()),
          ),
        ),
      ),
      data: (notes) {
        return RefreshIndicator(
          onRefresh: refreshData,
          child: notes.isEmpty
              ? SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: 400,
                    child: _EmptyState(
                      icon: FontAwesomeIcons.noteSticky,
                      title: 'No Notes Yet',
                      subtitle:
                          "${employee.name.split(' ').first} hasn't created any sticky notes.",
                    ),
                  ),
                )
              : SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionHeader(
                        title: "${employee.name.split(' ').first}'s Notes",
                        subtitle: '${notes.length} note(s)',
                        isDark: isDark,
                      ),
                      const SizedBox(height: 20),
                      // Masonry-style grid of sticky notes
                      LayoutBuilder(builder: (ctx, constraints) {
                        final cols = constraints.maxWidth > 800 ? 4 : 2;
                        return Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: notes.map((note) {
                            final color = hexToColor(note['color'] as String?);
                            final content = (note['content'] as String?) ?? '';
                            final createdAt = note['created_at'] != null
                                ? DateTime.tryParse(
                                    note['created_at'] as String)
                                : null;
                            return SizedBox(
                              width: (constraints.maxWidth - (cols - 1) * 16) /
                                  cols,
                              child: _StickyNoteCard(
                                content: content,
                                color: color,
                                createdAt: createdAt,
                                isDark: isDark,
                              ),
                            );
                          }).toList(),
                        );
                      }),
                    ],
                  ),
                ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Small Reusable Widgets
// ─────────────────────────────────────────────────────────────────────────────

class _TabConfig {
  final String label;
  final IconData icon;

  const _TabConfig({required this.label, required this.icon});
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isDark;

  const _SectionHeader(
      {required this.title, required this.subtitle, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: GoogleFonts.inter(
            fontSize: 13,
            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}

class _MiniStatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;
  final bool isDark;

  const _MiniStatCard(
      {required this.label,
      required this.value,
      required this.color,
      required this.icon,
      required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1F2937) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? const Color(0xFF374151) : Colors.grey.shade200,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProjectRow extends StatelessWidget {
  final dynamic project;
  final bool isDark;

  const _ProjectRow({required this.project, required this.isDark});

  Color _statusColor(String? s) => switch (s) {
        'IN_PROGRESS' => const Color(0xFF3B82F6),
        'DONE' || 'COMPLETED' => const Color(0xFF10B981),
        'ON_HOLD' => const Color(0xFFF59E0B),
        _ => const Color(0xFF6B7280),
      };

  @override
  Widget build(BuildContext context) {
    final p = project.project;
    final statusColor = _statusColor(p.status);
    final taskCount = (project.tasks as List).length;
    final completedTasks =
        (project.tasks as List).where((t) => t.task.progress == 100).length;
    final pct = taskCount > 0 ? completedTasks / taskCount : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: isDark ? const Color(0xFF374151) : Colors.grey.shade200),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                )
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  p.name,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: isDark ? Colors.white : const Color(0xFF111827),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  (p.status ?? 'UNKNOWN').replaceAll('_', ' '),
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                '$completedTasks / $taskCount tasks',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                ),
              ),
              const Spacer(),
              Text(
                '${(pct * 100).toStringAsFixed(0)}%',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: statusColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 5,
              backgroundColor:
                  isDark ? const Color(0xFF374151) : Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation(statusColor),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanItemCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final Color barColor;
  final bool isDark;

  const _PlanItemCard(
      {required this.item, required this.barColor, required this.isDark});

  String _statusLabel(String? s) => switch (s) {
        'PLANNED' => 'Planned',
        'STARTED' => 'Started',
        'IN_ACTIVITY' => 'In Progress',
        'COMPLETED' => 'Done',
        'MOVED_TO_PENDING' => 'Pending',
        _ => s ?? 'Unknown',
      };

  Color _statusColor(String? s) => switch (s) {
        'COMPLETED' => const Color(0xFF10B981),
        'IN_ACTIVITY' || 'STARTED' => const Color(0xFF3B82F6),
        'MOVED_TO_PENDING' => const Color(0xFFF59E0B),
        _ => const Color(0xFF6B7280),
      };

  @override
  Widget build(BuildContext context) {
    final catalogItem = item['catalog_item'] as Map<String, dynamic>?;
    final name = catalogItem?['name'] as String? ??
        item['title'] as String? ??
        'Unnamed Task';
    final status = item['status'] as String?;
    final durationMins = item['planned_duration_minutes'] as int? ?? 0;
    final hrs = durationMins ~/ 60;
    final mins = durationMins % 60;
    final durationStr = hrs > 0 ? '${hrs}h ${mins}m' : '${mins}m';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? const Color(0xFF374151) : Colors.grey.shade200,
        ),
        boxShadow: isDark
            ? []
            : [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4)],
      ),
      child: Row(
        children: [
          // Colored quadrant stripe
          Container(
            width: 3,
            height: 40,
            decoration: BoxDecoration(
              color: barColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: isDark ? Colors.white : const Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  durationStr,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
          // Status badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: _statusColor(status).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _statusLabel(status),
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: _statusColor(status),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StickyNoteCard extends StatelessWidget {
  final String content;
  final Color color;
  final DateTime? createdAt;
  final bool isDark;

  const _StickyNoteCard(
      {required this.content,
      required this.color,
      this.createdAt,
      required this.isDark});

  @override
  Widget build(BuildContext context) {
    final dateStr = createdAt != null
        ? '${createdAt!.day}/${createdAt!.month}/${createdAt!.year}'
        : '';
    return Container(
      constraints: const BoxConstraints(minHeight: 100),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (content.isEmpty)
            Text(
              'Empty note',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontStyle: FontStyle.italic,
                color: Colors.black38,
              ),
            )
          else
            Text(
              content,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          if (dateStr.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              dateStr,
              style: GoogleFonts.inter(
                fontSize: 10,
                color: Colors.black38,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool compact;

  const _EmptyState(
      {required this.icon,
      required this.title,
      required this.subtitle,
      this.compact = false});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon,
              size: compact ? 32 : 48,
              color: isDark ? Colors.grey.shade600 : Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: compact ? 14 : 16,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: compact ? 12 : 13,
              color: isDark ? Colors.grey.shade500 : Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;

  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded,
                color: Color(0xFFEF4444), size: 48),
            const SizedBox(height: 16),
            Text(
              'Failed to load data',
              style:
                  GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style:
                  GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade500),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubHeader extends StatelessWidget {
  final String title;
  final bool isDark;

  const _SubHeader({required this.title, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: isDark ? Colors.white : const Color(0xFF111827),
      ),
    );
  }
}

class _ActivityLogItem extends StatelessWidget {
  final Map<String, dynamic> log;
  final bool isDark;

  const _ActivityLogItem({required this.log, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final taskName = log['task_name'] as String? ?? 'Unknown Task';
    final duration = log['hours_worked'] as num? ?? 0.0;

    // Helper to safely parse time
    String formatTime(dynamic timeStr) {
      if (timeStr == null) return '--:--';
      try {
        if (timeStr is String) {
          // Backend sends ISO string in Asia/Kolkata timezone
          // Extract time directly without timezone conversion
          // Format: 2026-02-26T12:11:40+05:30
          final timeStart = timeStr.indexOf('T') + 1;
          if (timeStart > 0 && timeStart + 5 <= timeStr.length) {
            final timeStr24 =
                timeStr.substring(timeStart, timeStart + 5); // HH:mm
            final parts = timeStr24.split(':');
            if (parts.length == 2) {
              final hour = int.parse(parts[0]);
              final minute = parts[1];
              final h = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
              final ampm = hour >= 12 ? 'PM' : 'AM';
              return '$h:$minute $ampm';
            }
          }
        }
      } catch (_) {}
      return '--:--';
    }

    final startTime = formatTime(log['start_time']);
    final endTime = formatTime(log['end_time']);
    final isCompleted = log['is_completed'] == true;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF374151) : Colors.grey.shade200,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (isCompleted
                      ? const Color(0xFF10B981)
                      : const Color(0xFF3B82F6))
                  .withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isCompleted ? FontAwesomeIcons.check : FontAwesomeIcons.play,
              size: 14,
              color: isCompleted
                  ? const Color(0xFF10B981)
                  : const Color(0xFF3B82F6),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  taskName,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: isDark ? Colors.white : const Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$startTime - $endTime  •  ${duration.toStringAsFixed(1)} hrs',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PendingTaskItem extends StatelessWidget {
  final Map<String, dynamic> task;
  final bool isDark;

  const _PendingTaskItem({required this.task, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final taskName = task['task_name'] as String? ?? 'Unknown Task';
    final reason = task['reason'] as String? ?? 'No reason provided';
    final minutesLeft = task['minutes_left'] as int? ?? 0;
    final hrs = minutesLeft ~/ 60;
    final mins = minutesLeft % 60;
    final durationStr = hrs > 0 ? '${hrs}h ${mins}m left' : '${mins}m left';

    // Formatting reason if too long
    final displayReason =
        reason.length > 50 ? '${reason.substring(0, 50)}...' : reason;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF374151) : Colors.grey.shade200,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            FontAwesomeIcons.circleExclamation,
            size: 18,
            color: Color(0xFFF59E0B),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  taskName,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: isDark ? Colors.white : const Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  displayReason,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          // Time left badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF59E0B).withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              durationStr,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFF59E0B),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
