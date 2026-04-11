import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:project_pm/src/core/database/database.dart';
import 'package:project_pm/src/features/projects/project_providers.dart';
import 'package:drift/drift.dart' as drift;
import 'package:uuid/uuid.dart';

class AddProjectWizard extends HookConsumerWidget {
  const AddProjectWizard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final nameController = useTextEditingController();
    final descriptionController = useTextEditingController();
    final isLoading = useState(false);
    final error = useState<String?>(null);

    Future<void> handleCreateProject() async {
      if (nameController.text.isEmpty) {
        error.value = 'Please provide a project name.';
        return;
      }

      isLoading.value = true;
      error.value = null;

      try {
        final projectId = const Uuid().v4();
        final newProject = ProjectsCompanion(
          id: drift.Value(projectId),
          name: drift.Value(nameController.text),
          context: drift.Value(descriptionController.text),
          status: const drift.Value('active'),
          approvalStatus: const drift.Value('pending'),
        );

        await ref.read(projectRepositoryProvider).createProject(newProject);

        if (context.mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Project "${nameController.text}" requested. Pending admin approval.'),
              backgroundColor: Colors.blue,
            ),
          );
        }
      } catch (e) {
        error.value = 'Failed to create project: $e';
      } finally {
        isLoading.value = false;
      }
    }

    return Dialog(
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1F2937) : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Create New Project',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Define the name and initial context for your new project.',
              style: TextStyle(color: Colors.grey.shade500),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Project Name',
                hintText: 'e.g., Q1 Marketing Campaign',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Project Description / Context',
                hintText: 'Define the scope and requirements here...',
                border: OutlineInputBorder(),
              ),
            ),
            if (error.value != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  error.value!,
                  style: TextStyle(color: Colors.red.shade400),
                ),
              ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: isLoading.value ? null : handleCreateProject,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  child: isLoading.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Create Project'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
