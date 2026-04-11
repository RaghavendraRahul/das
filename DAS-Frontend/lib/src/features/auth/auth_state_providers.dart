import 'package:flutter/foundation.dart';
import 'package:project_pm/src/features/auth/auth_repository.dart';
import 'package:project_pm/src/features/auth/models/auth_models.dart';
import 'package:project_pm/src/core/providers/user_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'dart:html' as html show window;

part 'auth_state_providers.g.dart';

/// Auth state class
class AuthState {
  final bool isAuthenticated;
  final String? accessToken;
  final String? refreshToken;
  final int? userId;
  final String? userEmail;
  final UserRole? userRole;
  final String? themePreference;

  const AuthState({
    this.isAuthenticated = false,
    this.accessToken,
    this.refreshToken,
    this.userId,
    this.userEmail,
    this.userRole,
    this.themePreference,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    String? accessToken,
    String? refreshToken,
    int? userId,
    String? userEmail,
    UserRole? userRole,
    String? themePreference,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      userId: userId ?? this.userId,
      userEmail: userEmail ?? this.userEmail,
      userRole: userRole ?? this.userRole,
      themePreference: themePreference ?? this.themePreference,
    );
  }
}

/// Auth state notifier
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  Future<AuthState> build() async {
    // Intercept auto-login parameters from URL (HRM to DAS SSO)
    if (kIsWeb) {
      try {
        final uri = Uri.parse(html.window.location.href);
        debugPrint(
            '🔵 [AuthNotifier] Boot: Checking for HRM SSO parameters in URL...');

        // In Flutter, params can be in the top query or in the fragment (hash routing)
        // Redirects from HRM: http://localhost:63105/?code=...&email=...
        final topQueryParams = uri.queryParameters;

        // Some redirects might include a fragment: http://localhost:63105/#/login?code=...
        final fragment = uri.fragment;
        final fragmentQueryParams = fragment.contains('?')
            ? Uri.parse('/?${fragment.split('?').sublist(1).join('?')}')
                .queryParameters
            : <String, String>{};

        final queryParams = {...topQueryParams, ...fragmentQueryParams};

        if (queryParams.containsKey('code') &&
            queryParams.containsKey('email')) {
          final code = queryParams['code']!;
          final email = queryParams['email']!;
          debugPrint(
              '🔑 [AuthNotifier] Found HRM parameters - Code: ${code.substring(0, min(code.length, 5))}..., Email: $email');

          // Clean URL safely - we do this AFTER we have the code to avoid losing it if a re-render happens
          try {
            html.window.history.replaceState(null, '', '/');
            debugPrint(
                '🔵 [AuthNotifier] URL parameters cleaned from address bar');
          } catch (e) {
            debugPrint('⚠️ [AuthNotifier] URL cleanup error (non-fatal): $e');
          }

          try {
            final repository = ref.read(authRepositoryProvider);
            debugPrint(
                '🔵 [AuthNotifier] Attempting auto-login with HRM code...');

            final response =
                await repository.autoLoginWithHRMCode(code: code, email: email);

            if (response.containsKey('access_token')) {
              debugPrint('✅ [AuthNotifier] HRM Auto-login SUCCESS');
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('access_token', response['access_token']);
              await prefs.setString('refresh_token',
                  response['refresh_token'] ?? response['access_token']);
              await prefs.setInt('user_id', response['user_id'] as int);
              await prefs.setString('user_email', response['email']);
              await prefs.setString('user_role', response['role']);

              // Save metadata
              await prefs.setBool('launched_from_hrm', true);

              ref.read(currentUserIdProvider.notifier).updateId(
                  response['user_id'].toString());

              return AuthState(
                isAuthenticated: true,
                accessToken: response['access_token'],
                refreshToken:
                    response['refresh_token'] ?? response['access_token'],
                userId: response['user_id'] as int,
                userEmail: response['email'],
                userRole: UserRole.fromString(response['role']),
              );
            } else {
              debugPrint(
                  '❌ [AuthNotifier] HRM Auto-login failed: No access token in response');
            }
          } catch (e) {
            debugPrint('❌ [AuthNotifier] HRM Auto-login EXCEPTION: $e');
          }
        } else {
          debugPrint('ℹ️ [AuthNotifier] No HRM SSO parameters found in URL');
        }
      } catch (e) {
        debugPrint('❌ [AuthNotifier] URL parsing error: $e');
      }
    }

    // Load saved auth state from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');
    final refreshToken = prefs.getString('refresh_token');
    final userId = prefs.getInt('user_id');
    final userEmail = prefs.getString('user_email');
    final roleString = prefs.getString('user_role');
    final themePreference = prefs.getString('theme_preference');

    if (accessToken != null && userEmail != null && userId != null) {
      // Update currentUserIdProvider with saved user ID
      ref.read(currentUserIdProvider.notifier).updateId(userId.toString());

      // Restore impersonation state if present (fixes read-only mode breaking on refresh)
      final impersonateId = prefs.getString('impersonate_user_id');
      if (impersonateId != null && impersonateId.isNotEmpty) {
        ref.read(impersonatingFromUserIdProvider.notifier).state =
            userId.toString(); // Admin's own ID
        ref.read(impersonatingUserNameProvider.notifier).state =
            prefs.getString('impersonate_user_name');
      }

      return AuthState(
        isAuthenticated: true,
        accessToken: accessToken,
        refreshToken: refreshToken,
        userId: userId,
        userEmail: userEmail,
        userRole: roleString != null ? UserRole.fromString(roleString) : null,
        themePreference: themePreference,
      );
    }

    return const AuthState();
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(authRepositoryProvider);
      final response = await repository.login(
        LoginRequest(email: email, password: password),
      );

      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', response.access);
      await prefs.setString('refresh_token', response.refresh);
      await prefs.setInt('user_id', response.userId);
      await prefs.setString('user_email', response.email);
      await prefs.setString('user_role', response.role);
      await prefs.setString('theme_preference', response.themePreference);

      // Update currentUserIdProvider with the logged-in user's ID
      ref.read(currentUserIdProvider.notifier).updateId(
          response.userId.toString());

      return AuthState(
        isAuthenticated: true,
        accessToken: response.access,
        refreshToken: response.refresh,
        userId: response.userId,
        userEmail: response.email,
        userRole: UserRole.fromString(response.role),
        themePreference: response.themePreference,
      );
    });
  }

  /// Login with SSO token from HRM
  Future<void> loginWithToken({
    required String accessToken,
    required String refreshToken,
    required int userId,
    required String userEmail,
    required String userRole,
    String? themePreference,
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', accessToken);
      await prefs.setString('refresh_token', refreshToken);
      await prefs.setInt('user_id', userId);
      await prefs.setString('user_email', userEmail);
      await prefs.setString('user_role', userRole);
      if (themePreference != null) {
        await prefs.setString('theme_preference', themePreference);
      }

      // Update currentUserIdProvider with the logged-in user's ID
      ref.read(currentUserIdProvider.notifier).updateId(userId.toString());

      return AuthState(
        isAuthenticated: true,
        accessToken: accessToken,
        refreshToken: refreshToken,
        userId: userId,
        userEmail: userEmail,
        userRole: UserRole.fromString(userRole),
        themePreference: themePreference,
      );
    });
  }

  /// Auto-login with HRM temporary code
  Future<Map<String, dynamic>> autoLoginWithHRMCode({
    required String code,
    required String email,
  }) async {
    debugPrint('🔵 [AuthNotifier] autoLoginWithHRMCode called - email: $email');
    state = const AsyncValue.loading();

    try {
      final repository = ref.read(authRepositoryProvider);
      debugPrint('🔵 [AuthNotifier] Calling repository.autoLoginWithHRMCode');

      final response = await repository.autoLoginWithHRMCode(
        code: code,
        email: email,
      );

      debugPrint(
          '🔵 [AuthNotifier] Response received: ${response.keys.toList()}');

      if (response.containsKey('access_token')) {
        debugPrint(
            '✅ [AuthNotifier] Has access_token, saving to SharedPreferences');

        // Save to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', response['access_token']);
        await prefs.setString('refresh_token',
            response['refresh_token'] ?? response['access_token']);
        await prefs.setInt('user_id', response['user_id'] as int);
        await prefs.setString('user_email', response['email']);
        await prefs.setString('user_role', response['role']);

        debugPrint(
            '✅ [AuthNotifier] Saved tokens - userId: ${response['user_id']}, email: ${response['email']}, role: ${response['role']}');

        // Update currentUserIdProvider with the logged-in user's ID
        ref.read(currentUserIdProvider.notifier).updateId(
            response['user_id'].toString());

        state = AsyncValue.data(AuthState(
          isAuthenticated: true,
          accessToken: response['access_token'],
          refreshToken: response['refresh_token'] ?? response['access_token'],
          userId: response['user_id'] as int,
          userEmail: response['email'],
          userRole: UserRole.fromString(response['role']),
        ));

        debugPrint(
            '✅ [AuthNotifier] Auth state updated with authenticated user');
        return {'success': true, 'data': response};
      } else {
        debugPrint(
            '❌ [AuthNotifier] No access_token in response: ${response['error'] ?? 'Unknown error'}');
        state = const AsyncValue.data(AuthState());
        return {
          'success': false,
          'error': response['error'] ?? 'Auto-login failed'
        };
      }
    } catch (e) {
      debugPrint('❌ [AuthNotifier] Exception during auto-login: $e');
      state = const AsyncValue.data(AuthState());
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
    await prefs.remove('user_id');
    await prefs.remove('user_email');
    await prefs.remove('user_role');
    await prefs.remove('theme_preference');
    // Also clear any leftover impersonation state from a previous admin session
    await prefs.remove('impersonate_user_id');
    await prefs.remove('impersonate_user_name');

    // Reset currentUserIdProvider to null (not a legacy 'u1' placeholder)
    ref.read(currentUserIdProvider.notifier).updateId(null);

    state = const AsyncValue.data(AuthState());
  }
}

/// Signup notifier
@riverpod
class SignupNotifier extends _$SignupNotifier {
  @override
  FutureOr<void> build() {
    // No initial state needed
  }

  Future<SignupResponse> requestSignup({
    required String email,
    required String password,
    required String role,
  }) async {
    state = const AsyncValue.loading();

    final response = await AsyncValue.guard(() async {
      final repository = ref.read(authRepositoryProvider);
      return await repository.signup(
        SignupRequest(email: email, password: password, role: role),
      );
    });

    if (response.hasError) {
      state = AsyncValue.error(response.error!, response.stackTrace!);
      throw response.error!;
    }

    state = const AsyncValue.data(null);
    return response.value!;
  }

  Future<VerifySignupResponse> verifySignup({
    required String email,
    required String otp,
  }) async {
    state = const AsyncValue.loading();

    final response = await AsyncValue.guard(() async {
      final repository = ref.read(authRepositoryProvider);
      return await repository.verifySignup(
        VerifySignupRequest(email: email, otp: otp),
      );
    });

    if (response.hasError) {
      state = AsyncValue.error(response.error!, response.stackTrace!);
      throw response.error!;
    }

    state = const AsyncValue.data(null);
    return response.value!;
  }
}

/// Password reset notifier
@riverpod
class PasswordResetNotifier extends _$PasswordResetNotifier {
  @override
  FutureOr<void> build() {
    // No initial state needed
  }

  Future<ForgotPasswordResponse> requestPasswordReset({
    required String email,
  }) async {
    state = const AsyncValue.loading();

    final response = await AsyncValue.guard(() async {
      final repository = ref.read(authRepositoryProvider);
      return await repository.forgotPassword(
        ForgotPasswordRequest(email: email),
      );
    });

    if (response.hasError) {
      state = AsyncValue.error(response.error!, response.stackTrace!);
      throw response.error!;
    }

    state = const AsyncValue.data(null);
    return response.value!;
  }

  Future<ResetPasswordResponse> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    state = const AsyncValue.loading();

    final response = await AsyncValue.guard(() async {
      final repository = ref.read(authRepositoryProvider);
      return await repository.resetPassword(
        ResetPasswordRequest(email: email, otp: otp, newPassword: newPassword),
      );
    });

    if (response.hasError) {
      state = AsyncValue.error(response.error!, response.stackTrace!);
      throw response.error!;
    }

    state = const AsyncValue.data(null);
    return response.value!;
  }
}
