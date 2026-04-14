import 'package:auto_route/auto_route.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:project_pm/src/core/database/database.dart';
import 'package:project_pm/src/core/models/project_with_tasks.dart';
import 'package:project_pm/src/features/projects/project_providers.dart';

class ProjectSettingsPage extends HookConsumerWidget {
  const ProjectSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectAsync = ref.watch(currentProjectProvider);

    return Scaffold(
      body: projectAsync.when(
        data: (project) {
          if (project == null) {
            return const Center(child: Text("Project not found"));
          }
          return _SettingsView(project: project);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

class _SettingsView extends HookConsumerWidget {
  final ProjectWithTasks project;
  const _SettingsView({required this.project});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = useTextEditingController(text: project.project.name);
    final contextController =
        useTextEditingController(text: project.project.context);
    final status = useState<String>(project.project.status.toLowerCase());
    final isLoading = useState(false);

    // Derived state for dirty check could be added here

    Future<void> save() async {
      isLoading.value = true;
      try {
        final updatedProject = ProjectsCompanion(
          id: drift.Value(project.project.id),
          name: drift.Value(nameController.text),
          context: drift.Value(contextController.text),
          status: drift.Value(status.value),
        );

        await ref.read(projectRepositoryProvider).updateProject(updatedProject);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Project settings updated successfully!"),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Failed to update project: $e"),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } finally {
        isLoading.value = false;
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.settings_outlined,
                  size: 28, color: Colors.blueGrey),
              const SizedBox(width: 12),
              Flexible(
                child: Consumer(
                  builder: (context, ref, _) {
                    final allProjectsAsync =
                        ref.watch(projectsWithTasksProvider);
                    final allProjects = allProjectsAsync.valueOrNull ?? [];

                    if (allProjects.length <= 1) {
                      return Text(
                        project.project.name.toUpperCase(),
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                        overflow: TextOverflow.ellipsis,
                      );
                    }

                    return DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: project.project.id,
                        isDense: true,
                        isExpanded: false,
                        icon: const Icon(Icons.keyboard_arrow_down, size: 24),
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.color,
                            ),
                        items: allProjects.map((p) {
                          return DropdownMenuItem<String>(
                            value: p.project.id,
                            child: Text(p.project.name.toUpperCase()),
                          );
                        }).toList(),
                        onChanged: (newId) {
                          if (newId != null) {
                            ref.read(selectedProjectIdProvider.notifier).state =
                                newId;
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // General Settings
          const Text("General Information",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),

          TextField(
            controller: nameController,
            decoration: const InputDecoration(
                labelText: "Project Name",
                border: OutlineInputBorder(),
                helperText: "The display name of the project"),
          ),
          const SizedBox(height: 24),

          TextField(
            controller: contextController,
            maxLines: 5,
            decoration: const InputDecoration(
                labelText: "Context / Description",
                border: OutlineInputBorder(),
                helperText:
                    "Markdown supported description of the project goals."),
          ),
          const SizedBox(height: 24),

          // Status Dropdown
          DropdownButtonFormField<String>(
            initialValue: status.value,
            decoration: const InputDecoration(
              labelText: "Project Status",
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: 'active', child: Text('Active')),
              DropdownMenuItem(value: 'completed', child: Text('Completed')),
              DropdownMenuItem(value: 'archived', child: Text('Archived')),
              DropdownMenuItem(value: 'on_hold', child: Text('On Hold')),
            ],
            onChanged: (val) {
              if (val != null) status.value = val;
            },
          ),

          const SizedBox(height: 48),

          Row(
            children: [
              FilledButton.icon(
                onPressed: isLoading.value ? null : save,
                icon: isLoading.value 
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.save),
                label: Text(isLoading.value ? "Saving..." : "Save Changes"),
              ),
              const SizedBox(width: 16),
              OutlinedButton(
                onPressed: () {
                  // Reset or navigation back logic
                },
                child: const Text("Cancel"),
              )
            ],
          ),

          const Divider(height: 64),

          // Danger Zone
          const Text("Danger Zone",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.red.shade200),
                borderRadius: BorderRadius.circular(8),
                color: Colors.red.shade50),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Archive Project",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                          "This will hide the project from the main dashboard but keep data intact."),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: isLoading.value ? null : () {
                    // Archive logic
                    status.value = 'archived';
                    save();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade100,
                      foregroundColor: Colors.red.shade900,
                      elevation: 0),
                  child: Text(isLoading.value && status.value == 'archived' ? "Archiving..." : "Archive"),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
