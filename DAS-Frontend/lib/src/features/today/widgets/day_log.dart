import 'dart:async';

// For PathMetric
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:project_pm/src/features/projects/providers/api_providers.dart';
import 'package:project_pm/src/core/providers/user_providers.dart';

import 'review_task_dialog.dart';

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

          // NEW: Handle dragged Today's Plan items directly
          if (data['source'] == 'today_plan' && data['type'] == 'plan_item') {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Starting task...'),
                duration: Duration(seconds: 1),
              ),
            );

            try {
              final apiService = ref.read(taskApiServiceProvider);
              final plannedItemId = data['id'] as int;

              // Move existing plan item to activity log
              final targetItemInfo =
                  await apiService.moveTodayPlanToActivityLog(plannedItemId);
              debugPrint(
                  '✅ Moved to activity log: ${targetItemInfo.isNotEmpty}');

              // Refresh all data
              ref.invalidate(apiTodayPlanProvider);
              ref.invalidate(apiActivityLogsProvider(todayStr));
              ref.invalidate(apiActiveTaskProvider);

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Task initiated. Target acquired.'),
                    backgroundColor: Colors.blue,
                    duration: Duration(seconds: 2),
                  ),
                );

                debugPrint(
                    '📋 Target item info: ${targetItemInfo.keys.toList()}');

                if (targetItemInfo.isNotEmpty &&
                    targetItemInfo.containsKey('id')) {
                  debugPrint('🎯 Opening dialog with targetItemInfo');
                  showReviewTaskDialog(context, ref, targetItemInfo,
                      isEditMode: false);
                } else {
                  try {
                    debugPrint('⏳ Fetching active task...');
                    final actvTask = await apiService.getActiveTask();
                    if (actvTask is Map<String, dynamic> &&
                        actvTask.containsKey('id')) {
                      if (context.mounted) {
                        debugPrint('🎯 Opening dialog with active task');
                        showReviewTaskDialog(context, ref, actvTask,
                            isEditMode: false);
                      }
                    } else {
                      debugPrint('⚠️ Active task not found or invalid');
                    }
                  } catch (e) {
                    debugPrint('❌ Error fetching active task: $e');
                  }
                }
              }
            } catch (e) {
              if (context.mounted) {
                final errorMsg = e.toString().replaceAll('Exception: ', '');
                final isActiveTaskError =
                    errorMsg.contains('already have an active task');

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(errorMsg),
                    backgroundColor:
                        isActiveTaskError ? Colors.orange : Colors.red,
                    duration: const Duration(seconds: 4),
                  ),
                );
              }
            }
            return;
          }

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
            debugPrint(
                '🚀 [Drag Type 2] Calling moveTodayPlanToActivityLog for plannedItemId: $plannedItemId');
            final targetItemInfo =
                await apiService.moveTodayPlanToActivityLog(plannedItemId);
            debugPrint(
                '✅ [Drag Type 2] Moved to activity log: ${targetItemInfo.isNotEmpty}');

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

            if (context.mounted) {
              debugPrint(
                  '📋 [Drag Type 2] Target item info keys: ${targetItemInfo.keys.toList()}');
              if (targetItemInfo.isNotEmpty &&
                  targetItemInfo.containsKey('id')) {
                debugPrint(
                    '🎯 [Drag Type 2] Opening review dialog with targetItemInfo');
                showReviewTaskDialog(context, ref, targetItemInfo,
                    isEditMode: false);
              } else {
                try {
                  debugPrint('⏳ [Drag Type 2] Fetching active task...');
                  final actvTask = await apiService.getActiveTask();
                  if (actvTask is Map<String, dynamic> &&
                      actvTask.containsKey('id')) {
                    if (context.mounted) {
                      debugPrint(
                          '🎯 [Drag Type 2] Opening dialog with active task');
                      showReviewTaskDialog(context, ref, actvTask,
                          isEditMode: false);
                    }
                  } else {
                    debugPrint(
                        '⚠️ [Drag Type 2] Active task not found or invalid');
                  }
                } catch (e) {
                  debugPrint('❌ [Drag Type 2] Error fetching active task: $e');
                }
              }
            }
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
              color: isDark
                  ? Colors.white.withOpacity(0.08)
                  : Colors.black.withOpacity(0.05),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withOpacity(0.3)
                    : Colors.black.withOpacity(0.06),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: isDark
                    ? Colors.black.withOpacity(0.15)
                    : Colors.black.withOpacity(0.02),
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
                        final List<Map<String, dynamic>> combinedLogs = [
                          ...logs
                        ];
                        if (activeTask != null && activeTask['id'] != null) {
                          final bool isAlreadyInLogs =
                              logs.any((l) => l['id'] == activeTask['id']);
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
                            return _ApiLoggedItemCard(
                                item: combinedLogs[index]);
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
                          // Status Badge - Show Completed or Pending
                          if (status == 'COMPLETED')
                            Container(
                              margin: const EdgeInsets.only(right: 6),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                    color: Colors.green.withOpacity(0.4)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.check_circle,
                                      size: 12, color: Colors.green),
                                  const SizedBox(width: 3),
                                  Text(
                                    'Completed',
                                    style: GoogleFonts.inter(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (status == 'PENDING')
                            Container(
                              margin: const EdgeInsets.only(right: 6),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                    color: Colors.orange.withOpacity(0.4)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.pause_circle,
                                      size: 12, color: Colors.orange.shade700),
                                  const SizedBox(width: 3),
                                  Text(
                                    'Pending',
                                    style: GoogleFonts.inter(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.orange.shade700,
                                    ),
                                  ),
                                ],
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
                IconButton(
                  icon: Icon(Icons.edit,
                      color: isReadOnly ? Colors.grey : Colors.blue),
                  iconSize: 28,
                  onPressed: isReadOnly
                      ? null
                      : () {
                          showReviewTaskDialog(context, ref, item,
                              isEditMode: true);
                        },
                ),
              ],
            ),
          ),
        ],
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
