import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_pm/src/features/projects/project_providers.dart';
import 'package:project_pm/src/core/models/project_with_tasks.dart';
import 'package:project_pm/src/core/database/database.dart';

@RoutePage()
class ProjectOverviewPage extends HookConsumerWidget {
  const ProjectOverviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectAsync = ref.watch(currentProjectProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor = isDark ? Colors.grey.shade800 : Colors.grey.shade200;

    return Scaffold(
      backgroundColor: bgColor,
      body: projectAsync.when(
        data: (data) {
          if (data == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.folder_off_outlined,
                      size: 56, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text('No Project Selected',
                      style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600)),
                ],
              ),
            );
          }

          final p = data.project;
          final pwt = data;

          return SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 28.0, vertical: 22.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                _buildHeader(context, ref, pwt, isDark, cardColor, borderColor),
                const SizedBox(height: 20),

                // Summary stat chips row
                _buildStatChipsRow(pwt, isDark),
                const SizedBox(height: 20),

                // Main 2-col or 1-col layout
                LayoutBuilder(builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 800;
                  if (isWide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 7,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (p.context.isNotEmpty)
                                _buildContextCard(
                                    p, isDark, cardColor, borderColor),
                              if (p.context.isNotEmpty)
                                const SizedBox(height: 20),
                              // Full task list with milestones
                              _buildTasksSection(
                                  pwt, isDark, cardColor, borderColor),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          flex: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildKeyMetricsCard(
                                  pwt, isDark, cardColor, borderColor),
                              const SizedBox(height: 20),
                              _buildTaskSummaryCard(
                                  pwt, isDark, cardColor, borderColor),
                              const SizedBox(height: 20),
                              _buildTeamCard(
                                  pwt, isDark, cardColor, borderColor),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (p.context.isNotEmpty)
                        _buildContextCard(p, isDark, cardColor, borderColor),
                      if (p.context.isNotEmpty) const SizedBox(height: 20),
                      _buildKeyMetricsCard(pwt, isDark, cardColor, borderColor),
                      const SizedBox(height: 20),
                      _buildTaskSummaryCard(
                          pwt, isDark, cardColor, borderColor),
                      const SizedBox(height: 20),
                      _buildTasksSection(pwt, isDark, cardColor, borderColor),
                      const SizedBox(height: 20),
                      _buildTeamCard(pwt, isDark, cardColor, borderColor),
                    ],
                  );
                }),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
        error: (err, st) => Center(child: Text('Error: $err')),
        loading: () => const Center(child: CircularProgressIndicator()),
        skipLoadingOnReload: true,
        skipLoadingOnRefresh: true,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // HEADER
  // ---------------------------------------------------------------------------
  Widget _buildHeader(BuildContext context, WidgetRef ref, ProjectWithTasks pwt,
      bool isDark, Color cardColor, Color borderColor) {
    final p = pwt.project;
    final statusColor = _getStatusColor(p.status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
      decoration: _cardDeco(cardColor, borderColor),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.business_center_outlined,
                size: 26, color: Colors.blue.shade600),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('PROJECT OVERVIEW',
                    style: GoogleFonts.outfit(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade500,
                        letterSpacing: 1.3)),
                const SizedBox(height: 4),
                Consumer(builder: (context, ref, _) {
                  final allProjects =
                      ref.watch(projectsWithTasksProvider).valueOrNull ?? [];
                  if (allProjects.length <= 1) {
                    return Text(p.name,
                        style: GoogleFonts.inter(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : Colors.black87));
                  }
                  return DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: p.id,
                      isDense: true,
                      isExpanded: true,
                      icon: Icon(Icons.keyboard_arrow_down_rounded,
                          size: 18,
                          color: isDark ? Colors.white60 : Colors.black45),
                      dropdownColor:
                          isDark ? const Color(0xFF1F2937) : Colors.white,
                      style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : Colors.black87),
                      items: allProjects
                          .map((proj) => DropdownMenuItem<String>(
                                value: proj.project.id,
                                child: Text(proj.project.name,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: isDark
                                            ? Colors.white
                                            : Colors.grey.shade800)),
                              ))
                          .toList(),
                      onChanged: (id) {
                        if (id != null) {
                          ref.read(selectedProjectIdProvider.notifier).state =
                              id;
                        }
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: statusColor.withOpacity(0.3)),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Container(
                  width: 7,
                  height: 7,
                  decoration:
                      BoxDecoration(color: statusColor, shape: BoxShape.circle)),
              const SizedBox(width: 6),
              Text(p.status.toUpperCase(),
                  style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                      letterSpacing: 0.4)),
            ]),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // STAT CHIPS ROW  (quick numbers at a glance)
  // ---------------------------------------------------------------------------
  Widget _buildStatChipsRow(ProjectWithTasks pwt, bool isDark) {
    final total = pwt.tasks.length;
    final done = pwt.tasks.where((t) => t.task.progress >= 100).length;
    final inProg =
        pwt.tasks.where((t) => t.task.progress > 0 && t.task.progress < 100).length;

    // total milestones across all tasks
    int totalMs = 0, doneMs = 0;
    for (final twa in pwt.tasks) {
      final ms = _parseMilestones(twa.task.milestonesJson);
      totalMs += ms.length;
      doneMs += ms.where((m) => m['completed'] == true).length;
    }

    final chips = [
      _StatChip(
          label: 'Total Tasks',
          value: '$total',
          icon: Icons.assignment_outlined,
          color: Colors.blue),
      _StatChip(
          label: 'Completed',
          value: '$done',
          icon: Icons.check_circle_outline,
          color: Colors.green),
      _StatChip(
          label: 'In Progress',
          value: '$inProg',
          icon: Icons.pending_outlined,
          color: Colors.orange),
      _StatChip(
          label: 'Milestones',
          value: '$doneMs / $totalMs',
          icon: Icons.flag_outlined,
          color: Colors.purple),
    ];

    return Row(
      children: chips
          .map((c) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: _buildStatChip(c, isDark),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildStatChip(_StatChip chip, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: chip.color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: chip.color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: chip.color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(chip.icon, size: 18, color: chip.color),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(chip.label,
                  style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? Colors.grey.shade400
                          : Colors.grey.shade600)),
              const SizedBox(height: 2),
              Text(chip.value,
                  style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: chip.color)),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // DESCRIPTION
  // ---------------------------------------------------------------------------
  Widget _buildContextCard(
      Project p, bool isDark, Color cardColor, Color borderColor) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: _cardDeco(cardColor, borderColor),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _sectionHead('Description & Context', Icons.notes_rounded, isDark),
        const SizedBox(height: 14),
        Text(p.context,
            style: GoogleFonts.inter(
                fontSize: 14,
                color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                height: 1.6)),
      ]),
    );
  }

  // ---------------------------------------------------------------------------
  // KEY METRICS
  // ---------------------------------------------------------------------------
  Widget _buildKeyMetricsCard(
      ProjectWithTasks pwt, bool isDark, Color cardColor, Color borderColor) {
    final p = pwt.project;
    final progress = _calculateProgress(pwt.tasks);
    final daysRemaining =
        p.dueDate?.difference(DateTime.now()).inDays;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: _cardDeco(cardColor, borderColor),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _sectionHead('Key Metrics', Icons.insights_rounded, isDark),
        const SizedBox(height: 20),
        Text('Overall Progress',
            style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600)),
        const SizedBox(height: 7),
        Row(children: [
          Expanded(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                      value: progress / 100,
                      minHeight: 9,
                      backgroundColor: isDark
                          ? Colors.grey.shade800
                          : Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          progress == 100 ? Colors.green : Colors.blue)))),
          const SizedBox(width: 14),
          Text('$progress%',
              style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87)),
        ]),
        const Padding(
            padding: EdgeInsets.symmetric(vertical: 18),
            child: Divider(height: 1)),
        Row(children: [
          _metricChip('Planned Hours',
              '${p.plannedHours.toStringAsFixed(0)} h', Icons.schedule,
              Colors.purple, isDark),
          const SizedBox(width: 10),
          _metricChip('Target Date', _formatDate(p.dueDate),
              Icons.event_available_outlined, Colors.orange, isDark),
        ]),
        if (daysRemaining != null) ...[
          const SizedBox(height: 14),
          _deadlineBanner(daysRemaining, isDark),
        ],
      ]),
    );
  }

  // ---------------------------------------------------------------------------
  // TASK SUMMARY
  // ---------------------------------------------------------------------------
  Widget _buildTaskSummaryCard(
      ProjectWithTasks pwt, bool isDark, Color cardColor, Color borderColor) {
    final total = pwt.tasks.length;
    final done = pwt.tasks.where((t) => t.task.progress >= 100).length;
    final inProg = pwt.tasks
        .where((t) => t.task.progress > 0 && t.task.progress < 100)
        .length;
    final notStarted =
        pwt.tasks.where((t) => t.task.progress == 0).length;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: _cardDeco(cardColor, borderColor),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          _sectionHead('Task Summary', Icons.assignment_outlined, isDark),
          _badge('$total Total', Colors.blue, isDark),
        ]),
        const SizedBox(height: 20),
        _taskBar('Completed', done, total, Colors.green, isDark),
        const SizedBox(height: 12),
        _taskBar('In Progress', inProg, total, Colors.blue, isDark),
        const SizedBox(height: 12),
        _taskBar('Not Started', notStarted, total, Colors.grey.shade400, isDark),
      ]),
    );
  }

  // ---------------------------------------------------------------------------
  // FULL TASKS + MILESTONES SECTION  (the main new feature)
  // ---------------------------------------------------------------------------
  Widget _buildTasksSection(
      ProjectWithTasks pwt, bool isDark, Color cardColor, Color borderColor) {
    if (pwt.tasks.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: _cardDeco(cardColor, borderColor),
        child: Center(
          child: Column(children: [
            Icon(Icons.assignment_outlined,
                size: 44, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Text('No tasks yet',
                style: GoogleFonts.inter(
                    fontSize: 15,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500)),
          ]),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section label
        Padding(
          padding: const EdgeInsets.only(left: 2, bottom: 14),
          child: Text('Tasks & Milestones',
              style: GoogleFonts.outfit(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : Colors.black87)),
        ),
        ...pwt.tasks.map((twa) =>
            _buildTaskCard(twa, isDark, cardColor, borderColor)),
      ],
    );
  }

  Widget _buildTaskCard(
      TaskWithAssignees twa, bool isDark, Color cardColor, Color borderColor) {
    final task = twa.task;
    final milestones = _parseMilestones(task.milestonesJson);
    final totalMs = milestones.length;
    final doneMs = milestones.where((m) => m['completed'] == true).length;
    final progress = task.progress;
    final priorityColor = _priorityColor(task.priority);
    final statusColor = _taskStatusColor(task.approvalStatus ?? '', progress);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: _cardDeco(cardColor, borderColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---- task header ----
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Priority dot
                    Container(
                      margin: const EdgeInsets.only(top: 3, right: 10),
                      width: 9,
                      height: 9,
                      decoration: BoxDecoration(
                          color: priorityColor, shape: BoxShape.circle),
                    ),
                    Expanded(
                      child: Text(task.name,
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : Colors.grey.shade900)),
                    ),
                    const SizedBox(width: 10),
                    // Status chip
                    _statusChip(task.approvalStatus ?? '', progress, isDark),
                    const SizedBox(width: 6),
                    // Priority chip
                    _priorityChip(task.priority, isDark),
                  ],
                ),
                const SizedBox(height: 12),
                // Progress bar for this task
                Row(children: [
                  Expanded(
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                              value: progress / 100,
                              minHeight: 7,
                              backgroundColor: isDark
                                  ? Colors.grey.shade800
                                  : Colors.grey.shade100,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  statusColor)))),
                  const SizedBox(width: 12),
                  Text('$progress%',
                      style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: statusColor)),
                ]),
                const SizedBox(height: 12),
                // Task meta row
                Wrap(spacing: 16, runSpacing: 6, children: [
                  _metaItem(Icons.calendar_today_outlined,
                      'Due ${_formatDate(task.endDate)}', isDark),
                  if (task.plannedHours > 0)
                    _metaItem(Icons.schedule,
                        '${task.plannedHours.toStringAsFixed(0)} h planned', isDark),
                  if (twa.assignees.isNotEmpty)
                    _metaItem(Icons.person_outline,
                        twa.assignees.map((u) => u.name).join(', '), isDark),
                  if (totalMs > 0)
                    _metaItem(Icons.flag_outlined,
                        '$doneMs / $totalMs milestones done', isDark),
                ]),
              ],
            ),
          ),

          // ---- milestones list ----
          if (milestones.isNotEmpty)
            _buildMilestones(milestones, isDark, borderColor, cardColor),
        ],
      ),
    );
  }

  Widget _buildMilestones(List<Map<String, dynamic>> milestones, bool isDark,
      Color borderColor, Color cardColor) {
    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.03)
            : Colors.grey.shade50,
        borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(14),
            bottomRight: Radius.circular(14)),
        border: Border(
          top: BorderSide(
              color: isDark ? Colors.grey.shade800 : Colors.grey.shade100),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Milestones',
              style: GoogleFonts.outfit(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
                  letterSpacing: 0.8)),
          const SizedBox(height: 10),
          ...milestones.asMap().entries.map((entry) {
            final i = entry.key;
            final ms = entry.value;
            final done = ms['completed'] == true;
            final name = ms['name']?.toString() ?? 'Milestone';
            final completedBy = ms['completedBy']?.toString();
            final weight = ms['weight'] ?? 25;
            final isLast = i == milestones.length - 1;

            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Timeline line
                  Column(children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: done
                            ? Colors.green
                            : (isDark
                                ? Colors.grey.shade700
                                : Colors.grey.shade300),
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: done
                                ? Colors.green.shade700
                                : (isDark
                                    ? Colors.grey.shade600
                                    : Colors.grey.shade400),
                            width: 1.5),
                      ),
                      child: Icon(
                          done ? Icons.check : Icons.circle_outlined,
                          size: 12,
                          color: done ? Colors.white : Colors.grey.shade500),
                    ),
                    if (!isLast)
                      Expanded(
                          child: Container(
                              width: 1.5,
                              margin: const EdgeInsets.symmetric(vertical: 3),
                              color: isDark
                                  ? Colors.grey.shade700
                                  : Colors.grey.shade300)),
                  ]),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: isLast ? 0 : 14),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(name,
                                    style: GoogleFonts.inter(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        decoration: done
                                            ? TextDecoration.lineThrough
                                            : null,
                                        color: done
                                            ? (isDark
                                                ? Colors.grey.shade500
                                                : Colors.grey.shade500)
                                            : (isDark
                                                ? Colors.white
                                                : Colors.black87))),
                                if (done && completedBy != null)
                                  Text('by $completedBy',
                                      style: GoogleFonts.inter(
                                          fontSize: 11,
                                          color: isDark
                                              ? Colors.grey.shade600
                                              : Colors.grey.shade500)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text('$weight%',
                              style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: done
                                      ? Colors.green
                                      : (isDark
                                          ? Colors.grey.shade500
                                          : Colors.grey.shade500))),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TEAM CARD
  // ---------------------------------------------------------------------------
  Widget _buildTeamCard(
      ProjectWithTasks pwt, bool isDark, Color cardColor, Color borderColor) {
    final assignees = pwt.projectAssignees;
    if (assignees.isEmpty && pwt.projectLeadId == null) {
      return const SizedBox.shrink();
    }

    final taskCountById = <dynamic, int>{};
    for (final twa in pwt.tasks) {
      for (final user in twa.assignees) {
        taskCountById[user.id] = (taskCountById[user.id] ?? 0) + 1;
      }
    }
    final maxCount =
        taskCountById.values.fold<int>(0, (a, b) => b > a ? b : a);

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: _cardDeco(cardColor, borderColor),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          _sectionHead('Team Members', Icons.people_alt_outlined, isDark),
          const Spacer(),
          if (assignees.isNotEmpty) ...[
            _stackedPreviews(assignees, pwt.projectLeadId, isDark, cardColor),
            const SizedBox(width: 8),
            _badge('${assignees.length}', Colors.indigo, isDark),
          ],
        ]),
        const SizedBox(height: 6),
        Divider(
            color: isDark ? Colors.grey.shade800 : Colors.grey.shade100),
        const SizedBox(height: 14),
        ...assignees.map((a) {
          final name =
              (a['name'] ?? a['username'] ?? 'User').toString();
          final avatar = a['avatar'] ?? a['avatar_url'];
          final isLead = a['id'] == pwt.projectLeadId;
          final count = taskCountById[a['id']] ?? 0;
          final pct = maxCount > 0 ? count / maxCount : 0.0;
          final role = (a['role'] ?? '').toString();

          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Row(children: [
              _avatarWidget(name, avatar, isLead, isDark, cardColor),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Flexible(
                            child: Text(name,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? Colors.white
                                        : Colors.black87))),
                        const SizedBox(width: 7),
                        if (isLead)
                          _roleBadge('Lead', Colors.amber, isDark)
                        else if (role.isNotEmpty)
                          _roleBadge(_friendlyRole(role), Colors.indigo, isDark),
                      ]),
                      const SizedBox(height: 5),
                      Row(children: [
                        Expanded(
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                    value: pct,
                                    minHeight: 5,
                                    backgroundColor: isDark
                                        ? Colors.grey.shade800
                                        : Colors.grey.shade100,
                                    valueColor:
                                        AlwaysStoppedAnimation<Color>(isLead
                                            ? Colors.amber.shade600
                                            : Colors.indigo.shade400)))),
                        const SizedBox(width: 8),
                        Text('$count task${count == 1 ? '' : 's'}',
                            style: GoogleFonts.inter(
                                fontSize: 11,
                                color: isDark
                                    ? Colors.grey.shade500
                                    : Colors.grey.shade500)),
                      ]),
                    ]),
              ),
            ]),
          );
        }),
      ]),
    );
  }

  // ---------------------------------------------------------------------------
  // SHARED SMALL HELPERS
  // ---------------------------------------------------------------------------
  Widget _sectionHead(String title, IconData icon, bool isDark) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon,
          size: 18,
          color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
      const SizedBox(width: 9),
      Text(title,
          style: GoogleFonts.outfit(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.grey.shade800)),
    ]);
  }

  Widget _badge(String label, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.25))),
      child: Text(label,
          style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: color)),
    );
  }

  Widget _metricChip(String label, String value, IconData icon, Color color,
      bool isDark) {
    return Expanded(
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(9)),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label,
                style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600)),
            const SizedBox(height: 2),
            Text(value,
                style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87)),
          ]),
        ),
      ]),
    );
  }

  Widget _deadlineBanner(int days, bool isDark) {
    final isOverdue = days < 0;
    final isUrgent = !isOverdue && days <= 7;
    final color = isOverdue
        ? Colors.red
        : isUrgent
            ? Colors.orange
            : Colors.blue;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
          color: color.withOpacity(0.06),
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: color.withOpacity(0.2))),
      child: Row(children: [
        Icon(
            isOverdue
                ? Icons.warning_amber_rounded
                : Icons.info_outline_rounded,
            color: color,
            size: 16),
        const SizedBox(width: 8),
        Expanded(
            child: Text(
                isOverdue
                    ? 'Overdue by ${days.abs()} days'
                    : '$days days remaining',
                style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: color))),
      ]),
    );
  }

  Widget _taskBar(
      String label, int count, int total, Color color, bool isDark) {
    return Row(children: [
      SizedBox(
          width: 86,
          child: Text(label,
              style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color:
                      isDark ? Colors.grey.shade400 : Colors.grey.shade600))),
      Expanded(
          child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                  value: total > 0 ? count / total : 0,
                  minHeight: 7,
                  backgroundColor:
                      isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                  valueColor: AlwaysStoppedAnimation<Color>(color)))),
      const SizedBox(width: 12),
      SizedBox(
          width: 22,
          child: Text(count.toString(),
              textAlign: TextAlign.end,
              style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87))),
    ]);
  }

  Widget _metaItem(IconData icon, String label, bool isDark) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon,
          size: 13,
          color: isDark ? Colors.grey.shade500 : Colors.grey.shade500),
      const SizedBox(width: 4),
      Text(label,
          style: GoogleFonts.inter(
              fontSize: 12,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600)),
    ]);
  }

  Widget _statusChip(String approvalStatus, int progress, bool isDark) {
    String label;
    Color color;
    if (progress >= 100) {
      label = 'Done';
      color = Colors.green;
    } else if (approvalStatus.toLowerCase().contains('pending_completion')) {
      label = 'Review';
      color = Colors.amber;
    } else if (approvalStatus.toLowerCase().contains('reject')) {
      label = 'Rejected';
      color = Colors.red;
    } else if (progress > 0) {
      label = 'Active';
      color = Colors.blue;
    } else {
      label = 'Todo';
      color = Colors.grey;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: color.withOpacity(0.3))),
      child: Text(label,
          style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: color)),
    );
  }

  Widget _priorityChip(String priority, bool isDark) {
    final color = _priorityColor(priority);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(6)),
      child: Text(priority.toUpperCase(),
          style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: color,
              letterSpacing: 0.2)),
    );
  }

  Widget _stackedPreviews(List<Map<String, dynamic>> assignees, int? leadId,
      bool isDark, Color cardColor) {
    final preview = assignees.take(4).toList();
    return SizedBox(
      height: 28,
      width: (preview.length * 18 + 10).toDouble(),
      child: Stack(
        children: preview.asMap().entries.map((e) {
          final name =
              (e.value['name'] ?? e.value['username'] ?? 'U').toString();
          final avatar = e.value['avatar'] ?? e.value['avatar_url'];
          final isLead = e.value['id'] == leadId;
          return Positioned(
            left: e.key * 18.0,
            child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border:
                      Border.all(color: isLead ? Colors.amber : cardColor, width: 1.5)),
              child: CircleAvatar(
                radius: 12,
                backgroundColor: isDark
                    ? Colors.indigo.withOpacity(0.3)
                    : Colors.indigo.shade50,
                backgroundImage: avatar != null && avatar.toString().isNotEmpty
                    ? NetworkImage(avatar.toString())
                    : null,
                child: avatar == null || avatar.toString().isEmpty
                    ? Text(
                        name.isNotEmpty ? name[0].toUpperCase() : '?',
                        style: GoogleFonts.inter(
                            color: Colors.indigo.shade600,
                            fontWeight: FontWeight.bold,
                            fontSize: 9))
                    : null,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _avatarWidget(String name, dynamic avatar, bool isLead, bool isDark,
      Color cardColor) {
    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
              color: isLead
                  ? Colors.amber
                  : (isDark ? Colors.grey.shade700 : Colors.grey.shade200),
              width: isLead ? 2 : 1.5)),
      child: CircleAvatar(
        radius: 20,
        backgroundColor:
            isDark ? Colors.indigo.withOpacity(0.25) : Colors.indigo.shade50,
        backgroundImage: avatar != null && avatar.toString().isNotEmpty
            ? NetworkImage(avatar.toString())
            : null,
        child: avatar == null || avatar.toString().isEmpty
            ? Text(name.isNotEmpty ? name[0].toUpperCase() : '?',
                style: GoogleFonts.inter(
                    color: Colors.indigo.shade600,
                    fontWeight: FontWeight.bold,
                    fontSize: 14))
            : null,
      ),
    );
  }

  Widget _roleBadge(String label, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: color.withOpacity(0.3))),
      child: Text(label,
          style: GoogleFonts.inter(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: color.withOpacity(isDark ? 0.95 : 0.85),
              letterSpacing: 0.2)),
    );
  }

  BoxDecoration _cardDeco(Color cardColor, Color borderColor) {
    return BoxDecoration(
      color: cardColor,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: borderColor),
      boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 8,
            offset: const Offset(0, 2))
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // PURE DATA HELPERS
  // ---------------------------------------------------------------------------
  List<Map<String, dynamic>> _parseMilestones(String json) {
    try {
      final decoded = jsonDecode(json);
      if (decoded is List) {
        return decoded.cast<Map<String, dynamic>>();
      }
    } catch (_) {}
    return [];
  }

  int _calculateProgress(List<dynamic> tasks) {
    if (tasks.isEmpty) return 0;
    double total = 0;
    for (final t in tasks) {
      total += t.task.progress;
    }
    return (total / tasks.length).round();
  }

  Color _priorityColor(String priority) {
    switch (priority.toUpperCase()) {
      case 'HIGH':
      case 'CRITICAL':
        return Colors.red;
      case 'MEDIUM':
        return Colors.orange;
      case 'LOW':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Color _taskStatusColor(String approvalStatus, int progress) {
    if (progress >= 100) return Colors.green;
    if (approvalStatus.toLowerCase().contains('reject')) return Colors.red;
    if (approvalStatus.toLowerCase().contains('pending_completion')) {
      return Colors.amber;
    }
    if (progress > 0) return Colors.blue;
    return Colors.grey;
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'completed':
        return Colors.blue;
      case 'on_hold':
      case 'on hold':
        return Colors.orange;
      case 'pending':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Not Set';
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _friendlyRole(String role) {
    final lower = role.toLowerCase();
    if (lower.contains('admin')) return 'Admin';
    if (lower.contains('lead') || lower.contains('pl')) return 'Lead';
    if (lower.contains('senior')) return 'Senior';
    if (lower.contains('junior')) return 'Junior';
    if (lower.contains('dev') || lower.contains('engineer')) return 'Dev';
    if (lower.contains('design')) return 'Design';
    if (lower.contains('qa') || lower.contains('test')) return 'QA';
    return role.length > 8 ? '${role.substring(0, 7)}…' : role;
  }
}

// Helper data class for stat chips
class _StatChip {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _StatChip(
      {required this.label,
      required this.value,
      required this.icon,
      required this.color});
}
