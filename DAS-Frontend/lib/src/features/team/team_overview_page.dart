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

// ─── Brand colours ───────────────────────────────────────────────────────────
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

// ─── Route Page ──────────────────────────────────────────────────────────────

// ─── Route Page ──────────────────────────────────────────────────────────────

@RoutePage()
class TeamOverviewPage extends ConsumerWidget {
  const TeamOverviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final teamDataAsync = ref.watch(paginatedTeamOverviewProvider);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF111827) : const Color(0xFFF9FAFB),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(paginatedTeamOverviewProvider);
          return ref.read(paginatedTeamOverviewProvider.future);
        },
        color: _kAccent,
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(28, 8, 28, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 0),

              // ── Stats bar ────────────────────────────────────────────────────
              LayoutBuilder(builder: (_, c) {
              final stats = [
                _StatDef(
                  'TOTAL STRENGTH',
                  teamDataAsync.maybeWhen(
                      data: (d) => '${d['total_count'] ?? 0} Team\nMembers',
                      orElse: () => '— Team\nMembers'),
                  FontAwesomeIcons.userGroup,
                  const Color(0xFF6366F1), // faded purple-blue icon
                ),
                _StatDef(
                  'ACTIVE NOW',
                  teamDataAsync.maybeWhen(
                      data: (d) => '${d['team_stats']?['active_projects'] ?? 0} Active\nProjects',
                      orElse: () => '— Active\nProjects'),
                  FontAwesomeIcons.rocket,
                  const Color(0xFF10B981), // faded green
                ),
                _StatDef(
                  'PIPELINE',
                  teamDataAsync.maybeWhen(
                      data: (d) => '${d['team_stats']?['tasks_this_week'] ?? 0} Tasks\nthis week',
                      orElse: () => '— Tasks\nthis week'),
                  FontAwesomeIcons.clipboardCheck,
                  const Color(0xFF3B82F6), // faded blue
                ),
                _StatDef(
                  'OVERALL VELOCITY',
                  teamDataAsync.maybeWhen(
                      data: (d) => '${d['team_stats']?['completion_rate'] ?? 0}%\nCompletion rate',
                      orElse: () => '— %\nCompletion rate'),
                  FontAwesomeIcons.chartLine,
                  const Color(0xFF8B5CF6), // faded purple
                ),
              ];

                return Row(
                  children: stats
                      .map((s) => Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              child: _StatCard(stat: s, isDark: isDark),
                            ),
                          ))
                      .toList(),
                );
              }),

              const SizedBox(height: 28),

              // ── Members Section ─────────────────────────────────────────────
              teamDataAsync.when(
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(60),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (err, _) => Center(
                  child: Text('Failed to load team: $err'),
                ),
                data: (data) {
                  final members = (data['members'] as List<dynamic>?) ?? [];

                  if (members.isEmpty) {
                    return const Center(child: Text('No members found.'));
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with blue accent bar
                      Row(
                        children: [
                          Container(
                            width: 4,
                            height: 24,
                            decoration: BoxDecoration(
                              color: _kAccent,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'TEAM MEMBERS',
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white70 : _kNavy.withAlpha(180),
                              letterSpacing: 1.2,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${data['total_count'] ?? 0} total',
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white70 : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 260,
                          mainAxisSpacing: 24,
                          crossAxisSpacing: 24,
                          childAspectRatio: 0.98, // Smaller, smarter height for cards
                        ),
                        itemCount: members.length,
                        itemBuilder: (context, index) {
                          final memberData = members[index] as Map<String, dynamic>;
                          final member = _parseMember(memberData);
                          final active = (memberData['active_tasks'] as num?)?.toInt() ?? 0;
                          final completed = (memberData['completed_tasks'] as num?)?.toInt() ?? 0;
                          
                          // Use unified sidebar theme stroke color for all cards
                          const strokeColor = _kNavy;

                          return _TeamMemberCard(
                            member: member,
                            isDark: isDark,
                            active: active,
                            completed: completed,
                            strokeColor: strokeColor,
                            onTap: () => _openMemberView(context, ref, member),
                          );
                        },
                      ),

                      const SizedBox(height: 32),

                      // Pagination
                      if ((data['total_pages'] ?? 1) > 1)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _PagBtn(
                              icon: Icons.chevron_left,
                              enabled: data['page'] > 1,
                              onTap: () => ref.read(teamOverviewPageProvider.notifier).state =
                                  data['page'] - 1,
                              isDark: isDark,
                            ),
                            const SizedBox(width: 16),
                            Text(
                              'Page ${data['page']} of ${data['total_pages']}',
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white70 : _kNavy,
                              ),
                            ),
                            const SizedBox(width: 16),
                            _PagBtn(
                              icon: Icons.chevron_right,
                              enabled: data['page'] < (data['total_pages'] ?? 1),
                              onTap: () => ref.read(teamOverviewPageProvider.notifier).state =
                                  data['page'] + 1,
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
      ),
    );
  }

  void _openMemberView(BuildContext context, WidgetRef ref, User member) async {
    final currentUserId = ref.read(currentUserIdProvider);
    if (currentUserId == null || currentUserId == member.id) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('impersonate_user_id', member.id);
    await prefs.setString('impersonate_user_name', member.name);

    ref.read(impersonatingFromUserIdProvider.notifier).state = currentUserId;
    ref.read(impersonatingUserNameProvider.notifier).state = member.name;
    ref.read(currentUserIdProvider.notifier).updateId(member.id);

    ref.invalidate(dioProvider);
    ref.invalidate(taskApiServiceProvider);
    ref.invalidate(dashboardApiProjectsProvider);
    ref.invalidate(apiPaginatedProjectsProvider);
    ref.invalidate(paginatedDashboardProjectsProvider);
    ref.invalidate(filteredDashboardStatsProvider);
    ref.invalidate(apiTasksProvider);
    ref.invalidate(stickyNotesProvider);
    ref.invalidate(todayRepositoryProvider);

    if (context.mounted) {
      context.router.replaceAll([const DashboardRoute()]);
    }
  }
}

class _StatDef {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _StatDef(this.label, this.value, this.icon, this.color);
}

class _StatCard extends StatelessWidget {
  final _StatDef stat;
  final bool isDark;
  const _StatCard({required this.stat, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 95,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF374151) : const Color(0xFFE2E8F0),
        ),
        boxShadow: isDark ? [] : [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // ── Ribbon (Navy bookmark) ────────────────────────
            Positioned(
              top: 0,
              right: 16,
              child: Container(
                width: 22,
                height: 28,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2D3748) : _kNavy,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(4),
                    bottomRight: Radius.circular(4),
                  ),
                ),
                child: const Icon(Icons.bookmark, size: 12, color: Colors.white70),
              ),
            ),

            // ── Faint background icon ────────────────────────
            Positioned(
              bottom: 8,
              right: 8,
              child: Icon(
                stat.icon,
                size: 52,
                color: stat.color.withAlpha(isDark ? 30 : 20),
              ),
            ),

            // ── Text Content ───────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 16, 14, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stat.label,
                    style: GoogleFonts.outfit(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white70 : _kNavy.withAlpha(200),
                      letterSpacing: 0.6,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    stat.value,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : _kNavy.withAlpha(240),
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TeamMemberCard extends StatelessWidget {
  final User member;
  final bool isDark;
  final int active;
  final int completed;
  final Color strokeColor;
  final VoidCallback onTap;

  const _TeamMemberCard({
    required this.member,
    required this.isDark,
    required this.active,
    required this.completed,
    required this.strokeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? const Color(0xFF374151) : const Color(0xFFE2E8F0),
            width: 1.2,
          ),
          boxShadow: isDark ? [] : [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 4,
                  color: strokeColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: strokeColor, width: 2),
                      ),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: UserColorService.getColorForUser(member.id),
                        child: Text(
                          member.name[0].toUpperCase(),
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      member.name,
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: isDark ? Colors.white : _kNavy,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: (isDark ? _kAccent : _kNavy).withAlpha(20),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        member.role.toUpperCase(),
                        style: GoogleFonts.outfit(
                          color: isDark ? Colors.white.withAlpha(220) : _kNavy.withAlpha(200),
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _StatCell(label: 'ACTIVE', value: '$active', color: isDark ? Colors.white70 : _kNavy, isDark: isDark),
                        Container(width: 1, height: 20, color: isDark ? Colors.white10 : Colors.black12),
                        _StatCell(label: 'COMPLETED', value: '$completed', color: isDark ? Colors.white70 : _kNavy, isDark: isDark),
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
}

class _StatCell extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final bool isDark;
  const _StatCell({required this.label, required this.value, required this.color, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w800, color: color)),
        Text(label, style: GoogleFonts.outfit(fontSize: 8, fontWeight: FontWeight.w600, color: isDark ? Colors.white70 : Colors.grey)),
      ],
    );
  }
}

class _PagBtn extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;
  final bool isDark;
  const _PagBtn({required this.icon, required this.enabled, required this.onTap, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: enabled ? onTap : null,
      icon: Icon(icon, color: enabled ? (isDark ? _kAccent : _kNavy) : Colors.grey),
    );
  }
}
