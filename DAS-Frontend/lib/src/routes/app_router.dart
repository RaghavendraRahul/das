import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:project_pm/src/core/database/database.dart';
import 'package:project_pm/src/core/constants/enums.dart';

import 'package:project_pm/src/core/providers/user_providers.dart';

// import 'package:project_pm/src/features/admin/admin_user_management_page.dart'; // Removed
import 'package:project_pm/src/features/approvals/approvals_page.dart';
import 'package:project_pm/src/features/team/team_overview_page.dart';
import 'package:project_pm/src/features/team/admin_employee_view_page.dart';
import 'package:project_pm/src/features/today/today_page.dart';
import 'package:project_pm/src/features/startup/startup_page.dart';
import 'package:project_pm/src/features/dashboard/dashboard_page.dart';
import 'package:project_pm/src/features/shell/shell_page.dart';
import 'package:project_pm/src/features/reports/reports_page.dart';
import 'package:project_pm/src/features/settings/settings_page.dart';
import 'package:project_pm/src/features/shell/placeholder_views.dart';
import 'package:project_pm/src/features/projects/views/project_plan_page.dart';
import 'package:project_pm/src/features/projects/views/project_gantt_page.dart';
import 'package:project_pm/src/features/projects/views/project_grid_page.dart';
import 'package:project_pm/src/features/projects/views/project_context_page.dart';
import 'package:project_pm/src/features/projects/views/project_reports_page.dart';
// import 'package:project_pm/src/features/projects/views/project_settings_page.dart'; // Removed - settings page eliminated
import 'package:project_pm/src/features/projects/views/project_overview_page.dart';
import 'package:project_pm/src/features/auth/pages/login_page.dart';
import 'package:project_pm/src/features/auth/pages/signup_page.dart';
import 'package:project_pm/src/features/auth/pages/forgot_password_page.dart';
import 'package:project_pm/src/features/auth/pages/reset_password_page.dart';

import 'package:project_pm/src/features/quick_notes/quick_notes_page.dart';
import 'package:project_pm/src/features/projects/views/projects_page.dart';
import 'package:project_pm/src/features/notifications/views/notifications_page.dart';
import 'package:project_pm/src/features/projects/views/tasks_paginated_page.dart';

part 'app_router.gr.dart';

class RoleGuard extends AutoRouteGuard {
  final WidgetRef ref;
  RoleGuard(this.ref);

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final user = ref.read(currentUserProvider).valueOrNull;

    if (user != null) {
      final role = UserRole.fromString(user.role);
      if (role.isAdmin || role.isManager || role.isTeamLead) {
        resolver.next(true);
        return;
      }
    }

    // Redirect to dashboard if unauthorized
    router.push(const DashboardRoute());
    resolver.next(false);
  }
}

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  final WidgetRef ref;
  AppRouter(this.ref);

  @override
  List<AutoRoute> get routes => [
        // Startup is the initial route - navigates directly to dashboard (bypassing login for HRM SSO integration)
        AutoRoute(path: '/', page: StartupRoute.page, initial: true),
        AutoRoute(path: '/login', page: LoginRoute.page),
        AutoRoute(path: '/signup', page: SignupRoute.page),
        AutoRoute(path: '/forgot-password', page: ForgotPasswordRoute.page),
        AutoRoute(path: '/reset-password', page: ResetPasswordRoute.page),
        AutoRoute(path: '/app', page: ShellRoute.page, children: [
          AutoRoute(
              path: 'dashboard', page: DashboardRoute.page, initial: true),
          AutoRoute(path: 'today', page: TodayRoute.page),

          AutoRoute(path: 'projects', page: ProjectsRoute.page),
          AutoRoute(path: 'projects/overview', page: ProjectOverviewRoute.page),
          AutoRoute(path: 'projects/plan', page: ProjectPlanRoute.page),
          AutoRoute(path: 'projects/gantt', page: ProjectGanttRoute.page),
          AutoRoute(path: 'projects/grid', page: ProjectGridRoute.page),
          AutoRoute(path: 'projects/context', page: ProjectContextRoute.page),
          AutoRoute(path: 'projects/reports', page: ProjectReportsRoute.page),
          // AutoRoute(path: 'projects/settings', page: ProjectSettingsRoute.page), // Removed

          AutoRoute(path: 'quick-notes', page: QuickNotesRoute.page),

          AutoRoute(path: 'reports', page: ReportsRoute.page),
          AutoRoute(path: 'settings', page: SettingsRoute.page),
// AutoRoute(path: 'admin', page: AdminUserManagementRoute.page), // Removed
          AutoRoute(
              path: 'approvals',
              page: ApprovalsRoute.page,
              guards: [RoleGuard(ref)]),
          AutoRoute(
              path: 'team',
              page: TeamOverviewRoute.page,
              guards: [RoleGuard(ref)]),
          AutoRoute(
              path: 'team/employee-view',
              page: AdminEmployeeViewRoute.page,
              guards: [RoleGuard(ref)]),
          AutoRoute(path: 'notifications', page: NotificationsRoute.page),
        ]),
      ];

  @override
  List<AutoRouteGuard> get guards => [];
}

