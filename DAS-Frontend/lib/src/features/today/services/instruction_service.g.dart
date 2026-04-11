// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instruction_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$instructionServiceHash() =>
    r'63423507d5ddfbc4b4db6268f75d9d383550bdab';

/// See also [instructionService].
@ProviderFor(instructionService)
final instructionServiceProvider =
    AutoDisposeProvider<InstructionService>.internal(
  instructionService,
  name: r'instructionServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$instructionServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef InstructionServiceRef = AutoDisposeProviderRef<InstructionService>;
String _$receivedInstructionsHash() =>
    r'446c06322bd30d3d625211c44c958afac4208324';

/// See also [receivedInstructions].
@ProviderFor(receivedInstructions)
final receivedInstructionsProvider =
    AutoDisposeFutureProvider<List<TeamInstruction>>.internal(
  receivedInstructions,
  name: r'receivedInstructionsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$receivedInstructionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ReceivedInstructionsRef
    = AutoDisposeFutureProviderRef<List<TeamInstruction>>;
String _$sentInstructionsHash() => r'afbe8cb92bf8020174e18a11e5e0b18441ac29de';

/// See also [sentInstructions].
@ProviderFor(sentInstructions)
final sentInstructionsProvider =
    AutoDisposeFutureProvider<List<TeamInstruction>>.internal(
  sentInstructions,
  name: r'sentInstructionsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sentInstructionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SentInstructionsRef
    = AutoDisposeFutureProviderRef<List<TeamInstruction>>;
String _$projectMembersHash() => r'45d04ebeb7525055d0a58592f9cf4b51695eecc7';

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

/// See also [projectMembers].
@ProviderFor(projectMembers)
const projectMembersProvider = ProjectMembersFamily();

/// See also [projectMembers].
class ProjectMembersFamily extends Family<AsyncValue<List<db.User>>> {
  /// See also [projectMembers].
  const ProjectMembersFamily();

  /// See also [projectMembers].
  ProjectMembersProvider call(
    int? projectId,
  ) {
    return ProjectMembersProvider(
      projectId,
    );
  }

  @override
  ProjectMembersProvider getProviderOverride(
    covariant ProjectMembersProvider provider,
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
  String? get name => r'projectMembersProvider';
}

/// See also [projectMembers].
class ProjectMembersProvider extends AutoDisposeFutureProvider<List<db.User>> {
  /// See also [projectMembers].
  ProjectMembersProvider(
    int? projectId,
  ) : this._internal(
          (ref) => projectMembers(
            ref as ProjectMembersRef,
            projectId,
          ),
          from: projectMembersProvider,
          name: r'projectMembersProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$projectMembersHash,
          dependencies: ProjectMembersFamily._dependencies,
          allTransitiveDependencies:
              ProjectMembersFamily._allTransitiveDependencies,
          projectId: projectId,
        );

  ProjectMembersProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.projectId,
  }) : super.internal();

  final int? projectId;

  @override
  Override overrideWith(
    FutureOr<List<db.User>> Function(ProjectMembersRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProjectMembersProvider._internal(
        (ref) => create(ref as ProjectMembersRef),
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
  AutoDisposeFutureProviderElement<List<db.User>> createElement() {
    return _ProjectMembersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProjectMembersProvider && other.projectId == projectId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, projectId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ProjectMembersRef on AutoDisposeFutureProviderRef<List<db.User>> {
  /// The parameter `projectId` of this provider.
  int? get projectId;
}

class _ProjectMembersProviderElement
    extends AutoDisposeFutureProviderElement<List<db.User>>
    with ProjectMembersRef {
  _ProjectMembersProviderElement(super.provider);

  @override
  int? get projectId => (origin as ProjectMembersProvider).projectId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
