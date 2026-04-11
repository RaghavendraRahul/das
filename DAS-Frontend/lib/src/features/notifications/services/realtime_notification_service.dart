import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:project_pm/src/core/networking/api_client.dart';
import 'package:project_pm/src/core/theme/theme_provider.dart';

final notificationStreamProvider =
    StreamProvider.autoDispose<Map<String, dynamic>>((ref) async* {
  final dio = ref.watch(dioProvider);
  final prefs = ref.watch(sharedPreferencesProvider);

  final baseUrl = dio.options.baseUrl;
  if (baseUrl.isEmpty) return;

  // Convert http/https to ws/wss
  String wsUrl = baseUrl.startsWith('https')
      ? baseUrl.replaceFirst('https', 'wss')
      : baseUrl.replaceFirst('http', 'ws');

  // Remove /api suffix if present to point to root or /ws
  // Backend routing expects /ws/notifications/
  if (wsUrl.endsWith('/api')) {
    wsUrl = wsUrl.substring(0, wsUrl.length - 4);
  } else if (wsUrl.endsWith('/api/')) {
    wsUrl = wsUrl.substring(0, wsUrl.length - 5);
  }

  wsUrl = '$wsUrl/ws/notifications/';

  // Retry loop
  while (true) {
    final token = prefs.getString('access_token');

    // If no token, wait and check again or yield nothing?
    // If logged out, we shouldn't act.
    // If token becomes available, this provider will likely be re-evaluated if we watch auth state.
    // For now, if no token, just break/return.
    if (token == null) return;

    final uri = Uri.parse('$wsUrl?token=$token');
    // print('Connecting to Notification WebSocket: $uri');

    try {
      final channel = WebSocketChannel.connect(uri);

      // We yield values from the stream
      await for (final message in channel.stream) {
        if (message is String) {
          try {
            final data = jsonDecode(message);
            if (data['type'] == 'notification' &&
                data['notification'] != null) {
              yield data['notification'] as Map<String, dynamic>;
            }
          } catch (e) {
            // print('Error parsing notification: $e');
          }
        }
      }
    } catch (e) {
      // print('WebSocket error: $e');
    }

    // Wait before reconnecting
    await Future.delayed(const Duration(seconds: 5));
  }
});
