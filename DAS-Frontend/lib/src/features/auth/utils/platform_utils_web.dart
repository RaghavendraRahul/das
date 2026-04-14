import 'dart:html' as html;

/// Web implementation of platform utilities
class PlatformUtils {
  static String getCurrentUrl() => html.window.location.href;
  
  static void cleanUrl() {
    try {
      html.window.history.replaceState(null, '', '/');
    } catch (e) {
      // Ignore cleanup errors
    }
  }
}
