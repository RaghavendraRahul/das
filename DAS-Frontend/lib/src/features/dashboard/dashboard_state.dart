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

// User & Project Selection for Statistics
final selectedStatsUserIdProvider = StateProvider<int?>((ref) => null);
final selectedStatsProjectIdProvider = StateProvider<int?>((ref) => null);
final selectedStatsPeriodProvider = StateProvider<String>((ref) => 'month');

// Header UI injection
final headerActionsProvider = StateProvider<Widget?>((ref) => null);
