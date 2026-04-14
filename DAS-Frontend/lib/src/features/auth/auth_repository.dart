import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:project_pm/src/core/networking/api_client.dart';
import 'package:project_pm/src/features/auth/models/auth_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository.g.dart';

@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepository(ref.watch(dioProvider));
}

class AuthRepository {
  final Dio _dio;

  AuthRepository(this._dio);

  // Helper method to handle Dio exceptions and return user-friendly messages
  Exception _handleDioException(DioException e) {
    if (e.response != null) {
      // Handle backend errors (4xx, 5xx)
      final statusCode = e.response!.statusCode;
      final data = e.response!.data;

      String errorMessage = 'Something went wrong. Please try again.';

      if (data is Map<String, dynamic>) {
        if (data.containsKey('error')) {
          errorMessage = data['error'];
        } else if (data.containsKey('detail')) {
          errorMessage = data['detail'];
        } else if (data.containsKey('message')) {
          errorMessage = data['message'];
        } else if (data.containsKey('non_field_errors') &&
            data['non_field_errors'] is List &&
            data['non_field_errors'].isNotEmpty) {
          errorMessage = data['non_field_errors'][0].toString();
        } else if (statusCode == 400 && data.isNotEmpty) {
          final firstValue = data.values.first;
          if (firstValue is List && firstValue.isNotEmpty) {
            errorMessage = firstValue[0].toString();
          }
        }
      } else if (data is String && data.isNotEmpty && data.length < 100) {
        errorMessage = data;
      }

      if (statusCode == 401) {
        return Exception(
            'Invalid credentials. Please check your email and password.');
      } else if (statusCode == 403) {
        return Exception(
            'Access denied. You do not have permission to perform this action.');
      } else if (statusCode == 404) {
        return Exception('Resource not found.');
      } else if (statusCode == 500) {
        return Exception('Server error. Please try again later.');
      }

      return Exception(errorMessage);
    } else {
      // Handle connection/network errors
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return Exception(
              'Connection timed out. Please check your internet connection.');
        case DioExceptionType.connectionError:
          return Exception(
              'Unable to connect to the server. Please check your internet connection or try again later.');
        case DioExceptionType.cancel:
          return Exception('Request cancelled.');
        default:
          return Exception(
              'Network error occurred. Please check your connection.');
      }
    }
  }

  /// Login user
  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await _dio.post(
        '/login/',
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        return LoginResponse.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to login');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// Request signup (sends OTP to admin)
  Future<SignupResponse> signup(SignupRequest request) async {
    try {
      final response = await _dio.post(
        '/signup/',
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        return SignupResponse.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to signup');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// Verify signup with OTP
  Future<VerifySignupResponse> verifySignup(VerifySignupRequest request) async {
    try {
      final response = await _dio.post(
        '/verify-signup/',
        data: request.toJson(),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return VerifySignupResponse.fromJson(
            response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to verify signup');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// Request password reset (sends OTP to user email)
  Future<ForgotPasswordResponse> forgotPassword(
      ForgotPasswordRequest request) async {
    try {
      final response = await _dio.post(
        '/forgot-password/',
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        return ForgotPasswordResponse.fromJson(
            response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to request password reset');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// Reset password with OTP
  Future<ResetPasswordResponse> resetPassword(
      ResetPasswordRequest request) async {
    try {
      final response = await _dio.post(
        '/reset-password/',
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        return ResetPasswordResponse.fromJson(
            response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to reset password');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// Auto-login with HRM code
  Future<Map<String, dynamic>> autoLoginWithHRMCode({
    required String code,
    required String email,
  }) async {
    try {
      debugPrint(
          '🔵 [AutoLogin] Starting auto-login - code: ${code.substring(0, 10)}..., email: $email');

      final response = await _dio.post(
        '/auto-login/login/',
        data: {
          'code': code,
          'email': email,
        },
      );

      debugPrint('✅ [AutoLogin] Response status: ${response.statusCode}');
      debugPrint('✅ [AutoLogin] Response data: ${response.data}');

      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        debugPrint(
            '✅ [AutoLogin] Success - User: ${responseData['email']}, Role: ${responseData['role']}');
        return responseData;
      } else {
        debugPrint('❌ [AutoLogin] Failed - Status: ${response.statusCode}');
        throw Exception('Failed to auto-login with HRM code');
      }
    } on DioException catch (e) {
      debugPrint(
          '❌ [AutoLogin] DioException - Type: ${e.type}, Status: ${e.response?.statusCode}');
      debugPrint('❌ [AutoLogin] Error: ${e.message}');
      debugPrint('❌ [AutoLogin] Response: ${e.response?.data}');
      throw _handleDioException(e);
    } catch (e) {
      debugPrint('❌ [AutoLogin] Unexpected error: $e');
      rethrow;
    }
  }

  /// Update quick notes dashboard label
  Future<void> updateQuickNotesLabel(String label) async {
    try {
      await _dio.patch(
        '/user-preferences/update_label/',
        data: {'quick_notes_label': label},
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }
}
