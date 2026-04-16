import 'dart:async';

// For PathMetric
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:project_pm/src/features/projects/providers/api_providers.dart';
import 'package:project_pm/src/core/providers/user_providers.dart';

class DayLog extends ConsumerWidget {
  const DayLog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch API activity logs
    final isReadOnly = ref.watch(isReadOnlyProvider);
    final today = DateTime.now();
    final todayStr =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    final apiActivityLogsAsync = ref.watch(apiActivityLogsProvider(todayStr));
    final activeTaskAsync = ref.watch(apiActiveTaskProvider);
    final hasActiveTask =
        activeTaskAsync.value != null && activeTaskAsync.value!['id'] != null;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DragTarget<Map<String, dynamic>>(
      onAcceptWithDetails: (details) async {
        if (isReadOnly) return;
        try {
          if (hasActiveTask) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Already a task is running, stop it first.'),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }
          // Check for active task at the very beginning
          final data = details.data;
          if (data['type'] == 'project_task' ||
              data['type'] == 'catalog_item' ||
              data['type'] == 'catalog_task' ||
              data['type'] == 'custom_template' ||
              data['type'] == 'custom' ||
              data['type'] == 'pending_item') {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Starting task...'),
                duration: Duration(seconds: 1),
              ),
            );

            final apiService = ref.read(taskApiServiceProvider);
            final userId = ref.read(currentUserIdProvider);
            final now = DateTime.now();
            final planDate =
                '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

            int? plannedItemId;
            String taskName = data['name'] ?? 'Unnamed Task';
            int duration = 60;

            // Items dragged directly to activity log are marked as unplanned

            // 1. Create Plan Item
            if (data['type'] == 'project_task') {
              taskName = data['name'];
              duration = (data['duration'] as num?)?.toInt() ?? 60;
              final description =
                  'Unplanned task from \'${data['project_name'] ?? 'Project'}\'';

              final planItem = await apiService.addItemToTodayPlan(
                itemType: 'custom',
                title: taskName,
                planDate: planDate,
                plannedDurationMinutes: duration,
                quadrant: 'Q1',
                description: description,
                relatedTaskId: data['task_id'] != null
                    ? parseTaskId(data['task_id'])
                    : null,
                isUnplanned: true,
                userId: userId,
              );
              plannedItemId = planItem['id'] as int;
            } else if (data['type'] == 'catalog_item' &&
                data['catalog_id'] != null) {
              taskName = data['name'];
              duration = (data['duration'] as num?)?.toInt() ?? 60;
              final planItem = await apiService.addItemToTodayPlan(
                itemType: 'catalog',
                catalogId: parseTaskId(data['catalog_id']),
                planDate: planDate,
                plannedDurationMinutes: duration,
                quadrant: 'Q1',
                description: 'Unplanned - started directly from catalog',
                isUnplanned: true,
                userId: userId,
              );
              plannedItemId = planItem['id'] as int;
            } else if (data['type'] == 'catalog_task' &&
                data['task_id'] != null) {
              taskName = data['name'];
              duration = (data['duration'] as num?)?.toInt() ?? 60;
              final planItem = await apiService.addItemToTodayPlan(
                itemType: 'custom',
                title: taskName,
                planDate: planDate,
                plannedDurationMinutes: duration,
                quadrant: 'Q1',
                description:
                    'Unplanned task started directly from task catalog',
                relatedTaskId: parseTaskId(data['task_id']),
                isUnplanned: true,
                userId: userId,
              );
              plannedItemId = planItem['id'] as int;
            } else if (data['type'] == 'custom_template') {
              taskName = data['name'];
              duration = (data['duration'] as num?)?.toInt() ?? 60;
              final planItem = await apiService.addItemToTodayPlan(
                itemType: 'custom',
                title: taskName,
                planDate: planDate,
                plannedDurationMinutes: duration,
                quadrant: 'Q1',
                description: data['description']?.isNotEmpty == true
                    ? data['description']
                    : 'Unplanned task from custom template',
                isUnplanned: true,
                userId: userId,
              );
              plannedItemId = planItem['id'] as int;
            } else if (data['type'] == 'pending_item') {
              if (data['is_today_inbox'] == true) {
                // Today inbox item — already exists as a TodayPlan record
                // Just move it directly to activity log (no need to create a new plan item)
                taskName = data['name'] ?? 'Pending Task';
                duration = (data['duration'] as num?)?.toInt() ?? 60;
                plannedItemId = data['id'] as int;
                // Mark as unplanned before moving
                await apiService.updateTodayPlanItem(plannedItemId, {
                  'is_unplanned': true,
                });
              } else {
                // Historical pending task - must be created as a new plan item
                taskName = data['name'] ?? 'Pending Task';
                duration = (data['duration'] as num?)?.toInt() ?? 60;
                final planItem = await apiService.addItemToTodayPlan(
                  itemType: 'custom',
                  title: taskName,
                  planDate: planDate,
                  plannedDurationMinutes: duration,
                  quadrant: 'Q1',
                  description: data['description'] ?? 'Unplanned pending task',
                  relatedTaskId: data['catalog_id'] != null
                      ? parseTaskId(data['catalog_id'])
                      : null,
                  isUnplanned: true,
                  userId: userId,
                );
                plannedItemId = planItem['id'] as int;
              }
            } else {
              taskName = data['name'];
              final planItem = await apiService.addItemToTodayPlan(
                itemType: 'custom',
                title: taskName,
                planDate: planDate,
                plannedDurationMinutes: 60,
                quadrant: 'Q1',
                description: 'Unplanned task started directly from catalog',
                isUnplanned: true,
                userId: userId,
              );
              plannedItemId = planItem['id'] as int;
            }

            // 2. Start Task using API
            await apiService.moveTodayPlanToActivityLog(plannedItemId);

            // If it's a historical pending task (from Pending table), delete it
            // Don't delete for today inbox items — they are TodayPlan records, not Pending records
            if (data['is_pending'] == true &&
                data['pending_id'] != null &&
                data['is_today_inbox'] != true) {
              await apiService.deletePendingTask(data['pending_id']);
            }

            // Refresh all pending and plan data
            ref.invalidate(apiPendingItemsProvider(todayStr));
            ref.invalidate(apiAllPendingItemsProvider);

            // Invalidate to refresh UI
            ref.invalidate(apiTodayPlanProvider);
            ref.invalidate(apiActivityLogsProvider(todayStr));
            ref.invalidate(apiActiveTaskProvider);
          }
        } catch (e) {
          debugPrint('Drag start error: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to start task: $e')),
          );
        }
      },
      builder: (context, candidateData, rejectedData) {
        final isHovering = candidateData.isNotEmpty;
        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1F2937) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.05),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.06),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: isDark ? Colors.black.withOpacity(0.15) : Colors.black.withOpacity(0.02),
                blurRadius: 2,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "ACTIVITY LOG",
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                        color: isDark ? Colors.white : const Color(0xFF05263E),
                      ),
                    ),
                    apiActivityLogsAsync.when(
                      data: (logs) => _TotalWorkedTimerAPI(logs: logs),
                      loading: () => _buildTimerBadge(context, 0, 0, isDark),
                      error: (_, __) => _buildTimerBadge(context, 0, 0, isDark),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6)),

              // List
              Expanded(
                child: activeTaskAsync.when(
                  data: (activeTask) {
                    return apiActivityLogsAsync.when(
                      data: (logs) {
                        // Merge active task if it's not already in the logs list
                        // This handles "stuck" tasks from previous days
                        final List<Map<String, dynamic>> combinedLogs = [...logs];
                        if (activeTask != null && activeTask['id'] != null) {
                          final bool isAlreadyInLogs = logs.any((l) => l['id'] == activeTask['id']);
                          if (!isAlreadyInLogs) {
                            combinedLogs.insert(0, activeTask);
                          }
                        }

                        if (combinedLogs.isEmpty) {
                          return Center(
                              child: Text("No activities logged yet.",
                                  style: TextStyle(
                                      color: isDark
                                          ? Colors.grey.shade400
                                          : Colors.grey)));
                        }

                        return ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: combinedLogs.length,
                          separatorBuilder: (c, i) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            return _ApiLoggedItemCard(item: combinedLogs[index]);
                          },
                        );
                      },
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (_, __) => Center(
                          child: Text("Failed to load activity logs",
                              style: TextStyle(
                                  color: isDark
                                      ? Colors.grey.shade400
                                      : Colors.grey))),
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (_, __) => Center(
                      child: Text("Failed to load active task status",
                          style: TextStyle(
                              color: isDark
                                  ? Colors.grey.shade400
                                  : Colors.grey))),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildTimerBadge(
      BuildContext context, int hours, int minutes, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF064E3B) : const Color(0xFFECFDF5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF34D399) : const Color(0xFF10B981),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer,
              size: 14,
              color:
                  isDark ? const Color(0xFF34D399) : const Color(0xFF047857)),
          const SizedBox(width: 6),
          Text(
            "${hours}h ${minutes}m",
            style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color:
                    isDark ? const Color(0xFF34D399) : const Color(0xFF047857)),
          ),
        ],
      ),
    );
  }
}

// Timer widget for API-based activity logs
class _TotalWorkedTimerAPI extends StatefulWidget {
  final List<Map<String, dynamic>> logs;
  const _TotalWorkedTimerAPI({required this.logs});

  @override
  State<_TotalWorkedTimerAPI> createState() => _TotalWorkedTimerAPIState();
}

class _TotalWorkedTimerAPIState extends State<_TotalWorkedTimerAPI> {
  late Timer _timer;
  int _totalSeconds = 0;

  @override
  void initState() {
    super.initState();
    _calculateTotal();
    _timer =
        Timer.periodic(const Duration(seconds: 1), (_) => _calculateTotal());
  }

  @override
  void didUpdateWidget(_TotalWorkedTimerAPI oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.logs != widget.logs) {
      _calculateTotal();
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _calculateTotal() {
    int totalMillis = 0;
    final now = DateTime.now();

    for (var log in widget.logs) {
      try {
        final startStr = log['actual_start_time'] as String?;
        final endStr = log['actual_end_time'] as String?;

        if (startStr != null) {
          final start = DateTime.parse(
              startStr); // Already in correct timezone from backend
          final end = endStr != null ? DateTime.parse(endStr) : now;
          totalMillis += end.difference(start).inMilliseconds;
        }
      } catch (e) {
        debugPrint('Error calculating time for log: $e');
      }
    }

    if (mounted) {
      setState(() => _totalSeconds = (totalMillis / 1000).floor());
    }
  }

  @override
  Widget build(BuildContext context) {
    final hours = _totalSeconds ~/ 3600;
    final minutes = (_totalSeconds % 3600) ~/ 60;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF064E3B) : const Color(0xFFECFDF5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF34D399) : const Color(0xFF10B981),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer,
              size: 14,
              color:
                  isDark ? const Color(0xFF34D399) : const Color(0xFF047857)),
          const SizedBox(width: 6),
          Text(
            "${hours}h ${minutes}m",
            style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color:
                    isDark ? const Color(0xFF34D399) : const Color(0xFF047857)),
          ),
        ],
      ),
    );
  }
}

// Card widget for API-based activity log items
class _ApiLoggedItemCard extends HookConsumerWidget {
  final Map<String, dynamic> item;
  const _ApiLoggedItemCard({required this.item});

  /// Extract time from ISO string without timezone conversion
  /// Backend sends: 2026-02-26T12:11:40+05:30 (Asia/Kolkata)
  /// We extract the time portion directly to avoid device timezone conversion
  String _extractTime(String? isoString) {
    if (isoString == null) return '';
    try {
      // ISO format: 2026-02-26T12:11:40.602492+05:30
      // Extract the time part (HH:mm) from position after 'T'
      final timeStart = isoString.indexOf('T') + 1;
      if (timeStart > 0 && timeStart + 5 <= isoString.length) {
        return isoString.substring(timeStart, timeStart + 5); // HH:mm
      }
    } catch (e) {
      debugPrint('Error extracting time: $e');
    }
    return '';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = item['status'] as String? ?? 'IN_PROGRESS';
    final isRunning = status == 'IN_PROGRESS';
    final isReadOnly = ref.watch(isReadOnlyProvider);

    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Get task name from today_plan
    final todayPlan = item['today_plan'] as Map<String, dynamic>?;
    String taskName = 'Unknown Task';
    bool isUnplanned = false;
    if (todayPlan != null) {
      // Use catalog_name which is a convenience field from the serializer
      taskName = todayPlan['catalog_name'] as String? ?? 'Unknown Task';
      isUnplanned = todayPlan['is_unplanned'] == true;
      if (isUnplanned) {
        // Clean up the display name if it still has the prefix (for backward compatibility or if backend adds it)
        taskName = taskName.replaceFirst('[Unplanned] ', '');
      }
    }

    // Extract times directly from ISO strings (backend already sends in Asia/Kolkata)
    final startStr = item['actual_start_time'] as String?;
    final endStr = item['actual_end_time'] as String?;
    final startTimeDisplay = _extractTime(startStr);
    final endTimeDisplay = _extractTime(endStr);

    // Still parse for duration calculation
    DateTime? startTime;
    DateTime? endTime;
    try {
      if (startStr != null) startTime = DateTime.parse(startStr);
      if (endStr != null) endTime = DateTime.parse(endStr);
    } catch (e) {
      debugPrint('Error parsing times: $e');
    }

    // Calculate worked time
    final workedMinutes = item['minutes_worked'] as int? ?? 0;
    final workedHours = (workedMinutes / 60).floor();
    final workedMins = workedMinutes % 60;

    // Color based on status
    final accentColor = isRunning ? Colors.blue : Colors.green;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: isRunning
            ? Border.all(color: Colors.blue.withOpacity(0.3))
            : Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
        color: isDark ? Colors.grey.shade800 : Colors.white,
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: accentColor, width: 2),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status Indicator
                Container(
                  margin: const EdgeInsets.only(top: 4, right: 12),
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: accentColor,
                    shape: BoxShape.circle,
                    boxShadow: isRunning
                        ? [
                            BoxShadow(
                              color: accentColor.withOpacity(0.5),
                              blurRadius: 4,
                              spreadRadius: 1,
                            )
                          ]
                        : null,
                  ),
                ),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (isUnplanned)
                            Container(
                              margin: const EdgeInsets.only(right: 6),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                    color: Colors.orange.withOpacity(0.4)),
                              ),
                              child: Text(
                                'Unplanned',
                                style: GoogleFonts.inter(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.orange.shade700,
                                ),
                              ),
                            ),
                          Expanded(
                            child: Text(
                              taskName,
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                          ),
                          if (isRunning)
                            _LiveTimer(startTime: startTime ?? DateTime.now()),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.schedule,
                              size: 14,
                              color: isDark
                                  ? Colors.grey.shade400
                                  : Colors.grey.shade600),
                          const SizedBox(width: 4),
                          Text(
                            startTimeDisplay.isNotEmpty
                                ? '$startTimeDisplay - ${endTimeDisplay.isNotEmpty ? endTimeDisplay : "In Progress"}'
                                : 'Unknown time',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: isDark
                                  ? Colors.grey.shade400
                                  : Colors.grey.shade600,
                            ),
                          ),
                          const Spacer(),
                          if (!isRunning)
                            Text(
                              '${workedHours}h ${workedMins}m',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.green,
                              ),
                            ),
                        ],
                      ),
                      if (item['work_notes'] != null &&
                          (item['work_notes'] as String).isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 6),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white.withOpacity(0.05)
                                : Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: isDark
                                  ? Colors.white.withOpacity(0.1)
                                  : Colors.grey.shade200,
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.notes,
                                  size: 12,
                                  color: isDark
                                      ? Colors.grey.shade400
                                      : Colors.grey.shade600),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  item['work_notes'],
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontStyle: FontStyle.italic,
                                    color: isDark
                                        ? Colors.grey.shade300
                                        : Colors.grey.shade700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Action buttons
                if (isRunning)
                  IconButton(
                    icon: Icon(Icons.stop_circle,
                        color: isReadOnly ? Colors.grey : Colors.red),
                    iconSize: 28,
                    onPressed: isReadOnly
                        ? null
                        : () {
                            _showStopDialog(context, ref, item);
                          },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Extract time from ISO string without timezone conversion
  String _extractTimeForDialog(String? isoString) {
    if (isoString == null) return '';
    try {
      final timeStart = isoString.indexOf('T') + 1;
      if (timeStart > 0 && timeStart + 5 <= isoString.length) {
        return isoString.substring(timeStart, timeStart + 5); // HH:mm
      }
    } catch (e) {
      debugPrint('Error extracting time: $e');
    }
    return '';
  }

  void _showStopDialog(
      BuildContext context, WidgetRef ref, Map<String, dynamic> item) {
    final activityLogId = item['id'] as int;
    final todayPlan = item['today_plan'] as Map<String, dynamic>?;

    // Get task name
    String taskName = 'Unknown Task';
    if (todayPlan != null) {
      taskName = todayPlan['catalog_name'] as String? ?? 'Unknown Task';
    }

    // Extract times directly from ISO strings
    final startStr = item['actual_start_time'] as String?;
    final endStr = item['actual_end_time'] as String?;
    final startTimeDisplay = _extractTimeForDialog(startStr);
    final endTimeDisplay = _extractTimeForDialog(endStr);

    // Still parse for duration calculation
    DateTime? startTime;
    DateTime? endTime;
    try {
      if (startStr != null) startTime = DateTime.parse(startStr);
      if (endStr != null) endTime = DateTime.parse(endStr);
    } catch (e) {
      debugPrint('Error parsing times: $e');
    }

    // Calculate remaining time
    final plannedMinutes = todayPlan?['planned_duration_minutes'] as int? ?? 0;
    final workedMinutes = item['minutes_worked'] as int? ?? 0;
    final remainingMinutes = (plannedMinutes - workedMinutes).clamp(0, 999999);

    // State variables for the dialog
    String selectedOption = 'completed';
    final remainingController =
        TextEditingController(text: remainingMinutes.toString());
    final extraTimeController = TextEditingController(text: '0');
    final startTimeController = TextEditingController(text: startTimeDisplay);
    final endTimeController = TextEditingController(text: endTimeDisplay);
    final remarkController = TextEditingController(text: item['work_notes'] as String? ?? '');

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Review Task'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('You worked on $taskName for'),
                if (startTimeDisplay.isNotEmpty)
                  Text(
                    '$startTimeDisplay - ${endTimeDisplay.isNotEmpty ? endTimeDisplay : "In Progress"}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    setState(() => selectedOption = 'completed');
                  },
                  child: Row(
                    children: [
                      Radio<String>(
                        value: 'completed',
                        groupValue: selectedOption,
                        onChanged: (value) {
                          setState(() => selectedOption = value!);
                        },
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Completed',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'Task is done. No further work needed.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (selectedOption == 'completed')
                        const Icon(Icons.check_circle, color: Colors.green),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () {
                    setState(() => selectedOption = 'pending');
                  },
                  child: Row(
                    children: [
                      Radio<String>(
                        value: 'pending',
                        groupValue: selectedOption,
                        onChanged: (value) {
                          setState(() => selectedOption = value!);
                        },
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Still Pending',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'Work remains. Move reminder to pending list.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (selectedOption == 'pending')
                        const Icon(Icons.warning_amber, color: Colors.orange),
                    ],
                  ),
                ),
                // Remaining time field - only when "Still Pending" is selected
                if (selectedOption == 'pending') ...[
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.only(left: 48),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 140,
                          child: Text(
                            'Remaining time to work:',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 80,
                          child: TextField(
                            controller: remainingController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'mins',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.only(left: 188),
                    child: Text(
                      'Original plan had ${plannedMinutes}m left.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
                // Schedule Details - Show for both Completed and Pending
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),
                const Text(
                  'Schedule Details',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 12),
                // Start Time
                Row(
                  children: [
                    const SizedBox(
                      width: 120,
                      child: Text(
                        'Start Time:',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: startTimeController,
                        decoration: InputDecoration(
                          hintText: 'HH:MM',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.access_time,
                              color: Colors.grey[600],
                            ),
                            onPressed: () async {
                              final TimeOfDay? picked = await showTimePicker(
                                context: context,
                                initialTime: startTime != null
                                    ? TimeOfDay.fromDateTime(startTime)
                                    : TimeOfDay.now(),
                              );
                              if (picked != null) {
                                setState(() {
                                  startTimeController.text =
                                      picked.format(context);
                                });
                              }
                            },
                          ),
                        ),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // End Time
                Row(
                  children: [
                    const SizedBox(
                      width: 120,
                      child: Text(
                        'End Time:',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: endTimeController,
                        decoration: InputDecoration(
                          hintText: 'HH:MM',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.access_time,
                              color: Colors.grey[600],
                            ),
                            onPressed: () async {
                              final TimeOfDay? picked = await showTimePicker(
                                context: context,
                                initialTime: endTime != null
                                    ? TimeOfDay.fromDateTime(endTime)
                                    : TimeOfDay.now(),
                              );
                              if (picked != null) {
                                setState(() {
                                  endTimeController.text =
                                      picked.format(context);
                                });
                              }
                            },
                          ),
                        ),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Extra Time Worked - Show for both Completed and Pending
                Row(
                  children: [
                    const SizedBox(
                      width: 120,
                      child: Text(
                        'Extra time worked:',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 80,
                      child: TextField(
                        controller: extraTimeController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Enter here',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                const BorderSide(color: Colors.green, width: 2),
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        onTap: () {
                          // Clear field and select all text for easy entry
                          if (extraTimeController.text == '0') {
                            extraTimeController.clear();
                          }
                          extraTimeController.selection =
                              TextSelection.fromPosition(
                            TextPosition(
                                offset: extraTimeController.text.length),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'mins',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Remarks / Work Notes:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: remarkController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: 'What did you work on?',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  try {
                    final apiService = ref.read(taskApiServiceProvider);
                    final isCompleted = selectedOption == 'completed';

                    // Get remaining time and extra time
                    int? minutesLeft;
                    int? extraMinutes;

                    // Extra minutes applies to both completed and pending
                    final extra = int.tryParse(extraTimeController.text);
                    if (extra != null && extra > 0) {
                      extraMinutes = extra;
                    }

                    // Remaining time only for pending
                    if (!isCompleted) {
                      final remaining = int.tryParse(remainingController.text);
                      if (remaining != null && remaining > 0) {
                        minutesLeft = remaining;
                      }
                    }

                    await apiService.stopActivityLog(
                      activityLogId: activityLogId,
                      isCompleted: isCompleted,
                      reason: isCompleted ? 'Task completed' : 'Task paused',
                      workNotes: remarkController.text,
                      minutesLeft: minutesLeft,
                      extraMinutes: extraMinutes,
                      startTime: startTimeController.text,
                      endTime: endTimeController.text,
                    );

                    // Calculate today's date string for invalidation
                    final today = DateTime.now();
                    final todayStr =
                        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

                    ref.invalidate(apiActivityLogsProvider(todayStr));
                    ref.invalidate(apiActiveTaskProvider);
                    ref.invalidate(apiTodayPlanProvider);
                    ref.invalidate(apiPendingItemsProvider(todayStr));
                    ref.invalidate(apiAllPendingItemsProvider);

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(isCompleted
                              ? 'Task completed successfully!'
                              : 'Task paused and moved to pending'),
                          backgroundColor:
                              isCompleted ? Colors.green : Colors.orange,
                        ),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: ${e.toString()}')),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedOption == 'completed'
                      ? Colors.green
                      : Colors.orange,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Confirm & Stop'),
              ),
            ],
          );
        },
      ),
    );
  }
}

// Live timer widget for running tasks
class _LiveTimer extends HookWidget {
  final DateTime startTime;
  const _LiveTimer({required this.startTime});

  @override
  Widget build(BuildContext context) {
    final elapsed = useState(DateTime.now().difference(startTime));

    useEffect(() {
      final timer = Timer.periodic(const Duration(seconds: 1), (_) {
        elapsed.value = DateTime.now().difference(startTime);
      });
      return timer.cancel;
    }, [startTime]);

    final hours = elapsed.value.inHours;
    final minutes = elapsed.value.inMinutes % 60;
    final seconds = elapsed.value.inSeconds % 60;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
      ),
      child: Text(
        '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.blue,
          fontFeatures: [const FontFeature.tabularFigures()],
        ),
      ),
    );
  }
}

int parseTaskId(dynamic id) {
  final str = id.toString();
  final match = RegExp(r'\d+$').firstMatch(str);
  return int.parse(match?.group(0) ?? str);
}
