import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ReviewTaskModal extends HookConsumerWidget {
  final String taskName;
  final Duration durationWorked;
  final int originalTimeRemaining; // Minutes
  final Function(bool isCompleted, int remainingMinutes, String? extraHours)
      onConfirm;

  const ReviewTaskModal({
    super.key,
    required this.taskName,
    required this.durationWorked,
    required this.originalTimeRemaining,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCompleted = useState(true); // Default to completed
    final timeRemaining = useState(originalTimeRemaining);

    // Extra Time State - TextEditingControllers for manual input
    final hoursController = useTextEditingController(text: '0');
    final minutesController = useTextEditingController(text: '0');

    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Helper to format duration
    String formatDuration(Duration d) {
      if (d.inMinutes < 60) {
        return "${d.inMinutes} mins";
      }
      return "${d.inHours}h ${d.inMinutes % 60}m";
    }

    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Theme.of(context).cardColor,
        child: Container(
          width: 450,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Text(
                "Review Task",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // Summary Text
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                  ),
                  children: [
                    const TextSpan(text: "You worked on "),
                    TextSpan(
                        text: taskName,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const TextSpan(text: " for "),
                    TextSpan(
                        text: formatDuration(durationWorked),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.blue)),
                    const TextSpan(text: "."),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Option: Completed
              _OptionCard(
                title: "Completed",
                subtitle: "Task is done. No further work needed.",
                icon: Icons.check_circle_outline,
                color: Colors.green,
                isSelected: isCompleted.value,
                onTap: () => isCompleted.value = true,
                isDark: isDark,
              ),

              const SizedBox(height: 12),

              // Option: Still Pending
              _OptionCard(
                title: "Still Pending",
                subtitle: "Work remains. Move remainder to pending list.",
                icon: Icons.warning_amber_rounded,
                color: Colors.orange,
                isSelected: !isCompleted.value,
                onTap: () => isCompleted.value = false,
                isDark: isDark,
              ),

              // Pending Details
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: !isCompleted.value ? 100 : 0,
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16, left: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Time Remaining (Estimate)",
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: isDark
                                        ? Colors.grey.shade700
                                        : Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove, size: 16),
                                    onPressed: () {
                                      if (timeRemaining.value > 5) {
                                        timeRemaining.value -= 5;
                                      }
                                    },
                                    constraints: const BoxConstraints(),
                                    padding: const EdgeInsets.all(8),
                                  ),
                                  Container(
                                    width: 50,
                                    alignment: Alignment.center,
                                    child: Text(
                                      "${timeRemaining.value}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add, size: 16),
                                    onPressed: () => timeRemaining.value += 5,
                                    constraints: const BoxConstraints(),
                                    padding: const EdgeInsets.all(8),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text("mins"),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Original plan had ${originalTimeRemaining}m left.",
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? Colors.grey.shade500
                                : Colors.grey.shade500,
                            fontStyle: FontStyle.italic,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Extra Time Manual Input (Text Fields)
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Extra Time Worked (Optional)",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  // Hours TextField
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: isDark
                                ? Colors.grey.shade700
                                : Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: hoursController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Hours',
                          hintStyle: TextStyle(fontSize: 13),
                          contentPadding: EdgeInsets.symmetric(vertical: 8),
                        ),
                        onChanged: (value) {
                          // Validate hours (0-23)
                          final hours = int.tryParse(value);
                          if (hours == null || hours < 0 || hours > 23) {
                            if (value.isNotEmpty) {
                              hoursController.text = '0';
                              hoursController.selection =
                                  TextSelection.fromPosition(
                                TextPosition(
                                    offset: hoursController.text.length),
                              );
                            }
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Minutes TextField
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: isDark
                                ? Colors.grey.shade700
                                : Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: minutesController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Mins',
                          hintStyle: TextStyle(fontSize: 13),
                          contentPadding: EdgeInsets.symmetric(vertical: 8),
                        ),
                        onChanged: (value) {
                          // Validate minutes (0-59)
                          final mins = int.tryParse(value);
                          if (mins == null || mins < 0 || mins > 59) {
                            if (value.isNotEmpty) {
                              minutesController.text = '0';
                              minutesController.selection =
                                  TextSelection.fromPosition(
                                TextPosition(
                                    offset: minutesController.text.length),
                              );
                            }
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text("Cancel",
                        style: TextStyle(
                            color: isDark
                                ? Colors.grey.shade400
                                : Colors.grey.shade600)),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      String? extraTimeStr;
                      final hours = int.tryParse(hoursController.text) ?? 0;
                      final minutes = int.tryParse(minutesController.text) ?? 0;

                      if (hours > 0 || minutes > 0) {
                        extraTimeStr = "${hours}h ${minutes}m";
                      }

                      onConfirm(
                          isCompleted.value,
                          isCompleted.value ? 0 : timeRemaining.value,
                          extraTimeStr);
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isCompleted.value ? Colors.green : Colors.deepOrange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("Confirm & Stop"),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}

class _OptionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDark;

  const _OptionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Colors.blue
                : (isDark ? Colors.grey.shade700 : Colors.grey.shade300),
            width: isSelected ? 2 : 1,
          ),
          color: isSelected
              ? (isDark
                  ? Colors.blue.withValues(alpha: 0.1)
                  : Colors.blue.withValues(alpha: 0.05))
              : Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected ? Colors.blue : Colors.grey,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(subtitle,
                      style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            Icon(icon, color: color),
          ],
        ),
      ),
    );
  }
}
