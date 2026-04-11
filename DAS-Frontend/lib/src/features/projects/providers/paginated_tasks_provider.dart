import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/pagination/pagination_controller.dart';
import '../models/task_model.dart';
import 'api_providers.dart';

final paginatedTasksProvider = StateNotifierProvider.autoDispose<
    PaginationController<TaskModel>, PaginationState<TaskModel>>((ref) {
  final apiService = ref.watch(taskApiServiceProvider);

  // Initialize with optional default filters if needed
  return PaginationController(
      (page, params) => apiService.getPaginatedTasks(page, params));
});
