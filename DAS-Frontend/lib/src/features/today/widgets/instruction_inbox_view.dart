import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:project_pm/src/features/today/services/instruction_service.dart';
import 'package:project_pm/src/features/today/models/instruction_model.dart';

class InstructionInboxView extends ConsumerWidget {
  final bool isOutbox;
  const InstructionInboxView({super.key, this.isOutbox = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final instructionsAsync = ref.watch(
        isOutbox ? sentInstructionsProvider : receivedInstructionsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(Icons.mark_chat_unread_outlined,
                  color: isDark ? Colors.blue.shade300 : Colors.blue.shade700),
              const SizedBox(width: 8),
              Text(
                isOutbox ? 'Sent Instructions' : 'Recent Instructions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.refresh, size: 20),
                onPressed: () => ref.refresh(isOutbox
                    ? sentInstructionsProvider
                    : receivedInstructionsProvider),
                tooltip: 'Refresh',
              ),
            ],
          ),
        ),
        Expanded(
          child: instructionsAsync.when(
            data: (instructions) {
              if (instructions.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inbox_outlined,
                          size: 48, color: Colors.grey.shade400),
                      const SizedBox(height: 12),
                      Text(
                        isOutbox
                            ? 'You haven\'t sent any instructions.'
                            : 'No instructions received yet.',
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                );
              }

              // Grouping logic
              final now = DateTime.now();
              final today = DateTime(now.year, now.month, now.day);
              final yesterday = today.subtract(const Duration(days: 1));

              final Map<String, List<TeamInstruction>> groups = {
                'Today': [],
                'Yesterday': [],
                'Earlier': [],
              };

              for (var inst in instructions) {
                final instDate = DateTime(
                    inst.sentAt.year, inst.sentAt.month, inst.sentAt.day);
                if (instDate == today) {
                  groups['Today']!.add(inst);
                } else if (instDate == yesterday) {
                  groups['Yesterday']!.add(inst);
                } else {
                  groups['Earlier']!.add(inst);
                }
              }

              return RefreshIndicator(
                onRefresh: () => ref.refresh(isOutbox
                    ? sentInstructionsProvider.future
                    : receivedInstructionsProvider.future),
                child: Scrollbar(
                  thumbVisibility: true,
                  thickness: 6,
                  radius: const Radius.circular(3),
                  child: CustomScrollView(
                    slivers: [
                      for (var entry in groups.entries)
                        if (entry.value.isNotEmpty) ...[
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                              child: Text(
                                entry.key.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade500,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                          ),
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 6),
                                  child: _InstructionCard(
                                    instruction: entry.value[index],
                                    isOutbox: isOutbox,
                                  ),
                                );
                              },
                              childCount: entry.value.length,
                            ),
                          ),
                        ],
                      const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
                    ],
                  ),
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(
              child: Text('Error: $err',
                  style: const TextStyle(color: Colors.red)),
            ),
          ),
        ),
      ],
    );
  }
}

class _InstructionCard extends StatelessWidget {
  final TeamInstruction instruction;
  final bool isOutbox;

  const _InstructionCard({required this.instruction, this.isOutbox = false});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _showInstructionDetail(context, instruction),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header bar
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.black26 : Colors.grey.shade50,
                    border: Border(
                      bottom: BorderSide(
                        color: isDark
                            ? Colors.grey.shade800
                            : Colors.grey.shade100,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Text(
                              'Subject: ',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? Colors.blue.shade300
                                    : Colors.blue.shade700,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                instruction.subject,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _getSmartDate(instruction.sentAt),
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                // Body
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.person_pin,
                              size: 14,
                              color: const Color(0xFF4F46E5).withOpacity(0.7)),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              isOutbox
                                  ? 'To: ${instruction.recipientEmails.join(", ")}'
                                  : 'From: ${instruction.sentByEmail}',
                              style: TextStyle(
                                fontSize: 11,
                                color: isOutbox
                                    ? Colors.orange.shade700
                                    : const Color(0xFF4F46E5),
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (instruction.projectName != 'General') ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F3FF),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                instruction.projectName,
                                style: const TextStyle(
                                  fontSize: 9,
                                  color: Color(0xFF7C3AED),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              'Plan: ',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? Colors.green.shade300
                                    : Colors.green.shade700,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              instruction.instructions,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                                height: 1.4,
                                color: isDark
                                    ? Colors.grey.shade400
                                    : Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getSmartDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      return 'Today, ${DateFormat('HH:mm').format(date)}';
    } else if (dateOnly == yesterday) {
      return 'Yesterday, ${DateFormat('HH:mm').format(date)}';
    } else {
      return DateFormat('MMM dd, HH:mm').format(date);
    }
  }

  void _showInstructionDetail(
      BuildContext context, TeamInstruction instruction) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.description_outlined, color: Colors.blue, size: 20),
            SizedBox(width: 8),
            Text('Instruction Detail'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Subject:',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                instruction.subject,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(height: 24),
              Row(
                children: [
                  const Icon(Icons.person_pin,
                      size: 16, color: Color(0xFF4F46E5)),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                        isOutbox
                            ? 'To: ${instruction.recipientEmails.join(", ")}'
                            : 'From: ${instruction.sentByEmail}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: isOutbox
                              ? Colors.orange.shade700
                              : const Color(0xFF4F46E5),
                          fontWeight: FontWeight.w600,
                        )),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.work_outline,
                      size: 16, color: Color(0xFF7C3AED)),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(instruction.projectName,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF7C3AED),
                          fontWeight: FontWeight.w600,
                        )),
                  ),
                ],
              ),
              const Divider(height: 24),
              Text(
                'Plan:',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                instruction.instructions,
                style: const TextStyle(fontSize: 14, height: 1.5),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
