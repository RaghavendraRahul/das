import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:project_pm/src/core/database/database.dart';
import 'package:project_pm/src/core/models/project_with_tasks.dart';
import 'package:project_pm/src/features/today/today_repository.dart';
import 'package:project_pm/src/shared/widgets/speech_input_field.dart';
import 'package:drift/drift.dart' as drift;
import 'package:url_launcher/url_launcher.dart';

/// Milestone model parsed from JSON
class MilestoneItem {
  final String id;
  final String name;
  final int weight;
  final bool isCompleted;

  MilestoneItem({
    required this.id,
    required this.name,
    required this.weight,
    required this.isCompleted,
  });

  factory MilestoneItem.fromJson(Map<String, dynamic> json) {
    return MilestoneItem(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      weight: json['weight'] is int
          ? json['weight']
          : int.tryParse(json['weight']?.toString() ?? '0') ?? 0,
      isCompleted: json['completed'] == true,
    );
  }
}

/// Unified Modal for configuring a task before adding to daily planner or editing an experienced one.
/// Shows milestones, action plan input (with speech), and duration slider.
class TaskConfigModal extends HookConsumerWidget {
  final PlannedItem? plannedItem;
  final Task? taskObject;
  final TaskWithAssignees?
      taskWithAssignees; // Support for ProjectTaskCard which passes TaskWithAssignees
  final Project? projectObject;
  final ProjectWithTasks?
      projectWithTasks; // Support for ProjectTaskCard which passes ProjectWithTasks

  final Function({
    required String name,
    required int duration,
    String? description,
    List<String>? selectedMilestoneIds,
    String? quadrant,
  })? onConfirm;

  final String? initialQuadrant;

  final String? initialTitle;
  final String? initialDescription;
  final int? initialDuration;
  final bool showQuadrantSelector;

  const TaskConfigModal({
    super.key,
    this.plannedItem,
    this.taskObject,
    this.taskWithAssignees,
    this.projectObject,
    this.projectWithTasks,
    this.onConfirm,
    this.initialTitle,
    this.initialDescription,
    this.initialDuration,
    this.initialQuadrant,
    this.showQuadrantSelector = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Resolve effective task and project names/objects
    final effectiveTaskName = plannedItem?.name ??
        taskObject?.name ??
        taskWithAssignees?.task.name ??
        initialTitle ??
        'New Task';

    final effectiveProjectName =
        projectObject?.name ?? projectWithTasks?.project.name ?? '';

    final effectiveDescription =
        plannedItem?.description ?? initialDescription ?? '';
    final effectiveDuration =
        plannedItem?.durationMinutes ?? initialDuration ?? 60;

    // Links (from task object if available)
    final effectiveGithubLink =
        taskObject?.githubLink ?? taskWithAssignees?.task.githubLink ?? '';
    final effectiveFigmaLink =
        taskObject?.figmaLink ?? taskWithAssignees?.task.figmaLink ?? '';

    // Milestones JSON (from task object if available)
    final effectiveMilestonesJson =
        taskObject?.milestonesJson ?? taskWithAssignees?.task.milestonesJson;

    final nameController = useTextEditingController(text: effectiveTaskName);
    final descriptionController =
        useTextEditingController(text: effectiveDescription);
    final duration = useState(effectiveDuration);
    final selectedQuadrant = useState<String>(
      showQuadrantSelector ? (initialQuadrant ?? 'Q1') : (initialQuadrant ?? ''),
    );

    // Links State
    final githubLink = useState(effectiveGithubLink);
    final figmaLink = useState(effectiveFigmaLink);
    final isEditingLinks = useState(false);

    // Milestones State
    final milestones = useState<List<MilestoneItem>>([]);
    final selectedMilestoneIds = useState<Set<String>>({});

    // Parse milestones on init
    useEffect(() {
      if (effectiveMilestonesJson != null) {
        try {
          final List<dynamic> decoded = jsonDecode(effectiveMilestonesJson);
          final ms = decoded.map((m) => MilestoneItem.fromJson(m)).toList();
          milestones.value = ms;

          // Auto-select first incomplete milestone if specific description isn't set
          if (effectiveDescription.isEmpty) {
            final firstIncomplete =
                ms.where((m) => !m.isCompleted).take(1).toList();
            if (firstIncomplete.isNotEmpty) {
              selectedMilestoneIds.value = {firstIncomplete.first.id};
              descriptionController.text =
                  'Focusing on: ${firstIncomplete.first.name}';
            } else if (ms.isNotEmpty) {
              descriptionController.text = 'General work on $effectiveTaskName';
            }
          }
        } catch (e) {
          debugPrint("Error parsing milestones: $e");
        }
      }
      return null;
    }, [effectiveMilestonesJson]);

    void toggleMilestone(String id) {
      final current = Set<String>.from(selectedMilestoneIds.value);
      if (current.contains(id)) {
        current.remove(id);
      } else {
        current.add(id);
      }
      selectedMilestoneIds.value = current;
    }

    Future<void> openLink(String url) async {
      if (url.isEmpty) return;
      final uri = Uri.tryParse(url);
      if (uri != null && await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }

    String formatDuration(int minutes) {
      final h = minutes ~/ 60;
      final m = minutes % 60;
      if (h > 0 && m > 0) return '${h}h ${m}m';
      if (h > 0) return '${h}h';
      return '${m}m';
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.hardEdge,
      child: Container(
        width: 500,
        constraints: const BoxConstraints(maxHeight: 700),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1F2937) : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              color: const Color(0xFF05263E),
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (effectiveProjectName.isNotEmpty)
                          Text(
                            effectiveProjectName.toUpperCase(),
                            style: GoogleFonts.inter(
                              color: Colors.blue.shade200,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                              letterSpacing: 0.5,
                            ),
                          ),
                        if (effectiveProjectName.isNotEmpty)
                          const SizedBox(height: 4),
                        TextField(
                          controller: nameController,
                          cursorColor: Colors.white,
                          style: GoogleFonts.inter(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            hintText: "New Task",
                            hintStyle: GoogleFonts.inter(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Colors.white.withValues(alpha: 0.6),
                            ),
                            filled: false,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),

            // Scrollable Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Resources Bar (Links)
                    if (githubLink.value.isNotEmpty ||
                        figmaLink.value.isNotEmpty ||
                        isEditingLinks.value)
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                                color: isDark
                                    ? Colors.grey.shade700
                                    : Colors.grey.shade200),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: isEditingLinks.value
                                  ? Column(
                                      children: [
                                        Row(
                                          children: [
                                            const FaIcon(
                                                FontAwesomeIcons.github,
                                                size: 16,
                                                color: Colors.grey),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: TextField(
                                                decoration: InputDecoration(
                                                  hintText: 'GitHub Link',
                                                  isDense: true,
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 8,
                                                          vertical: 8),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                    borderSide: BorderSide(
                                                        color: Colors
                                                            .grey.shade300),
                                                  ),
                                                ),
                                                style: const TextStyle(
                                                    fontSize: 12),
                                                onChanged: (v) =>
                                                    githubLink.value = v,
                                                controller:
                                                    TextEditingController(
                                                        text: githubLink.value),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            const FaIcon(FontAwesomeIcons.figma,
                                                size: 16, color: Colors.grey),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: TextField(
                                                decoration: InputDecoration(
                                                  hintText: 'Figma Link',
                                                  isDense: true,
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 8,
                                                          vertical: 8),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                    borderSide: BorderSide(
                                                        color: Colors
                                                            .grey.shade300),
                                                  ),
                                                ),
                                                style: const TextStyle(
                                                    fontSize: 12),
                                                onChanged: (v) =>
                                                    figmaLink.value = v,
                                                controller:
                                                    TextEditingController(
                                                        text: figmaLink.value),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  : Wrap(
                                      spacing: 8,
                                      children: [
                                        if (githubLink.value.isNotEmpty)
                                          ActionChip(
                                            avatar: const FaIcon(
                                                FontAwesomeIcons.github,
                                                size: 14),
                                            label: const Text('GitHub',
                                                style: TextStyle(fontSize: 12)),
                                            onPressed: () =>
                                                openLink(githubLink.value),
                                            backgroundColor: isDark
                                                ? Colors.grey.shade800
                                                : Colors.grey.shade100,
                                          ),
                                        if (figmaLink.value.isNotEmpty)
                                          ActionChip(
                                            avatar: const FaIcon(
                                                FontAwesomeIcons.figma,
                                                size: 14),
                                            label: const Text('Figma',
                                                style: TextStyle(fontSize: 12)),
                                            onPressed: () =>
                                                openLink(figmaLink.value),
                                            backgroundColor: isDark
                                                ? Colors.grey.shade800
                                                : Colors.grey.shade100,
                                          ),
                                      ],
                                    ),
                            ),
                            TextButton(
                              onPressed: () =>
                                  isEditingLinks.value = !isEditingLinks.value,
                              child: Text(
                                isEditingLinks.value ? 'Done' : 'Edit Links',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.blue.shade600),
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Milestones Section
                    if (milestones.value.isNotEmpty) ...[
                      Row(
                        children: [
                          Icon(FontAwesomeIcons.listCheck,
                              size: 14, color: isDark ? Colors.white : const Color(0xFF05263E)),
                          const SizedBox(width: 8),
                          Text(
                            'Select Milestones to Tackle',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: isDark
                                  ? Colors.grey.shade300
                                  : const Color(0xFF05263E),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        constraints: const BoxConstraints(maxHeight: 160),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: isDark
                                  ? Colors.grey.shade700
                                  : Colors.grey.shade200),
                          borderRadius: BorderRadius.circular(8),
                          color: isDark
                              ? Colors.grey.shade900.withValues(alpha: 0.5)
                              : Colors.grey.shade50,
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: milestones.value.length,
                          itemBuilder: (context, index) {
                            final m = milestones.value[index];
                            final isSelected =
                                selectedMilestoneIds.value.contains(m.id);

                            return InkWell(
                              onTap: m.isCompleted
                                  ? null
                                  : () => toggleMilestone(m.id),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: isSelected,
                                      onChanged: m.isCompleted
                                          ? null
                                          : (_) => toggleMilestone(m.id),
                                      activeColor: const Color(0xFF05263E),
                                    ),
                                    Expanded(
                                      child: Text(
                                        m.name,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: m.isCompleted
                                              ? Colors.grey
                                              : (isDark
                                                  ? Colors.grey.shade200
                                                  : Colors.grey.shade800),
                                          decoration: m.isCompleted
                                              ? TextDecoration.lineThrough
                                              : null,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '${m.weight}%',
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey.shade400,
                                          fontFamily: 'monospace'),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Action Plan / Strategy
                    SpeechInputField(
                      controller: descriptionController,
                      labelText: 'Planned Remark',
                      hintText:
                          'What specifically will you do to achieve these milestones?',
                      maxLines: 3,
                    ),

                    const SizedBox(height: 20),

                     if (showQuadrantSelector) ...[
                      Text(
                        'Add to Quadrant:',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: isDark ? Colors.grey.shade300 : const Color(0xFF05263E),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final q in [
                            ('Q1', 'Q1 Do First', Colors.red),
                            ('Q2', 'Q2 Schedule', Colors.orange),
                            ('Q3', 'Q3 Delegate', Colors.purple),
                            ('Q4', 'Q4 Eliminate', Colors.green),
                          ])
                            GestureDetector(
                              onTap: () => selectedQuadrant.value = q.$1,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: selectedQuadrant.value == q.$1
                                      ? q.$3.withValues(alpha: 0.3)
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: selectedQuadrant.value == q.$1
                                        ? q.$3
                                        : (isDark ? Colors.grey.shade700 : Colors.grey.shade300),
                                    width: selectedQuadrant.value == q.$1 ? 2 : 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  q.$2,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: selectedQuadrant.value == q.$1
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: selectedQuadrant.value == q.$1
                                        ? q.$3
                                        : (isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Duration Slider
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Planned Duration:',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: isDark
                                ? Colors.grey.shade300
                                : const Color(0xFF05263E),
                          ),
                        ),
                        Text(
                          formatDuration(duration.value),
                          style: GoogleFonts.inter(
                            color: isDark ? const Color(0xFFFBBF24) : const Color(0xFFF97316),
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: isDark ? const Color(0xFFFBBF24) : const Color(0xFFF97316),
                        inactiveTrackColor: isDark
                            ? Colors.grey.shade800
                            : Colors.orange.shade100,
                        thumbColor: isDark ? const Color(0xFFFBBF24) : const Color(0xFFF97316),
                        overlayColor: (isDark ? const Color(0xFFFBBF24) : const Color(0xFFF97316)).withValues(alpha: 0.4),
                      ),
                      child: Slider(
                        value: duration.value.toDouble().clamp(15.0, 120.0),
                        min: 15,
                        max: 120,
                        divisions: 7, // 15, 30, 45, 60, 75, 90, 105, 120
                        onChanged: (v) => duration.value = v.toInt(),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('15m',
                            style: GoogleFonts.inter(
                                color: Colors.grey.shade400, fontSize: 11)),
                        Text('1h',
                            style: GoogleFonts.inter(
                                color: Colors.grey.shade400, fontSize: 11)),
                        Text('2h',
                            style: GoogleFonts.inter(
                                color: Colors.grey.shade400, fontSize: 11)),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Actions
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        side: BorderSide(color: Colors.red.shade600),
                        foregroundColor: Colors.red.shade600,
                      ),
                      child: Text('Cancel',
                          style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 12)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        String finalName = nameController.text.trim();
                        if ((finalName == 'New Task' || finalName.isEmpty) &&
                            descriptionController.text.trim().isNotEmpty) {
                          finalName = descriptionController.text.trim();
                        }
                        if (finalName.isEmpty) finalName = 'New Task';

                        final capturedDescription = descriptionController.text;
                        final capturedDuration = duration.value;
                        final capturedMilestones =
                            selectedMilestoneIds.value.toList();
                        final capturedQuadrant = selectedQuadrant.value;

                        // Pop FIRST to ensure dialog is closed before any subsequent actions
                        if (context.mounted) Navigator.pop(context);

                        if (onConfirm != null) {
                          onConfirm!(
                            name: finalName,
                            duration: capturedDuration,
                            description: capturedDescription,
                            selectedMilestoneIds: capturedMilestones,
                            quadrant: capturedQuadrant,
                          );
                        } else if (plannedItem != null) {
                          try {
                            final repo = ref.read(todayRepositoryProvider);
                            await repo.updatePlannedItem(
                              plannedItem!.id,
                              PlannedItemsCompanion(
                                description: drift.Value(capturedDescription),
                                durationMinutes: drift.Value(capturedDuration),
                              ),
                            );
                          } catch (e) {
                            debugPrint('Failed to update task: $e');
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: const Color(0xFF05263E),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text('Confirm Plan',
                          style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 12, color: Colors.white)),
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
