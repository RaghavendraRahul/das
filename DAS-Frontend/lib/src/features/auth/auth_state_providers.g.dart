// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_state_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authNotifierHash() => r'4c6b9fc51628d82403a34b04ecb499ee47d3d202';

/// Auth state notifier
///
/// Copied from [AuthNotifier].
@ProviderFor(AuthNotifier)
final authNotifierProvider =
    AutoDisposeAsyncNotifierProvider<AuthNotifier, AuthState>.internal(
  AuthNotifier.new,
  name: r'authNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AuthNotifier = AutoDisposeAsyncNotifier<AuthState>;
String _$signupNotifierHash() => r'c0c5078f785a8b5d9d083d5230db9525c7af15c6';

/// Signup notifier
///
/// Copied from [SignupNotifier].
@ProviderFor(SignupNotifier)
final signupNotifierProvider =
    AutoDisposeAsyncNotifierProvider<SignupNotifier, void>.internal(
  SignupNotifier.new,
  name: r'signupNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$signupNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SignupNotifier = AutoDisposeAsyncNotifier<void>;
String _$passwordResetNotifierHash() =>
    r'a2b994fc98d9e3be72f2b0545cc647149440b63c';

/// Password reset notifier
///
/// Copied from [PasswordResetNotifier].
@ProviderFor(PasswordResetNotifier)
final passwordResetNotifierProvider =
    AutoDisposeAsyncNotifierProvider<PasswordResetNotifier, void>.internal(
  PasswordResetNotifier.new,
  name: r'passwordResetNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$passwordResetNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PasswordResetNotifier = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
