import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:project_pm/src/features/projects/project_providers.dart';
import 'package:project_pm/src/core/models/project_with_tasks.dart';

@RoutePage()
class ProjectContextPage extends HookConsumerWidget {
  const ProjectContextPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectAsync = ref.watch(currentProjectProvider);

    return projectAsync.when(
      data: (data) {
        if (data == null) {
          return const Scaffold(body: Center(child: Text("Project not found")));
        }
        return _ProjectContextView(project: data);
      },
      error: (err, st) => Scaffold(body: Center(child: Text("Error: $err"))),
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}

class _ProjectContextView extends HookConsumerWidget {
  final ProjectWithTasks project;
  const _ProjectContextView({required this.project});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditing = useState(false);
    final isLoading = useState(false);
    final contextController =
        useTextEditingController(text: project.project.context);

    // Sync controller if project updates externally
    useEffect(() {
      if (!isEditing.value &&
          contextController.text != project.project.context) {
        contextController.text = project.project.context;
      }
      return null;
    }, [project.project.context]);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.description_outlined,
                              size: 24, color: Colors.indigo),
                          const SizedBox(width: 10),
                          Flexible(
                            child: Consumer(
                              builder: (context, ref, _) {
                                final allProjectsAsync =
                                    ref.watch(projectsWithTasksProvider);
                                final allProjects =
                                    allProjectsAsync.valueOrNull ?? [];

                                if (allProjects.length <= 1) {
                                  return Text(
                                    project.project.name.toUpperCase(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 18,
                                      letterSpacing: 0.5,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  );
                                }

                                return DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: project.project.id,
                                    isDense: true,
                                    isExpanded: false,
                                    icon: const Icon(Icons.keyboard_arrow_down,
                                        size: 20),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 18,
                                      letterSpacing: 0.5,
                                      color: Colors.black87,
                                    ),
                                    items: allProjects.map((p) {
                                      return DropdownMenuItem<String>(
                                        value: p.project.id,
                                        child:
                                            Text(p.project.name.toUpperCase()),
                                      );
                                    }).toList(),
                                    onChanged: (newId) {
                                      if (newId != null) {
                                        ref
                                            .read(selectedProjectIdProvider
                                                .notifier)
                                            .state = newId;
                                      }
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                          "Define the project scope and requirements. The AI uses this context to generate relevant tasks and milestones.",
                          style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
                Row(
                  children: [
                    if (isEditing.value)
                      ElevatedButton(
                        onPressed: isLoading.value ? null : () async {
                          isLoading.value = true;
                          try {
                            await ref.read(projectRepositoryProvider).updateProjectContext(
                                  project.project.id, contextController.text);
                            isEditing.value = false;
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Project context updated successfully!"),
                                  backgroundColor: Colors.green,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Failed to update context: $e"),
                                  backgroundColor: Colors.red,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          } finally {
                            isLoading.value = false;
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white),
                        child: isLoading.value 
                          ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Text("Save"),
                      )
                    else
                      OutlinedButton(
                        onPressed: () => isEditing.value = true,
                        child: const Text("Edit"),
                      )
                  ],
                )
              ],
            ),
            const Divider(height: 32),
            Expanded(
                child: isEditing.value
                    ? TextField(
                        controller: contextController,
                        maxLines: null,
                        expands: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Enter markdown context here...",
                        ),
                        style: const TextStyle(
                            fontFamily: 'Courier', fontSize: 14),
                      )
                    : SingleChildScrollView(
                        child: MarkdownBody(data: contextController.text),
                      ))
          ],
        ),
      ),
    );
  }
}
