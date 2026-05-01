import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/utils/user_color_service.dart';
import '../../core/providers/user_providers.dart';
import 'team_api_service.dart';

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
            color: Colors.black.withValues(alpha: 0.15),
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
                  style: GoogleFonts.manrope(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800),
                ),
                Text(
                  employee.email,
                  style: GoogleFonts.inter(
                      color: Colors.white.withValues(alpha: 0.8), fontSize: 12),
                ),
              ],
            ),
          ),

          // Read-only badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.2),
              border:
                  Border.all(color: Colors.amber.withValues(alpha: 0.6), width: 1),
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
// Planner Tab — Day / Week / Month calendar (admin read-only)
// ─────────────────────────────────────────────────────────────────────────────

typedef _PlanRange = ({String memberId, DateTime from, DateTime to});

final _employeeDatePlansProvider =
    FutureProvider.family<List<Map<String, dynamic>>, _PlanRange>((ref, p) async {
  final api = ref.read(teamApiServiceProvider);
  return api.getEmployeeDatePlans(memberId: p.memberId, dateFrom: p.from, dateTo: p.to);
});

class _EmployeePlannerTab extends HookConsumerWidget {
  final User employee;
  final bool isDark;

  const _EmployeePlannerTab({required this.employee, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewMode = useState(0); // 0=Day 1=Week 2=Month
    final selDate = useState(DateTime.now());

    bool sameDay(DateTime a, DateTime b) =>
        a.year == b.year && a.month == b.month && a.day == b.day;

    DateTime shift(DateTime d, int dir) {
      if (viewMode.value == 0) return d.add(Duration(days: dir));
      if (viewMode.value == 1) return d.add(Duration(days: dir * 7));
      return DateTime(d.year, d.month + dir, 1);
    }

    String label(DateTime d) {
      const mo = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
      if (viewMode.value == 0) return '${d.day} ${mo[d.month-1]} ${d.year}';
      if (viewMode.value == 1) {
        final e = d.add(const Duration(days: 6));
        return '${d.day} ${mo[d.month-1]} – ${e.day} ${mo[e.month-1]}';
      }
      return '${mo[d.month-1]} ${d.year}';
    }

    return Column(children: [
      // ── toolbar ──────────────────────────────────────────────────────
      Container(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(children: [
          Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF111827) : const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) {
                final s = viewMode.value == i;
                final labels = ['Day', 'Week', 'Month'];
                return GestureDetector(
                  onTap: () => viewMode.value = i,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
                    decoration: BoxDecoration(
                      color: s ? const Color(0xFF3B82F6) : Colors.transparent,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Text(labels[i],
                        style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600,
                            color: s ? Colors.white : (isDark ? Colors.grey.shade400 : Colors.grey.shade600))),
                  ),
                );
              }),
            ),
          ),
          const Spacer(),
          IconButton(icon: const Icon(Icons.chevron_left, size: 20), onPressed: () => selDate.value = shift(selDate.value, -1), padding: EdgeInsets.zero, constraints: const BoxConstraints()),
          const SizedBox(width: 4),
          Text(label(selDate.value), style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xFF111827))),
          const SizedBox(width: 4),
          IconButton(icon: const Icon(Icons.chevron_right, size: 20), onPressed: () => selDate.value = shift(selDate.value, 1), padding: EdgeInsets.zero, constraints: const BoxConstraints()),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: () => selDate.value = DateTime.now(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(color: const Color(0xFF3B82F6).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
              child: Text('Today', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF3B82F6))),
            ),
          ),
        ]),
      ),
      Divider(height: 1, color: isDark ? const Color(0xFF374151) : Colors.grey.shade200),

      // ── content ──────────────────────────────────────────────────────
      Expanded(child: Builder(builder: (_) {
        if (viewMode.value == 0) {
          // DAY — today uses dashboard provider (has activity log + pending)
          final isToday = sameDay(selDate.value, DateTime.now());
          if (isToday) {
            final async = ref.watch(adminEmployeeDashboardProvider(employee.id));
            return async.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => _ErrorView(message: e.toString()),
              data: (data) => _dayScroll(ref,
                plans: (data['todays_plan'] as List?)?.cast<Map<String,dynamic>>() ?? [],
                activityLogs: (data['activity_logs'] as List?)?.cast<Map<String,dynamic>>() ?? [],
                pending: (data['pending_tasks'] as List?)?.cast<Map<String,dynamic>>() ?? [],
              ),
            );
          }
          // other day
          final d = selDate.value;
          final async = ref.watch(_employeeDatePlansProvider((
            memberId: employee.id.toString(),
            from: d, to: d,
          )));
          return async.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => _ErrorView(message: e.toString()),
            data: (plans) => _dayScroll(ref, plans: plans, activityLogs: [], pending: []),
          );
        }

        // WEEK / MONTH
        final d = selDate.value;
        final from = viewMode.value == 1 ? d : DateTime(d.year, d.month, 1);
        final to   = viewMode.value == 1 ? d.add(const Duration(days: 6)) : DateTime(d.year, d.month + 1, 0);
        final async = ref.watch(_employeeDatePlansProvider((
          memberId: employee.id.toString(),
          from: from, to: to,
        )));
        return async.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => _ErrorView(message: e.toString()),
          data: (plans) {
            final byDate = <String, List<Map<String,dynamic>>>{};
            for (final p in plans) {
              byDate.putIfAbsent(p['plan_date'] as String, () => []).add(p);
            }
            return viewMode.value == 1
                ? _weekView(byDate, from, sameDay)
                : _monthView(byDate, from, sameDay);
          },
        );
      })),
    ]);
  }

  // ── helpers ────────────────────────────────────────────────────────────────

  Color _qColor(String? q) => switch (q) {
    'Q1' => const Color(0xFFEF4444), 'Q2' => const Color(0xFF3B82F6),
    'Q3' => const Color(0xFFF59E0B), 'Q4' => const Color(0xFF6B7280),
    _ => const Color(0xFF8B5CF6),
  };

  String _qLabel(String? q) => switch (q) {
    'Q1' => 'Start First', 'Q2' => 'Schedule',
    'Q3' => 'Delegate', 'Q4' => 'Routine', _ => 'Other',
  };

  Widget _planChip(Map<String,dynamic> item) {
    final q = item['quadrant'] as String?;
    final c = _qColor(q);
    final done = item['status'] == 'COMPLETED';
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: c.withValues(alpha: 0.3)),
      ),
      child: Row(children: [
        Container(width: 3, height: 28, decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(item['name'] as String? ?? 'Task',
              style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF111827),
                  decoration: done ? TextDecoration.lineThrough : null)),
          if ((item['duration_minutes'] as int? ?? 0) > 0)
            Text('${item['duration_minutes']} min',
                style: GoogleFonts.inter(fontSize: 11, color: Colors.grey.shade500)),
        ])),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(color: (done ? Colors.green : c).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
          child: Text(done ? 'Done' : (item['status'] as String? ?? 'Planned'),
              style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w700, color: done ? Colors.green : c)),
        ),
      ]),
    );
  }

  Widget _dayScroll(WidgetRef ref, {
    required List<Map<String,dynamic>> plans,
    required List<Map<String,dynamic>> activityLogs,
    required List<Map<String,dynamic>> pending,
  }) {
    final grouped = <String, List<Map<String,dynamic>>>{};
    for (final p in plans) {
      grouped.putIfAbsent(p['quadrant'] as String? ?? 'OTHER', () => []).add(p);
    }
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _SubHeader(title: 'Planned Tasks', isDark: isDark),
        const SizedBox(height: 12),
        if (plans.isEmpty)
          const _EmptyState(icon: FontAwesomeIcons.calendarXmark,
              title: 'No Plans', subtitle: 'No tasks planned for this day.', compact: true)
        else
          ...grouped.entries.map((e) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Container(width: 8, height: 8, decoration: BoxDecoration(color: _qColor(e.key), shape: BoxShape.circle)),
                const SizedBox(width: 8),
                Text('${e.key} — ${_qLabel(e.key)}', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: _qColor(e.key))),
              ]),
              const SizedBox(height: 8),
              ...e.value.map((item) => _PlanItemCard(item: item, barColor: _qColor(item['quadrant'] as String?), isDark: isDark)),
              const SizedBox(height: 12),
            ],
          )),

        if (activityLogs.isNotEmpty) ...[
          Divider(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
          const SizedBox(height: 12),
          _SubHeader(title: 'Activity Log', isDark: isDark),
          const SizedBox(height: 12),
          ...activityLogs.map((log) => _ActivityLogItem(log: log, isDark: isDark, employeeId: employee.id)),
        ],
        if (pending.isNotEmpty) ...[
          Divider(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
          const SizedBox(height: 12),
          _SubHeader(title: 'Pending / Rollover', isDark: isDark),
          const SizedBox(height: 12),
          ...pending.map((t) => _PendingTaskItem(task: t, isDark: isDark)),
        ],
        const SizedBox(height: 40),
      ]),
    );
  }

  Widget _weekView(Map<String, List<Map<String,dynamic>>> byDate, DateTime weekStart,
      bool Function(DateTime, DateTime) sameDay) {
    const dn = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'];
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(children: List.generate(7, (i) {
        final d = weekStart.add(Duration(days: i));
        final key = '${d.year}-${d.month.toString().padLeft(2,'0')}-${d.day.toString().padLeft(2,'0')}';
        final items = byDate[key] ?? [];
        final today = sameDay(d, DateTime.now());
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1F2937) : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: today ? const Color(0xFF3B82F6) : (isDark ? const Color(0xFF374151) : Colors.grey.shade200),
                width: today ? 1.5 : 1),
          ),
          child: ExpansionTile(
            initiallyExpanded: today,
            tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            title: Row(children: [
              Text('${dn[i]}  ${d.day}',
                  style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700,
                      color: today ? const Color(0xFF3B82F6) : (isDark ? Colors.white : const Color(0xFF111827)))),
              const SizedBox(width: 8),
              if (items.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(color: const Color(0xFF3B82F6).withValues(alpha: 0.12), borderRadius: BorderRadius.circular(5)),
                  child: Text('${items.length}', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: const Color(0xFF3B82F6))),
                ),
            ]),
            children: items.isEmpty
                ? [Padding(padding: const EdgeInsets.fromLTRB(16,0,16,12),
                    child: Text('No plans', style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade500)))]
                : items.map(_planChip).toList(),
          ),
        );
      })),
    );
  }

  Widget _monthView(Map<String, List<Map<String,dynamic>>> byDate, DateTime ms,
      bool Function(DateTime, DateTime) sameDay) {
    const mo = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    const dn = ['M','T','W','T','F','S','S'];
    final dim = DateTime(ms.year, ms.month + 1, 0).day;
    final fw = ms.weekday;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: dn.map((d) => Expanded(
          child: Center(child: Text(d, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700,
              color: isDark ? Colors.grey.shade500 : Colors.grey.shade400))),
        )).toList()),
        const SizedBox(height: 6),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7, childAspectRatio: 1.1, crossAxisSpacing: 3, mainAxisSpacing: 3),
          itemCount: (fw - 1) + dim,
          itemBuilder: (_, idx) {
            if (idx < fw - 1) return const SizedBox();
            final day = idx - (fw - 1) + 1;
            final d = DateTime(ms.year, ms.month, day);
            final key = '${d.year}-${d.month.toString().padLeft(2,'0')}-${d.day.toString().padLeft(2,'0')}';
            final count = byDate[key]?.length ?? 0;
            final today = sameDay(d, DateTime.now());
            return Container(
              decoration: BoxDecoration(
                color: today ? const Color(0xFF3B82F6)
                    : (count > 0 ? const Color(0xFF3B82F6).withValues(alpha: 0.08)
                        : (isDark ? const Color(0xFF1F2937) : const Color(0xFFF9FAFB))),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: today ? const Color(0xFF3B82F6)
                    : (isDark ? const Color(0xFF374151) : Colors.grey.shade200)),
              ),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('$day', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700,
                    color: today ? Colors.white : (isDark ? Colors.white : const Color(0xFF111827)))),
                if (count > 0)
                  Text('$count', style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w600,
                      color: today ? Colors.white70 : const Color(0xFF3B82F6))),
              ]),
            );
          },
        ),
        const SizedBox(height: 20),
        ...byDate.entries.map((e) {
          final d = DateTime.parse(e.key);
          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(padding: const EdgeInsets.symmetric(vertical: 6),
              child: Text('${const ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'][d.weekday-1]}, ${d.day} ${mo[d.month-1]}',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 12,
                      color: isDark ? Colors.grey.shade300 : const Color(0xFF374151)))),
            ...e.value.map(_planChip),
          ]);
        }),
        const SizedBox(height: 40),
      ]),
    );
  }
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
                            final title = (note['title'] as String?) ?? 'Untitled';
                            final content = (note['content'] as String?) ?? '';
                            final createdAt = note['created_at'] != null
                                ? DateTime.tryParse(note['created_at'] as String)
                                : null;
                            return SizedBox(
                              width: (constraints.maxWidth - (cols - 1) * 16) /
                                  cols,
                              child: _StickyNoteCard(
                                title: title,
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
          style: GoogleFonts.manrope(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: isDark ? Colors.white : const Color(0xFF05263E),
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
                  color: Colors.black.withValues(alpha: 0.04),
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
                    fontSize: 13,
                    color: isDark ? Colors.white : const Color(0xFF111827),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
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
            : [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 4)],
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
                if (item['notes'] != null && item['notes'].toString().isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      item['notes'],
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ),
          // Status badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: _statusColor(status).withValues(alpha: 0.1),
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
  final String title;
  final String content;
  final Color color;
  final DateTime? createdAt;
  final bool isDark;

  const _StickyNoteCard({
    required this.title,
    required this.content,
    required this.color,
    this.createdAt,
    required this.isDark,
  });

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
            color: color.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Text(
              content,
              style: GoogleFonts.inter(
                height: 1.5,
              ),
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

// ─────────────────────────────────────────────────────────────────────────────
// Activity Log Item — Supports Admin Remark Feature
// ─────────────────────────────────────────────────────────────────────────────

class _ActivityLogItem extends ConsumerStatefulWidget {
  final Map<String, dynamic> log;
  final bool isDark;
  /// The employee whose planner is being viewed (used to refresh parent data)
  final String employeeId;

  const _ActivityLogItem({
    required this.log,
    required this.isDark,
    required this.employeeId,
  });

  @override
  ConsumerState<_ActivityLogItem> createState() => _ActivityLogItemState();
}

class _ActivityLogItemState extends ConsumerState<_ActivityLogItem> {
  // Optimistic local state for the remark so UI updates instantly on save
  late String? _remarkText;
  late String? _remarkByName;
  bool _showInput = false;
  bool _isSaving = false;
  final _remarkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _remarkText = widget.log['admin_remark'] as String?;
    _remarkByName = widget.log['admin_remark_by_name'] as String?;
  }

  @override
  void dispose() {
    _remarkController.dispose();
    super.dispose();
  }

  String _formatTime(dynamic timeStr) {
    if (timeStr == null) return '--:--';
    try {
      if (timeStr is String) {
        final timeStart = timeStr.indexOf('T') + 1;
        if (timeStart > 0 && timeStart + 5 <= timeStr.length) {
          final timeStr24 = timeStr.substring(timeStart, timeStart + 5);
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

  Future<void> _saveRemark() async {
    final remark = _remarkController.text.trim();
    if (remark.isEmpty) return;
    setState(() => _isSaving = true);
    try {
      final logId = widget.log['id'] as int;
      final teamApi = ref.read(teamApiServiceProvider);
      final result = await teamApi.addAdminRemark(
        activityLogId: logId,
        remark: remark,
      );
      // Optimistic update — no full refresh needed
      setState(() {
        _remarkText = result['admin_remark'] as String?;
        _remarkByName = result['admin_remark_by'] as String?;
        _showInput = false;
        _remarkController.clear();
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Remark saved.', style: GoogleFonts.inter()),
            backgroundColor: const Color(0xFF10B981),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save remark: $e',
                style: GoogleFonts.inter()),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final log = widget.log;
    final isDark = widget.isDark;
    final taskName = log['task_name'] as String? ?? 'Unknown Task';
    final duration = log['hours_worked'] as num? ?? 0.0;
    final startTime = _formatTime(log['start_time']);
    final endTime = _formatTime(log['end_time']);
    final isCompleted = log['is_completed'] == true;
    final workNotes = log['work_notes'] as String?;
    final hasAdminRemark = _remarkText != null && _remarkText!.isNotEmpty;

    // Role check — only ADMIN, MANAGER, TEAM_LEAD can write remarks
    final currentUserAsync = ref.watch(currentUserProvider);
    final canAddRemark = currentUserAsync.maybeWhen(
      data: (u) {
        final role = u?.role.toUpperCase() ?? '';
        return role == 'ADMIN' || role == 'MANAGER' || role == 'TEAM_LEAD';
      },
      orElse: () => false,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasAdminRemark
              ? Colors.amber.withValues(alpha: 0.4)
              : (isDark ? const Color(0xFF374151) : Colors.grey.shade200),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (isCompleted
                          ? const Color(0xFF10B981)
                          : const Color(0xFF3B82F6))
                      .withValues(alpha: 0.1),
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
                        fontSize: 13,
                        color: isDark ? Colors.white : const Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$startTime - $endTime  •  ${duration.toStringAsFixed(1)} hrs',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color:
                            isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                      ),
                    ),
                    // Employee work notes
                    if (workNotes != null && workNotes.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Work Notes: ',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade400,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                workNotes,
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: isDark
                                      ? Colors.grey.shade400
                                      : Colors.grey.shade600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              // Add remark button — only for privileged roles
              if (canAddRemark)
                Tooltip(
                  message:
                      hasAdminRemark ? 'Edit Remark' : 'Add Admin Remark',
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _showInput = !_showInput;
                        if (_showInput && hasAdminRemark) {
                          _remarkController.text = _remarkText!;
                        }
                      });
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.amber.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: Colors.amber.withValues(alpha: 0.4), width: 1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            hasAdminRemark
                                ? Icons.edit_note_rounded
                                : Icons.add_comment_rounded,
                            size: 14,
                            color: Colors.amber.shade700,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            hasAdminRemark ? 'Edit' : 'Remark',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.amber.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),

          // ── Existing Admin Remark Display (read by everyone) ──────────
          if (hasAdminRemark && !_showInput)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                  border:
                      Border.all(color: Colors.amber.withValues(alpha: 0.3), width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.admin_panel_settings_rounded,
                            size: 13, color: Colors.amber),
                        const SizedBox(width: 5),
                        Text(
                          _remarkByName != null
                              ? 'Admin Remark by $_remarkByName'
                              : 'Admin Remark',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _remarkText!,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        height: 1.5,
                        color:
                            isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // ── Remark Input (admin/teamlead only) ────────────────────────
          if (_showInput && canAddRemark)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _remarkController,
                    maxLines: 3,
                    style: GoogleFonts.inter(fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Write your remark for this activity...',
                      hintStyle: GoogleFonts.inter(
                          fontSize: 12,
                          color: isDark
                              ? Colors.grey.shade500
                              : Colors.grey.shade400),
                      filled: true,
                      fillColor: isDark
                          ? const Color(0xFF111827)
                          : const Color(0xFFFFFBEB),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                            color: Colors.amber.withValues(alpha: 0.4), width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                            color: Colors.amber, width: 1.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                            color: Colors.amber.withValues(alpha: 0.3), width: 1),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _showInput = false;
                            _remarkController.clear();
                          });
                        },
                        child: Text('Cancel',
                            style: GoogleFonts.inter(
                                fontSize: 12,
                                color: Colors.grey.shade500)),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _isSaving ? null : _saveRemark,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber.shade600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                        ),
                        child: _isSaving
                            ? const SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white))
                            : Text('Save Remark',
                                style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600)),
                      ),
                    ],
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
                    fontSize: 13,
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
              color: const Color(0xFFF59E0B).withValues(alpha: 0.1),
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
