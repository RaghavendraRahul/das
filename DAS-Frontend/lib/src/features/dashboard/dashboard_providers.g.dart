// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dashboardRepositoryHash() =>
    r'f8fa37babca8b659520fd64b5ce477373a599e52';

/// See also [dashboardRepository].
@ProviderFor(dashboardRepository)
final dashboardRepositoryProvider =
    AutoDisposeProvider<DashboardRepository>.internal(
  dashboardRepository,
  name: r'dashboardRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dashboardRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef DashboardRepositoryRef = AutoDisposeProviderRef<DashboardRepository>;
String _$dashboardProjectsHash() => r'424dc55c857e267c3b6dba91967607fb77d45fa3';

/// See also [dashboardProjects].
@ProviderFor(dashboardProjects)
final dashboardProjectsProvider =
    AutoDisposeFutureProvider<List<ProjectWithTasks>>.internal(
  dashboardProjects,
  name: r'dashboardProjectsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dashboardProjectsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef DashboardProjectsRef
    = AutoDisposeFutureProviderRef<List<ProjectWithTasks>>;
String _$filteredDashboardStatsHash() =>
    r'3b61f5612cf6fc30ecaddd64c2ca07107a2f920c';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Provider to fetch ALL projects with filter (for dashboard stats)
/// This ensures stats reflect the entire dataset, not just the current page
///
/// Copied from [filteredDashboardStats].
@ProviderFor(filteredDashboardStats)
const filteredDashboardStatsProvider = FilteredDashboardStatsFamily();

/// Provider to fetch ALL projects with filter (for dashboard stats)
/// This ensures stats reflect the entire dataset, not just the current page
///
/// Copied from [filteredDashboardStats].
class FilteredDashboardStatsFamily
    extends Family<AsyncValue<List<ProjectWithTasks>>> {
  /// Provider to fetch ALL projects with filter (for dashboard stats)
  /// This ensures stats reflect the entire dataset, not just the current page
  ///
  /// Copied from [filteredDashboardStats].
  const FilteredDashboardStatsFamily();

  /// Provider to fetch ALL projects with filter (for dashboard stats)
  /// This ensures stats reflect the entire dataset, not just the current page
  ///
  /// Copied from [filteredDashboardStats].
  FilteredDashboardStatsProvider call({
    required String filter,
  }) {
    return FilteredDashboardStatsProvider(
      filter: filter,
    );
  }

  @override
  FilteredDashboardStatsProvider getProviderOverride(
    covariant FilteredDashboardStatsProvider provider,
  ) {
    return call(
      filter: provider.filter,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'filteredDashboardStatsProvider';
}

/// Provider to fetch ALL projects with filter (for dashboard stats)
/// This ensures stats reflect the entire dataset, not just the current page
///
/// Copied from [filteredDashboardStats].
class FilteredDashboardStatsProvider
    extends AutoDisposeFutureProvider<List<ProjectWithTasks>> {
  /// Provider to fetch ALL projects with filter (for dashboard stats)
  /// This ensures stats reflect the entire dataset, not just the current page
  ///
  /// Copied from [filteredDashboardStats].
  FilteredDashboardStatsProvider({
    required String filter,
  }) : this._internal(
          (ref) => filteredDashboardStats(
            ref as FilteredDashboardStatsRef,
            filter: filter,
          ),
          from: filteredDashboardStatsProvider,
          name: r'filteredDashboardStatsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$filteredDashboardStatsHash,
          dependencies: FilteredDashboardStatsFamily._dependencies,
          allTransitiveDependencies:
              FilteredDashboardStatsFamily._allTransitiveDependencies,
          filter: filter,
        );

  FilteredDashboardStatsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.filter,
  }) : super.internal();

  final String filter;

  @override
  Override overrideWith(
    FutureOr<List<ProjectWithTasks>> Function(
            FilteredDashboardStatsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FilteredDashboardStatsProvider._internal(
        (ref) => create(ref as FilteredDashboardStatsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        filter: filter,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<ProjectWithTasks>> createElement() {
    return _FilteredDashboardStatsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FilteredDashboardStatsProvider && other.filter == filter;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, filter.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FilteredDashboardStatsRef
    on AutoDisposeFutureProviderRef<List<ProjectWithTasks>> {
  /// The parameter `filter` of this provider.
  String get filter;
}

class _FilteredDashboardStatsProviderElement
    extends AutoDisposeFutureProviderElement<List<ProjectWithTasks>>
    with FilteredDashboardStatsRef {
  _FilteredDashboardStatsProviderElement(super.provider);

  @override
  String get filter => (origin as FilteredDashboardStatsProvider).filter;
}

String _$usersForStatsHash() => r'd095821330473d9f1dc133c588d75e247ce00fdf';

/// Provider for fetching users list for stats dropdown
///
/// Copied from [usersForStats].
@ProviderFor(usersForStats)
final usersForStatsProvider = AutoDisposeFutureProvider<List<dynamic>>.internal(
  usersForStats,
  name: r'usersForStatsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$usersForStatsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UsersForStatsRef = AutoDisposeFutureProviderRef<List<dynamic>>;
String _$projectWorkStatsHash() => r'40b28a7b2650a25908d3842a2dea3e305ed0b09f';

/// Provider for fetching project work statistics
///
/// Copied from [projectWorkStats].
@ProviderFor(projectWorkStats)
final projectWorkStatsProvider =
    AutoDisposeFutureProvider<Map<String, dynamic>>.internal(
  projectWorkStats,
  name: r'projectWorkStatsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$projectWorkStatsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ProjectWorkStatsRef
    = AutoDisposeFutureProviderRef<Map<String, dynamic>>;
String _$statsProjectsHash() => r'263714a8c1710579e7731feb606267747abf372c';

/// Provider for fetching user-specific projects for the stats dropdown
///
/// Copied from [statsProjects].
@ProviderFor(statsProjects)
final statsProjectsProvider = AutoDisposeFutureProvider<List<dynamic>>.internal(
  statsProjects,
  name: r'statsProjectsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$statsProjectsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef StatsProjectsRef = AutoDisposeFutureProviderRef<List<dynamic>>;
String _$projectCompletionChartHash() =>
    r'f434b6bf032a299754791b956660e840f923b4bf';

/// See also [projectCompletionChart].
@ProviderFor(projectCompletionChart)
const projectCompletionChartProvider = ProjectCompletionChartFamily();

/// See also [projectCompletionChart].
class ProjectCompletionChartFamily
    extends Family<AsyncValue<Map<String, dynamic>>> {
  /// See also [projectCompletionChart].
  const ProjectCompletionChartFamily();

  /// See also [projectCompletionChart].
  ProjectCompletionChartProvider call(
    ProjectChartParams params,
  ) {
    return ProjectCompletionChartProvider(
      params,
    );
  }

  @override
  ProjectCompletionChartProvider getProviderOverride(
    covariant ProjectCompletionChartProvider provider,
  ) {
    return call(
      provider.params,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'projectCompletionChartProvider';
}

/// See also [projectCompletionChart].
class ProjectCompletionChartProvider
    extends AutoDisposeFutureProvider<Map<String, dynamic>> {
  /// See also [projectCompletionChart].
  ProjectCompletionChartProvider(
    ProjectChartParams params,
  ) : this._internal(
          (ref) => projectCompletionChart(
            ref as ProjectCompletionChartRef,
            params,
          ),
          from: projectCompletionChartProvider,
          name: r'projectCompletionChartProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$projectCompletionChartHash,
          dependencies: ProjectCompletionChartFamily._dependencies,
          allTransitiveDependencies:
              ProjectCompletionChartFamily._allTransitiveDependencies,
          params: params,
        );

  ProjectCompletionChartProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.params,
  }) : super.internal();

  final ProjectChartParams params;

  @override
  Override overrideWith(
    FutureOr<Map<String, dynamic>> Function(ProjectCompletionChartRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProjectCompletionChartProvider._internal(
        (ref) => create(ref as ProjectCompletionChartRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        params: params,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Map<String, dynamic>> createElement() {
    return _ProjectCompletionChartProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProjectCompletionChartProvider && other.params == params;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, params.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ProjectCompletionChartRef
    on AutoDisposeFutureProviderRef<Map<String, dynamic>> {
  /// The parameter `params` of this provider.
  ProjectChartParams get params;
}

class _ProjectCompletionChartProviderElement
    extends AutoDisposeFutureProviderElement<Map<String, dynamic>>
    with ProjectCompletionChartRef {
  _ProjectCompletionChartProviderElement(super.provider);

  @override
  ProjectChartParams get params =>
      (origin as ProjectCompletionChartProvider).params;
}

String _$taskCompletionChartHash() =>
    r'71b52cec21c721e5f0541053dd0aa2014187189c';

/// See also [taskCompletionChart].
@ProviderFor(taskCompletionChart)
const taskCompletionChartProvider = TaskCompletionChartFamily();

/// See also [taskCompletionChart].
class TaskCompletionChartFamily
    extends Family<AsyncValue<Map<String, dynamic>>> {
  /// See also [taskCompletionChart].
  const TaskCompletionChartFamily();

  /// See also [taskCompletionChart].
  TaskCompletionChartProvider call(
    TaskChartParams params,
  ) {
    return TaskCompletionChartProvider(
      params,
    );
  }

  @override
  TaskCompletionChartProvider getProviderOverride(
    covariant TaskCompletionChartProvider provider,
  ) {
    return call(
      provider.params,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'taskCompletionChartProvider';
}

/// See also [taskCompletionChart].
class TaskCompletionChartProvider
    extends AutoDisposeFutureProvider<Map<String, dynamic>> {
  /// See also [taskCompletionChart].
  TaskCompletionChartProvider(
    TaskChartParams params,
  ) : this._internal(
          (ref) => taskCompletionChart(
            ref as TaskCompletionChartRef,
            params,
          ),
          from: taskCompletionChartProvider,
          name: r'taskCompletionChartProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$taskCompletionChartHash,
          dependencies: TaskCompletionChartFamily._dependencies,
          allTransitiveDependencies:
              TaskCompletionChartFamily._allTransitiveDependencies,
          params: params,
        );

  TaskCompletionChartProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.params,
  }) : super.internal();

  final TaskChartParams params;

  @override
  Override overrideWith(
    FutureOr<Map<String, dynamic>> Function(TaskCompletionChartRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TaskCompletionChartProvider._internal(
        (ref) => create(ref as TaskCompletionChartRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        params: params,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Map<String, dynamic>> createElement() {
    return _TaskCompletionChartProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TaskCompletionChartProvider && other.params == params;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, params.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin TaskCompletionChartRef
    on AutoDisposeFutureProviderRef<Map<String, dynamic>> {
  /// The parameter `params` of this provider.
  TaskChartParams get params;
}

class _TaskCompletionChartProviderElement
    extends AutoDisposeFutureProviderElement<Map<String, dynamic>>
    with TaskCompletionChartRef {
  _TaskCompletionChartProviderElement(super.provider);

  @override
  TaskChartParams get params => (origin as TaskCompletionChartProvider).params;
}

String _$hoursCompletionChartHash() =>
    r'51079cecb07a208565fe45414d7f08f3728613dc';

/// See also [hoursCompletionChart].
@ProviderFor(hoursCompletionChart)
const hoursCompletionChartProvider = HoursCompletionChartFamily();

/// See also [hoursCompletionChart].
class HoursCompletionChartFamily extends Family<AsyncValue<List<dynamic>>> {
  /// See also [hoursCompletionChart].
  const HoursCompletionChartFamily();

  /// See also [hoursCompletionChart].
  HoursCompletionChartProvider call(
    ProjectChartParams params,
  ) {
    return HoursCompletionChartProvider(
      params,
    );
  }

  @override
  HoursCompletionChartProvider getProviderOverride(
    covariant HoursCompletionChartProvider provider,
  ) {
    return call(
      provider.params,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'hoursCompletionChartProvider';
}

/// See also [hoursCompletionChart].
class HoursCompletionChartProvider
    extends AutoDisposeFutureProvider<List<dynamic>> {
  /// See also [hoursCompletionChart].
  HoursCompletionChartProvider(
    ProjectChartParams params,
  ) : this._internal(
          (ref) => hoursCompletionChart(
            ref as HoursCompletionChartRef,
            params,
          ),
          from: hoursCompletionChartProvider,
          name: r'hoursCompletionChartProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$hoursCompletionChartHash,
          dependencies: HoursCompletionChartFamily._dependencies,
          allTransitiveDependencies:
              HoursCompletionChartFamily._allTransitiveDependencies,
          params: params,
        );

  HoursCompletionChartProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.params,
  }) : super.internal();

  final ProjectChartParams params;

  @override
  Override overrideWith(
    FutureOr<List<dynamic>> Function(HoursCompletionChartRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: HoursCompletionChartProvider._internal(
        (ref) => create(ref as HoursCompletionChartRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        params: params,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<dynamic>> createElement() {
    return _HoursCompletionChartProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HoursCompletionChartProvider && other.params == params;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, params.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin HoursCompletionChartRef on AutoDisposeFutureProviderRef<List<dynamic>> {
  /// The parameter `params` of this provider.
  ProjectChartParams get params;
}

class _HoursCompletionChartProviderElement
    extends AutoDisposeFutureProviderElement<List<dynamic>>
    with HoursCompletionChartRef {
  _HoursCompletionChartProviderElement(super.provider);

  @override
  ProjectChartParams get params =>
      (origin as HoursCompletionChartProvider).params;
}

String _$dashboardServiceHash() => r'da21473931a480e0ac60a906d9fe0175470d5b61';

/// See also [dashboardService].
@ProviderFor(dashboardService)
final dashboardServiceProvider = AutoDisposeProvider<DashboardService>.internal(
  dashboardService,
  name: r'dashboardServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dashboardServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef DashboardServiceRef = AutoDisposeProviderRef<DashboardService>;
String _$dashboardMetricsHash() => r'cadaf34c29d044f0a9f35c5b86c280a82d863c3b';

/// See also [dashboardMetrics].
@ProviderFor(dashboardMetrics)
final dashboardMetricsProvider =
    AutoDisposeFutureProvider<DashboardMetrics>.internal(
  dashboardMetrics,
  name: r'dashboardMetricsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dashboardMetricsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef DashboardMetricsRef = AutoDisposeFutureProviderRef<DashboardMetrics>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
