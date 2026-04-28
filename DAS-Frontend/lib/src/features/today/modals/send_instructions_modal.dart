import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:project_pm/src/core/database/database.dart';
import 'package:project_pm/src/features/projects/project_providers.dart';
import 'package:project_pm/src/features/today/models/instruction_model.dart';
import 'package:project_pm/src/features/today/services/instruction_service.dart';
import 'package:google_fonts/google_fonts.dart';

// Premium Design Tokens
const _kSidebarBg = Color(0xFF05263E);
const _kPrimaryBlue = Color(0xFF3B82F6);
const _kInputBg = Color(0xFF0F172A);
const _kBorderColor = Color(0xFF1E293B);

class SendInstructionsModal extends HookConsumerWidget {
  const SendInstructionsModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedProject = useState<String?>(null);
    final selectedProjectId = selectedProject.value != null
        ? int.tryParse(selectedProject.value!)
        : null;
    final allUsersAsync = ref.watch(projectMembersProvider(selectedProjectId));
    final projectsAsync = ref.watch(projectsWithTasksProvider);
    final isSending = useState(false);
    final selectedRecipients = useState<List<User>>([]);
    final subjectController = useTextEditingController();
    final instructionsController = useTextEditingController();

    // Determine if submit is enabled
    final canSubmit = selectedRecipients.value.isNotEmpty &&
        instructionsController.text.isNotEmpty;
    // Rebuild when text changes to update button state
    useListenable(instructionsController);

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        width: 600,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0B1424) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 24,
              offset: const Offset(0, 8),
            )
          ],
          border: Border.all(
            color: isDark ? _kBorderColor : Colors.grey.shade200,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // COMPACT HEADER
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_kSidebarBg, _kSidebarBg.withOpacity(0.9)],
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'TEAM INSTRUCTION',
                      style: GoogleFonts.outfit(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded, color: Colors.white70, size: 18),
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ROW: Project Filter & Add Recipient
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildFormField(
                          label: 'PROJECT CONTEXT',
                          child: _buildDropdownWrapper(
                            isDark: isDark,
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String?>(
                                value: selectedProject.value,
                                isExpanded: true,
                                dropdownColor: isDark ? _kInputBg : Colors.white,
                                hint: Text('-- General --',
                                    style: GoogleFonts.inter(fontSize: 12)),
                                items: [
                                  DropdownMenuItem<String?>(
                                    value: null,
                                    child: Text('-- General --',
                                        style: GoogleFonts.inter(fontSize: 12)),
                                  ),
                                  ...projectsAsync.when(
                                    data: (projects) => projects.map((p) =>
                                        DropdownMenuItem(
                                            value: p.project.id,
                                            child: Text(p.project.name,
                                                style: GoogleFonts.inter(
                                                    fontSize: 12)))),
                                    loading: () => [],
                                    error: (_, __) => [],
                                  ),
                                ],
                                onChanged: (val) {
                                  selectedProject.value = val;
                                  selectedRecipients.value = [];
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildFormField(
                          label: 'ADD RECIPIENT',
                          child: _buildDropdownWrapper(
                            isDark: isDark,
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<User?>(
                                value: null,
                                isExpanded: true,
                                dropdownColor: isDark ? _kInputBg : Colors.white,
                                hint: Text('+ Add Member...',
                                    style: GoogleFonts.inter(
                                        fontSize: 12, color: _kPrimaryBlue)),
                                items: [
                                  DropdownMenuItem<User?>(
                                    value: null,
                                    child: Text('+ Add Member...',
                                        style: GoogleFonts.inter(fontSize: 12)),
                                  ),
                                  ...allUsersAsync.when(
                                    data: (users) => users
                                        .where((u) => !selectedRecipients.value
                                            .any((r) => r.id == u.id))
                                        .map((u) => DropdownMenuItem(
                                            value: u,
                                            child: Text(u.name,
                                                style: GoogleFonts.inter(
                                                    fontSize: 12)))),
                                    loading: () => [],
                                    error: (_, __) => [],
                                  ),
                                ],
                                onChanged: (User? user) {
                                  if (user != null) {
                                    selectedRecipients.value = [
                                      ...selectedRecipients.value,
                                      user
                                    ];
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // RECIPIENTS SECTION
                  _buildFormField(
                    label: 'RECIPIENTS LIST',
                    isRequired: true,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      constraints: const BoxConstraints(minHeight: 40, maxHeight: 80),
                      decoration: BoxDecoration(
                        color: isDark ? _kInputBg : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isDark ? _kBorderColor : Colors.grey.shade200,
                        ),
                      ),
                      child: selectedRecipients.value.isEmpty
                          ? Center(
                              child: Text(
                                'No recipients selected yet',
                                style: GoogleFonts.inter(
                                    color: Colors.grey.shade500,
                                    fontSize: 12),
                              ),
                            )
                          : SingleChildScrollView(
                              child: Wrap(
                                spacing: 6,
                                runSpacing: 6,
                                children: selectedRecipients.value.map((user) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? _kSidebarBg.withOpacity(0.3)
                                          : Colors.blue.shade50,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: isDark
                                            ? _kPrimaryBlue.withOpacity(0.3)
                                            : Colors.blue.shade100,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            user.name,
                                            style: GoogleFonts.inter(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                              color: isDark
                                                  ? Colors.white
                                                  : Colors.blue.shade900,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          GestureDetector(
                                            onTap: () {
                                              selectedRecipients.value =
                                                  selectedRecipients.value
                                                      .where((u) => u.id != user.id)
                                                      .toList();
                                            },
                                            child: Icon(
                                              Icons.close_rounded,
                                              size: 12,
                                              color: isDark
                                                  ? Colors.white54
                                                  : Colors.blue.shade400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // SUBJECT FIELD
                  _buildFormField(
                    label: 'SUBJECT / TITLE',
                    child: TextField(
                      controller: subjectController,
                      style: GoogleFonts.inter(fontSize: 13),
                      decoration: _buildInputDecoration(
                        isDark: isDark,
                        hint: 'e.g. Daily Operations Plan...',
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // INSTRUCTIONS FIELD
                  _buildFormField(
                    label: 'INSTRUCTIONS / DAY PLAN',
                    isRequired: true,
                    child: TextField(
                      controller: instructionsController,
                      maxLines: 3,
                      minLines: 3,
                      style: GoogleFonts.inter(fontSize: 13, height: 1.3),
                      decoration: _buildInputDecoration(
                        isDark: isDark,
                        hint: 'Detail the tasks and priorities...',
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // FOOTER ACTIONS
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F172A) : Colors.grey.shade50,
                border: Border(
                  top: BorderSide(
                    color: isDark ? _kBorderColor : Colors.grey.shade200,
                  ),
                ),
              ),
              child: Row(
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red.shade600,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    child: Text('Cancel',
                        style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w600, fontSize: 13)),
                  ),
                  const Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: canSubmit && !isSending.value
                          ? const LinearGradient(
                              colors: [_kPrimaryBlue, Color(0xFF2563EB)],
                            )
                          : null,
                      color: canSubmit && !isSending.value
                          ? null
                          : Colors.grey.withOpacity(0.1),
                    ),
                    child: ElevatedButton(
                      onPressed: canSubmit && !isSending.value
                          ? () async {
                              isSending.value = true;
                              try {
                                final request = CreateTeamInstructionRequest(
                                  project: selectedProjectId,
                                  recipients: selectedRecipients.value
                                      .map((u) => int.parse(u.id))
                                      .toList(),
                                  subject: subjectController.text,
                                  instructions: instructionsController.text,
                                );

                                await ref
                                    .read(instructionServiceProvider)
                                    .sendInstruction(request);

                                if (context.mounted) {
                                  Navigator.of(context).pop();
                                }
                              } catch (e) {
                                // Error handled by service
                              } finally {
                                isSending.value = false;
                              }
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isSending.value)
                            const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          else ...[
                            const Icon(Icons.rocket_launch_rounded, size: 14),
                            const SizedBox(width: 8),
                          ],
                          Text(
                            isSending.value
                                ? 'SENDING...'
                                : 'SEND INSTRUCTION (${selectedRecipients.value.length})',
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
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
      ),
    );
  }

  // --- REUSABLE PREMIUM UI HELPERS ---

  Widget _buildFormField({
    required String label,
    required Widget child,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: _kPrimaryBlue.withOpacity(0.8),
                letterSpacing: 0.5,
              ),
            ),
            if (isRequired)
              const Text(' *', style: TextStyle(color: Colors.red, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 10),
        child,
      ],
    );
  }

  Widget _buildDropdownWrapper({required bool isDark, required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? _kInputBg : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? _kBorderColor : Colors.grey.shade300,
        ),
      ),
      child: child,
    );
  }

  InputDecoration _buildInputDecoration({
    required bool isDark,
    required String hint,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.inter(
        color: isDark ? Colors.white24 : Colors.grey.shade400,
        fontSize: 13,
      ),
      filled: true,
      fillColor: isDark ? _kInputBg : Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isDark ? _kBorderColor : Colors.grey.shade300,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _kPrimaryBlue, width: 1.5),
      ),
    );
  }
}
