import 'package:auto_route/auto_route.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:project_pm/src/features/projects/providers/api_providers.dart';
import 'package:project_pm/src/features/projects/project_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:project_pm/src/features/dashboard/dashboard_providers.dart';
import 'dart:ui';

part 'approvals_page.g.dart';

// Provider to track pending vs history mode
final approvalsViewModeProvider = StateProvider<String>((ref) => 'PENDING');

// Provider for new project approval requests
@riverpod
Future<List<Map<String, dynamic>>> apiNewProjects(ApiNewProjectsRef ref) async {
  final apiService = ref.watch(taskApiServiceProvider);
  final viewMode = ref.watch(approvalsViewModeProvider);
  try {
    final result = await apiService.getPendingProjects(status: viewMode);
    return result.cast<Map<String, dynamic>>();
  } catch (e) {
    throw Exception('Failed to fetch new projects: $e');
  }
}

// Provider for project closure approval requests
@riverpod
Future<List<Map<String, dynamic>>> apiProjectClosures(
    ApiProjectClosuresRef ref) async {
  final apiService = ref.watch(taskApiServiceProvider);
  final viewMode = ref.watch(approvalsViewModeProvider);
  try {
    final result = await apiService.getPendingProjectClosures(status: viewMode);
    return result.cast<Map<String, dynamic>>();
  } catch (e) {
    throw Exception('Failed to fetch project closures: $e');
  }
}

// Provider for new task approval requests
@riverpod
Future<List<Map<String, dynamic>>> apiNewTasks(ApiNewTasksRef ref) async {
  final apiService = ref.watch(taskApiServiceProvider);
  final viewMode = ref.watch(approvalsViewModeProvider);
  try {
    final result = await apiService.getPendingTasks(status: viewMode);
    return result.cast<Map<String, dynamic>>();
  } catch (e) {
    throw Exception('Failed to fetch new tasks: $e');
  }
}

// Provider for task completion approval requests
@riverpod
Future<List<Map<String, dynamic>>> apiTaskCompletions(
    ApiTaskCompletionsRef ref) async {
  final apiService = ref.watch(taskApiServiceProvider);
  final viewMode = ref.watch(approvalsViewModeProvider);
  try {
    final result = await apiService.getPendingTaskCompletions(status: viewMode);
    return result.cast<Map<String, dynamic>>();
  } catch (e) {
    throw Exception('Failed to fetch task completions: $e');
  }
}

@RoutePage()
class ApprovalsPage extends HookConsumerWidget {
  const ApprovalsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabController = useTabController(initialLength: 4);
    // Listen to tabController to rebuild for badge color synchronization
    useListenable(tabController);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final viewMode = ref.watch(approvalsViewModeProvider);

    // Brand Colors
    const brandNavy = Color(0xFF05263E);
    const brandAccent = Color(0xFF7EC8F4);
    final activeColor = isDark ? brandAccent : brandNavy;
    final selectedLabelColor = isDark ? brandNavy : Colors.white;
    final unselectedLabelColor = activeColor;

    // Watch providers at the top level for a stable build cycle
    final projects = ref.watch(apiNewProjectsProvider);
    final closures = ref.watch(apiProjectClosuresProvider);
    final tasks = ref.watch(apiNewTasksProvider);
    final completions = ref.watch(apiTaskCompletionsProvider);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF111827) : Colors.grey.shade50,
      body: Column(
        children: [
          // ── Combined Tab Bar + Toggle Row ──────────────────────────────
          ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1F2937).withOpacity(0.7)
                      : Colors.white.withOpacity(0.7),
                  border: Border(
                    bottom: BorderSide(
                        color: isDark
                            ? Colors.white.withOpacity(0.1)
                            : Colors.grey.shade200),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      // Tab bar takes remaining space
                      Expanded(
                        child: SizedBox(
                          height: 44,
                          child: TabBar(
                            controller: tabController,
                            isScrollable: true,
                            labelColor: selectedLabelColor,
                            unselectedLabelColor: unselectedLabelColor,
                            dividerColor: Colors.transparent,
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicator: BoxDecoration(
                              borderRadius: BorderRadius.circular(22),
                              color: activeColor,
                            ),
                            labelPadding: const EdgeInsets.symmetric(horizontal: 20),
                            labelStyle: GoogleFonts.outfit(
                                fontWeight: FontWeight.bold, fontSize: 13.5, letterSpacing: 0.3),
                            unselectedLabelStyle: GoogleFonts.outfit(
                                fontWeight: FontWeight.w600, fontSize: 13.5),
                            tabs: [
                              _buildApiTab(projects, 'New Projects', isDark, tabController.index == 0),
                              _buildApiTab(closures, 'Project Closures', isDark, tabController.index == 1),
                              _buildApiTab(tasks, 'New Tasks', isDark, tabController.index == 2),
                              _buildApiTab(completions, 'Task Completions', isDark, tabController.index == 3),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Pending / History toggle on same row
                      Container(
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withOpacity(0.05)
                              : Colors.black.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildToggleBtn(context, ref, 'PENDING', 'Pending', viewMode, isDark),
                            _buildToggleBtn(context, ref, 'HISTORY', 'History', viewMode, isDark),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                _ApiNewProjectsTab(isDark: isDark),
                _ProjectClosuresTab(isDark: isDark),
                _ApiNewTasksTab(isDark: isDark),
                _ApiTaskCompletionsTab(isDark: isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApiTab(AsyncValue<List<Map<String, dynamic>>> asyncValue,
      String label, bool isDark, bool isSelected) {
    const brandNavy = Color(0xFF05263E);
    const brandAccent = Color(0xFF7EC8F4);
    final baseActiveColor = isDark ? brandAccent : brandNavy;
    final badgeBgColor = isSelected
        ? (isDark ? brandNavy : Colors.white)
        : baseActiveColor.withOpacity(0.12);
    final badgeTextColor = isSelected ? baseActiveColor : baseActiveColor;
    final count = asyncValue.when(
      data: (list) => list.length,
      loading: () => 0,
      error: (_, __) => 0,
    );
    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          if (count > 0) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: badgeBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                    fontSize: 11,
                    color: badgeTextColor,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildToggleBtn(BuildContext context, WidgetRef ref, String value, String label, String currentVal, bool isDark) {
    final isSelected = value == currentVal;
    return GestureDetector(
      onTap: () => ref.read(approvalsViewModeProvider.notifier).state = value,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected 
              ? (isDark ? const Color(0xFF7EC8F4) : const Color(0xFF05263E))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected 
                ? (isDark ? const Color(0xFF05263E) : Colors.white)
                : (isDark ? Colors.white70 : Colors.black87),
          ),
        ),
      ),
    );
  }
}

// ========== NEW PROJECTS TAB ==========
class _ApiNewProjectsTab extends ConsumerWidget {
  final bool isDark;

  const _ApiNewProjectsTab({required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsAsync = ref.watch(apiNewProjectsProvider);
    final apiService = ref.read(taskApiServiceProvider);

    return projectsAsync.when(
      data: (projects) {
        if (projects.isEmpty) {
          return Center(
            child: Text(
              'No pending project requests.',
              style: TextStyle(
                  color: Colors.grey.shade400, fontStyle: FontStyle.italic),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: projects.length,
          itemBuilder: (context, index) {
            final project = projects[index];
            return _ApiProjectCard(
              data: project,
              isDark: isDark,
              icon: Icons.create_new_folder,
              iconColor: Colors.blue,
              borderColor: Colors.blue,
              nameKey: 'project_name',
              descriptionKey: 'description',
              onApprove: () async {
                await apiService.approveRequest(project['approval_id']);
                ref.invalidate(apiNewProjectsProvider);
                ref.invalidate(apiProjectsProvider);
                ref.invalidate(paginatedDashboardProjectsProvider);
                ref.invalidate(filteredDashboardStatsProvider);
                ref.invalidate(dashboardProjectsProvider);
              },
              onReject: () async {
                final reasonController = TextEditingController();
                final reason = await showDialog<String>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text(
                      'Reject Project',
                      style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
                    ),
                    content: TextField(
                      controller: reasonController,
                      decoration: InputDecoration(
                        hintText: 'Enter reason for rejection',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      maxLines: 3,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: Text('Cancel', style: GoogleFonts.outfit(color: Colors.grey)),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (reasonController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(ctx).showSnackBar(
                              const SnackBar(content: Text('Please enter a rejection reason.')),
                            );
                            return;
                          }
                          Navigator.pop(ctx, reasonController.text.trim());
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFB7185)),
                        child: Text('Reject', style: GoogleFonts.outfit(color: Colors.white)),
                      ),
                    ],
                  ),
                );

                if (reason != null && reason.isNotEmpty) {
                  await apiService.rejectRequest(project['approval_id'], reason: reason);
                  ref.invalidate(apiNewProjectsProvider);
                  ref.invalidate(apiProjectsProvider);
                  ref.invalidate(paginatedDashboardProjectsProvider);
                  ref.invalidate(filteredDashboardStatsProvider);
                  ref.invalidate(dashboardProjectsProvider);
                }
              },
              approveLabel: 'Approve',
              rejectLabel: 'Reject',
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text("Error: $e")),
    );
  }
}

// ========== PROJECT CLOSURES TAB ==========
class _ProjectClosuresTab extends ConsumerWidget {
  final bool isDark;

  const _ProjectClosuresTab({required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final closuresAsync = ref.watch(apiProjectClosuresProvider);

    return closuresAsync.when(
      data: (closures) {
        if (closures.isEmpty) {
          return Center(
            child: Text(
              'No pending project closures.',
              style: TextStyle(
                  color: Colors.grey.shade400, fontStyle: FontStyle.italic),
            ),
          );
        }

        final apiService = ref.read(taskApiServiceProvider);

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: closures.length,
          itemBuilder: (context, index) {
            final closure = closures[index];
            return _ProjectClosureCard(
              closure: closure,
              isDark: isDark,
              onApprove: () async {
                await apiService.approveRequest(closure['approval_id']);
                ref.invalidate(apiProjectClosuresProvider);
                ref.invalidate(apiProjectsProvider);
                ref.invalidate(paginatedDashboardProjectsProvider);
                ref.invalidate(currentProjectProvider);
                ref.invalidate(projectsWithTasksProvider);
                ref.invalidate(filteredDashboardStatsProvider);
                ref.invalidate(dashboardProjectsProvider);
              },
              onReject: () async {
                await apiService.rejectRequest(closure['approval_id']);
                ref.invalidate(apiProjectClosuresProvider);
                ref.invalidate(apiProjectsProvider);
                ref.invalidate(paginatedDashboardProjectsProvider);
                ref.invalidate(currentProjectProvider);
                ref.invalidate(projectsWithTasksProvider);
                ref.invalidate(filteredDashboardStatsProvider);
                ref.invalidate(dashboardProjectsProvider);
              },
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text("Error: $e")),
    );
  }
}

// ========== NEW TASKS TAB ==========
class _ApiNewTasksTab extends ConsumerWidget {
  final bool isDark;

  const _ApiNewTasksTab({required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(apiNewTasksProvider);
    final apiService = ref.read(taskApiServiceProvider);

    return tasksAsync.when(
      data: (items) {
        if (items.isEmpty) {
          return Center(
            child: Text(
              'No pending task creation requests.',
              style: TextStyle(
                  color: Colors.grey.shade400, fontStyle: FontStyle.italic),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return _ApiTaskCard(
              data: item,
              isDark: isDark,
              onApprove: () async {
                await apiService.approveRequest(item['approval_id']);
                ref.invalidate(apiNewTasksProvider);
                ref.invalidate(apiTasksProvider);
                ref.invalidate(projectsWithTasksProvider);
                ref.invalidate(currentProjectProvider);
                ref.invalidate(filteredDashboardStatsProvider);
                ref.invalidate(dashboardProjectsProvider);
              },
              onReject: () async {
                final reasonController = TextEditingController();
                final reason = await showDialog<String>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text(
                      'Reject Task Creation',
                      style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
                    ),
                    content: TextField(
                      controller: reasonController,
                      decoration: InputDecoration(
                        hintText: 'Enter reason for rejection',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      maxLines: 3,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: Text('Cancel',
                            style: GoogleFonts.outfit(color: Colors.grey)),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (reasonController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(ctx).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Please enter a rejection reason.')),
                            );
                            return;
                          }
                          Navigator.pop(ctx, reasonController.text.trim());
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFB7185)),
                        child: Text('Reject',
                            style: GoogleFonts.outfit(color: Colors.white)),
                      ),
                    ],
                  ),
                );

                if (reason != null && reason.isNotEmpty) {
                  await apiService.rejectRequest(item['approval_id'],
                      reason: reason);
                  ref.invalidate(apiNewTasksProvider);
                  ref.invalidate(filteredDashboardStatsProvider);
                  ref.invalidate(dashboardProjectsProvider);
                }
              },
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text("Error: $e")),
    );
  }
}

// ========== TASK COMPLETIONS TAB ==========
class _ApiTaskCompletionsTab extends ConsumerWidget {
  final bool isDark;

  const _ApiTaskCompletionsTab({required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(apiTaskCompletionsProvider);
    final apiService = ref.read(taskApiServiceProvider);

    return tasksAsync.when(
      data: (items) {
        if (items.isEmpty) {
          return Center(
            child: Text(
              'No pending task completions.',
              style: TextStyle(
                  color: Colors.grey.shade400, fontStyle: FontStyle.italic),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return _ApiTaskCompletionCard(
              data: item,
              isDark: isDark,
              onApprove: () async {
                await apiService.approveRequest(item['approval_id']);
                ref.invalidate(apiTaskCompletionsProvider);
                ref.invalidate(apiTasksProvider);
                ref.invalidate(projectsWithTasksProvider);
                ref.invalidate(currentProjectProvider);
                ref.invalidate(filteredDashboardStatsProvider);
                ref.invalidate(dashboardProjectsProvider);
              },
              onReject: () async {
                final reasonController = TextEditingController();
                final reason = await showDialog<String>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text(
                      'Reject Task Completion',
                      style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
                    ),
                    content: TextField(
                      controller: reasonController,
                      decoration: InputDecoration(
                        hintText: 'Enter reason for rejection',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      maxLines: 3,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: Text('Cancel',
                            style: GoogleFonts.outfit(color: Colors.grey)),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (reasonController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(ctx).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Please enter a rejection reason.')),
                            );
                            return;
                          }
                          Navigator.pop(ctx, reasonController.text.trim());
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFB7185)),
                        child: Text('Reject',
                            style: GoogleFonts.outfit(color: Colors.white)),
                      ),
                    ],
                  ),
                );

                if (reason != null && reason.isNotEmpty) {
                  await apiService.rejectRequest(item['approval_id'],
                      reason: reason);
                  ref.invalidate(apiTaskCompletionsProvider);
                  ref.invalidate(apiTasksProvider);
                  ref.invalidate(projectsWithTasksProvider);
                  ref.invalidate(currentProjectProvider);
                  ref.invalidate(filteredDashboardStatsProvider);
                  ref.invalidate(dashboardProjectsProvider);
                }
              },
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text("Error: $e")),
    );
  }
}

// ========== REUSABLE CARDS ==========

// Generic API card for New Projects tab
class _ApiProjectCard extends HookWidget {
  final Map<String, dynamic> data;
  final bool isDark;
  final IconData icon;
  final Color iconColor;
  final Color borderColor;
  final String nameKey;
  final String descriptionKey;
  final VoidCallback onApprove;
  final VoidCallback onReject;
  final String approveLabel;
  final String rejectLabel;

  const _ApiProjectCard({
    required this.data,
    required this.isDark,
    required this.icon,
    required this.iconColor,
    required this.borderColor,
    required this.nameKey,
    required this.descriptionKey,
    required this.onApprove,
    required this.onReject,
    required this.approveLabel,
    required this.rejectLabel,
  });

  @override
  Widget build(BuildContext context) {
    final name = data[nameKey] ?? 'Unnamed';
    final description = data[descriptionKey] ?? '';
    final requestedBy = data['requested_by'] ?? 'Unknown';
    final isHovered = useState(false);

    return MouseRegion(
      onEnter: (_) => isHovered.value = true,
      onExit: (_) => isHovered.value = false,
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Background "Stacked" Effect
            Positioned(
              top: 4,
              left: 4,
              right: -4,
              bottom: -4,
              child: Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withOpacity(0.05)
                      : Colors.black.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            // Main Card
            AnimatedContainer(
              duration: 200.ms,
              transform: Matrix4.identity()
                ..translate(
                    isHovered.value ? -2.0 : 0.0, isHovered.value ? -2.0 : 0.0),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1F2937) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isHovered.value
                      ? iconColor
                      : (isDark ? Colors.grey.shade800 : Colors.grey.shade200),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black
                        .withOpacity(isHovered.value ? 0.2 : 0.1),
                    blurRadius: isHovered.value ? 20 : 10,
                    offset: Offset(0, isHovered.value ? 10 : 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: iconColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(icon, size: 24, color: iconColor),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: isDark
                                      ? Colors.white
                                      : Colors.grey.shade900,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  _ExecutiveStatusChip(
                                    label: 'PROJECT REQUEST',
                                    color: iconColor,
                                    isDark: isDark,
                                    icon: Icons.auto_awesome,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              _buildRequesterInfo(requestedBy, isDark),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (description.toString().isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Text(
                        description.toString(),
                        style: GoogleFonts.outfit(
                          color: isDark
                              ? Colors.grey.shade400
                              : Colors.grey.shade600,
                          fontSize: 14,
                          height: 1.5,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 20),
                    const Divider(height: 1),
                    const SizedBox(height: 20),
                    if (data['approval_request_status'] == 'PENDING')
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (data['requested_at'] != null)
                            _buildSmartFooterDate(
                                DateTime.parse(data['requested_at'].toString()),
                                isDark),
                          Row(
                            children: [
                              _ExecutiveActionButton(
                                label: rejectLabel,
                                icon: Icons.block_flipped,
                                color: const Color(0xFFFB7185), // Rose
                                onPressed: onReject,
                              ),
                              const SizedBox(width: 12),
                              _ExecutiveActionButton(
                                label: approveLabel,
                                icon: Icons.check_circle_outline,
                                color: const Color(0xFF10B981), // Emerald
                                isPrimary: true,
                                onPressed: onApprove,
                              ),
                            ],
                          ),
                        ],
                      )
                    else
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (data['requested_at'] != null)
                            _buildSmartFooterDate(
                                DateTime.parse(data['requested_at'].toString()),
                                isDark),
                          _ExecutiveStatusChip(
                            label: 'Status: ${data['approval_request_status']}',
                            color: data['approval_request_status'] == 'APPROVED' 
                                ? const Color(0xFF10B981) 
                                : const Color(0xFFFB7185),
                            isDark: isDark,
                            icon: data['approval_request_status'] == 'APPROVED' 
                                ? Icons.check_circle_outline 
                                : Icons.block,
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn().slideY(begin: 0.1);
  }
}

// API card for New Tasks tab
class _ApiTaskCard extends HookWidget {
  final Map<String, dynamic> data;
  final bool isDark;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const _ApiTaskCard({
    required this.data,
    required this.isDark,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final taskTitle = data['task_title'] ?? 'Unnamed Task';
    final projectName = data['project'] ?? '';
    final priority = data['priority'] ?? '';
    final requestedBy = data['requested_by'] ?? 'Unknown';
    final isHovered = useState(false);

    return MouseRegion(
      onEnter: (_) => isHovered.value = true,
      onExit: (_) => isHovered.value = false,
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        child: AnimatedContainer(
          duration: 200.ms,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1F2937) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isHovered.value
                  ? Colors.blue
                  : (isDark ? Colors.grey.shade800 : Colors.grey.shade200),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black
                    .withOpacity(isHovered.value ? 0.2 : 0.05),
                blurRadius: isHovered.value ? 15 : 5,
                offset: Offset(0, isHovered.value ? 8 : 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              if (projectName.toString().isNotEmpty)
                                _ExecutiveStatusChip(
                                  label: projectName.toString(),
                                  color: Colors.blue,
                                  isDark: isDark,
                                  icon: Icons.folder_open,
                                ),
                              if (priority.toString().isNotEmpty) ...[
                                const SizedBox(width: 8),
                                _ExecutiveStatusChip(
                                  label: priority.toString(),
                                  color: priority == 'High'
                                      ? Colors.red
                                      : Colors.grey,
                                  isDark: isDark,
                                  icon: priority == 'High'
                                      ? Icons.priority_high
                                      : null,
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            taskTitle,
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color:
                                  isDark ? Colors.white : Colors.grey.shade900,
                            ),
                          ),
                          const SizedBox(height: 10),
                          _buildRequesterInfo(requestedBy, isDark),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (data['requested_at'] != null)
                      _buildSmartFooterDate(
                          DateTime.parse(data['requested_at'].toString()),
                          isDark)
                    else
                      const SizedBox.shrink(),
                    if (data['approval_request_status'] == 'PENDING')
                      Row(
                        children: [
                          _ExecutiveActionButton(
                            label: 'Reject',
                            icon: Icons.close,
                            color: const Color(0xFFFB7185),
                            onPressed: onReject,
                          ),
                          const SizedBox(width: 8),
                          _ExecutiveActionButton(
                            label: 'Approve',
                            icon: Icons.check,
                            color: const Color(0xFF10B981),
                            isPrimary: true,
                            onPressed: onApprove,
                          ),
                        ],
                      )
                    else
                      _ExecutiveStatusChip(
                        label: '${data['approval_request_status']}',
                        color: data['approval_request_status'] == 'APPROVED'
                            ? const Color(0xFF10B981)
                            : const Color(0xFFFB7185),
                        isDark: isDark,
                        icon: data['approval_request_status'] == 'APPROVED'
                            ? Icons.check_circle_outline
                            : Icons.block,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn().slideX(begin: 0.1);
  }
}

// API card for Task Completions tab
class _ApiTaskCompletionCard extends HookWidget {
  final Map<String, dynamic> data;
  final bool isDark;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const _ApiTaskCompletionCard({
    required this.data,
    required this.isDark,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final taskTitle = data['task_title'] ?? 'Unnamed Task';
    final projectName = data['project'] ?? '';
    final requestedBy = data['requested_by'] ?? 'Unknown';
    final isHovered = useState(false);

    return MouseRegion(
      onEnter: (_) => isHovered.value = true,
      onExit: (_) => isHovered.value = false,
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        child: AnimatedContainer(
          duration: 200.ms,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1F2937) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isHovered.value
                  ? const Color(0xFF10B981)
                  : (isDark ? Colors.grey.shade800 : Colors.grey.shade200),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black
                    .withOpacity(isHovered.value ? 0.2 : 0.05),
                blurRadius: isHovered.value ? 15 : 5,
                offset: Offset(0, isHovered.value ? 8 : 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              _ExecutiveStatusChip(
                                label: projectName.toString(),
                                color: const Color(0xFF10B981),
                                isDark: isDark,
                                icon: Icons.checklist_rtl_rounded,
                              ),
                              const SizedBox(width: 8),
                              _ExecutiveStatusChip(
                                label: 'COMPLETION',
                                color: Colors.blue,
                                isDark: isDark,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            taskTitle,
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: isDark ? Colors.white : Colors.grey.shade900,
                            ),
                          ),
                          const SizedBox(height: 10),
                          _buildRequesterInfo(requestedBy, isDark),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (data['requested_at'] != null)
                      _buildSmartFooterDate(
                          DateTime.parse(data['requested_at'].toString()),
                          isDark)
                    else
                      const SizedBox.shrink(),
                    if (data['approval_request_status'] == 'PENDING')
                      Row(
                        children: [
                          _ExecutiveActionButton(
                            label: 'Revoke',
                            icon: Icons.undo_rounded,
                            color: const Color(0xFFFB7185),
                            onPressed: onReject,
                          ),
                          const SizedBox(width: 8),
                          _ExecutiveActionButton(
                            label: 'Confirm',
                            icon: Icons.verified,
                            color: const Color(0xFF10B981),
                            isPrimary: true,
                            onPressed: onApprove,
                          ),
                        ],
                      )
                    else
                      _ExecutiveStatusChip(
                        label: '${data['approval_request_status']}',
                        color: data['approval_request_status'] == 'APPROVED' 
                            ? const Color(0xFF10B981) 
                            : const Color(0xFFFB7185),
                        isDark: isDark,
                        icon: data['approval_request_status'] == 'APPROVED' 
                            ? Icons.check_circle_outline 
                            : Icons.block,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn().scale(begin: const Offset(0.95, 0.95));
  }
}

// New widget for project closure cards with requester info
class _ProjectClosureCard extends HookWidget {
  final Map<String, dynamic> closure;
  final bool isDark;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const _ProjectClosureCard({
    required this.closure,
    required this.isDark,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final requestedBy = closure['requested_by'] ?? 'Unknown';
    final projectName = closure['project_name'] ?? 'Unnamed Project';
    final description = closure['description'] ?? '';
    final isHovered = useState(false);

    return MouseRegion(
      onEnter: (_) => isHovered.value = true,
      onExit: (_) => isHovered.value = false,
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        child: AnimatedContainer(
          duration: 250.ms,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1F2937) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isHovered.value
                  ? Colors.purple
                  : (isDark ? Colors.grey.shade800 : Colors.grey.shade200),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.purple
                    .withOpacity(isHovered.value ? 0.2 : 0.05),
                blurRadius: isHovered.value ? 25 : 10,
                offset: Offset(0, isHovered.value ? 12 : 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.purple.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.archive_outlined,
                                    size: 20, color: Colors.purple),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  projectName,
                                  style: GoogleFonts.outfit(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: isDark
                                        ? Colors.white
                                        : Colors.grey.shade900,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              _ExecutiveStatusChip(
                                label: 'CLOSURE REQUEST',
                                color: Colors.purple,
                                isDark: isDark,
                                icon: Icons.lock_clock_rounded,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          _buildRequesterInfo(requestedBy, isDark),
                          if (description.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            Text(
                              description,
                              style: GoogleFonts.outfit(
                                color: isDark
                                    ? Colors.grey.shade400
                                    : Colors.grey.shade600,
                                fontSize: 14,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (closure['requested_at'] != null)
                      _buildSmartFooterDate(
                          DateTime.parse(closure['requested_at'].toString()),
                          isDark)
                    else
                      const SizedBox.shrink(),
                    if (closure['approval_request_status'] == 'PENDING')
                      Row(
                        children: [
                          _ExecutiveActionButton(
                            label: 'Reject',
                            icon: Icons.close,
                            color: const Color(0xFFFB7185),
                            onPressed: onReject,
                          ),
                          const SizedBox(width: 8),
                          _ExecutiveActionButton(
                            label: 'Approve',
                            icon: Icons.check,
                            color: Colors.purple,
                            isPrimary: true,
                            onPressed: onApprove,
                          ),
                        ],
                      )
                    else
                      _ExecutiveStatusChip(
                        label: '${closure['approval_request_status']}',
                        color: closure['approval_request_status'] == 'APPROVED' 
                            ? const Color(0xFF10B981) 
                            : const Color(0xFFFB7185),
                        isDark: isDark,
                        icon: closure['approval_request_status'] == 'APPROVED' 
                            ? Icons.check_circle_outline 
                            : Icons.block,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn().slideY(begin: 0.1);
  }
}

// ========== PENDING TEMPLATES TAB ==========

class _ExecutiveStatusChip extends StatelessWidget {
  final String label;
  final Color color;
  final bool isDark;
  final IconData? icon;

  const _ExecutiveStatusChip({
    required this.label,
    required this.color,
    required this.isDark,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(isDark ? 0.15 : 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 6),
          ],
          Text(
            label.toUpperCase(),
            style: GoogleFonts.outfit(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExecutiveActionButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  final bool isPrimary;

  const _ExecutiveActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
    this.isPrimary = false,
  });

  @override
  State<_ExecutiveActionButton> createState() => _ExecutiveActionButtonState();
}

class _ExecutiveActionButtonState extends State<_ExecutiveActionButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: widget.onPressed,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: 200.ms,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: widget.isPrimary
                ? (_isHovered
                    ? widget.color.withOpacity(0.8)
                    : widget.color)
                : (_isHovered
                    ? widget.color.withOpacity(0.1)
                    : Colors.transparent),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  widget.color.withOpacity(widget.isPrimary ? 1.0 : 0.5),
              width: 1.5,
            ),
            boxShadow: (widget.isPrimary && _isHovered)
                ? [
                    BoxShadow(
                      color: widget.color.withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    )
                  ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                size: 16,
                color: widget.isPrimary ? Colors.white : widget.color,
              ),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: GoogleFonts.outfit(
                  color: widget.isPrimary ? Colors.white : widget.color,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _formatSmartDate(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  final dateToCheck = DateTime(date.year, date.month, date.day);

  if (dateToCheck == today) {
    return 'Today at ${DateFormat('h:mm a').format(date)}';
  } else if (dateToCheck == yesterday) {
    return 'Yesterday at ${DateFormat('h:mm a').format(date)}';
  } else if (date.year == now.year) {
    return DateFormat('MMM dd, h:mm a').format(date);
  } else {
    return DateFormat('MMM dd, yyyy').format(date);
  }
}

Widget _buildRequesterInfo(String email, bool isDark) {
  return Row(
    children: [
      Icon(
        Icons.person_outline_rounded,
        size: 14,
        color: isDark ? Colors.blue.shade300 : Colors.blue.shade600,
      ),
      const SizedBox(width: 6),
      Text(
        email,
        style: GoogleFonts.outfit(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.blue.shade200 : Colors.blue.shade700,
        ),
      ),
    ],
  );
}

Widget _buildSmartFooterDate(DateTime? date, bool isDark) {
  if (date == null) return const SizedBox.shrink();
  
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(
        Icons.access_time_rounded,
        size: 14,
        color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
      ),
      const SizedBox(width: 6),
      RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Raised on ',
              style: GoogleFonts.outfit(
                fontSize: 12,
                color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
              ),
            ),
            TextSpan(
              text: _formatSmartDate(date),
              style: GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

