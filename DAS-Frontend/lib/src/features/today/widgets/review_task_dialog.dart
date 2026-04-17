import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:project_pm/src/features/projects/providers/api_providers.dart';

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

void showReviewTaskDialog(
    BuildContext context, WidgetRef ref, Map<String, dynamic> item,
    {bool isEditMode = false}) {
  final activityLogId = item['id'] as int;
  final todayPlan = item['today_plan'] as Map<String, dynamic>?;

  debugPrint('📋 [ReviewTaskDialog] Received item:');
  debugPrint('   - Activity Log ID: $activityLogId');
  debugPrint('   - TodayPlan: $todayPlan');
  debugPrint('   - TodayPlan ID: ${todayPlan?['id']}');
  debugPrint('   - Item keys: ${item.keys.toList()}');

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

  // Calculate remaining time
  final plannedMinutes = todayPlan?['planned_duration_minutes'] as int? ?? 0;
  final workedMinutes = item['minutes_worked'] as int? ?? 0;
  final remainingMinutes = (plannedMinutes - workedMinutes).clamp(0, 999999);

  // State variables for the dialog
  String? selectedOption; // null by default, it is optional
  final remainingController =
      TextEditingController(text: remainingMinutes.toString());
  final extraTimeController = TextEditingController(text: '0');

  // Timing controllers are not going to be editable
  final startTimeController = TextEditingController(text: startTimeDisplay);
  final endTimeController = TextEditingController(text: endTimeDisplay);

  final plannedRemark = todayPlan?['notes'] as String? ?? '';
  final remarkController =
      TextEditingController(text: item['work_notes'] as String? ?? '');

  showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          title: const Text('Review Task'),
          content: SingleChildScrollView(
            child: Column(
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

                if (plannedRemark.isNotEmpty) ...[
                  const Text(
                    'Planned Remark:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.withOpacity(0.2)),
                    ),
                    child: Text(
                      plannedRemark,
                      style: const TextStyle(
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Optional completion chips
                Wrap(
                  spacing: 10,
                  children: [
                    ChoiceChip(
                      label: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle, size: 16),
                          SizedBox(width: 4),
                          Text('Completed'),
                        ],
                      ),
                      selected: selectedOption == 'completed',
                      onSelected: (selected) {
                        setState(() {
                          selectedOption = selected ? 'completed' : null;
                        });
                      },
                      selectedColor: Colors.green.withOpacity(0.3),
                    ),
                    ChoiceChip(
                      label: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.warning_amber, size: 16),
                          SizedBox(width: 4),
                          Text('Still Pending'),
                        ],
                      ),
                      selected: selectedOption == 'pending',
                      onSelected: (selected) {
                        setState(() {
                          selectedOption = selected ? 'pending' : null;
                        });
                      },
                      selectedColor: Colors.orange.withOpacity(0.3),
                    ),
                  ],
                ),

                // Remaining time field - only when "Still Pending" is selected
                if (selectedOption == 'pending') ...[
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
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
                    padding: const EdgeInsets.only(left: 152),
                    child: Text(
                      'Original plan had ${plannedMinutes}m left.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
                // Schedule Details - Disabled timing fields
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
                // Start Time (Editable only on drag-drop, disabled on edit)
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
                        enabled:
                            !isEditMode, // Editable only when drag-dropping, disabled when editing
                        keyboardType: TextInputType.datetime,
                        decoration: InputDecoration(
                          hintText: 'HH:MM',
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
                                const BorderSide(color: Colors.blue, width: 2),
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 14,
                          color: isEditMode ? Colors.grey : Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // End Time (Editable only on drag-drop, disabled on edit)
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
                        enabled:
                            !isEditMode, // Editable only when drag-dropping, disabled when editing
                        keyboardType: TextInputType.datetime,
                        decoration: InputDecoration(
                          hintText: 'HH:MM',
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
                                const BorderSide(color: Colors.blue, width: 2),
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 14,
                          color: isEditMode ? Colors.grey : Colors.black,
                        ),
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
                  'Achieved Remark:',
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

                  // Selected Option is optional now
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
                  if (!isCompleted && selectedOption != null) {
                    final remaining = int.tryParse(remainingController.text);
                    if (remaining != null && remaining > 0) {
                      minutesLeft = remaining;
                    }
                  }

                  // Get today's date
                  final today = DateTime.now();
                  final todayStr =
                      '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

                  // Get todayPlanId from the item
                  final todayPlanId = todayPlan?['id'] as int? ?? 0;

                  if (todayPlanId > 0) {
                    // Use bulk stop to update ALL instances of this task on this day
                    await apiService.bulkStopActivityLogs(
                      todayPlanId: todayPlanId,
                      date: todayStr,
                      isCompleted: isCompleted,
                      isPendingSelected: selectedOption == 'pending',
                      workNotes: remarkController.text,
                      minutesLeft: minutesLeft,
                      extraMinutes: extraMinutes,
                      startTime: startTimeController.text,
                      endTime: endTimeController.text,
                    );
                  } else {
                    // Fallback to single stop if todayPlanId not available
                    await apiService.stopActivityLog(
                      activityLogId: activityLogId,
                      isCompleted: isCompleted,
                      reason: isCompleted
                          ? 'Task completed'
                          : (selectedOption != null
                              ? 'Task paused'
                              : 'Task updated'),
                      workNotes: remarkController.text,
                      minutesLeft: minutesLeft,
                      extraMinutes: extraMinutes,
                      startTime: startTimeController.text,
                      endTime: endTimeController.text,
                    );
                  }

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
                            : 'Task updated!'),
                        backgroundColor:
                            isCompleted ? Colors.green : Colors.blue,
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
                    : (selectedOption == 'pending'
                        ? Colors.orange
                        : Colors.blue),
              ),
              child: Text(selectedOption == 'completed'
                  ? 'Confirm & Complete'
                  : 'Save Edit'),
            ),
          ],
        );
      },
    ),
  );
}
