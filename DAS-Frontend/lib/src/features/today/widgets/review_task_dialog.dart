import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:project_pm/src/features/projects/providers/api_providers.dart';
import 'package:intl/intl.dart';

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
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final activityLogId = item['id'] as int? ?? 0;
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
    // Sanitize taskName to remove any redundant time patterns
    taskName = taskName.replaceAll(RegExp(r'\s*\[\d{2}:\d{2}\s*-\s*\d{2}:\d{2}\]$'), '');
  }

  // Extract times directly from ISO strings
  final startStr = item['actual_start_time'] as String?;
  final endStr = item['actual_end_time'] as String?;
  final startTimeDisplay = _extractTimeForDialog(startStr);
  final endTimeDisplay = _extractTimeForDialog(endStr);

  // Calculate remaining and worked time
  final plannedMinutes = todayPlan?['planned_duration_minutes'] as int? ?? 0;
  final initialMinutesWorked = item['minutes_worked'] as int? ?? 0;
  final remainingMinutes = (plannedMinutes - initialMinutesWorked).clamp(0, 999999);

  // State variables for the dialog
  String? selectedOption; // null by default, it is optional
  final remainingController =
      TextEditingController(text: remainingMinutes.toString());
      
  // Initial extra worked - calculated auto
  final initialExtraMinutes = (initialMinutesWorked - plannedMinutes).clamp(0, 999999);
  final extraTimeController = TextEditingController(text: initialExtraMinutes.toString());

  // Timing controllers - ENABLED for manual entry as per user requirement
  final startTimeController = TextEditingController(text: startTimeDisplay);
  final endTimeController = TextEditingController(text: endTimeDisplay);

  final workedMinutesController =
      TextEditingController(text: initialMinutesWorked.toString());
      
  final plannedRemark = todayPlan?['notes'] as String? ?? '';
  final plannedRemarkController = TextEditingController(text: plannedRemark);
  final initialWorkNotes = item['work_notes'] as String? ?? '';
  final remarkController = TextEditingController(text: initialWorkNotes);

  // Helper to pick time
  Future<void> selectTime(
      BuildContext context,
      TextEditingController controller,
      StateSetter setDialogState,
      {required bool isStart}) async {
    final currentText = controller.text;
    TimeOfDay initialTime = TimeOfDay.now();

    if (currentText.isNotEmpty) {
      final parts = currentText.split(':');
      if (parts.length >= 2) {
        initialTime = TimeOfDay(
          hour: int.tryParse(parts[0]) ?? initialTime.hour,
          minute: int.tryParse(parts[1]) ?? initialTime.minute,
        );
      }
    }

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (picked != null) {
      final formatted =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      setDialogState(() {
        controller.text = formatted;
        
        // Auto-calculate worked minutes if both exist
        if (startTimeController.text.isNotEmpty &&
            endTimeController.text.isNotEmpty) {
          try {
            final now = DateTime.now();
            final sParts = startTimeController.text.split(':');
            final eParts = endTimeController.text.split(':');
            
            final start = DateTime(now.year, now.month, now.day, 
                int.parse(sParts[0]), int.parse(sParts[1]));
            var end = DateTime(now.year, now.month, now.day, 
                int.parse(eParts[0]), int.parse(eParts[1]));
            
            if (end.isBefore(start)) {
              end = end.add(const Duration(days: 1));
            }
            
            final diff = end.difference(start).inMinutes;
            workedMinutesController.text = diff.toString();
            
            // Updating the "Remaining" controller pre-fill if user later clicks Pending
            final remainingValue = (plannedMinutes - diff).clamp(0, 999999);
            remainingController.text = remainingValue.toString();

            // Updating extra time controller for the backend - only if worked > planned
            final extraValue = (diff - plannedMinutes).clamp(0, 999999);
            extraTimeController.text = extraValue.toString();
          } catch (e) {
            debugPrint('Error auto-calculating time: $e');
          }
        }
      });
    }
  }


  showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'Review Task',
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'You worked on $taskName for',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  ),
                ),
                if (startTimeDisplay.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$startTimeDisplay - ${endTimeDisplay.isNotEmpty ? endTimeDisplay : "In Progress"}',
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: Colors.blue.shade600,
                          ),
                        ),
                        if ((todayPlan?['total_minutes_worked'] as int? ?? 0) > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.blue.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Total: ${todayPlan?['total_minutes_worked']}m',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade700,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                const SizedBox(height: 20),

                Text(
                  'PLANNED REMARK',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w800,
                    fontSize: 11,
                    letterSpacing: 1.0,
                    color: isDark ? Colors.grey.shade500 : Colors.grey.shade500,
                  ),
                ),
                const SizedBox(height: 4),
                TextField(
                  controller: plannedRemarkController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.withValues(alpha: 0.1),
                    hintText: 'Add a planned remark...',
                    hintStyle:
                        TextStyle(fontSize: 13, color: Colors.grey.shade600),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
                    ),
                    contentPadding: const EdgeInsets.all(10),
                  ),
                  style: const TextStyle(
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 16),

                // Optional completion chips
                Wrap(
                  spacing: 10,
                  children: [
                    ChoiceChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.check_circle, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            'Completed',
                            style: GoogleFonts.outfit(
                                fontWeight: FontWeight.w600, fontSize: 13),
                          ),
                        ],
                      ),
                      selected: selectedOption == 'completed',
                      onSelected: (selected) {
                        setState(() {
                          selectedOption = selected ? 'completed' : null;
                        });
                      },
                      selectedColor: Colors.green.withValues(alpha: 0.2),
                      backgroundColor: isDark ? Colors.white10 : Colors.grey.shade100,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      side: BorderSide.none,
                    ),
                    ChoiceChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.warning_amber, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            'Still Pending',
                            style: GoogleFonts.outfit(
                                fontWeight: FontWeight.w600, fontSize: 13),
                          ),
                        ],
                      ),
                      selected: selectedOption == 'pending',
                      onSelected: (selected) {
                        setState(() {
                          selectedOption = selected ? 'pending' : null;
                          if (selected) {
                             // Pre-fill remaining time based on current entries
                             final worked = int.tryParse(workedMinutesController.text) ?? 0;
                             final left = (plannedMinutes - worked).clamp(0, 999999);
                             remainingController.text = left.toString();
                          }
                        });
                      },
                      selectedColor: Colors.orange.withValues(alpha: 0.2),

                      backgroundColor: isDark ? Colors.white10 : Colors.grey.shade100,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      side: BorderSide.none,
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
                const SizedBox(height: 24),
                Text(
                  'SCHEDULE DETAILS',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                    letterSpacing: 1.0,
                    color: isDark ? Colors.blue.shade300 : Colors.blue.shade700,
                  ),
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
                    const Text('mins'),
                  ],
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.only(left: 120),
                  child: Text(
                    'Extra time is also auto-calculated based on plan.',
                    style: TextStyle(
                      fontSize: 10,
                      color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Time Pickers
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Start Time',
                              style: TextStyle(fontSize: 12, color: Colors.grey)),
                          const SizedBox(height: 4),
                          InkWell(
                            onTap: () => selectTime(
                                context, startTimeController, setState,
                                isStart: true),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade50,
                                border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.access_time, 
                                      size: 16, 
                                      color: isDark ? Colors.blue.shade300 : Colors.blue.shade600),
                                  const SizedBox(width: 10),
                                  Text(
                                    startTimeController.text.isEmpty
                                        ? 'Select'
                                        : startTimeController.text,
                                    style: GoogleFonts.outfit(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('End Time',
                              style: TextStyle(fontSize: 12, color: Colors.grey)),
                          const SizedBox(height: 4),
                          InkWell(
                            onTap: () => selectTime(
                                context, endTimeController, setState,
                                isStart: false),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade50,
                                border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.access_time, 
                                      size: 16, 
                                      color: isDark ? Colors.blue.shade300 : Colors.blue.shade600),
                                  const SizedBox(width: 10),
                                  Text(
                                    endTimeController.text.isEmpty
                                        ? 'Select'
                                        : endTimeController.text,
                                    style: GoogleFonts.outfit(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                // Live Calculation Feedback
                if (startTimeController.text.isNotEmpty && endTimeController.text.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Builder(
                      builder: (context) {
                        final worked = int.tryParse(workedMinutesController.text) ?? 0;
                        final diff = (worked - plannedMinutes).abs();
                        final isExtra = worked > plannedMinutes;
                        final isUnder = worked < plannedMinutes;
                        
                        if (worked == 0) return const SizedBox.shrink();
                        
                        return Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isExtra 
                               ? Colors.green.withValues(alpha: 0.1) 
                               : (isUnder ? Colors.orange.withValues(alpha: 0.1) : Colors.blue.withValues(alpha: 0.1)),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isExtra 
                                ? Colors.green.withValues(alpha: 0.3) 
                                : (isUnder ? Colors.orange.withValues(alpha: 0.3) : Colors.blue.withValues(alpha: 0.3)),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                isExtra ? Icons.trending_up : (isUnder ? Icons.trending_down : Icons.check_circle_outline),
                                size: 16,
                                color: isExtra ? Colors.green.shade700 : (isUnder ? Colors.orange.shade700 : Colors.blue.shade700),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  isExtra 
                                    ? "Extra Time Worked: +${diff}m" 
                                    : (isUnder ? "Remaining to reach goal: ${diff}m" : "Planned goal reached!"),
                                  style: GoogleFonts.outfit(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                    color: isExtra ? Colors.green.shade900 : (isUnder ? Colors.orange.shade900 : Colors.blue.shade900),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                const SizedBox(height: 16),
                const Divider(),

                const SizedBox(height: 8),
                Text(
                  'ACHIEVED REMARK',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w800,
                    fontSize: 11,
                    letterSpacing: 1.0,
                    color: isDark ? Colors.grey.shade500 : Colors.grey.shade500,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: remarkController,
                  maxLines: 2,
                  style: GoogleFonts.inter(fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'What did you work on?',
                    hintStyle: GoogleFonts.inter(fontSize: 14, color: Colors.grey),
                    filled: true,
                    fillColor: isDark ? Colors.white.withValues(alpha: 0.03) : Colors.grey.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: isDark ? Colors.white12 : Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: isDark ? Colors.white12 : Colors.grey.shade300),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8, bottom: 8),
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    final apiService = ref.read(taskApiServiceProvider);
                    final isCompleted = selectedOption == 'completed';
                    
                    // Parse manual overrides if any
                    final minutesLeft = int.tryParse(remainingController.text) ?? 0;
                    final extraMinutes = int.tryParse(extraTimeController.text) ?? 0;

                    final today = DateTime.now();
                    final todayStr = DateFormat('yyyy-MM-dd').format(today);
                    
                    // Robust ID extraction
                    final todayPlanId = int.tryParse(todayPlan?['id']?.toString() ?? '') ?? 0;
                    
                    debugPrint('💾 [ReviewTaskDialog] Saving task progress:');
                    debugPrint('   - todayPlanId: $todayPlanId');
                    debugPrint('   - activityLogId: $activityLogId');
                    debugPrint('   - isCompleted: $isCompleted');
                    debugPrint('   - selectedOption: $selectedOption');
                    
                    bool apiCalled = false;
                    
                    // Prioritize singular stopActivityLog in edit mode to target specific session
                    if (isEditMode && activityLogId > 0) {
                      debugPrint('   - [Edit Mode] Calling stopActivityLog for ID: $activityLogId');
                      await apiService.stopActivityLog(
                        activityLogId: activityLogId,
                        isCompleted: isCompleted,
                        isPendingSelected: selectedOption == 'pending',
                        reason: isCompleted ? 'Task completed' : 'Task updated',
                        workNotes: remarkController.text,
                        minutesLeft: minutesLeft,
                        extraMinutes: extraMinutes > 0 ? extraMinutes : null,
                        startTime: startTimeController.text,
                        endTime: endTimeController.text,
                        plannedRemark: plannedRemarkController.text,
                      );
                      apiCalled = true;
                    } 
                    // Use bulkStopActivityLogs when stopping active task (Sync logic)
                    else if (todayPlanId > 0) {
                      debugPrint('   - Calling bulkStopActivityLogs...');
                      await apiService.bulkStopActivityLogs(
                        todayPlanId: todayPlanId,
                        date: todayStr,
                        isCompleted: isCompleted,
                        isPendingSelected: selectedOption == 'pending',
                        workNotes: remarkController.text,
                        minutesLeft: minutesLeft,
                        extraMinutes: extraMinutes > 0 ? extraMinutes : null,
                        startTime: startTimeController.text,
                        endTime: endTimeController.text,
                        plannedRemark: plannedRemarkController.text,
                      );
                      apiCalled = true;
                    } 
                    // Fallback to singular stop for non-standard cases
                    else if (activityLogId > 0) {
                      debugPrint('   - Calling stopActivityLog...');
                      await apiService.stopActivityLog(
                        activityLogId: activityLogId,
                        isCompleted: isCompleted,
                        reason: isCompleted ? 'Task completed' : 'Task paused',
                        workNotes: remarkController.text,
                        minutesLeft: minutesLeft,
                        extraMinutes: extraMinutes > 0 ? extraMinutes : null,
                        startTime: startTimeController.text,
                        endTime: endTimeController.text,
                        plannedRemark: plannedRemarkController.text,
                      );
                      apiCalled = true;
                    }

                    if (apiCalled) {
                      ref.invalidate(apiActivityLogsProvider(todayStr));
                      ref.invalidate(apiActiveTaskProvider);
                      ref.invalidate(apiTodayPlanProvider);
                      ref.invalidate(apiPendingItemsProvider(todayStr));

                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(isCompleted ? 'Task completed!' : 'Updated!'),
                            backgroundColor: isCompleted ? Colors.green : Colors.blue,
                          ),
                        );
                      }
                    } else {
                      debugPrint('⚠️ [ReviewTaskDialog] No valid ID found to stop. todayPlanId=$todayPlanId, activityLogId=$activityLogId');
                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Warning: No task ID found to update.'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                      }
                    }
                  } catch (e, stack) {
                    debugPrint('❌ [ReviewTaskDialog] Error saving: $e');
                    debugPrint(stack.toString());
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedOption == 'completed'
                      ? Colors.green.shade600
                      : (selectedOption == 'pending'
                          ? Colors.orange.shade700
                          : Colors.blue.shade700),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  selectedOption == 'completed'
                      ? 'Confirm & Complete'
                      : 'Save Progress',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    ),
  );
}
