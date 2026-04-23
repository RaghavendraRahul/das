import 'dart:async';

// For PathMetric
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:project_pm/src/features/projects/providers/api_providers.dart';
import 'package:project_pm/src/core/providers/user_providers.dart';

import 'review_task_dialog.dart';
import 'task_config_modal.dart';

class DayLog extends HookConsumerWidget {
  const DayLog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Trigger day rollover once on first render — moves stale previous-day
    // IN_PROGRESS logs into Pending, keeping today's activity log clean.
    useEffect(() {
      Future.microtask(() async {
        final service = ref.read(taskApiServiceProvider);
        await service.rolloverDay();
        // Refresh pending + activity logs after rollover
        ref.invalidate(apiAllPendingItemsProvider);
      });
      return null;
    }, const []);
    final isReadOnly = ref.watch(isReadOnlyProvider);
    final today = DateTime.now();
    final todayStr =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    final activeSessionAsync = ref.watch(apiActiveSessionProvider(todayStr));
    final isFinalized = activeSessionAsync.valueOrNull != null;

    final apiActivityLogsAsync = ref.watch(apiActivityLogsProvider(todayStr));
    final activeTaskAsync = ref.watch(apiActiveTaskProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DragTarget<Map<String, dynamic>>(
      onAcceptWithDetails: (details) async {
        if (isReadOnly) return;

        try {
          // Check for active task at the very beginning
          final data = details.data;


          // Helper to handle manual review directly (No automatic timer start)
          Future<void> openManualReview(int plannedItemId, Map<String, dynamic> sourceData, {String? description, int? duration}) async {
            try {
              // Refresh today plan to ensure the UI knows about any new unplanned additions
              ref.invalidate(apiTodayPlanProvider);
              
              if (context.mounted) {
                // Construct a shell item that ReviewTaskDialog can use to call bulkStopActivityLogs
                final Map<String, dynamic> shellItem = {
                  'id': 0, // Not started in backend work logs
                  'today_plan': {
                    'id': plannedItemId,
                    'catalog_name': sourceData['catalog_name'] ?? sourceData['name'] ?? 'Task',
                    'planned_duration_minutes': duration ?? sourceData['planned_duration_minutes'] ?? 60,
                    'notes': description ?? sourceData['notes'] ?? '',
                  },
                  'actual_start_time': null,
                  'actual_end_time': null,
                  'minutes_worked': 0,
                };
                
                showReviewTaskDialog(context, ref, shellItem, isEditMode: false);
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
                );
              }
            }
          }

          // Case 1: Planned Items (from today's plan column)
          if (data['source'] == 'today_plan' && data['type'] == 'plan_item') {
            if (!isFinalized) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Please Lock/Start the day plan to begin recording activities.'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
              return;
            }
            final plannedItemId = data['id'] as int;
            showDialog(
              context: context,
              builder: (ctx) => TaskConfigModal(
                initialTitle: data['catalog_name'] ?? 'Task',
                initialDescription: data['notes'],
                initialDuration: ((data['planned_duration_minutes'] as num?)?.toInt() ?? 60).clamp(15, 120),
                showQuadrantSelector: false,
                onConfirm: ({required String name, required int duration, String? description, List<String>? selectedMilestoneIds, String? quadrant}) async {
                  await openManualReview(plannedItemId, data, 
                    description: description, 
                    duration: duration
                  );
                },
              ),
            );
            return;
          }

          // Case 2: Unplanned Items (Catalog, Project Task, etc.)
          if (data['type'] == 'project_task' ||
              data['type'] == 'catalog_item' ||
              data['type'] == 'catalog_task' ||
              data['type'] == 'custom_template' ||
              data['type'] == 'custom' ||
              data['type'] == 'pending_item') {
            
            showDialog(
              context: context,
              builder: (ctx) => TaskConfigModal(
                initialTitle: data['name'] ?? 'New Unplanned Task',
                initialDescription: data['description'],
                initialDuration: ((data['duration'] as num?)?.toInt() ?? 60).clamp(15, 120),
                showQuadrantSelector: false,
                onConfirm: ({required String name, required int duration, String? description, List<String>? selectedMilestoneIds, String? quadrant}) async {
                  try {
                    final apiService = ref.read(taskApiServiceProvider);
                    final userId = ref.read(currentUserIdProvider);
                    final planDate = todayStr;
                    int? plannedItemId;

                    // Create the Plan Item (marked as unplanned)
                    debugPrint('📦 [DayLog] Creating unplanned task for log: type=${data['type']}, name=$name');

                    if (data['type'] == 'catalog_item' || 
                        data['type'] == 'template' || 
                        data['type'] == 'custom_template') {
                      // Standard catalog items
                      final catalogId = data['catalog_id'] ?? data['id'] ?? data['template_id'];
                      debugPrint('   - Using catalog path: id=$catalogId');
                      
                      final planItem = await apiService.addItemToTodayPlan(
                        itemType: 'catalog',
                        catalogId: catalogId,
                        planDate: planDate,
                        plannedDurationMinutes: duration,
                        description: description,
                        isUnplanned: true,
                        quadrant: 'inbox',
                        userId: userId,
                      );
                      plannedItemId = planItem['id'] as int;
                    } else if (data['type'] == 'project_task' || data['type'] == 'catalog_task') {
                      // Tasks linked to project/backend tasks
                      final taskId = data['task_id'] != null ? parseTaskId(data['task_id']) : (data['id'] != null ? parseTaskId(data['id']) : null);
                      debugPrint('   - Using task path: taskId=$taskId');

                      final planItem = await apiService.addItemToTodayPlan(
                        itemType: 'custom',
                        title: name,
                        planDate: planDate,
                        plannedDurationMinutes: duration,
                        description: description,
                        relatedTaskId: taskId,
                        isUnplanned: true,
                        quadrant: 'inbox',
                        userId: userId,
                      );
                      plannedItemId = planItem['id'] as int;
                    } else if (data['type'] == 'pending_item') {
                      debugPrint('   - Using pending path: id=${data['id']}, is_today_inbox=${data['is_today_inbox']}');
                      if (data['is_today_inbox'] == true) {
                        plannedItemId = data['id'] as int;
                        await apiService.updateTodayPlanItem(plannedItemId, {
                          'is_unplanned': true,
                          'notes': description,
                          'planned_duration_minutes': duration,
                        });
                      } else {
                        final planItem = await apiService.addItemToTodayPlan(
                          itemType: 'custom',
                          title: name,
                          planDate: planDate,
                          plannedDurationMinutes: duration,
                          description: description,
                          isUnplanned: true,
                          quadrant: 'inbox',
                          userId: userId,
                        );
                        plannedItemId = planItem['id'] as int;
                      }
                    } else {
                      // Generic custom items
                      debugPrint('   - Using generic custom path');
                      final planItem = await apiService.addItemToTodayPlan(
                        itemType: 'custom',
                        title: name,
                        planDate: planDate,
                        plannedDurationMinutes: duration,
                        description: description,
                        isUnplanned: true,
                        quadrant: 'inbox',
                        userId: userId,
                      );
                      plannedItemId = planItem['id'] as int;
                    }

                    debugPrint('   - Created plannedItemId: $plannedItemId');
                    // Clean up pending if applicable
                    if (data['is_pending'] == true && data['pending_id'] != null && data['is_today_inbox'] != true) {
                      await apiService.deletePendingTask(data['pending_id']);
                      ref.invalidate(apiAllPendingItemsProvider);
                    }
                    
                    debugPrint('   - Opening manual review for $plannedItemId');
                    await openManualReview(plannedItemId, {
                      ...data,
                      'name': name,
                      'notes': description,
                      'planned_duration_minutes': duration,
                    }, 
                    description: description, 
                    duration: duration);
                                    } catch (e, stack) {
                    debugPrint('❌ [DayLog] Failed to create unplanned item: $e');
                    debugPrint(stack.toString());
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to start task: $e'), backgroundColor: Colors.red));
                    }
                  }
                },
              ),
            );
          }
        } catch (e) {
          debugPrint('Drag start error: $e');
        }
      },
      onWillAcceptWithDetails: (details) {
        if (isReadOnly) return false;
        final data = details.data;
        
        // Accept from today_plan or catalog/unplanned sources
        return data['source'] == 'today_plan' || 
               data['source'] == 'catalog' ||
               data['source'] == 'pending' ||
               data['type'] == 'project_task' ||
               data['type'] == 'catalog_item' ||
               data['type'] == 'catalog_task' ||
               data['type'] == 'custom_template' ||
               data['type'] == 'pending_item' ||
               data['type'] == 'template';
      },
      builder: (context, candidateData, rejectedData) {
        final isHovering = candidateData.isNotEmpty;
        return Container(
          height: double.infinity,
          width: double.infinity,
        decoration: BoxDecoration(
          color: isHovering 
              ? (isDark ? Colors.blue.withValues(alpha: 0.05) : Colors.blue.shade50.withValues(alpha: 0.3))
              : (isDark ? const Color(0xFF1F2937) : Colors.white),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.black.withValues(alpha: 0.04),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black.withValues(alpha: 0.4) : Colors.black.withValues(alpha: 0.06),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: isDark ? Colors.black.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.02),
              blurRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Compact horizontal
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "ACTIVITY LOG",
                      style: GoogleFonts.inter(
                        fontSize: 11, // Match catalog size
                        fontWeight: FontWeight.w900, // Extra bold
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
              Divider(
                height: 1,
                thickness: 1,
                color: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : Colors.black.withValues(alpha: 0.05),
              ),

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
class _TotalWorkedTimerAPI extends StatelessWidget {
  final List<Map<String, dynamic>> logs;
  const _TotalWorkedTimerAPI({required this.logs});

  @override
  Widget build(BuildContext context) {
    int totalMillis = 0;
    final now = DateTime.now();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    for (var log in logs) {
      try {
        final startStr = log['actual_start_time'] as String?;
        final endStr = log['actual_end_time'] as String?;

        if (startStr != null) {
          final start = DateTime.parse(startStr);
          final end = endStr != null ? DateTime.parse(endStr) : now;
          totalMillis += end.difference(start).inMilliseconds;
        }
      } catch (e) {
        debugPrint('Error calculating time for log: $e');
      }
    }

    final totalSeconds = (totalMillis / 1000).floor();
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;

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
                fontWeight: FontWeight.bold,
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
      // Sanitize taskName to remove any redundant time patterns e.g. "Lunch [13:00-14:00]"
      taskName = taskName.replaceAll(RegExp(r'\s*\[\d{2}:\d{2}\s*-\s*\d{2}:\d{2}\]$'), '');
      
      isUnplanned = todayPlan['is_unplanned'] == true;
      if (isUnplanned) {
        taskName = taskName.replaceFirst('[Unplanned] ', '');
      }
    }

    // Extract times directly from ISO strings (backend already sends in Asia/Kolkata)
    final startStr = item['actual_start_time'] as String?;
    final endStr = item['actual_end_time'] as String?;
    final startTimeDisplay = _extractTime(startStr);
    final endTimeDisplay = _extractTime(endStr);

    // Parsed startTime removed as it was unused
    try {
      if (startStr != null) DateTime.parse(startStr);
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
            ? Border.all(color: Colors.blue.withValues(alpha: 0.3))
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
                              color: accentColor.withValues(alpha: 0.5),
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
                                color: Colors.orange.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                    color: Colors.orange.withValues(alpha: 0.4)),
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
                          if ((item['extra_minutes'] as int? ?? 0) > 0)
                            Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: isDark ? Colors.redAccent.withValues(alpha: 0.15) : Colors.red.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                    color: isDark ? Colors.redAccent.withValues(alpha: 0.3) : Colors.red.withValues(alpha: 0.2)),
                              ),
                              child: Text(
                                'Extra: ${item['extra_minutes']}m',
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: isDark ? Colors.redAccent : Colors.red.shade700,
                                ),
                              ),
                            ),

                          // Status Badge - Show Completed or Pending
                          if (status == 'COMPLETED')
                            Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                    color: Colors.green.withValues(alpha: 0.3)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.check_circle,
                                      size: 13, color: Colors.green),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Completed',
                                    style: GoogleFonts.inter(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (status == 'PENDING')
                            Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.orange.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                    color: Colors.orange.withValues(alpha: 0.3)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.pause_circle,
                                      size: 13, color: Colors.orange.shade700),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Pending',
                                    style: GoogleFonts.inter(
                                      fontSize: 10,
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
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                letterSpacing: 0.3,
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.access_time_filled,
                              size: 14,
                              color: accentColor.withValues(alpha: 0.7)),
                          const SizedBox(width: 6),
                          Text(
                            startTimeDisplay.isNotEmpty
                                ? '$startTimeDisplay - ${endTimeDisplay.isNotEmpty ? endTimeDisplay : "In Progress"}'
                                : 'Session not started',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? Colors.grey.shade300
                                  : Colors.grey.shade700,
                            ),
                          ),
                          const Spacer(),
                          if (!isRunning)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${workedHours}h ${workedMins}m',
                                style: GoogleFonts.outfit(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.green.shade600,
                                ),
                              ),
                            ),
                        ],
                      ),
                      // Remarks Section (Side by Side)
                      if ((todayPlan != null &&
                              todayPlan['notes'] != null &&
                              todayPlan['notes'].toString().isNotEmpty) ||
                          (item['work_notes'] != null &&
                              (item['work_notes'] as String).isNotEmpty)) ...[
                        const SizedBox(height: 12),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Planned Remarks column
                            if (todayPlan != null &&
                                todayPlan['notes'] != null &&
                                todayPlan['notes'].toString().isNotEmpty)
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? Colors.blue.withValues(alpha: 0.08)
                                        : Colors.blue.withValues(alpha: 0.04),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: isDark
                                          ? Colors.blue.withValues(alpha: 0.2)
                                          : Colors.blue.withValues(alpha: 0.1),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.lightbulb_outline,
                                              size: 14,
                                              color: isDark
                                                  ? Colors.blue.shade300
                                                  : Colors.blue.shade700),
                                          const SizedBox(width: 4),
                                          Text(
                                            'PLANNED',
                                            style: GoogleFonts.outfit(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w800,
                                              letterSpacing: 0.5,
                                              color: isDark
                                                  ? Colors.blue.shade300
                                                  : Colors.blue.shade700,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        todayPlan['notes'],
                                        style: GoogleFonts.inter(
                                          fontSize: 11,
                                          height: 1.3,
                                          color: isDark
                                              ? Colors.blue.shade100
                                              : Colors.blue.shade900,
                                        ),
                                        maxLines: 4,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                            if (todayPlan != null &&
                                todayPlan['notes'] != null &&
                                todayPlan['notes'].toString().isNotEmpty &&
                                item['work_notes'] != null &&
                                (item['work_notes'] as String).isNotEmpty)
                              const SizedBox(width: 10),

                            // Achieved Remarks column
                            if (item['work_notes'] != null &&
                                (item['work_notes'] as String).isNotEmpty)
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? Colors.green.withValues(alpha: 0.08)
                                        : Colors.green.withValues(alpha: 0.04),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: isDark
                                          ? Colors.green.withValues(alpha: 0.2)
                                          : Colors.green.withValues(alpha: 0.1),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.task_alt,
                                              size: 14,
                                              color: isDark
                                                  ? Colors.green.shade300
                                                  : Colors.green.shade700),
                                          const SizedBox(width: 4),
                                          Text(
                                            'ACHIEVED',
                                            style: GoogleFonts.outfit(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w800,
                                              letterSpacing: 0.5,
                                              color: isDark
                                                  ? Colors.green.shade300
                                                  : Colors.green.shade700,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        item['work_notes'],
                                        style: GoogleFonts.inter(
                                          fontSize: 11,
                                          height: 1.3,
                                          color: isDark
                                              ? Colors.green.shade100
                                              : Colors.green.shade900,
                                        ),
                                        maxLines: 4,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
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



int parseTaskId(dynamic id) {
  final str = id.toString();
  final match = RegExp(r'\d+$').firstMatch(str);
  return int.parse(match?.group(0) ?? str);
}
