import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

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
  // 2. .env file loaded via flutter_dotenv
  // 3. Fallback to production/localhost defaults
  const dartDefineUrl = String.fromEnvironment('API_BASE_URL');
  final envUrl = dotenv.maybeGet('API_BASE_URL');

  String baseUrl = dartDefineUrl.isNotEmpty
      ? dartDefineUrl
      : (envUrl != null && envUrl.isNotEmpty)
          ? envUrl
          : 'http://127.0.0.1:8000/api/';
          // : 'https://dasbackendapi.meridahr.com/api/';


  if (defaultTargetPlatform == TargetPlatform.android &&
      !kIsWeb &&
      dartDefineUrl.isEmpty &&
      (envUrl == null || envUrl.isEmpty)) {
    baseUrl = 'http://10.0.2.2:8000/api/';
  }

  // Log the base URL being used (helpful for debugging)
  debugPrint('🌐 API Base URL: $baseUrl');

  // Configure dio (base options, interceptors)
  dio.options.baseUrl = baseUrl;

  // Increased timeouts for slower networks/dev environments as per user feedback
  // Using 60 seconds to ensure large data fetches complete successfully
  dio.options.connectTimeout = const Duration(seconds: 60);
  dio.options.receiveTimeout = const Duration(seconds: 60);

  // sendTimeout is not supported on Web without body
  if (!kIsWeb) {
    dio.options.sendTimeout = const Duration(seconds: 60);
  }

  // Add Smart Retry Interceptor
  dio.interceptors.add(InterceptorsWrapper(
    onError: (DioException err, handler) async {
      // Retry only on connection/timeout errors up to 3 times
      final isTimeout = err.type == DioExceptionType.connectionTimeout ||
          err.type == DioExceptionType.receiveTimeout ||
          err.type == DioExceptionType.sendTimeout ||
          err.type == DioExceptionType.connectionError;

      int retryCount = err.requestOptions.extra['retry_count'] ?? 0;

      if (isTimeout && retryCount < 3) {
        retryCount++;
        debugPrint(
            '🔄 Retrying request (${err.requestOptions.path}) - Attempt $retryCount');

        final options = err.requestOptions;
        options.extra['retry_count'] = retryCount;

        // Add a small delay before retry
        await Future.delayed(Duration(milliseconds: 1000 * retryCount));

        try {
          final response = await dio.fetch(options);
          return handler.resolve(response);
        } catch (e) {
          // If retry fails, continue with error handling
        }
      }
      return handler.next(err);
    },
  ));

  // Add auth interceptor to include JWT token and Impersonation header
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      final prefs = await SharedPreferences.getInstance();

      // JWT Token
      final token = prefs.getString('access_token');
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
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
        final requestOptions = error.requestOptions;

        // Avoid infinite refresh loops
        if (requestOptions.extra['is_retry'] == true) {
          return handler.next(error);
        }

        debugPrint(
            '🔒 401 Unauthorized [${requestOptions.path}] - Attempting token refresh');

        try {
          final prefs = await SharedPreferences.getInstance();
          final refreshToken = prefs.getString('refresh_token');

          if (refreshToken != null) {
            // Use a clean Dio instance to avoid interceptor recursion
            final refreshDio = Dio(BaseOptions(baseUrl: dio.options.baseUrl));
            final response = await refreshDio.post('token/refresh/', data: {
              'refresh': refreshToken,
            });

            if (response.statusCode == 200) {
              final newAccessToken = response.data['access'];
              debugPrint(
                  '✅ Token refresh successful. Retrying original request.');

              // Save new access token
              await prefs.setString('access_token', newAccessToken);

              // Update headers and retry request
              requestOptions.headers['Authorization'] =
                  'Bearer $newAccessToken';
              requestOptions.extra['is_retry'] = true;

              final retryResponse = await dio.fetch(requestOptions);
              return handler.resolve(retryResponse);
            }
          }
        } catch (e) {
          debugPrint('❌ Token refresh failed: $e');
        }

        // If refresh fails or no refresh token, clear auth state
        debugPrint('🚫 Session expired - clearing auth state');
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('access_token');
        await prefs.remove('refresh_token');
        await prefs.remove('user_id');
        await prefs.remove('user_email');
        await prefs.remove('user_role');

        ref.invalidate(authNotifierProvider);
      }

      return handler.next(error);
    },
  ));

  // Add interceptors for logging (optional)
  if (kDebugMode) {
    dio.interceptors.add(LogInterceptor(
      requestBody: false, // Set to false to reduce console noise during retries
      responseBody: false,
    ));
  }

  return dio;
}
