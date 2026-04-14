import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:project_pm/src/core/database/database.dart';

import 'package:project_pm/src/routes/app_router.dart';
import 'package:project_pm/src/features/team/team_api_service.dart';
import '../../core/utils/user_color_service.dart';
import 'package:project_pm/src/core/providers/user_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_pm/src/core/networking/api_client.dart';
import 'package:project_pm/src/features/projects/providers/api_providers.dart';
import 'package:project_pm/src/features/dashboard/dashboard_providers.dart';
import 'package:project_pm/src/features/quick_notes/notes_provider.dart';
import 'package:project_pm/src/features/today/today_repository.dart';
// ─── Brand colours from the sidebar ─────────────────────────────────────────
const _kNavy = Color(0xFF05263E);
const _kAccent = Color(0xFF7EC8F4);

final teamOverviewPageProvider = StateProvider.autoDispose<int>((ref) => 1);

final paginatedTeamOverviewProvider =
    FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  final page = ref.watch(teamOverviewPageProvider);
  final teamApi = ref.read(teamApiServiceProvider);
  return await teamApi.getTeamMembers(page: page);
});

User _parseMember(Map<String, dynamic> json) {
  return User(
    id: json['id'].toString(),
    name: json['name'] != null && (json['name'] as String).trim().isNotEmpty
        ? json['name'] as String
        : (json['email'] as String).split('@')[0].trim(),
    email: json['email'],
    role: json['role'] as String,
    department: json['department'],
    avatarUrl: '',
    reportingManagerId: null,
  );
}

// ─── Role accent colours ──────────────────────────────────────────────────────
Color _roleAccent(String role) {
  switch (role.toUpperCase()) {
    case 'ADMIN':
      return const Color(0xFF8B5CF6); // purple
    case 'MANAGER':
      return const Color(0xFF3B82F6); // blue
    case 'TEAM_LEAD':
      return const Color(0xFF14B8A6); // teal
    default:
      return const Color(0xFF10B981); // green
  }
}

// ─── Card left-border colours — unique per index ──────────────────────────────
const _kStrokeColors = [
  Color(0xFF3B82F6), // blue
  Color(0xFF10B981), // green
  Color(0xFF8B5CF6), // purple
  Color(0xFFF59E0B), // amber
  Color(0xFFEF4444), // red
  Color(0xFF14B8A6), // teal
  Color(0xFFEC4899), // pink
  Color(0xFF06B6D4), // cyan
];

@RoutePage()
class TeamOverviewPage extends ConsumerWidget {
  const TeamOverviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final teamDataAsync = ref.watch(paginatedTeamOverviewProvider);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF111827) : const Color(0xFFF9FAFB),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(28, 24, 28, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Page header ────────────────────────────────────────────────
            Row(
              children: [
                Container(
                  width: 4,
                  height: 32,
                  decoration: BoxDecoration(
                    color: _kAccent,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Team Overview',
                      style: GoogleFonts.outfit(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : _kNavy,
                        letterSpacing: -0.5,
                      ),
                    ),
                    Text(
                      'Monitor your team\'s workload and progress',
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 28),

            // ── Stats bar ────────────────────────────────────────────────────
            LayoutBuilder(builder: (_, c) {
              final stats = [
                _StatDef(
                  'Team Members',
                  teamDataAsync.maybeWhen(
                      data: (d) => '${d['total_count'] ?? 0}',
                      orElse: () => '—'),
                  FontAwesomeIcons.users,
                  const Color(0xFF3B82F6),
                ),
                _StatDef(
                  'Active Projects',
                  teamDataAsync.maybeWhen(
                      data: (d) =>
                          '${d['team_stats']?['active_projects'] ?? 0}',
                      orElse: () => '—'),
                  FontAwesomeIcons.briefcase,
                  const Color(0xFF10B981),
                ),
                _StatDef(
                  'Tasks This Week',
                  teamDataAsync.maybeWhen(
                      data: (d) =>
                          '${d['team_stats']?['tasks_this_week'] ?? 0}',
                      orElse: () => '—'),
                  FontAwesomeIcons.listCheck,
                  const Color(0xFF8B5CF6),
                ),
                _StatDef(
                  'Completion Rate',
                  teamDataAsync.maybeWhen(
                      data: (d) =>
                          '${d['team_stats']?['completion_rate'] ?? 0}%',
                      orElse: () => '—'),
                  FontAwesomeIcons.chartLine,
                  const Color(0xFFF59E0B),
                ),
              ];

              if (c.maxWidth > 720) {
                return Row(
                  children: stats
                      .expand((s) => [
                            Expanded(
                                child: _StatCard(stat: s, isDark: isDark)),
                            if (s != stats.last) const SizedBox(width: 16),
                          ])
                      .toList(),
                );
              }
              return GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2.4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: stats
                    .map((s) => _StatCard(stat: s, isDark: isDark))
                    .toList(),
              );
            }),
            const SizedBox(height: 32),

            // ── Section title ─────────────────────────────────────────────────
            Row(
              children: [
                Text(
                  'Team Members',
                  style: GoogleFonts.outfit(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : _kNavy,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(width: 10),
                teamDataAsync.maybeWhen(
                  data: (d) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: _kNavy.withAlpha(isDark ? 60 : 18),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${d['total_count'] ?? 0} total',
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: isDark ? _kAccent : _kNavy,
                      ),
                    ),
                  ),
                  orElse: () => const SizedBox.shrink(),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ── Members grid ──────────────────────────────────────────────────
            teamDataAsync.when(
              loading: () => const Center(
                  child: Padding(
                padding: EdgeInsets.all(60),
                child: CircularProgressIndicator(),
              )),
              error: (err, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    children: [
                      Icon(FontAwesomeIcons.circleExclamation,
                          size: 40, color: Colors.red.shade300),
                      const SizedBox(height: 12),
                      Text('Failed to load team members',
                          style: GoogleFonts.outfit(
                              fontSize: 14,
                              color: isDark
                                  ? Colors.grey.shade400
                                  : Colors.grey.shade600)),
                    ],
                  ),
                ),
              ),
              data: (data) {
                final members =
                    (data['members'] as List<dynamic>?) ?? [];

                if (members.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(60),
                      child: Column(
                        children: [
                          Icon(FontAwesomeIcons.usersSlash,
                              size: 40,
                              color: isDark
                                  ? Colors.grey.shade600
                                  : Colors.grey.shade300),
                          const SizedBox(height: 16),
                          Text('No team members to display',
                              style: GoogleFonts.outfit(
                                  fontSize: 14,
                                  color: isDark
                                      ? Colors.grey.shade400
                                      : Colors.grey.shade500)),
                        ],
                      ),
                    ),
                  );
                }

                return Column(
                  children: [
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 340,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 1.08,
                      ),
                      itemCount: members.length,
                      itemBuilder: (context, index) {
                        final memberData =
                            members[index] as Map<String, dynamic>;
                        final member = _parseMember(memberData);
                        final active =
                            (memberData['active_tasks'] as num?)?.toInt() ?? 0;
                        final completed =
                            (memberData['completed_tasks'] as num?)?.toInt() ??
                                0;
                        final totalTasks = active + completed;
                        final workload = totalTasks == 0 
                                ? 0 
                                : ((active / totalTasks) * 100).toInt().clamp(0, 100);
                        final strokeColor =
                            _kStrokeColors[index % _kStrokeColors.length];

                        return _TeamMemberCard(
                          member: member,
                          isDark: isDark,
                          active: active,
                          completed: completed,
                          workload: workload,
                          strokeColor: strokeColor,
                          onTap: () => _openMemberView(context, ref, member),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    // Pagination
                    if ((data['total_pages'] ?? 1) > 1)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _PagBtn(
                            icon: Icons.chevron_left,
                            enabled: data['page'] > 1,
                            onTap: () => ref
                                .read(teamOverviewPageProvider.notifier)
                                .state = data['page'] - 1,
                            isDark: isDark,
                          ),
                          const SizedBox(width: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 8),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF1E293B)
                                  : _kNavy.withAlpha(15),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: _kNavy.withAlpha(isDark ? 60 : 40)),
                            ),
                            child: Text(
                              'Page ${data['page']} of ${data['total_pages'] ?? 1}',
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                color: isDark ? Colors.white70 : _kNavy,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          _PagBtn(
                            icon: Icons.chevron_right,
                            enabled: data['page'] < (data['total_pages'] ?? 1),
                            onTap: () => ref
                                .read(teamOverviewPageProvider.notifier)
                                .state = data['page'] + 1,
                            isDark: isDark,
                          ),
                        ],
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Navigate to view the entire application as this user in read-only mode.
  void _openMemberView(BuildContext context, WidgetRef ref, User member) async {
    final currentUserId = ref.read(currentUserIdProvider);
    if (currentUserId == null || currentUserId == member.id) return;

    final prefs = await SharedPreferences.getInstance();

    // ── 1. Persist impersonation in SharedPreferences ──────────────────────
    // The Dio interceptor reads 'impersonate_user_id' and sends it as the
    // 'X-Impersonate-User' header on EVERY API request. Without this the
    // backend never knows to switch user context and keeps returning admin data.
    await prefs.setString('impersonate_user_id', member.id);
    await prefs.setString('impersonate_user_name', member.name);

    // ── 2. Update Riverpod state ────────────────────────────────────────────
    // Keep the original admin ID so we can restore it on exit
    ref.read(impersonatingFromUserIdProvider.notifier).state = currentUserId;
    ref.read(impersonatingUserNameProvider.notifier).state = member.name;

    // Switch the active user identity to the employee
    ref.read(currentUserIdProvider.notifier).updateId(member.id);

    // Invalidate the root Dio provider so that ALL dependent API providers
    // (projects, planners, notes, dashboard) will be recalculated and
    // recreated. This causes them to refetch data with the new impersonation header.
    ref.invalidate(dioProvider);
    ref.invalidate(taskApiServiceProvider);
    ref.invalidate(dashboardApiProjectsProvider);
    ref.invalidate(apiPaginatedProjectsProvider);
    ref.invalidate(paginatedDashboardProjectsProvider);
    ref.invalidate(filteredDashboardStatsProvider);
    ref.invalidate(apiTasksProvider);
    // Explicitly invalidate other major modules to ensure clean UI refresh
    ref.invalidate(stickyNotesProvider);
    ref.invalidate(todayRepositoryProvider);

    // ── 3. Navigate — AutoRoute replaceAll forces a full widget rebuild ──────
    // Combined with the header now being sent, every provider that fires a
    // new API request will receive the employee's data from the backend.
    if (context.mounted) {
      context.router.replaceAll([const DashboardRoute()]);
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Data model for stat cards
// ─────────────────────────────────────────────────────────────────────────────

class _StatDef {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _StatDef(this.label, this.value, this.icon, this.color);
}

// ─────────────────────────────────────────────────────────────────────────────
// Stat Card
// ─────────────────────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final _StatDef stat;
  final bool isDark;
  const _StatCard({required this.stat, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        gradient: isDark 
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1F2937), Color(0xFF111827)],
              )
            : const LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Colors.white, Color(0xFFF0F7FB)],
              ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? const Color(0xFF374151) : const Color(0xFFE2E8F0),
        ),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: const Color(0xFF05263E).withAlpha(8),
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
              color: stat.color.withAlpha(25),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(stat.icon, size: 18, color: stat.color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  stat.value,
                  style: GoogleFonts.outfit(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : _kNavy,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  stat.label,
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
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
// Team Member Card
// ─────────────────────────────────────────────────────────────────────────────

class _TeamMemberCard extends StatelessWidget {
  final User member;
  final bool isDark;
  final int active;
  final int completed;
  final int workload;
  final Color strokeColor;
  final VoidCallback onTap;

  const _TeamMemberCard({
    required this.member,
    required this.isDark,
    required this.active,
    required this.completed,
    required this.workload,
    required this.strokeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final accent = _roleAccent(member.role);
    final borderColor =
        isDark ? const Color(0xFF374151) : const Color(0xFFE2E8F0);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                )
              : const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.white, Color(0xFFF4FAFE)],
                ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
          boxShadow: isDark
              ? []
              : [
                  BoxShadow(
                    color: const Color(0xFF05263E).withAlpha(10),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Left accent stroke
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 4,
                  decoration: BoxDecoration(
                    color: strokeColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                    ),
                  ),
                ),
              ),
              // faint watermark icon top-right
              Positioned(
                right: -8,
                top: -8,
                child: Icon(
                  member.role.toUpperCase() == 'ADMIN'
                      ? Icons.shield_rounded
                      : member.role.toUpperCase() == 'MANAGER'
                          ? Icons.manage_accounts_rounded
                          : Icons.person_rounded,
                  size: 64,
                  color: strokeColor.withAlpha(isDark ? 18 : 12),
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 16, 16, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // ── Header ───────────────────────────────────────────
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor:
                              UserColorService.getColorForUser(member.id),
                          backgroundImage: member.avatarUrl.isNotEmpty
                              ? NetworkImage(member.avatarUrl)
                              : null,
                          child: member.avatarUrl.isEmpty
                              ? Text(
                                  member.name[0].toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                member.name,
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: isDark ? Colors.white : _kNavy,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 3),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: accent.withAlpha(20),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: accent.withAlpha(60),
                                      width: 1),
                                ),
                                child: Text(
                                  member.role
                                      .replaceAll('_', ' ')
                                      .toUpperCase(),
                                  style: GoogleFonts.outfit(
                                    color: accent,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // View arrow
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 13,
                          color: strokeColor.withAlpha(180),
                        ),
                      ],
                    ),

                    // ── Stats Row ─────────────────────────────────────────
                    Row(
                      children: [
                        _StatPill(
                          label: 'Active',
                          value: '$active',
                          color: const Color(0xFF3B82F6),
                          isDark: isDark,
                        ),
                        const SizedBox(width: 10),
                        _StatPill(
                          label: 'Done',
                          value: '$completed',
                          color: const Color(0xFF10B981),
                          isDark: isDark,
                        ),
                      ],
                    ),

                    // ── Workload bar ──────────────────────────────────────
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Workload',
                              style: GoogleFonts.outfit(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? Colors.grey.shade400
                                    : Colors.grey.shade500,
                              ),
                            ),
                            Text(
                              '$workload%',
                              style: GoogleFonts.outfit(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: _workloadColor(workload),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: (workload / 100).clamp(0.0, 1.0),
                            minHeight: 6,
                            backgroundColor:
                                isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                _workloadColor(workload)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _workloadColor(int w) {
    if (w >= 80) return const Color(0xFFEF4444);
    if (w >= 50) return const Color(0xFFF59E0B);
    return const Color(0xFF10B981);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Stat Pill (inside member card)
// ─────────────────────────────────────────────────────────────────────────────

class _StatPill extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final bool isDark;
  const _StatPill(
      {required this.label,
      required this.value,
      required this.color,
      required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withAlpha(isDark ? 30 : 18),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: color,
              height: 1.1,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: color.withAlpha(180),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Pagination button helper
// ─────────────────────────────────────────────────────────────────────────────

class _PagBtn extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;
  final bool isDark;
  const _PagBtn(
      {required this.icon,
      required this.enabled,
      required this.onTap,
      required this.isDark});

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: enabled ? 1.0 : 0.35,
      duration: const Duration(milliseconds: 150),
      child: Material(
        color: enabled
            ? _kNavy.withAlpha(isDark ? 50 : 20)
            : Colors.grey.withAlpha(20),
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(icon,
                color: enabled
                    ? (isDark ? _kAccent : _kNavy)
                    : Colors.grey,
                size: 20),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Deprecated — kept for compilation safety
// ─────────────────────────────────────────────────────────────────────────────

// ignore: unused_element
final memberStatsProvider =
    FutureProvider.family<Map<String, int>, String>((ref, userId) async {
  return {'active': 0, 'completed': 0, 'workload': 0};
});
