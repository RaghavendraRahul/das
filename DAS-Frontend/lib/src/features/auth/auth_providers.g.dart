// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userRepositoryHash() => r'29ec3dfdcf5ddd65510928eba17db11f7a59e16f';

/// See also [userRepository].
@ProviderFor(userRepository)
final userRepositoryProvider = AutoDisposeProvider<UserRepository>.internal(
  userRepository,
  name: r'userRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UserRepositoryRef = AutoDisposeProviderRef<UserRepository>;
String _$allUsersStreamHash() => r'10dc29285c88557f9801d586f249c20ec3d149d8';

/// See also [allUsersStream].
@ProviderFor(allUsersStream)
final allUsersStreamProvider = AutoDisposeStreamProvider<List<User>>.internal(
  allUsersStream,
  name: r'allUsersStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$allUsersStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AllUsersStreamRef = AutoDisposeStreamProviderRef<List<User>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
