import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:project_pm/src/core/constants/enums.dart';
import 'package:project_pm/src/core/database/database.dart';

import 'package:project_pm/src/core/providers/user_providers.dart';
import 'package:project_pm/src/features/projects/project_providers.dart';
import 'package:project_pm/src/routes/app_router.dart';
import 'package:project_pm/src/shared/widgets/header.dart';
import 'package:project_pm/src/shared/widgets/sidebar.dart';
import 'package:project_pm/src/features/auth/auth_state_providers.dart';
import 'package:project_pm/src/features/projects/providers/approval_polling_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_pm/src/core/networking/api_client.dart';
import 'package:project_pm/src/features/projects/providers/api_providers.dart';
import 'package:project_pm/src/features/dashboard/dashboard_providers.dart';
import 'package:project_pm/src/features/quick_notes/notes_provider.dart';
import 'package:project_pm/src/features/today/today_repository.dart';

@RoutePage()
class ShellPage extends ConsumerWidget {
  const ShellPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch auth state to ensure session is restored
    final authStateAsync = ref.watch(authNotifierProvider);

    // Log auth state and errors
    if (authStateAsync.hasError) {
      debugPrint('🔴 [ShellPage] Auth Error: ${authStateAsync.error}');
      debugPrint('🔴 [ShellPage] Auth Stack: ${authStateAsync.stackTrace}');
    }
    if (authStateAsync.hasValue) {
      final authState = authStateAsync.value;
      debugPrint(
          '🔵 [ShellPage] Auth State - IsAuthenticated: ${authState?.isAuthenticated}, UserId: ${authState?.userId}');
    }

    // Watch user providers
    final currentUserAsync = ref.watch(currentUserProvider);

    final impersonatingFrom = ref.watch(impersonatingFromUserIdProvider);
    final isReadOnly = ref.watch(isReadOnlyProvider);

    // Start background approval polling for non-admin users
    ref.watch(approvalPollingProvider);

    // Watch the router to rebuild when route changes
    context.watchRouter;

    // Get current route path from URL to determine view mode
    final router = context.router;
    final urlState = router.urlState;
    final currentPath = urlState.path;

    // Map the URL path to the ViewMode
    final currentViewMode = _viewModeFromPath(currentPath);

    // Check if a project is selected
    final selectedProjectId = ref.watch(selectedProjectIdProvider);
    final isProjectSelected = selectedProjectId != null;

    // Dynamic Title Logic
    final projectAsync = ref.watch(currentProjectProvider);
    final currentProject = projectAsync.valueOrNull?.project;
    final titleInfo = _getTitleInfo(currentViewMode, currentProject);

    // 1. Check Auth State Loading
    if (authStateAsync.isLoading) {
      debugPrint('⏳ [ShellPage] Auth state is loading...');
      return _buildLoadingScreen(context);
    }

    // 2. Check Auth State Error or Not Authenticated
    if (authStateAsync.hasError ||
        !(authStateAsync.valueOrNull?.isAuthenticated ?? false)) {
      final isError = authStateAsync.hasError;
      final errorMsg = authStateAsync.error?.toString() ?? 'Unknown error';
      final isAuth = authStateAsync.valueOrNull?.isAuthenticated ?? false;
      debugPrint(
          '🔴 [ShellPage] NOT AUTHENTICATED - hasError: $isError, error: $errorMsg, isAuthenticated: $isAuth');

      // If we are on the ShellPage but not authenticated, we should probably redirect to login.
      // However, AutoRoute guards usually handle this. If we occupy this page, show a message.
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Session expired or invalid."),
              const SizedBox(height: 16),
              Text(
                'Debug: ${authStateAsync.hasError ? authStateAsync.error.toString() : "Not authenticated"}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  debugPrint('🔵 [ShellPage] User clicked "Go to Login"');
                  ref.read(authNotifierProvider.notifier).logout();
                  context.router.replaceAll([const LoginRoute()]);
                },
                child: const Text("Go to Login"),
              ),
            ],
          ),
        ),
      );
    }

    // 3. Authenticated - Check User Data
    return currentUserAsync.when(
      data: (currentUser) {
        if (currentUser == null) {
          // If auth is done but user is null, it means we have a session but no DB record.
          final userId = ref.watch(currentUserIdProvider);
          debugPrint(
              '⚠️ [ShellPage] Authenticated but currentUser is NULL. userId: $userId');

          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_off_rounded,
                      size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 24),
                  Text(
                    'Profile not found (ID: $userId)',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Your session may be invalid or you have no project access.',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: () {
                      debugPrint(
                          '🔵 [ShellPage] Manual logout from error screen');
                      ref.read(authNotifierProvider.notifier).logout();
                      context.router.replaceAll([const LoginRoute()]);
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text("Return to Login"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final screenWidth = MediaQuery.of(context).size.width;
        final isMobile = screenWidth < 768;

        // Sidebar widget reused for both desktop sidebar and mobile drawer
        Widget sidebarWidget() => Sidebar(
              currentUser: currentUser,
              viewMode: currentViewMode,
              isProjectSelected: isProjectSelected,
              onViewModeChange: (mode) {
                _navigateToViewMode(context, mode);
                if (isMobile) Navigator.of(context).pop(); // Close drawer
              },
            );

        return Scaffold(
          backgroundColor: Colors.transparent, // Ensures Scaffold background lets gradient show through
          // Drawer for mobile
          drawer: isMobile
              ? Drawer(
                  child: sidebarWidget(),
                )
              : null,
          body: Builder(
            builder: (scaffoldContext) => Stack(
              children: [
                // Global Background Gradient matches sidebar theme vibe
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: Theme.of(context).brightness == Brightness.dark
                          ? [const Color(0xFF0B1426), const Color(0xFF0F172A), const Color(0xFF1E293B)]
                          : [const Color(0xFFF4F7FB), const Color(0xFFE8F0F8), const Color(0xFFF4F7FB)],
                    ),
                  ),
                ),
                // Main layout
                Column(
                  children: [
                    // Impersonation Banner
                    if (impersonatingFrom != null)
                      _ImpersonationBannerLoader(
                        onExit: () async {
                          // Capture router before async gap to avoid
                          // use_build_context_synchronously warning.
                          final router = context.router;

                          // Clear SharedPreferences impersonation keys
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.remove('impersonate_user_id');
                          await prefs.remove('impersonate_user_name');

                          // Restore currentUserIdProvider back to original admin/manager
                          final originalId =
                              ref.read(impersonatingFromUserIdProvider);
                          if (originalId != null) {
                            ref.read(currentUserIdProvider.notifier).updateId(originalId);
                          }

                          // Clear impersonation state
                          ref
                              .read(impersonatingFromUserIdProvider.notifier)
                              .state = null;

                          // Invalidate the root Dio provider so that API calls are
                          // made without the impersonation header and admin's original
                          // data is fetched.
                          ref.invalidate(dioProvider);
                          ref.invalidate(taskApiServiceProvider);
                          ref.invalidate(dashboardApiProjectsProvider);
                          ref.invalidate(apiPaginatedProjectsProvider);
                          ref.invalidate(paginatedDashboardProjectsProvider);
                          ref.invalidate(filteredDashboardStatsProvider);
                          ref.invalidate(apiTasksProvider);
                          // Explicitly invalidate other major modules to ensure clean UI refresh
                          ref.invalidate(stickyNotesProvider);
                          ref.invalidate(todayRepositoryProvider);

                          // Navigate to Dashboard to reload original data
                          router.navigate(const DashboardRoute());
                        },
                      ),
                    // Main content
                    Expanded(
                      child: Row(
                        children: [
                          // Desktop sidebar
                          if (!isMobile) sidebarWidget(),
                          // Content area
                          Expanded(
                            child: Builder(builder: (context) {
                              // Role-based access check removed per request

                              return RepaintBoundary(
                                child: Center(
                                  child: ConstrainedBox(
                                    constraints:
                                        const BoxConstraints(maxWidth: 1600),
                                    child: Column(
                                      children: [
                                        AppHeader(
                                          title: titleInfo.key,
                                          subtitle: isReadOnly
                                              ? 'Viewing ${ref.watch(impersonatingUserNameFutureProvider).valueOrNull ?? "Employee"}\'s account (Read-only)'
                                              : titleInfo.value,
                                          customTitleWidget: (_isProjectSubPage(
                                                      currentViewMode) &&
                                                  currentProject != null)
                                              ? _AppBarProjectSelector(
                                                  project: currentProject,
                                                  isDark: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.dark,
                                                  isMobile: isMobile)
                                              : null,
                                          onMenuTap: isMobile
                                              ? () => Scaffold.of(scaffoldContext)
                                                  .openDrawer()
                                              : null,
                                        ),
                                        const Expanded(child: AutoRouter()),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Debug User Switcher (top-right) - REMOVED
              ],
            ),
          ),
        );
      },
      loading: () => _buildLoadingScreen(context),
      error: (e, __) => Scaffold(
        body: Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildLoadingScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Full Logo (No Clipping) - Exactly match StartupPage dimensions
            Container(
              height: 180,
              width: 300,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image.asset(
                  'assets/images/logo.jpeg',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 48),
            Text(
              'Welcome to DAS',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                    letterSpacing: 1.2,
                  ),
            ),
            const SizedBox(height: 60),
            const SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Navigate to the appropriate route based on ViewMode
  void _navigateToViewMode(BuildContext context, ViewMode mode) {
    final router = context.router;
    switch (mode) {
      case ViewMode.today:
        router.navigate(const TodayRoute());
        break;
      case ViewMode.dashboard:
        router.navigate(const DashboardRoute());
        break;
      case ViewMode.projects:
        // Navigate to the projects list/grid
        router.navigate(const ProjectsRoute());
        break;
      case ViewMode.quickNotes:
        router.navigate(const QuickNotesRoute());
        break;
      case ViewMode.projectOverview:
        router.navigate(const ProjectOverviewRoute());
        break;
      case ViewMode.plan:
        router.navigate(const ProjectPlanRoute());
        break;
      case ViewMode.gantt:
        router.navigate(const ProjectGanttRoute());
        break;
      case ViewMode.grid:
        router.navigate(const ProjectGridRoute());
        break;
// case ViewMode.adminPanel:
//   router.navigate(const AdminUserManagementRoute());
//   break;
      case ViewMode.approvals:
        router.navigate(const ApprovalsRoute());
        break;
      case ViewMode.teamOverview:
        router.navigate(const TeamOverviewRoute());
        break;
    }
  }

  // Map URL path to ViewMode
  ViewMode _viewModeFromPath(String path) {
    // Paths in AutoRoute urlState are usually full paths, e.g. "/app/today"

    if (path.contains('/dashboard')) {
      return ViewMode.dashboard;
    } else if (path.contains('/quick-notes')) {
      return ViewMode.quickNotes;
    } else if (path.contains('/today')) {
      return ViewMode.today;
    } else if (path.contains('/projects/overview')) {
      return ViewMode.projectOverview;
    } else if (path.contains('/projects/plan')) {
      return ViewMode.plan;
    } else if (path.contains('/projects/gantt')) {
      return ViewMode.gantt;
    } else if (path.contains('/projects/grid')) {
      return ViewMode.grid;
    } else if (path.contains('/team')) {
      return ViewMode.teamOverview;
    } else if (path.contains('/approvals')) {
      return ViewMode.approvals;
// } else if (path.contains('/admin')) {
//   return ViewMode.dashboard; // Redirect to dashboard instead of admin
    } else if (path.contains('/projects')) {
      // Fallback for any other projects path
      return ViewMode.projects;
    }

    // Default fallback
    return ViewMode.dashboard;
  }

  bool _isProjectSubPage(ViewMode mode) {
    return mode == ViewMode.plan ||
        mode == ViewMode.gantt ||
        mode == ViewMode.grid;
  }

  MapEntry<String, String> _getTitleInfo(ViewMode mode, Project? project) {
    // Subtitles mapping
    String subtitle;

    // Custom logic for project views where we want project details in appbar
    if (_isProjectSubPage(mode) && project != null) {
      final desc = project.context.toString();
      return MapEntry(
          project.name, desc.isNotEmpty ? 'Description: $desc' : '');
    }

    switch (mode) {
      case ViewMode.today:
        subtitle = ""; // Removed per user request
        break;
      case ViewMode.dashboard:
        subtitle = ""; // Removed per user request
        break;
      case ViewMode.projects:
        subtitle = "";
        break;
      case ViewMode.projectOverview:
        subtitle = "Detailed project metrics and details.";
        break;
      case ViewMode.quickNotes:
        subtitle = "Capture ideas and reminders.";
        break;
      case ViewMode.grid:
        subtitle = "Manage tasks in a grid view.";
        break;
      case ViewMode.plan:
        subtitle = ""; // Removed per user request
        break;
      case ViewMode.gantt:
        subtitle = "Visual timeline of your project.";
        break;
// case ViewMode.adminPanel:
//   subtitle = "Manage users and permissions.";
//   break;
      case ViewMode.approvals:
        subtitle = "Review and approve requests.";
        break;
      case ViewMode.teamOverview:
        subtitle = "See what everyone is working on.";
        break;
    }

    return MapEntry(mode.label, subtitle);
  }
}

/// Impersonation banner that async-loads the employee name from SharedPreferences.
/// This avoids needing to pass the name through provider state.
class _ImpersonationBannerLoader extends StatefulWidget {
  final VoidCallback onExit;

  const _ImpersonationBannerLoader({required this.onExit});

  @override
  State<_ImpersonationBannerLoader> createState() =>
      _ImpersonationBannerLoaderState();
}

class _ImpersonationBannerLoaderState
    extends State<_ImpersonationBannerLoader> {
  String _userName = 'User';

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('impersonate_user_name');
    if (name != null && mounted) {
      setState(() => _userName = name);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF312E81) : const Color(0xFF4F46E5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(30),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "Viewing $_userName's account. Read-only mode.",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: widget.onExit,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF4F46E5),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              'Exit & Return',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _AppBarProjectSelector extends ConsumerWidget {
  final dynamic project;
  final bool isDark;
  final bool isMobile;

  const _AppBarProjectSelector({
    required this.project,
    required this.isDark,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allProjectsAsync = ref.watch(projectsWithTasksProvider);
    final allProjects = allProjectsAsync.valueOrNull ?? [];

    if (allProjects.length <= 1) {
      return Text(
        "PROJECT: ${project.name.toUpperCase()}",
        style: TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: isMobile ? 16 : 18,
          letterSpacing: -0.5,
          color: isDark ? Colors.white : Colors.black87,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
            color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "PROJECT:",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isMobile ? 11 : 12,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: project.id,
                isDense: true,
                icon: Icon(Icons.arrow_drop_down,
                    size: 24,
                    color:
                        isDark ? Colors.grey.shade400 : Colors.blue.shade700),
                dropdownColor: isDark ? const Color(0xFF1F2937) : Colors.white,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: isMobile ? 16 : 18,
                  letterSpacing: -0.5,
                  color: isDark ? Colors.white : Colors.black87,
                ),
                items: allProjects
                    .map((p) => DropdownMenuItem<String>(
                          value: p.project.id,
                          child: Text(
                            p.project.name.toUpperCase(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ))
                    .toList(),
                onChanged: (newId) {
                  if (newId != null) {
                    ref.read(selectedProjectIdProvider.notifier).state = newId;
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
