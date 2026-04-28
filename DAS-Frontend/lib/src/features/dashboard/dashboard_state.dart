import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Dashboard filter state providers
final dashboardProjectTypeProvider = StateProvider<String>((ref) => 'my');
final dashboardSearchQueryProvider = StateProvider<String>((ref) => '');
final dashboardDateRangeProvider = StateProvider<DateTimeRange?>((ref) => null);

// Global Search State
final globalSearchQueryProvider = StateProvider<String>((ref) => '');
final isSearchFocusedProvider = StateProvider<bool>((ref) => false);

// Project Working Report State
final workingReportScopeProvider = StateProvider<String>((ref) => 'My');
final workingReportViewProvider = StateProvider<String>((ref) => 'Projects');
final workingReportYearProvider = StateProvider<int>((ref) => DateTime.now().year);
final workingReportDetailMonthProvider = StateProvider<String?>((ref) => null);
final workingReportDrillDownTypeProvider = StateProvider<String>((ref) => 'Projects');

class ProjectAnalyticsState {
  final int? selectedUserId;
  final int? selectedProjectId;
  final int? selectedClientId;
  final String period;

  ProjectAnalyticsState({
    this.selectedUserId,
    this.selectedProjectId,
    this.selectedClientId,
    this.period = 'month',
  });

  ProjectAnalyticsState copyWith({
    int? Function()? selectedUserId,
    int? Function()? selectedProjectId,
    int? Function()? selectedClientId,
    String? period,
  }) {
    return ProjectAnalyticsState(
      selectedUserId: selectedUserId != null ? selectedUserId() : this.selectedUserId,
      selectedProjectId: selectedProjectId != null ? selectedProjectId() : this.selectedProjectId,
      selectedClientId: selectedClientId != null ? selectedClientId() : this.selectedClientId,
      period: period ?? this.period,
    );
  }
}

class ProjectAnalyticsController extends StateNotifier<ProjectAnalyticsState> {
  ProjectAnalyticsController() : super(ProjectAnalyticsState());

  void setClient(int? clientId) {
    if (state.selectedClientId == clientId) return;
    state = state.copyWith(
      selectedClientId: () => clientId,
      selectedProjectId: () => null,
      selectedUserId: () => null,
    );
  }

  void setProject(int? projectId) {
    if (state.selectedProjectId == projectId) return;
    state = state.copyWith(
      selectedProjectId: () => projectId,
      selectedUserId: () => null,
    );
  }

  void setUser(int? userId) {
    state = state.copyWith(selectedUserId: () => userId);
  }

  void setPeriod(String period) {
    state = state.copyWith(period: period);
  }
}

final projectAnalyticsControllerProvider =
    StateNotifierProvider<ProjectAnalyticsController, ProjectAnalyticsState>((ref) {
  return ProjectAnalyticsController();
});

// Header UI injection
final headerActionsProvider = StateProvider<Widget?>((ref) => null);
