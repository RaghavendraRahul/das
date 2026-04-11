// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter();

  @override
  final Map<String, PageFactory> pagesMap = {
    AdminEmployeeViewRoute.name: (routeData) {
      final args = routeData.argsAs<AdminEmployeeViewRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: AdminEmployeeViewPage(
          key: args.key,
          employee: args.employee,
        ),
      );
    },
    ApprovalsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ApprovalsPage(),
      );
    },
    DashboardRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const DashboardPage(),
      );
    },
    ForgotPasswordRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ForgotPasswordPage(),
      );
    },
    LoginRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LoginPage(),
      );
    },
    NotificationsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const NotificationsPage(),
      );
    },
    ProjectContextRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ProjectContextPage(),
      );
    },
    ProjectDetailsRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ProjectDetailsRouteArgs>(
          orElse: () =>
              ProjectDetailsRouteArgs(projectId: pathParams.getString('id')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ProjectDetailsPage(
          key: args.key,
          projectId: args.projectId,
        ),
      );
    },
    ProjectGanttRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ProjectGanttPage(),
      );
    },
    ProjectGridRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ProjectGridPage(),
      );
    },
    ProjectOverviewRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ProjectOverviewPage(),
      );
    },
    ProjectPlanRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ProjectPlanPage(),
      );
    },
    ProjectReportsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ProjectReportsPage(),
      );
    },
    ProjectSettingsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ProjectSettingsPage(),
      );
    },
    ProjectsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ProjectsPage(),
      );
    },
    ProjectsPlaceholderRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ProjectsPlaceholderPage(),
      );
    },
    QuickNotesRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const QuickNotesPage(),
      );
    },
    ReportsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ReportsPage(),
      );
    },
    ResetPasswordRoute.name: (routeData) {
      final args = routeData.argsAs<ResetPasswordRouteArgs>(
          orElse: () => const ResetPasswordRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ResetPasswordPage(
          key: args.key,
          email: args.email,
        ),
      );
    },
    SettingsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SettingsPage(),
      );
    },
    ShellRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ShellPage(),
      );
    },
    SignupRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SignupPage(),
      );
    },
    StartupRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const StartupPage(),
      );
    },
    TasksPaginatedRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const TasksPaginatedPage(),
      );
    },
    TeamOverviewRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const TeamOverviewPage(),
      );
    },
    TodayRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const TodayPage(),
      );
    },
  };
}

/// generated route for
/// [AdminEmployeeViewPage]
class AdminEmployeeViewRoute extends PageRouteInfo<AdminEmployeeViewRouteArgs> {
  AdminEmployeeViewRoute({
    Key? key,
    required User employee,
    List<PageRouteInfo>? children,
  }) : super(
          AdminEmployeeViewRoute.name,
          args: AdminEmployeeViewRouteArgs(
            key: key,
            employee: employee,
          ),
          initialChildren: children,
        );

  static const String name = 'AdminEmployeeViewRoute';

  static const PageInfo<AdminEmployeeViewRouteArgs> page =
      PageInfo<AdminEmployeeViewRouteArgs>(name);
}

class AdminEmployeeViewRouteArgs {
  const AdminEmployeeViewRouteArgs({
    this.key,
    required this.employee,
  });

  final Key? key;

  final User employee;

  @override
  String toString() {
    return 'AdminEmployeeViewRouteArgs{key: $key, employee: $employee}';
  }
}

/// generated route for
/// [ApprovalsPage]
class ApprovalsRoute extends PageRouteInfo<void> {
  const ApprovalsRoute({List<PageRouteInfo>? children})
      : super(
          ApprovalsRoute.name,
          initialChildren: children,
        );

  static const String name = 'ApprovalsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [DashboardPage]
class DashboardRoute extends PageRouteInfo<void> {
  const DashboardRoute({List<PageRouteInfo>? children})
      : super(
          DashboardRoute.name,
          initialChildren: children,
        );

  static const String name = 'DashboardRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ForgotPasswordPage]
class ForgotPasswordRoute extends PageRouteInfo<void> {
  const ForgotPasswordRoute({List<PageRouteInfo>? children})
      : super(
          ForgotPasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'ForgotPasswordRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [LoginPage]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [NotificationsPage]
class NotificationsRoute extends PageRouteInfo<void> {
  const NotificationsRoute({List<PageRouteInfo>? children})
      : super(
          NotificationsRoute.name,
          initialChildren: children,
        );

  static const String name = 'NotificationsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ProjectContextPage]
class ProjectContextRoute extends PageRouteInfo<void> {
  const ProjectContextRoute({List<PageRouteInfo>? children})
      : super(
          ProjectContextRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProjectContextRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ProjectDetailsPage]
class ProjectDetailsRoute extends PageRouteInfo<ProjectDetailsRouteArgs> {
  ProjectDetailsRoute({
    Key? key,
    required String projectId,
    List<PageRouteInfo>? children,
  }) : super(
          ProjectDetailsRoute.name,
          args: ProjectDetailsRouteArgs(
            key: key,
            projectId: projectId,
          ),
          rawPathParams: {'id': projectId},
          initialChildren: children,
        );

  static const String name = 'ProjectDetailsRoute';

  static const PageInfo<ProjectDetailsRouteArgs> page =
      PageInfo<ProjectDetailsRouteArgs>(name);
}

class ProjectDetailsRouteArgs {
  const ProjectDetailsRouteArgs({
    this.key,
    required this.projectId,
  });

  final Key? key;

  final String projectId;

  @override
  String toString() {
    return 'ProjectDetailsRouteArgs{key: $key, projectId: $projectId}';
  }
}

/// generated route for
/// [ProjectGanttPage]
class ProjectGanttRoute extends PageRouteInfo<void> {
  const ProjectGanttRoute({List<PageRouteInfo>? children})
      : super(
          ProjectGanttRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProjectGanttRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ProjectGridPage]
class ProjectGridRoute extends PageRouteInfo<void> {
  const ProjectGridRoute({List<PageRouteInfo>? children})
      : super(
          ProjectGridRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProjectGridRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ProjectOverviewPage]
class ProjectOverviewRoute extends PageRouteInfo<void> {
  const ProjectOverviewRoute({List<PageRouteInfo>? children})
      : super(
          ProjectOverviewRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProjectOverviewRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ProjectPlanPage]
class ProjectPlanRoute extends PageRouteInfo<void> {
  const ProjectPlanRoute({List<PageRouteInfo>? children})
      : super(
          ProjectPlanRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProjectPlanRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ProjectReportsPage]
class ProjectReportsRoute extends PageRouteInfo<void> {
  const ProjectReportsRoute({List<PageRouteInfo>? children})
      : super(
          ProjectReportsRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProjectReportsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ProjectSettingsPage]
class ProjectSettingsRoute extends PageRouteInfo<void> {
  const ProjectSettingsRoute({List<PageRouteInfo>? children})
      : super(
          ProjectSettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProjectSettingsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ProjectsPage]
class ProjectsRoute extends PageRouteInfo<void> {
  const ProjectsRoute({List<PageRouteInfo>? children})
      : super(
          ProjectsRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProjectsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ProjectsPlaceholderPage]
class ProjectsPlaceholderRoute extends PageRouteInfo<void> {
  const ProjectsPlaceholderRoute({List<PageRouteInfo>? children})
      : super(
          ProjectsPlaceholderRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProjectsPlaceholderRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [QuickNotesPage]
class QuickNotesRoute extends PageRouteInfo<void> {
  const QuickNotesRoute({List<PageRouteInfo>? children})
      : super(
          QuickNotesRoute.name,
          initialChildren: children,
        );

  static const String name = 'QuickNotesRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ReportsPage]
class ReportsRoute extends PageRouteInfo<void> {
  const ReportsRoute({List<PageRouteInfo>? children})
      : super(
          ReportsRoute.name,
          initialChildren: children,
        );

  static const String name = 'ReportsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ResetPasswordPage]
class ResetPasswordRoute extends PageRouteInfo<ResetPasswordRouteArgs> {
  ResetPasswordRoute({
    Key? key,
    String? email,
    List<PageRouteInfo>? children,
  }) : super(
          ResetPasswordRoute.name,
          args: ResetPasswordRouteArgs(
            key: key,
            email: email,
          ),
          initialChildren: children,
        );

  static const String name = 'ResetPasswordRoute';

  static const PageInfo<ResetPasswordRouteArgs> page =
      PageInfo<ResetPasswordRouteArgs>(name);
}

class ResetPasswordRouteArgs {
  const ResetPasswordRouteArgs({
    this.key,
    this.email,
  });

  final Key? key;

  final String? email;

  @override
  String toString() {
    return 'ResetPasswordRouteArgs{key: $key, email: $email}';
  }
}

/// generated route for
/// [SettingsPage]
class SettingsRoute extends PageRouteInfo<void> {
  const SettingsRoute({List<PageRouteInfo>? children})
      : super(
          SettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ShellPage]
class ShellRoute extends PageRouteInfo<void> {
  const ShellRoute({List<PageRouteInfo>? children})
      : super(
          ShellRoute.name,
          initialChildren: children,
        );

  static const String name = 'ShellRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SignupPage]
class SignupRoute extends PageRouteInfo<void> {
  const SignupRoute({List<PageRouteInfo>? children})
      : super(
          SignupRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignupRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [StartupPage]
class StartupRoute extends PageRouteInfo<void> {
  const StartupRoute({List<PageRouteInfo>? children})
      : super(
          StartupRoute.name,
          initialChildren: children,
        );

  static const String name = 'StartupRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [TasksPaginatedPage]
class TasksPaginatedRoute extends PageRouteInfo<void> {
  const TasksPaginatedRoute({List<PageRouteInfo>? children})
      : super(
          TasksPaginatedRoute.name,
          initialChildren: children,
        );

  static const String name = 'TasksPaginatedRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [TeamOverviewPage]
class TeamOverviewRoute extends PageRouteInfo<void> {
  const TeamOverviewRoute({List<PageRouteInfo>? children})
      : super(
          TeamOverviewRoute.name,
          initialChildren: children,
        );

  static const String name = 'TeamOverviewRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [TodayPage]
class TodayRoute extends PageRouteInfo<void> {
  const TodayRoute({List<PageRouteInfo>? children})
      : super(
          TodayRoute.name,
          initialChildren: children,
        );

  static const String name = 'TodayRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
