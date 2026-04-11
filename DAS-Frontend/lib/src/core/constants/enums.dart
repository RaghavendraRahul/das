enum ViewMode {
  today,
  dashboard,
  projectOverview,
  gantt,
  grid,
  plan,
// adminPanel, // Removed
  projects,
  quickNotes,
  teamOverview,
  approvals;

  String get label {
    switch (this) {
      case ViewMode.today:
        return 'Planner';
      case ViewMode.dashboard:
        return 'Dashboard';
      case ViewMode.projects:
        return 'Projects';
      case ViewMode.quickNotes:
        return 'Quick Notes';
      case ViewMode.projectOverview:
        return 'Project Overview';
      case ViewMode.gantt:
        return 'Timeline (Gantt)';
      case ViewMode.grid:
        return 'Grid View';
      case ViewMode.plan:
        return 'Tasks & Plan';
// adminPanel, // Removed
      case ViewMode.teamOverview:
        return 'Team Overview';
      case ViewMode.approvals:
        return 'Approvals';
    }
  }
}

enum UserRole {
  admin,
  manager,
  teamLead,
  employee;

  bool get isAdmin => this == UserRole.admin;
  bool get isManager => this == UserRole.manager;
  bool get isTeamLead => this == UserRole.teamLead;
  bool get isEmployee => this == UserRole.employee;

  String get label {
    switch (this) {
      case UserRole.admin:
        return 'ADMIN';
      case UserRole.manager:
        return 'MANAGER';
      case UserRole.teamLead:
        return 'TEAM LEAD';
      case UserRole.employee:
        return 'EMPLOYEE';
    }
  }

  // Helper to parse from string (e.g. from DB)
  static UserRole fromString(String role) {
    return UserRole.values.firstWhere(
      (e) => e.name.toLowerCase() == role.toLowerCase().replaceAll('_', ''),
      orElse: () => UserRole.employee, // Default
    );
  }
}
