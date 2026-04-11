import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_pm/src/features/auth/auth_state_providers.dart';

// Conditional import: on web loads BrowserHttpClientAdapter, stub on all others.
import 'dio_web_adapter_stub.dart'
    if (dart.library.html) 'dio_web_adapter_impl.dart';

part 'api_client.g.dart';

@Riverpod(keepAlive: true)
Dio dio(DioRef ref) {
  final dio = Dio();

  // Fix for Flutter Web: set BrowserHttpClientAdapter to avoid
  // "LegacyJavaScriptObject is not a subtype of FutureOr<ResponseBody>"
  configureWebAdapter(dio);

  // Get base URL from multiple sources (priority order):
  // 1. --dart-define=API_BASE_URL=... (from launch.json or command line)
  // 2. Fallback to production URL
  const dartDefineUrl = String.fromEnvironment('API_BASE_URL');
  String baseUrl = dartDefineUrl.isNotEmpty
      ? dartDefineUrl
      // : 'https://dasbackendapi.meridahr.com/api/';
      : 'http://192.168.18.40:8000/api/';

  if (defaultTargetPlatform == TargetPlatform.android &&
      !kIsWeb &&
      dartDefineUrl.isEmpty) {
    baseUrl = 'http://10.0.2.2:8000/api/';
  }

  // Log the base URL being used (helpful for debugging)
  debugPrint('🌐 API Base URL: $baseUrl');

  // Configure dio (base options, interceptors)
  dio.options.baseUrl = baseUrl;
  // Increased timeouts for slower networks/dev environments
  dio.options.connectTimeout = const Duration(seconds: 15);
  dio.options.receiveTimeout = const Duration(seconds: 15);
  // sendTimeout is not supported on Web without body
  if (!kIsWeb) {
    dio.options.sendTimeout = const Duration(seconds: 15);
  }

  // Add auth interceptor to include JWT token and Impersonation header
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      final prefs = await SharedPreferences.getInstance();

      // JWT Token
      final token = prefs.getString('access_token');
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
        // debugPrint('📡 API Request: ${options.method} ${options.path} [Auth: Yes]');
      } else {
        // debugPrint('📡 API Request: ${options.method} ${options.path} [Auth: No]');
      }

      // Impersonation Header for Admins viewing as another user
      final impersonateId = prefs.getString('impersonate_user_id');
      if (impersonateId != null && impersonateId.isNotEmpty) {
        options.headers['X-Impersonate-User'] = impersonateId;
      }

      return handler.next(options);
    },
    onError: (DioException error, handler) async {
      // Handle 401 Unauthorized errors
      if (error.response?.statusCode == 401) {
        debugPrint('🔒 401 Unauthorized [${error.requestOptions.path}] - clearing auth state');

        // Clear stored auth tokens
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('access_token');
        await prefs.remove('refresh_token');
        await prefs.remove('user_id');
        await prefs.remove('user_email');
        await prefs.remove('user_role');

        // Invalidate the auth state in the provider
        // Note: This will trigger a rebuild and redirect to login
        ref.invalidate(authNotifierProvider);

        debugPrint('🔒 Auth state cleared, user will be redirected to login');
      }

      return handler.next(error);
    },
  ));

  // Add interceptors for logging (optional)
  dio.interceptors.add(LogInterceptor(
    requestBody: true,
    responseBody: true,
  ));

  return dio;
}
