import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_pm/src/core/providers/user_providers.dart';
import 'package:project_pm/src/features/projects/providers/api_providers.dart';
import 'package:project_pm/src/features/projects/project_providers.dart';

/// Polls every 20 seconds for non-admin users to detect when admin has
/// approved or rejected their pending requests (project/task creation &
/// completion). This keeps button states (Pending → Completed / reverted)
/// in sync without WebSockets.
///
/// Mount once in ShellPage via `ref.watch(approvalPollingProvider)`.
/// The provider auto-disposes when the shell is torn down.
final approvalPollingProvider = Provider.autoDispose<void>((ref) {
  // Only poll for non-admin authenticated users
  final currentUser = ref.watch(currentUserProvider).valueOrNull;
  if (currentUser == null || currentUser.role == 'ADMIN') return;

  // Keep alive while the shell is mounted
  final link = ref.keepAlive();

  // Increased interval from 20s to 120s (2 mins) now that WebSockets provide real-time updates.
  final timer = Timer.periodic(const Duration(seconds: 120), (_) {
    // Refresh the providers that drive button states and card displays.
    // These are the same providers invalidated after manual user actions.
    ref.invalidate(paginatedDashboardProjectsProvider);
    ref.invalidate(apiTasksProvider);
    ref.invalidate(projectsWithTasksProvider);
    ref.invalidate(currentProjectProvider);
  });

  ref.onDispose(() {
    timer.cancel();
    link.close();
  });
});
