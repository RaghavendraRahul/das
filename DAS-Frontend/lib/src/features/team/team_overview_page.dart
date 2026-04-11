import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:project_pm/src/core/database/database.dart';
import 'package:project_pm/src/core/providers/user_providers.dart';
import 'package:project_pm/src/routes/app_router.dart';
import 'package:project_pm/src/features/team/team_api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_pm/src/core/networking/api_client.dart';
import '../../core/utils/user_color_service.dart';

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

@RoutePage()
class TeamOverviewPage extends ConsumerWidget {
  const TeamOverviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = Theme.of(context).cardColor;
    final borderColor = isDark ? const Color(0xFF374151) : Colors.grey.shade200;
    final mutedText = isDark ? Colors.grey.shade400 : Colors.grey.shade600;

    final teamDataAsync = ref.watch(paginatedTeamOverviewProvider);
    final visibleTeam = ref.watch(visibleTeamMembersProvider);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Team Stats
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 800) {
                  // Wide screen: 4 columns
                  return Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          title: 'Team Members',
                          value: teamDataAsync.maybeWhen(
                              data: (d) => '${d['total_count'] ?? 0}',
                              orElse: () => '-'),
                          icon: FontAwesomeIcons.users,
                          color: Colors.blue,
                          isDark: isDark,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _StatCard(
                          title: 'Active Projects',
                          value: teamDataAsync.maybeWhen(
                              data: (d) =>
                                  '${d['team_stats']?['active_projects'] ?? 0}',
                              orElse: () => '-'),
                          icon: FontAwesomeIcons.briefcase,
                          color: Colors.green,
                          isDark: isDark,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _StatCard(
                          title: 'Tasks This Week',
                          value: teamDataAsync.maybeWhen(
                              data: (d) =>
                                  '${d['team_stats']?['tasks_this_week'] ?? 0}',
                              orElse: () => '-'),
                          icon: FontAwesomeIcons.listCheck,
                          color: Colors.purple,
                          isDark: isDark,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _StatCard(
                          title: 'Completion Rate',
                          value: teamDataAsync.maybeWhen(
                              data: (d) =>
                                  '${d['team_stats']?['completion_rate'] ?? 0}%',
                              orElse: () => '-'),
                          icon: FontAwesomeIcons.chartLine,
                          color: Colors.orange,
                          isDark: isDark,
                        ),
                      ),
                    ],
                  );
                } else {
                  // Narrow screen: 2 columns grid
                  return GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 2.5,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _StatCard(
                        title: 'Team Members',
                        value: teamDataAsync.maybeWhen(
                            data: (d) => '${d['total_count'] ?? 0}',
                            orElse: () => '-'),
                        icon: FontAwesomeIcons.users,
                        color: Colors.blue,
                        isDark: isDark,
                      ),
                      _StatCard(
                        title: 'Active Projects',
                        value: teamDataAsync.maybeWhen(
                            data: (d) =>
                                '${d['team_stats']?['active_projects'] ?? 0}',
                            orElse: () => '-'),
                        icon: FontAwesomeIcons.briefcase,
                        color: Colors.green,
                        isDark: isDark,
                      ),
                      _StatCard(
                        title: 'Tasks This Week',
                        value: teamDataAsync.maybeWhen(
                            data: (d) =>
                                '${d['team_stats']?['tasks_this_week'] ?? 0}',
                            orElse: () => '-'),
                        icon: FontAwesomeIcons.listCheck,
                        color: Colors.purple,
                        isDark: isDark,
                      ),
                      _StatCard(
                        title: 'Completion Rate',
                        value: teamDataAsync.maybeWhen(
                            data: (d) =>
                                '${d['team_stats']?['completion_rate'] ?? 0}%',
                            orElse: () => '-'),
                        icon: FontAwesomeIcons.chartLine,
                        color: Colors.orange,
                        isDark: isDark,
                      ),
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 32),

            // Team Members Grid (from database)
            Text(
              'Team Members',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),

            teamDataAsync.when(
              loading: () => const Center(
                  child: Padding(
                padding: EdgeInsets.all(40.0),
                child: CircularProgressIndicator(),
              )),
              error: (err, st) => Container(
                padding: const EdgeInsets.all(40),
                child: Center(
                  child: Column(
                    children: [
                      Icon(FontAwesomeIcons.circleExclamation,
                          size: 48, color: Colors.red.shade300),
                      const SizedBox(height: 16),
                      Text('Error loading team members',
                          style: TextStyle(color: mutedText, fontSize: 15)),
                    ],
                  ),
                ),
              ),
              data: (data) {
                final members = (data['members'] as List<dynamic>?) ?? [];

                if (visibleTeam.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(40),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(FontAwesomeIcons.usersSlash,
                              size: 48, color: mutedText),
                          const SizedBox(height: 16),
                          Text('No team members to display',
                              style: TextStyle(color: mutedText, fontSize: 15)),
                          const SizedBox(height: 8),
                          Text(
                            'Only managers and team leads can view team members.',
                            style: TextStyle(color: mutedText, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (members.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(40),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(FontAwesomeIcons.usersSlash,
                              size: 48, color: mutedText),
                          const SizedBox(height: 16),
                          Text('No team members available on this page.',
                              style: TextStyle(color: mutedText, fontSize: 15)),
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
                        maxCrossAxisExtent: 350,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 1.1,
                      ),
                      itemCount: members.length,
                      itemBuilder: (context, index) {
                        final memberData = members[index];
                        final member = _parseMember(memberData);
                        final stats = <String, int>{
                          'active': memberData['active_tasks'] ?? 0,
                          'completed': memberData['completed_tasks'] ?? 0,
                          'workload': memberData['workload_intensity'] ?? 0,
                        };

                        return _TeamMemberCard(
                          member: member,
                          isDark: isDark,
                          cardBg: cardBg,
                          borderColor: borderColor,
                          mutedText: mutedText,
                          stats: stats,
                          onTap: () {
                            _showMemberDetails(context, ref, member, stats);
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    // Pagination Controls
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: data['page'] > 1
                                ? Colors.blue.withAlpha(25)
                                : Colors.grey.withAlpha(25),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.chevron_left),
                            color: data['page'] > 1 ? Colors.blue : Colors.grey,
                            onPressed: data['page'] > 1
                                ? () {
                                    ref
                                        .read(teamOverviewPageProvider.notifier)
                                        .state = data['page'] - 1;
                                  }
                                : null,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF1E293B)
                                : Colors.blue.withAlpha(12),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: isDark
                                    ? const Color(0xFF334155)
                                    : Colors.blue.withAlpha(50)),
                          ),
                          child: Text(
                            'Page ${data['page']} of ${data['total_pages'] ?? 1}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color:
                                  isDark ? Colors.white : Colors.blue.shade700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: data['page'] < (data['total_pages'] ?? 1)
                                ? Colors.blue.withAlpha(25)
                                : Colors.grey.withAlpha(25),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.chevron_right),
                            color: data['page'] < (data['total_pages'] ?? 1)
                                ? Colors.blue
                                : Colors.grey,
                            onPressed: data['page'] < (data['total_pages'] ?? 1)
                                ? () {
                                    ref
                                        .read(teamOverviewPageProvider.notifier)
                                        .state = data['page'] + 1;
                                  }
                                : null,
                          ),
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

  void _showMemberDetails(BuildContext context, WidgetRef ref, User member,
      Map<String, int> stats) {
    showDialog(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            width: 400,
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: UserColorService.getColorForUser(member.id),
                      backgroundImage: member.avatarUrl.isNotEmpty
                          ? NetworkImage(member.avatarUrl)
                          : null,
                      child: member.avatarUrl.isEmpty
                          ? Text(member.name[0].toUpperCase(),
                              style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold))
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(member.name,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          Text(member.email,
                              style: TextStyle(
                                  color: Colors.grey.shade600, fontSize: 13)),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color:
                                  _getRoleColor(member.role).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              member.role.replaceAll('_', ' '),
                              style: TextStyle(
                                color: _getRoleColor(member.role),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),
                const Text("Performance Summary",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatColumn("Active", "${stats['active']}", Colors.blue),
                    _StatColumn(
                        "Completed", "${stats['completed']}", Colors.green),
                    _StatColumn(
                        "Workload", "${stats['workload']}%", Colors.orange),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      Navigator.pop(context); // Close dialog

                      // Impersonate
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setString('impersonate_user_id', member.id);
                      await prefs.setString(
                          'impersonate_user_name', member.name);

                      final currentId = ref.read(currentUserIdProvider);
                      // This triggers the global banner and puts app in read-only mode
                      ref.read(impersonatingFromUserIdProvider.notifier).state =
                          currentId;
                      ref.read(impersonatingUserNameProvider.notifier).state =
                          member.name;

                      // Navigate to Dashboard to reload original data
                      if (context.mounted) {
                        // For a clean web experience, we could use html.window.location.reload()
                        // But to be cross-platform, we force clear the API cache locally
                        // or just recreate the DIO client.
                        ref.invalidate(dioProvider);

                        context.router.navigate(const DashboardRoute());
                      }
                    },
                    icon: const Icon(Icons.login),
                    label: const Text("View As This User"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: Colors.blue.shade600,
                      foregroundColor: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _StatColumn(String label, String value, Color color) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'ADMIN':
        return Colors.purple;
      case 'MANAGER':
        return Colors.blue;
      case 'TEAM_LEAD':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }
}

// Provider to fetch stats for a specific user - DEPRECATED in favor of teamStatsProvider
final memberStatsProvider =
    FutureProvider.family<Map<String, int>, String>((ref, userId) async {
  return {'active': 0, 'completed': 0, 'workload': 0};
});

class _TeamMemberCard extends StatelessWidget {
  final User member;
  final bool isDark;
  final Color cardBg;
  final Color borderColor;
  final Color mutedText;
  final VoidCallback onTap;
  final Map<String, int> stats;

  const _TeamMemberCard({
    required this.member,
    required this.isDark,
    required this.cardBg,
    required this.borderColor,
    required this.mutedText,
    required this.onTap,
    this.stats = const {'active': 0, 'completed': 0, 'workload': 0},
  });

  @override
  Widget build(BuildContext context) {
    final active = stats['active'] ?? 0;
    final completed = stats['completed'] ?? 0;
    final workload = stats['workload'] ?? 0;

    // Helper to get role color
    Color getRoleColor(String role) {
      switch (role) {
        case 'ADMIN':
          return Colors.purple;
        case 'MANAGER':
          return Colors.blue;
        case 'TEAM_LEAD':
          return Colors.teal;
        default:
          return Colors.grey;
      }
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16), // Reduced padding
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          // Ensure space between elements, but start alignment
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Avatar, Name, Role
            Row(
              children: [
                CircleAvatar(
                  radius: 20, // Slightly smaller
                  backgroundColor: UserColorService.getColorForUser(member.id),
                  backgroundImage: member.avatarUrl.isNotEmpty
                      ? NetworkImage(member.avatarUrl)
                      : null,
                  child: member.avatarUrl.isEmpty 
                      ? Text(member.name[0].toUpperCase(), style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold)) 
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        member.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: getRoleColor(member.role).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          member.role.replaceAll('_', ' '),
                          style: TextStyle(
                            color: getRoleColor(member.role),
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Removed fixed SizedBox, relying on MainAxisAlignment.spaceBetween

            // Stats Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Active Tasks',
                      style: TextStyle(color: mutedText, fontSize: 10),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$active',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Completed',
                      style: TextStyle(color: mutedText, fontSize: 10),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$completed',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Workload Row (Moved closer to bottom)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Workload',
                      style: TextStyle(color: mutedText, fontSize: 10),
                    ),
                    Text(
                      '${workload.toInt()}%',
                      style: TextStyle(
                          color: mutedText,
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: workload / 100,
                    backgroundColor:
                        isDark ? Colors.grey.shade800 : Colors.blue.shade50,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.blue.shade300),
                    minHeight: 6,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final bool isDark;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF374151) : Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withAlpha(25),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
