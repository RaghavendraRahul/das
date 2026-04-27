// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$projectRepositoryHash() => r'720fa6e881df487cdc4b2b7bada7ec2684eb2283';

/// See also [projectRepository].
@ProviderFor(projectRepository)
final projectRepositoryProvider =
    AutoDisposeProvider<ProjectRepository>.internal(
  projectRepository,
  name: r'projectRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$projectRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ProjectRepositoryRef = AutoDisposeProviderRef<ProjectRepository>;
String _$currentProjectHash() => r'12e4bf6be494baae77d7d6cbb3bdde307f81c3f8';

/// See also [currentProject].
@ProviderFor(currentProject)
final currentProjectProvider =
    AutoDisposeFutureProvider<ProjectWithTasks?>.internal(
  currentProject,
  name: r'currentProjectProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentProjectHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CurrentProjectRef = AutoDisposeFutureProviderRef<ProjectWithTasks?>;
String _$projectsWithTasksHash() => r'4b511cb90f85a7b6ceaac1c0920c042ab81ac592';

/// All projects with tasks for Activity Catalog
/// Uses apiTasksProvider which already returns tasks WITH subtasks (via TaskSerializer)
///
/// Copied from [projectsWithTasks].
@ProviderFor(projectsWithTasks)
final projectsWithTasksProvider =
    AutoDisposeFutureProvider<List<ProjectWithTasks>>.internal(
  projectsWithTasks,
  name: r'projectsWithTasksProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$projectsWithTasksHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ProjectsWithTasksRef
    = AutoDisposeFutureProviderRef<List<ProjectWithTasks>>;
String _$pendingProjectsHash() => r'e1c9094ee328af79243453a0c46671593df6aad9';

/// See also [pendingProjects].
@ProviderFor(pendingProjects)
final pendingProjectsProvider =
    AutoDisposeStreamProvider<List<Project>>.internal(
  pendingProjects,
  name: r'pendingProjectsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$pendingProjectsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PendingProjectsRef = AutoDisposeStreamProviderRef<List<Project>>;
String _$pendingProjectClosuresHash() =>
    r'81c0aab78e40d347cd4f9d85fe5cb2b1c3726ae4';

/// See also [pendingProjectClosures].
@ProviderFor(pendingProjectClosures)
final pendingProjectClosuresProvider =
    AutoDisposeStreamProvider<List<Project>>.internal(
  pendingProjectClosures,
  name: r'pendingProjectClosuresProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$pendingProjectClosuresHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PendingProjectClosuresRef = AutoDisposeStreamProviderRef<List<Project>>;
String _$pendingNewTasksHash() => r'ec722e656eb27ab70abd781fcf93e33cb6f3b4a2';

/// See also [pendingNewTasks].
@ProviderFor(pendingNewTasks)
final pendingNewTasksProvider =
    AutoDisposeStreamProvider<List<TaskWithProject>>.internal(
  pendingNewTasks,
  name: r'pendingNewTasksProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$pendingNewTasksHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PendingNewTasksRef
    = AutoDisposeStreamProviderRef<List<TaskWithProject>>;
String _$pendingTaskCompletionsHash() =>
    r'fc58687b3bc9b8343e2348965dc112d10693799e';

/// See also [pendingTaskCompletions].
@ProviderFor(pendingTaskCompletions)
final pendingTaskCompletionsProvider =
    AutoDisposeStreamProvider<List<TaskWithProject>>.internal(
  pendingTaskCompletions,
  name: r'pendingTaskCompletionsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$pendingTaskCompletionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PendingTaskCompletionsRef
    = AutoDisposeStreamProviderRef<List<TaskWithProject>>;
String _$pendingTemplatesHash() => r'e7e53cba390ac9f9e223705797bb7d05705048f3';

/// See also [pendingTemplates].
@ProviderFor(pendingTemplates)
final pendingTemplatesProvider =
    AutoDisposeStreamProvider<List<ActivityTemplate>>.internal(
  pendingTemplates,
  name: r'pendingTemplatesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$pendingTemplatesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PendingTemplatesRef
    = AutoDisposeStreamProviderRef<List<ActivityTemplate>>;
String _$analyticsDataHash() => r'daf09fd70acbea68961ffc0fee1b5ae1e54ba3f9';

/// Fetches project analytics hours with optional project and employee filters
/// DEDICATED provider for analytics - does NOT use dashboard's date filters
///
/// Copied from [analyticsData].
@ProviderFor(analyticsData)
final analyticsDataProvider =
    AutoDisposeFutureProvider<Map<String, dynamic>>.internal(
  analyticsData,
  name: r'analyticsDataProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$analyticsDataHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AnalyticsDataRef = AutoDisposeFutureProviderRef<Map<String, dynamic>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
