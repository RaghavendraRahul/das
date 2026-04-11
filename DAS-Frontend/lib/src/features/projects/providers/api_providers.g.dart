// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$taskApiServiceHash() => r'c6791f3f5b2d6577d5ec02adeabf95c6b9eb1913';

/// Task API service provider
///
/// Copied from [taskApiService].
@ProviderFor(taskApiService)
final taskApiServiceProvider = AutoDisposeProvider<TaskApiService>.internal(
  taskApiService,
  name: r'taskApiServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$taskApiServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef TaskApiServiceRef = AutoDisposeProviderRef<TaskApiService>;
String _$apiProjectsHash() => r'bd8e90ff6b05ace3f166dc14e5c6e278765e1171';

/// Fetch all projects from API
///
/// Copied from [apiProjects].
@ProviderFor(apiProjects)
final apiProjectsProvider =
    AutoDisposeFutureProvider<List<ProjectModel>>.internal(
  apiProjects,
  name: r'apiProjectsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$apiProjectsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ApiProjectsRef = AutoDisposeFutureProviderRef<List<ProjectModel>>;
String _$dashboardApiProjectsHash() =>
    r'757049d5415a0cd8108b14bf2a3466fdb3d2349b';

/// Fetch only authorized projects for the dashboard to avoid 401 errors
///
/// Copied from [dashboardApiProjects].
@ProviderFor(dashboardApiProjects)
final dashboardApiProjectsProvider =
    AutoDisposeFutureProvider<List<ProjectModel>>.internal(
  dashboardApiProjects,
  name: r'dashboardApiProjectsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dashboardApiProjectsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef DashboardApiProjectsRef
    = AutoDisposeFutureProviderRef<List<ProjectModel>>;
String _$apiPaginatedProjectsHash() =>
    r'eedea76bdae514ec07956a62c32eae96c9eb66af';

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

/// See also [apiPaginatedProjects].
@ProviderFor(apiPaginatedProjects)
const apiPaginatedProjectsProvider = ApiPaginatedProjectsFamily();

/// See also [apiPaginatedProjects].
class ApiPaginatedProjectsFamily
    extends Family<AsyncValue<PaginatedResponse<ProjectModel>>> {
  /// See also [apiPaginatedProjects].
  const ApiPaginatedProjectsFamily();

  /// See also [apiPaginatedProjects].
  ApiPaginatedProjectsProvider call({
    required int page,
    String? filter,
  }) {
    return ApiPaginatedProjectsProvider(
      page: page,
      filter: filter,
    );
  }

  @override
  ApiPaginatedProjectsProvider getProviderOverride(
    covariant ApiPaginatedProjectsProvider provider,
  ) {
    return call(
      page: provider.page,
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
  String? get name => r'apiPaginatedProjectsProvider';
}

/// See also [apiPaginatedProjects].
class ApiPaginatedProjectsProvider
    extends AutoDisposeFutureProvider<PaginatedResponse<ProjectModel>> {
  /// See also [apiPaginatedProjects].
  ApiPaginatedProjectsProvider({
    required int page,
    String? filter,
  }) : this._internal(
          (ref) => apiPaginatedProjects(
            ref as ApiPaginatedProjectsRef,
            page: page,
            filter: filter,
          ),
          from: apiPaginatedProjectsProvider,
          name: r'apiPaginatedProjectsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$apiPaginatedProjectsHash,
          dependencies: ApiPaginatedProjectsFamily._dependencies,
          allTransitiveDependencies:
              ApiPaginatedProjectsFamily._allTransitiveDependencies,
          page: page,
          filter: filter,
        );

  ApiPaginatedProjectsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.page,
    required this.filter,
  }) : super.internal();

  final int page;
  final String? filter;

  @override
  Override overrideWith(
    FutureOr<PaginatedResponse<ProjectModel>> Function(
            ApiPaginatedProjectsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ApiPaginatedProjectsProvider._internal(
        (ref) => create(ref as ApiPaginatedProjectsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        page: page,
        filter: filter,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<PaginatedResponse<ProjectModel>>
      createElement() {
    return _ApiPaginatedProjectsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ApiPaginatedProjectsProvider &&
        other.page == page &&
        other.filter == filter;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, page.hashCode);
    hash = _SystemHash.combine(hash, filter.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ApiPaginatedProjectsRef
    on AutoDisposeFutureProviderRef<PaginatedResponse<ProjectModel>> {
  /// The parameter `page` of this provider.
  int get page;

  /// The parameter `filter` of this provider.
  String? get filter;
}

class _ApiPaginatedProjectsProviderElement
    extends AutoDisposeFutureProviderElement<PaginatedResponse<ProjectModel>>
    with ApiPaginatedProjectsRef {
  _ApiPaginatedProjectsProviderElement(super.provider);

  @override
  int get page => (origin as ApiPaginatedProjectsProvider).page;
  @override
  String? get filter => (origin as ApiPaginatedProjectsProvider).filter;
}

String _$paginatedDashboardProjectsHash() =>
    r'3281b13dfb7303da1870d03f7dc1c404735f2754';

/// Fetch projects with tasks pre-mapped (for simple listing cases)
///
/// Copied from [paginatedDashboardProjects].
@ProviderFor(paginatedDashboardProjects)
const paginatedDashboardProjectsProvider = PaginatedDashboardProjectsFamily();

/// Fetch projects with tasks pre-mapped (for simple listing cases)
///
/// Copied from [paginatedDashboardProjects].
class PaginatedDashboardProjectsFamily
    extends Family<AsyncValue<PaginatedResponse<ProjectWithTasks>>> {
  /// Fetch projects with tasks pre-mapped (for simple listing cases)
  ///
  /// Copied from [paginatedDashboardProjects].
  const PaginatedDashboardProjectsFamily();

  /// Fetch projects with tasks pre-mapped (for simple listing cases)
  ///
  /// Copied from [paginatedDashboardProjects].
  PaginatedDashboardProjectsProvider call({
    required int page,
    String? filter,
  }) {
    return PaginatedDashboardProjectsProvider(
      page: page,
      filter: filter,
    );
  }

  @override
  PaginatedDashboardProjectsProvider getProviderOverride(
    covariant PaginatedDashboardProjectsProvider provider,
  ) {
    return call(
      page: provider.page,
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
  String? get name => r'paginatedDashboardProjectsProvider';
}

/// Fetch projects with tasks pre-mapped (for simple listing cases)
///
/// Copied from [paginatedDashboardProjects].
class PaginatedDashboardProjectsProvider
    extends AutoDisposeFutureProvider<PaginatedResponse<ProjectWithTasks>> {
  /// Fetch projects with tasks pre-mapped (for simple listing cases)
  ///
  /// Copied from [paginatedDashboardProjects].
  PaginatedDashboardProjectsProvider({
    required int page,
    String? filter,
  }) : this._internal(
          (ref) => paginatedDashboardProjects(
            ref as PaginatedDashboardProjectsRef,
            page: page,
            filter: filter,
          ),
          from: paginatedDashboardProjectsProvider,
          name: r'paginatedDashboardProjectsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$paginatedDashboardProjectsHash,
          dependencies: PaginatedDashboardProjectsFamily._dependencies,
          allTransitiveDependencies:
              PaginatedDashboardProjectsFamily._allTransitiveDependencies,
          page: page,
          filter: filter,
        );

  PaginatedDashboardProjectsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.page,
    required this.filter,
  }) : super.internal();

  final int page;
  final String? filter;

  @override
  Override overrideWith(
    FutureOr<PaginatedResponse<ProjectWithTasks>> Function(
            PaginatedDashboardProjectsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PaginatedDashboardProjectsProvider._internal(
        (ref) => create(ref as PaginatedDashboardProjectsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        page: page,
        filter: filter,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<PaginatedResponse<ProjectWithTasks>>
      createElement() {
    return _PaginatedDashboardProjectsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PaginatedDashboardProjectsProvider &&
        other.page == page &&
        other.filter == filter;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, page.hashCode);
    hash = _SystemHash.combine(hash, filter.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin PaginatedDashboardProjectsRef
    on AutoDisposeFutureProviderRef<PaginatedResponse<ProjectWithTasks>> {
  /// The parameter `page` of this provider.
  int get page;

  /// The parameter `filter` of this provider.
  String? get filter;
}

class _PaginatedDashboardProjectsProviderElement
    extends AutoDisposeFutureProviderElement<
        PaginatedResponse<ProjectWithTasks>>
    with PaginatedDashboardProjectsRef {
  _PaginatedDashboardProjectsProviderElement(super.provider);

  @override
  int get page => (origin as PaginatedDashboardProjectsProvider).page;
  @override
  String? get filter => (origin as PaginatedDashboardProjectsProvider).filter;
}

String _$projectsPageProjectsHash() =>
    r'725a3b39a07a4ffec70dbecb2ba49e5865cccce5';

/// Independent provider for the Projects Page (My Projects / Team Projects).
/// Completely separate from [paginatedDashboardProjectsProvider] so that
/// invalidating page-level state never affects Dashboard data.
///
/// Copied from [projectsPageProjects].
@ProviderFor(projectsPageProjects)
const projectsPageProjectsProvider = ProjectsPageProjectsFamily();

/// Independent provider for the Projects Page (My Projects / Team Projects).
/// Completely separate from [paginatedDashboardProjectsProvider] so that
/// invalidating page-level state never affects Dashboard data.
///
/// Copied from [projectsPageProjects].
class ProjectsPageProjectsFamily
    extends Family<AsyncValue<PaginatedResponse<ProjectWithTasks>>> {
  /// Independent provider for the Projects Page (My Projects / Team Projects).
  /// Completely separate from [paginatedDashboardProjectsProvider] so that
  /// invalidating page-level state never affects Dashboard data.
  ///
  /// Copied from [projectsPageProjects].
  const ProjectsPageProjectsFamily();

  /// Independent provider for the Projects Page (My Projects / Team Projects).
  /// Completely separate from [paginatedDashboardProjectsProvider] so that
  /// invalidating page-level state never affects Dashboard data.
  ///
  /// Copied from [projectsPageProjects].
  ProjectsPageProjectsProvider call({
    required int page,
    String? filter,
    String? search,
  }) {
    return ProjectsPageProjectsProvider(
      page: page,
      filter: filter,
      search: search,
    );
  }

  @override
  ProjectsPageProjectsProvider getProviderOverride(
    covariant ProjectsPageProjectsProvider provider,
  ) {
    return call(
      page: provider.page,
      filter: provider.filter,
      search: provider.search,
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
  String? get name => r'projectsPageProjectsProvider';
}

/// Independent provider for the Projects Page (My Projects / Team Projects).
/// Completely separate from [paginatedDashboardProjectsProvider] so that
/// invalidating page-level state never affects Dashboard data.
///
/// Copied from [projectsPageProjects].
class ProjectsPageProjectsProvider
    extends AutoDisposeFutureProvider<PaginatedResponse<ProjectWithTasks>> {
  /// Independent provider for the Projects Page (My Projects / Team Projects).
  /// Completely separate from [paginatedDashboardProjectsProvider] so that
  /// invalidating page-level state never affects Dashboard data.
  ///
  /// Copied from [projectsPageProjects].
  ProjectsPageProjectsProvider({
    required int page,
    String? filter,
    String? search,
  }) : this._internal(
          (ref) => projectsPageProjects(
            ref as ProjectsPageProjectsRef,
            page: page,
            filter: filter,
            search: search,
          ),
          from: projectsPageProjectsProvider,
          name: r'projectsPageProjectsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$projectsPageProjectsHash,
          dependencies: ProjectsPageProjectsFamily._dependencies,
          allTransitiveDependencies:
              ProjectsPageProjectsFamily._allTransitiveDependencies,
          page: page,
          filter: filter,
          search: search,
        );

  ProjectsPageProjectsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.page,
    required this.filter,
    required this.search,
  }) : super.internal();

  final int page;
  final String? filter;
  final String? search;

  @override
  Override overrideWith(
    FutureOr<PaginatedResponse<ProjectWithTasks>> Function(
            ProjectsPageProjectsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProjectsPageProjectsProvider._internal(
        (ref) => create(ref as ProjectsPageProjectsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        page: page,
        filter: filter,
        search: search,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<PaginatedResponse<ProjectWithTasks>>
      createElement() {
    return _ProjectsPageProjectsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProjectsPageProjectsProvider &&
        other.page == page &&
        other.filter == filter &&
        other.search == search;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, page.hashCode);
    hash = _SystemHash.combine(hash, filter.hashCode);
    hash = _SystemHash.combine(hash, search.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ProjectsPageProjectsRef
    on AutoDisposeFutureProviderRef<PaginatedResponse<ProjectWithTasks>> {
  /// The parameter `page` of this provider.
  int get page;

  /// The parameter `filter` of this provider.
  String? get filter;

  /// The parameter `search` of this provider.
  String? get search;
}

class _ProjectsPageProjectsProviderElement
    extends AutoDisposeFutureProviderElement<
        PaginatedResponse<ProjectWithTasks>> with ProjectsPageProjectsRef {
  _ProjectsPageProjectsProviderElement(super.provider);

  @override
  int get page => (origin as ProjectsPageProjectsProvider).page;
  @override
  String? get filter => (origin as ProjectsPageProjectsProvider).filter;
  @override
  String? get search => (origin as ProjectsPageProjectsProvider).search;
}

String _$apiTasksHash() => r'156208f57f2f50a6e9db6b36f8735cf0f0e50de9';

/// See also [apiTasks].
@ProviderFor(apiTasks)
final apiTasksProvider = AutoDisposeFutureProvider<List<TaskModel>>.internal(
  apiTasks,
  name: r'apiTasksProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$apiTasksHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ApiTasksRef = AutoDisposeFutureProviderRef<List<TaskModel>>;
String _$apiProjectHash() => r'3947fdb5313e1106969f513a2e251231262ca82f';

/// Fetch specific project by ID from API
///
/// Copied from [apiProject].
@ProviderFor(apiProject)
const apiProjectProvider = ApiProjectFamily();

/// Fetch specific project by ID from API
///
/// Copied from [apiProject].
class ApiProjectFamily extends Family<AsyncValue<ProjectModel>> {
  /// Fetch specific project by ID from API
  ///
  /// Copied from [apiProject].
  const ApiProjectFamily();

  /// Fetch specific project by ID from API
  ///
  /// Copied from [apiProject].
  ApiProjectProvider call(
    int projectId,
  ) {
    return ApiProjectProvider(
      projectId,
    );
  }

  @override
  ApiProjectProvider getProviderOverride(
    covariant ApiProjectProvider provider,
  ) {
    return call(
      provider.projectId,
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
  String? get name => r'apiProjectProvider';
}

/// Fetch specific project by ID from API
///
/// Copied from [apiProject].
class ApiProjectProvider extends AutoDisposeFutureProvider<ProjectModel> {
  /// Fetch specific project by ID from API
  ///
  /// Copied from [apiProject].
  ApiProjectProvider(
    int projectId,
  ) : this._internal(
          (ref) => apiProject(
            ref as ApiProjectRef,
            projectId,
          ),
          from: apiProjectProvider,
          name: r'apiProjectProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$apiProjectHash,
          dependencies: ApiProjectFamily._dependencies,
          allTransitiveDependencies:
              ApiProjectFamily._allTransitiveDependencies,
          projectId: projectId,
        );

  ApiProjectProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.projectId,
  }) : super.internal();

  final int projectId;

  @override
  Override overrideWith(
    FutureOr<ProjectModel> Function(ApiProjectRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ApiProjectProvider._internal(
        (ref) => create(ref as ApiProjectRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        projectId: projectId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<ProjectModel> createElement() {
    return _ApiProjectProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ApiProjectProvider && other.projectId == projectId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, projectId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ApiProjectRef on AutoDisposeFutureProviderRef<ProjectModel> {
  /// The parameter `projectId` of this provider.
  int get projectId;
}

class _ApiProjectProviderElement
    extends AutoDisposeFutureProviderElement<ProjectModel> with ApiProjectRef {
  _ApiProjectProviderElement(super.provider);

  @override
  int get projectId => (origin as ApiProjectProvider).projectId;
}

String _$apiCatalogHash() => r'eca2f9f39483c398a98dffda022cde18a4fe272f';

/// Fetch all catalog items from API (filtered by backend based on role and assignments)
///
/// Copied from [apiCatalog].
@ProviderFor(apiCatalog)
final apiCatalogProvider = FutureProvider<List<CatalogModel>>.internal(
  apiCatalog,
  name: r'apiCatalogProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$apiCatalogHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ApiCatalogRef = FutureProviderRef<List<CatalogModel>>;
String _$apiCatalogProjectsHash() =>
    r'2668eee60adc39f8862d83203cf72a6c50a91698';

/// Fetch catalog projects (only user's assigned projects for planner catalog)
///
/// Copied from [apiCatalogProjects].
@ProviderFor(apiCatalogProjects)
final apiCatalogProjectsProvider = FutureProvider<List<ProjectModel>>.internal(
  apiCatalogProjects,
  name: r'apiCatalogProjectsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$apiCatalogProjectsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ApiCatalogProjectsRef = FutureProviderRef<List<ProjectModel>>;
String _$apiCatalogTasksHash() => r'a88bf5d13286c7dcc90dc7713d6562b7c95fc13b';

/// Fetch catalog tasks (only user's assigned tasks for planner catalog)
///
/// Copied from [apiCatalogTasks].
@ProviderFor(apiCatalogTasks)
final apiCatalogTasksProvider = FutureProvider<List<TaskModel>>.internal(
  apiCatalogTasks,
  name: r'apiCatalogTasksProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$apiCatalogTasksHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ApiCatalogTasksRef = FutureProviderRef<List<TaskModel>>;
String _$apiCoursesHash() => r'3a8ebab64af782a810c9ce049ec3327f745dc294';

/// Fetch courses from catalog API
///
/// Copied from [apiCourses].
@ProviderFor(apiCourses)
final apiCoursesProvider =
    AutoDisposeFutureProvider<List<CatalogModel>>.internal(
  apiCourses,
  name: r'apiCoursesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$apiCoursesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ApiCoursesRef = AutoDisposeFutureProviderRef<List<CatalogModel>>;
String _$apiRoutinesHash() => r'a526bcee05526db3b359e2b4750549c46f8dca8a';

/// Fetch routines from catalog API
///
/// Copied from [apiRoutines].
@ProviderFor(apiRoutines)
final apiRoutinesProvider =
    AutoDisposeFutureProvider<List<CatalogModel>>.internal(
  apiRoutines,
  name: r'apiRoutinesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$apiRoutinesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ApiRoutinesRef = AutoDisposeFutureProviderRef<List<CatalogModel>>;
String _$apiWorkItemsHash() => r'fdf71ff1660980066f904f9fd5fc7fcfa4ab9dcd';

/// Fetch work items from catalog API (CUSTOM type)
///
/// Copied from [apiWorkItems].
@ProviderFor(apiWorkItems)
final apiWorkItemsProvider =
    AutoDisposeFutureProvider<List<CatalogModel>>.internal(
  apiWorkItems,
  name: r'apiWorkItemsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$apiWorkItemsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ApiWorkItemsRef = AutoDisposeFutureProviderRef<List<CatalogModel>>;
String _$apiTodayPlanHash() => r'5d8636839c7225cd3c688fd4c4cfd88099bf9f40';

/// Fetch today's planned items from API
///
/// Copied from [apiTodayPlan].
@ProviderFor(apiTodayPlan)
final apiTodayPlanProvider =
    AutoDisposeFutureProvider<List<Map<String, dynamic>>>.internal(
  apiTodayPlan,
  name: r'apiTodayPlanProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$apiTodayPlanHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ApiTodayPlanRef
    = AutoDisposeFutureProviderRef<List<Map<String, dynamic>>>;
String _$apiActivityLogsHash() => r'0a961bda37f9cb2bd3f9fdcfb6074106347e16c0';

/// Fetch activity logs from API
///
/// Copied from [apiActivityLogs].
@ProviderFor(apiActivityLogs)
const apiActivityLogsProvider = ApiActivityLogsFamily();

/// Fetch activity logs from API
///
/// Copied from [apiActivityLogs].
class ApiActivityLogsFamily
    extends Family<AsyncValue<List<Map<String, dynamic>>>> {
  /// Fetch activity logs from API
  ///
  /// Copied from [apiActivityLogs].
  const ApiActivityLogsFamily();

  /// Fetch activity logs from API
  ///
  /// Copied from [apiActivityLogs].
  ApiActivityLogsProvider call(
    String? date,
  ) {
    return ApiActivityLogsProvider(
      date,
    );
  }

  @override
  ApiActivityLogsProvider getProviderOverride(
    covariant ApiActivityLogsProvider provider,
  ) {
    return call(
      provider.date,
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
  String? get name => r'apiActivityLogsProvider';
}

/// Fetch activity logs from API
///
/// Copied from [apiActivityLogs].
class ApiActivityLogsProvider
    extends AutoDisposeFutureProvider<List<Map<String, dynamic>>> {
  /// Fetch activity logs from API
  ///
  /// Copied from [apiActivityLogs].
  ApiActivityLogsProvider(
    String? date,
  ) : this._internal(
          (ref) => apiActivityLogs(
            ref as ApiActivityLogsRef,
            date,
          ),
          from: apiActivityLogsProvider,
          name: r'apiActivityLogsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$apiActivityLogsHash,
          dependencies: ApiActivityLogsFamily._dependencies,
          allTransitiveDependencies:
              ApiActivityLogsFamily._allTransitiveDependencies,
          date: date,
        );

  ApiActivityLogsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.date,
  }) : super.internal();

  final String? date;

  @override
  Override overrideWith(
    FutureOr<List<Map<String, dynamic>>> Function(ApiActivityLogsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ApiActivityLogsProvider._internal(
        (ref) => create(ref as ApiActivityLogsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        date: date,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Map<String, dynamic>>> createElement() {
    return _ApiActivityLogsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ApiActivityLogsProvider && other.date == date;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, date.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ApiActivityLogsRef
    on AutoDisposeFutureProviderRef<List<Map<String, dynamic>>> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _ApiActivityLogsProviderElement
    extends AutoDisposeFutureProviderElement<List<Map<String, dynamic>>>
    with ApiActivityLogsRef {
  _ApiActivityLogsProviderElement(super.provider);

  @override
  String? get date => (origin as ApiActivityLogsProvider).date;
}

String _$apiActiveTaskHash() => r'5cf46890d8246c368b0f0a54f99689a048aae0df';

/// Fetch currently active task from API
///
/// Copied from [apiActiveTask].
@ProviderFor(apiActiveTask)
final apiActiveTaskProvider =
    AutoDisposeFutureProvider<Map<String, dynamic>?>.internal(
  apiActiveTask,
  name: r'apiActiveTaskProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$apiActiveTaskHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ApiActiveTaskRef = AutoDisposeFutureProviderRef<Map<String, dynamic>?>;
String _$apiPendingItemsHash() => r'8803ba519f34f07ad5186a72bb3f6e71cb409972';

/// Fetch current user's pending (incomplete) tasks for a specific date
/// This filtered version only returns items from today's plan that are in the 'inbox' (unquadranted)
///
/// Copied from [apiPendingItems].
@ProviderFor(apiPendingItems)
const apiPendingItemsProvider = ApiPendingItemsFamily();

/// Fetch current user's pending (incomplete) tasks for a specific date
/// This filtered version only returns items from today's plan that are in the 'inbox' (unquadranted)
///
/// Copied from [apiPendingItems].
class ApiPendingItemsFamily
    extends Family<AsyncValue<List<Map<String, dynamic>>>> {
  /// Fetch current user's pending (incomplete) tasks for a specific date
  /// This filtered version only returns items from today's plan that are in the 'inbox' (unquadranted)
  ///
  /// Copied from [apiPendingItems].
  const ApiPendingItemsFamily();

  /// Fetch current user's pending (incomplete) tasks for a specific date
  /// This filtered version only returns items from today's plan that are in the 'inbox' (unquadranted)
  ///
  /// Copied from [apiPendingItems].
  ApiPendingItemsProvider call(
    String date,
  ) {
    return ApiPendingItemsProvider(
      date,
    );
  }

  @override
  ApiPendingItemsProvider getProviderOverride(
    covariant ApiPendingItemsProvider provider,
  ) {
    return call(
      provider.date,
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
  String? get name => r'apiPendingItemsProvider';
}

/// Fetch current user's pending (incomplete) tasks for a specific date
/// This filtered version only returns items from today's plan that are in the 'inbox' (unquadranted)
///
/// Copied from [apiPendingItems].
class ApiPendingItemsProvider
    extends AutoDisposeFutureProvider<List<Map<String, dynamic>>> {
  /// Fetch current user's pending (incomplete) tasks for a specific date
  /// This filtered version only returns items from today's plan that are in the 'inbox' (unquadranted)
  ///
  /// Copied from [apiPendingItems].
  ApiPendingItemsProvider(
    String date,
  ) : this._internal(
          (ref) => apiPendingItems(
            ref as ApiPendingItemsRef,
            date,
          ),
          from: apiPendingItemsProvider,
          name: r'apiPendingItemsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$apiPendingItemsHash,
          dependencies: ApiPendingItemsFamily._dependencies,
          allTransitiveDependencies:
              ApiPendingItemsFamily._allTransitiveDependencies,
          date: date,
        );

  ApiPendingItemsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.date,
  }) : super.internal();

  final String date;

  @override
  Override overrideWith(
    FutureOr<List<Map<String, dynamic>>> Function(ApiPendingItemsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ApiPendingItemsProvider._internal(
        (ref) => create(ref as ApiPendingItemsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        date: date,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Map<String, dynamic>>> createElement() {
    return _ApiPendingItemsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ApiPendingItemsProvider && other.date == date;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, date.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ApiPendingItemsRef
    on AutoDisposeFutureProviderRef<List<Map<String, dynamic>>> {
  /// The parameter `date` of this provider.
  String get date;
}

class _ApiPendingItemsProviderElement
    extends AutoDisposeFutureProviderElement<List<Map<String, dynamic>>>
    with ApiPendingItemsRef {
  _ApiPendingItemsProviderElement(super.provider);

  @override
  String get date => (origin as ApiPendingItemsProvider).date;
}

String _$apiAllPendingItemsHash() =>
    r'0ed29bd431e7a246862041b1a9f29641e6dd82eb';

/// Fetch all pending items for the current user (including today's)
///
/// Copied from [apiAllPendingItems].
@ProviderFor(apiAllPendingItems)
final apiAllPendingItemsProvider =
    AutoDisposeFutureProvider<List<Map<String, dynamic>>>.internal(
  apiAllPendingItems,
  name: r'apiAllPendingItemsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$apiAllPendingItemsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ApiAllPendingItemsRef
    = AutoDisposeFutureProviderRef<List<Map<String, dynamic>>>;
String _$apiWeekPlansHash() => r'f6501ddbd323c45d0798b444d377f6dafd596150';

/// Fetch week view plans using date range API and local grouping
///
/// Copied from [apiWeekPlans].
@ProviderFor(apiWeekPlans)
const apiWeekPlansProvider = ApiWeekPlansFamily();

/// Fetch week view plans using date range API and local grouping
///
/// Copied from [apiWeekPlans].
class ApiWeekPlansFamily extends Family<AsyncValue<Map<String, dynamic>>> {
  /// Fetch week view plans using date range API and local grouping
  ///
  /// Copied from [apiWeekPlans].
  const ApiWeekPlansFamily();

  /// Fetch week view plans using date range API and local grouping
  ///
  /// Copied from [apiWeekPlans].
  ApiWeekPlansProvider call(
    String startDate,
  ) {
    return ApiWeekPlansProvider(
      startDate,
    );
  }

  @override
  ApiWeekPlansProvider getProviderOverride(
    covariant ApiWeekPlansProvider provider,
  ) {
    return call(
      provider.startDate,
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
  String? get name => r'apiWeekPlansProvider';
}

/// Fetch week view plans using date range API and local grouping
///
/// Copied from [apiWeekPlans].
class ApiWeekPlansProvider
    extends AutoDisposeFutureProvider<Map<String, dynamic>> {
  /// Fetch week view plans using date range API and local grouping
  ///
  /// Copied from [apiWeekPlans].
  ApiWeekPlansProvider(
    String startDate,
  ) : this._internal(
          (ref) => apiWeekPlans(
            ref as ApiWeekPlansRef,
            startDate,
          ),
          from: apiWeekPlansProvider,
          name: r'apiWeekPlansProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$apiWeekPlansHash,
          dependencies: ApiWeekPlansFamily._dependencies,
          allTransitiveDependencies:
              ApiWeekPlansFamily._allTransitiveDependencies,
          startDate: startDate,
        );

  ApiWeekPlansProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.startDate,
  }) : super.internal();

  final String startDate;

  @override
  Override overrideWith(
    FutureOr<Map<String, dynamic>> Function(ApiWeekPlansRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ApiWeekPlansProvider._internal(
        (ref) => create(ref as ApiWeekPlansRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        startDate: startDate,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Map<String, dynamic>> createElement() {
    return _ApiWeekPlansProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ApiWeekPlansProvider && other.startDate == startDate;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, startDate.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ApiWeekPlansRef on AutoDisposeFutureProviderRef<Map<String, dynamic>> {
  /// The parameter `startDate` of this provider.
  String get startDate;
}

class _ApiWeekPlansProviderElement
    extends AutoDisposeFutureProviderElement<Map<String, dynamic>>
    with ApiWeekPlansRef {
  _ApiWeekPlansProviderElement(super.provider);

  @override
  String get startDate => (origin as ApiWeekPlansProvider).startDate;
}

String _$apiMonthPlansHash() => r'8785befa046621388109238f40eabdc380c93221';

/// Fetch month view plans using date range API and local grouping
///
/// Copied from [apiMonthPlans].
@ProviderFor(apiMonthPlans)
const apiMonthPlansProvider = ApiMonthPlansFamily();

/// Fetch month view plans using date range API and local grouping
///
/// Copied from [apiMonthPlans].
class ApiMonthPlansFamily extends Family<AsyncValue<Map<String, dynamic>>> {
  /// Fetch month view plans using date range API and local grouping
  ///
  /// Copied from [apiMonthPlans].
  const ApiMonthPlansFamily();

  /// Fetch month view plans using date range API and local grouping
  ///
  /// Copied from [apiMonthPlans].
  ApiMonthPlansProvider call(
    int year,
    int month,
  ) {
    return ApiMonthPlansProvider(
      year,
      month,
    );
  }

  @override
  ApiMonthPlansProvider getProviderOverride(
    covariant ApiMonthPlansProvider provider,
  ) {
    return call(
      provider.year,
      provider.month,
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
  String? get name => r'apiMonthPlansProvider';
}

/// Fetch month view plans using date range API and local grouping
///
/// Copied from [apiMonthPlans].
class ApiMonthPlansProvider
    extends AutoDisposeFutureProvider<Map<String, dynamic>> {
  /// Fetch month view plans using date range API and local grouping
  ///
  /// Copied from [apiMonthPlans].
  ApiMonthPlansProvider(
    int year,
    int month,
  ) : this._internal(
          (ref) => apiMonthPlans(
            ref as ApiMonthPlansRef,
            year,
            month,
          ),
          from: apiMonthPlansProvider,
          name: r'apiMonthPlansProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$apiMonthPlansHash,
          dependencies: ApiMonthPlansFamily._dependencies,
          allTransitiveDependencies:
              ApiMonthPlansFamily._allTransitiveDependencies,
          year: year,
          month: month,
        );

  ApiMonthPlansProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.year,
    required this.month,
  }) : super.internal();

  final int year;
  final int month;

  @override
  Override overrideWith(
    FutureOr<Map<String, dynamic>> Function(ApiMonthPlansRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ApiMonthPlansProvider._internal(
        (ref) => create(ref as ApiMonthPlansRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        year: year,
        month: month,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Map<String, dynamic>> createElement() {
    return _ApiMonthPlansProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ApiMonthPlansProvider &&
        other.year == year &&
        other.month == month;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, year.hashCode);
    hash = _SystemHash.combine(hash, month.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ApiMonthPlansRef on AutoDisposeFutureProviderRef<Map<String, dynamic>> {
  /// The parameter `year` of this provider.
  int get year;

  /// The parameter `month` of this provider.
  int get month;
}

class _ApiMonthPlansProviderElement
    extends AutoDisposeFutureProviderElement<Map<String, dynamic>>
    with ApiMonthPlansRef {
  _ApiMonthPlansProviderElement(super.provider);

  @override
  int get year => (origin as ApiMonthPlansProvider).year;
  @override
  int get month => (origin as ApiMonthPlansProvider).month;
}

String _$apiProjectMembersHash() => r'2ed74f4469ea0a5f1ef71eb36c2ff9fd3475e9d1';

/// Fetch project members (task assignees, project leads, admins, managers)
/// If projectId is null, returns only admins and managers
///
/// Copied from [apiProjectMembers].
@ProviderFor(apiProjectMembers)
const apiProjectMembersProvider = ApiProjectMembersFamily();

/// Fetch project members (task assignees, project leads, admins, managers)
/// If projectId is null, returns only admins and managers
///
/// Copied from [apiProjectMembers].
class ApiProjectMembersFamily extends Family<AsyncValue<Map<String, dynamic>>> {
  /// Fetch project members (task assignees, project leads, admins, managers)
  /// If projectId is null, returns only admins and managers
  ///
  /// Copied from [apiProjectMembers].
  const ApiProjectMembersFamily();

  /// Fetch project members (task assignees, project leads, admins, managers)
  /// If projectId is null, returns only admins and managers
  ///
  /// Copied from [apiProjectMembers].
  ApiProjectMembersProvider call(
    String? projectId,
  ) {
    return ApiProjectMembersProvider(
      projectId,
    );
  }

  @override
  ApiProjectMembersProvider getProviderOverride(
    covariant ApiProjectMembersProvider provider,
  ) {
    return call(
      provider.projectId,
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
  String? get name => r'apiProjectMembersProvider';
}

/// Fetch project members (task assignees, project leads, admins, managers)
/// If projectId is null, returns only admins and managers
///
/// Copied from [apiProjectMembers].
class ApiProjectMembersProvider
    extends AutoDisposeFutureProvider<Map<String, dynamic>> {
  /// Fetch project members (task assignees, project leads, admins, managers)
  /// If projectId is null, returns only admins and managers
  ///
  /// Copied from [apiProjectMembers].
  ApiProjectMembersProvider(
    String? projectId,
  ) : this._internal(
          (ref) => apiProjectMembers(
            ref as ApiProjectMembersRef,
            projectId,
          ),
          from: apiProjectMembersProvider,
          name: r'apiProjectMembersProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$apiProjectMembersHash,
          dependencies: ApiProjectMembersFamily._dependencies,
          allTransitiveDependencies:
              ApiProjectMembersFamily._allTransitiveDependencies,
          projectId: projectId,
        );

  ApiProjectMembersProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.projectId,
  }) : super.internal();

  final String? projectId;

  @override
  Override overrideWith(
    FutureOr<Map<String, dynamic>> Function(ApiProjectMembersRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ApiProjectMembersProvider._internal(
        (ref) => create(ref as ApiProjectMembersRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        projectId: projectId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Map<String, dynamic>> createElement() {
    return _ApiProjectMembersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ApiProjectMembersProvider && other.projectId == projectId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, projectId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ApiProjectMembersRef
    on AutoDisposeFutureProviderRef<Map<String, dynamic>> {
  /// The parameter `projectId` of this provider.
  String? get projectId;
}

class _ApiProjectMembersProviderElement
    extends AutoDisposeFutureProviderElement<Map<String, dynamic>>
    with ApiProjectMembersRef {
  _ApiProjectMembersProviderElement(super.provider);

  @override
  String? get projectId => (origin as ApiProjectMembersProvider).projectId;
}

String _$adminEmployeeTodayPlanHash() =>
    r'9c3ec53e4bf3b38e07404d190ef96bdfcdb2b639';

/// [Admin only] Fetch a specific employee's today plan items.
/// Calls GET /today-plan/?user_id=<userId>&plan_date=<date>
///
/// Copied from [adminEmployeeTodayPlan].
@ProviderFor(adminEmployeeTodayPlan)
const adminEmployeeTodayPlanProvider = AdminEmployeeTodayPlanFamily();

/// [Admin only] Fetch a specific employee's today plan items.
/// Calls GET /today-plan/?user_id=<userId>&plan_date=<date>
///
/// Copied from [adminEmployeeTodayPlan].
class AdminEmployeeTodayPlanFamily
    extends Family<AsyncValue<List<Map<String, dynamic>>>> {
  /// [Admin only] Fetch a specific employee's today plan items.
  /// Calls GET /today-plan/?user_id=<userId>&plan_date=<date>
  ///
  /// Copied from [adminEmployeeTodayPlan].
  const AdminEmployeeTodayPlanFamily();

  /// [Admin only] Fetch a specific employee's today plan items.
  /// Calls GET /today-plan/?user_id=<userId>&plan_date=<date>
  ///
  /// Copied from [adminEmployeeTodayPlan].
  AdminEmployeeTodayPlanProvider call(
    String userId,
  ) {
    return AdminEmployeeTodayPlanProvider(
      userId,
    );
  }

  @override
  AdminEmployeeTodayPlanProvider getProviderOverride(
    covariant AdminEmployeeTodayPlanProvider provider,
  ) {
    return call(
      provider.userId,
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
  String? get name => r'adminEmployeeTodayPlanProvider';
}

/// [Admin only] Fetch a specific employee's today plan items.
/// Calls GET /today-plan/?user_id=<userId>&plan_date=<date>
///
/// Copied from [adminEmployeeTodayPlan].
class AdminEmployeeTodayPlanProvider
    extends AutoDisposeFutureProvider<List<Map<String, dynamic>>> {
  /// [Admin only] Fetch a specific employee's today plan items.
  /// Calls GET /today-plan/?user_id=<userId>&plan_date=<date>
  ///
  /// Copied from [adminEmployeeTodayPlan].
  AdminEmployeeTodayPlanProvider(
    String userId,
  ) : this._internal(
          (ref) => adminEmployeeTodayPlan(
            ref as AdminEmployeeTodayPlanRef,
            userId,
          ),
          from: adminEmployeeTodayPlanProvider,
          name: r'adminEmployeeTodayPlanProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$adminEmployeeTodayPlanHash,
          dependencies: AdminEmployeeTodayPlanFamily._dependencies,
          allTransitiveDependencies:
              AdminEmployeeTodayPlanFamily._allTransitiveDependencies,
          userId: userId,
        );

  AdminEmployeeTodayPlanProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  Override overrideWith(
    FutureOr<List<Map<String, dynamic>>> Function(
            AdminEmployeeTodayPlanRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AdminEmployeeTodayPlanProvider._internal(
        (ref) => create(ref as AdminEmployeeTodayPlanRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Map<String, dynamic>>> createElement() {
    return _AdminEmployeeTodayPlanProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AdminEmployeeTodayPlanProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AdminEmployeeTodayPlanRef
    on AutoDisposeFutureProviderRef<List<Map<String, dynamic>>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _AdminEmployeeTodayPlanProviderElement
    extends AutoDisposeFutureProviderElement<List<Map<String, dynamic>>>
    with AdminEmployeeTodayPlanRef {
  _AdminEmployeeTodayPlanProviderElement(super.provider);

  @override
  String get userId => (origin as AdminEmployeeTodayPlanProvider).userId;
}

String _$adminEmployeeStickyNotesHash() =>
    r'b48d18a43c948c5a757363a814ec0c2be766310c';

/// [Admin only] Fetch a specific employee's sticky notes.
/// Calls GET /sticky-notes/?user_id=<userId>
///
/// Copied from [adminEmployeeStickyNotes].
@ProviderFor(adminEmployeeStickyNotes)
const adminEmployeeStickyNotesProvider = AdminEmployeeStickyNotesFamily();

/// [Admin only] Fetch a specific employee's sticky notes.
/// Calls GET /sticky-notes/?user_id=<userId>
///
/// Copied from [adminEmployeeStickyNotes].
class AdminEmployeeStickyNotesFamily
    extends Family<AsyncValue<List<Map<String, dynamic>>>> {
  /// [Admin only] Fetch a specific employee's sticky notes.
  /// Calls GET /sticky-notes/?user_id=<userId>
  ///
  /// Copied from [adminEmployeeStickyNotes].
  const AdminEmployeeStickyNotesFamily();

  /// [Admin only] Fetch a specific employee's sticky notes.
  /// Calls GET /sticky-notes/?user_id=<userId>
  ///
  /// Copied from [adminEmployeeStickyNotes].
  AdminEmployeeStickyNotesProvider call(
    String userId,
  ) {
    return AdminEmployeeStickyNotesProvider(
      userId,
    );
  }

  @override
  AdminEmployeeStickyNotesProvider getProviderOverride(
    covariant AdminEmployeeStickyNotesProvider provider,
  ) {
    return call(
      provider.userId,
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
  String? get name => r'adminEmployeeStickyNotesProvider';
}

/// [Admin only] Fetch a specific employee's sticky notes.
/// Calls GET /sticky-notes/?user_id=<userId>
///
/// Copied from [adminEmployeeStickyNotes].
class AdminEmployeeStickyNotesProvider
    extends AutoDisposeFutureProvider<List<Map<String, dynamic>>> {
  /// [Admin only] Fetch a specific employee's sticky notes.
  /// Calls GET /sticky-notes/?user_id=<userId>
  ///
  /// Copied from [adminEmployeeStickyNotes].
  AdminEmployeeStickyNotesProvider(
    String userId,
  ) : this._internal(
          (ref) => adminEmployeeStickyNotes(
            ref as AdminEmployeeStickyNotesRef,
            userId,
          ),
          from: adminEmployeeStickyNotesProvider,
          name: r'adminEmployeeStickyNotesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$adminEmployeeStickyNotesHash,
          dependencies: AdminEmployeeStickyNotesFamily._dependencies,
          allTransitiveDependencies:
              AdminEmployeeStickyNotesFamily._allTransitiveDependencies,
          userId: userId,
        );

  AdminEmployeeStickyNotesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  Override overrideWith(
    FutureOr<List<Map<String, dynamic>>> Function(
            AdminEmployeeStickyNotesRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AdminEmployeeStickyNotesProvider._internal(
        (ref) => create(ref as AdminEmployeeStickyNotesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Map<String, dynamic>>> createElement() {
    return _AdminEmployeeStickyNotesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AdminEmployeeStickyNotesProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AdminEmployeeStickyNotesRef
    on AutoDisposeFutureProviderRef<List<Map<String, dynamic>>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _AdminEmployeeStickyNotesProviderElement
    extends AutoDisposeFutureProviderElement<List<Map<String, dynamic>>>
    with AdminEmployeeStickyNotesRef {
  _AdminEmployeeStickyNotesProviderElement(super.provider);

  @override
  String get userId => (origin as AdminEmployeeStickyNotesProvider).userId;
}

String _$adminEmployeeProjectsHash() =>
    r'df5b3f4de499ff20c3c23ecc532a8b3f355537fc';

/// [Admin only] Fetch a specific employee's projects via the paginated endpoint.
/// Re-uses paginatedDashboardProjectsProvider but scoped to a specific user_id.
///
/// Copied from [adminEmployeeProjects].
@ProviderFor(adminEmployeeProjects)
const adminEmployeeProjectsProvider = AdminEmployeeProjectsFamily();

/// [Admin only] Fetch a specific employee's projects via the paginated endpoint.
/// Re-uses paginatedDashboardProjectsProvider but scoped to a specific user_id.
///
/// Copied from [adminEmployeeProjects].
class AdminEmployeeProjectsFamily
    extends Family<AsyncValue<PaginatedResponse<ProjectWithTasks>>> {
  /// [Admin only] Fetch a specific employee's projects via the paginated endpoint.
  /// Re-uses paginatedDashboardProjectsProvider but scoped to a specific user_id.
  ///
  /// Copied from [adminEmployeeProjects].
  const AdminEmployeeProjectsFamily();

  /// [Admin only] Fetch a specific employee's projects via the paginated endpoint.
  /// Re-uses paginatedDashboardProjectsProvider but scoped to a specific user_id.
  ///
  /// Copied from [adminEmployeeProjects].
  AdminEmployeeProjectsProvider call({
    required String userId,
    required int page,
  }) {
    return AdminEmployeeProjectsProvider(
      userId: userId,
      page: page,
    );
  }

  @override
  AdminEmployeeProjectsProvider getProviderOverride(
    covariant AdminEmployeeProjectsProvider provider,
  ) {
    return call(
      userId: provider.userId,
      page: provider.page,
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
  String? get name => r'adminEmployeeProjectsProvider';
}

/// [Admin only] Fetch a specific employee's projects via the paginated endpoint.
/// Re-uses paginatedDashboardProjectsProvider but scoped to a specific user_id.
///
/// Copied from [adminEmployeeProjects].
class AdminEmployeeProjectsProvider
    extends AutoDisposeFutureProvider<PaginatedResponse<ProjectWithTasks>> {
  /// [Admin only] Fetch a specific employee's projects via the paginated endpoint.
  /// Re-uses paginatedDashboardProjectsProvider but scoped to a specific user_id.
  ///
  /// Copied from [adminEmployeeProjects].
  AdminEmployeeProjectsProvider({
    required String userId,
    required int page,
  }) : this._internal(
          (ref) => adminEmployeeProjects(
            ref as AdminEmployeeProjectsRef,
            userId: userId,
            page: page,
          ),
          from: adminEmployeeProjectsProvider,
          name: r'adminEmployeeProjectsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$adminEmployeeProjectsHash,
          dependencies: AdminEmployeeProjectsFamily._dependencies,
          allTransitiveDependencies:
              AdminEmployeeProjectsFamily._allTransitiveDependencies,
          userId: userId,
          page: page,
        );

  AdminEmployeeProjectsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
    required this.page,
  }) : super.internal();

  final String userId;
  final int page;

  @override
  Override overrideWith(
    FutureOr<PaginatedResponse<ProjectWithTasks>> Function(
            AdminEmployeeProjectsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AdminEmployeeProjectsProvider._internal(
        (ref) => create(ref as AdminEmployeeProjectsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
        page: page,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<PaginatedResponse<ProjectWithTasks>>
      createElement() {
    return _AdminEmployeeProjectsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AdminEmployeeProjectsProvider &&
        other.userId == userId &&
        other.page == page;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);
    hash = _SystemHash.combine(hash, page.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AdminEmployeeProjectsRef
    on AutoDisposeFutureProviderRef<PaginatedResponse<ProjectWithTasks>> {
  /// The parameter `userId` of this provider.
  String get userId;

  /// The parameter `page` of this provider.
  int get page;
}

class _AdminEmployeeProjectsProviderElement
    extends AutoDisposeFutureProviderElement<
        PaginatedResponse<ProjectWithTasks>> with AdminEmployeeProjectsRef {
  _AdminEmployeeProjectsProviderElement(super.provider);

  @override
  String get userId => (origin as AdminEmployeeProjectsProvider).userId;
  @override
  int get page => (origin as AdminEmployeeProjectsProvider).page;
}

String _$adminEmployeeDashboardHash() =>
    r'8ace4f420ff47b3f8ce5b4c405ece66837742fa0';

/// See also [adminEmployeeDashboard].
@ProviderFor(adminEmployeeDashboard)
const adminEmployeeDashboardProvider = AdminEmployeeDashboardFamily();

/// See also [adminEmployeeDashboard].
class AdminEmployeeDashboardFamily
    extends Family<AsyncValue<Map<String, dynamic>>> {
  /// See also [adminEmployeeDashboard].
  const AdminEmployeeDashboardFamily();

  /// See also [adminEmployeeDashboard].
  AdminEmployeeDashboardProvider call(
    String userId,
  ) {
    return AdminEmployeeDashboardProvider(
      userId,
    );
  }

  @override
  AdminEmployeeDashboardProvider getProviderOverride(
    covariant AdminEmployeeDashboardProvider provider,
  ) {
    return call(
      provider.userId,
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
  String? get name => r'adminEmployeeDashboardProvider';
}

/// See also [adminEmployeeDashboard].
class AdminEmployeeDashboardProvider
    extends AutoDisposeFutureProvider<Map<String, dynamic>> {
  /// See also [adminEmployeeDashboard].
  AdminEmployeeDashboardProvider(
    String userId,
  ) : this._internal(
          (ref) => adminEmployeeDashboard(
            ref as AdminEmployeeDashboardRef,
            userId,
          ),
          from: adminEmployeeDashboardProvider,
          name: r'adminEmployeeDashboardProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$adminEmployeeDashboardHash,
          dependencies: AdminEmployeeDashboardFamily._dependencies,
          allTransitiveDependencies:
              AdminEmployeeDashboardFamily._allTransitiveDependencies,
          userId: userId,
        );

  AdminEmployeeDashboardProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  Override overrideWith(
    FutureOr<Map<String, dynamic>> Function(AdminEmployeeDashboardRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AdminEmployeeDashboardProvider._internal(
        (ref) => create(ref as AdminEmployeeDashboardRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Map<String, dynamic>> createElement() {
    return _AdminEmployeeDashboardProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AdminEmployeeDashboardProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AdminEmployeeDashboardRef
    on AutoDisposeFutureProviderRef<Map<String, dynamic>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _AdminEmployeeDashboardProviderElement
    extends AutoDisposeFutureProviderElement<Map<String, dynamic>>
    with AdminEmployeeDashboardRef {
  _AdminEmployeeDashboardProviderElement(super.provider);

  @override
  String get userId => (origin as AdminEmployeeDashboardProvider).userId;
}

String _$monthlyCompletedProjectsHash() =>
    r'6c4a455e07610c81adafca162d3375270abd3ad2';

/// See also [monthlyCompletedProjects].
@ProviderFor(monthlyCompletedProjects)
const monthlyCompletedProjectsProvider = MonthlyCompletedProjectsFamily();

/// See also [monthlyCompletedProjects].
class MonthlyCompletedProjectsFamily
    extends Family<AsyncValue<List<ProjectModel>>> {
  /// See also [monthlyCompletedProjects].
  const MonthlyCompletedProjectsFamily();

  /// See also [monthlyCompletedProjects].
  MonthlyCompletedProjectsProvider call(
    String monthYear,
  ) {
    return MonthlyCompletedProjectsProvider(
      monthYear,
    );
  }

  @override
  MonthlyCompletedProjectsProvider getProviderOverride(
    covariant MonthlyCompletedProjectsProvider provider,
  ) {
    return call(
      provider.monthYear,
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
  String? get name => r'monthlyCompletedProjectsProvider';
}

/// See also [monthlyCompletedProjects].
class MonthlyCompletedProjectsProvider
    extends AutoDisposeFutureProvider<List<ProjectModel>> {
  /// See also [monthlyCompletedProjects].
  MonthlyCompletedProjectsProvider(
    String monthYear,
  ) : this._internal(
          (ref) => monthlyCompletedProjects(
            ref as MonthlyCompletedProjectsRef,
            monthYear,
          ),
          from: monthlyCompletedProjectsProvider,
          name: r'monthlyCompletedProjectsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$monthlyCompletedProjectsHash,
          dependencies: MonthlyCompletedProjectsFamily._dependencies,
          allTransitiveDependencies:
              MonthlyCompletedProjectsFamily._allTransitiveDependencies,
          monthYear: monthYear,
        );

  MonthlyCompletedProjectsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.monthYear,
  }) : super.internal();

  final String monthYear;

  @override
  Override overrideWith(
    FutureOr<List<ProjectModel>> Function(MonthlyCompletedProjectsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MonthlyCompletedProjectsProvider._internal(
        (ref) => create(ref as MonthlyCompletedProjectsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        monthYear: monthYear,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<ProjectModel>> createElement() {
    return _MonthlyCompletedProjectsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MonthlyCompletedProjectsProvider &&
        other.monthYear == monthYear;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, monthYear.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin MonthlyCompletedProjectsRef
    on AutoDisposeFutureProviderRef<List<ProjectModel>> {
  /// The parameter `monthYear` of this provider.
  String get monthYear;
}

class _MonthlyCompletedProjectsProviderElement
    extends AutoDisposeFutureProviderElement<List<ProjectModel>>
    with MonthlyCompletedProjectsRef {
  _MonthlyCompletedProjectsProviderElement(super.provider);

  @override
  String get monthYear =>
      (origin as MonthlyCompletedProjectsProvider).monthYear;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
