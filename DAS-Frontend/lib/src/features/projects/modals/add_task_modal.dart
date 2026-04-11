import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:project_pm/src/core/database/database.dart';
import 'package:project_pm/src/features/projects/project_providers.dart';
import 'package:drift/drift.dart' as drift;
import 'package:uuid/uuid.dart';

class AddTaskModal extends HookConsumerWidget {
  final String projectId;

  const AddTaskModal({super.key, required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = useTextEditingController();
    final priorityController = useTextEditingController(text: 'Medium');

    return AlertDialog(
      title: const Text('New Task'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Task Name')),
          // Simple text for priority for now, dropdown ideally
          TextField(
              controller: priorityController,
              decoration: const InputDecoration(labelText: 'Priority')),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel')),
        FilledButton(
          onPressed: () async {
            // For MVP, handling dates and other fields simply
            final newTask = TasksCompanion(
              id: drift.Value(const Uuid().v4()),
              projectId: drift.Value(projectId),
              name: drift.Value(nameController.text),
              priority: drift.Value(priorityController.text),
              startDate: drift.Value(DateTime.now()),
              endDate: drift.Value(DateTime.now().add(const Duration(days: 7))),
              progress: const drift.Value(0),
              assigneesJson: const drift.Value('[]'),
              milestonesJson: const drift.Value('[]'),
              approvalStatus: const drift.Value('pending_creation'),
            );
            await ref.read(projectRepositoryProvider).createTask(newTask);
            if (context.mounted) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'Task "${nameController.text}" requested. Pending admin approval.'),
                  backgroundColor: Colors.blue,
                ),
              );
            }
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}
