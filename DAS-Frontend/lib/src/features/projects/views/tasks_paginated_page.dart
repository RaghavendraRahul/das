import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/pagination/pagination_controls.dart';
import '../providers/paginated_tasks_provider.dart';

@RoutePage()
class TasksPaginatedPage extends ConsumerStatefulWidget {
  const TasksPaginatedPage({super.key});

  @override
  ConsumerState<TasksPaginatedPage> createState() => _TasksPaginatedPageState();
}

class _TasksPaginatedPageState extends ConsumerState<TasksPaginatedPage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initial fetch
    Future.microtask(
        () => ref.read(paginatedTasksProvider.notifier).fetchPage(1));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch() {
    ref.read(paginatedTasksProvider.notifier).updateFilters({
      if (_searchController.text.isNotEmpty) 'search': _searchController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(paginatedTasksProvider);
    final controller = ref.read(paginatedTasksProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Tasks (Paginated)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.refresh,
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Search Tasks',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _onSearch(),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: _onSearch,
                  child: const Text('Filter'),
                ),
              ],
            ),
          ),

          // Error State
          if (state.error != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                color: Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Icon(Icons.error, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(child: Text(state.error!)),
                      TextButton(
                        onPressed: controller.refresh,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // List Content
          Expanded(
            child: state.isLoading && state.items.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : state.items.isEmpty && !state.isLoading
                    ? const Center(child: Text('No tasks found.'))
                    : ListView.builder(
                        itemCount: state.items.length,
                        itemBuilder: (context, index) {
                          final task = state.items[index];
                          return ListTile(
                            leading: CircleAvatar(
                              child: Text('${index + 1}'),
                            ),
                            title: Text(task.title),
                            subtitle: Text(
                                'Due: ${task.dueDate} • Priority: ${task.priority}'),
                            trailing: Chip(
                              label: Text(
                                task.status,
                                style: const TextStyle(fontSize: 10),
                              ),
                              backgroundColor: _getStatusColor(task.status),
                            ),
                          );
                        },
                      ),
          ),

          // Pagination Controls
          PaginationControls(
            currentPage: state.page,
            totalItems: state.totalItems,
            hasNext: state.hasNext,
            hasPrevious: state.hasPrevious,
            isLoading: state.isLoading,
            onNext: controller.nextPage,
            onPrevious: controller.previousPage,
            onPageSelected: (page) => controller.fetchPage(page),
            // Uses backend default page size (8) or customizable
            pageSize: 8,
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'DONE':
      case 'COMPLETED':
        return Colors.green.shade100;
      case 'IN_PROGRESS':
        return Colors.blue.shade100;
      case 'PENDING':
        return Colors.orange.shade100;
      default:
        return Colors.grey.shade200;
    }
  }
}
