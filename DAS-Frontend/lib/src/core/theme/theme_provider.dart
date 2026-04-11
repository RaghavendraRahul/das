import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:shared_preferences/shared_preferences.dart';

/// Provider for SharedPreferences instance (must be overridden in main.dart)
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

/// Theme mode: light, dark, or system
enum AppThemeMode { light, dark, system }

/// Theme state notifier
class ThemeNotifier extends StateNotifier<AppThemeMode> {
  final SharedPreferences? _prefs;
  static const _key = 'theme_mode';

  ThemeNotifier(this._prefs) : super(_loadFromPrefs(_prefs));

  static AppThemeMode _loadFromPrefs(SharedPreferences? prefs) {
    if (prefs == null) return AppThemeMode.system;
    try {
      final saved = prefs.getString(_key);
      if (saved == 'light') return AppThemeMode.light;
      if (saved == 'dark') return AppThemeMode.dark;
    } catch (e) {
      debugPrint('Error reading theme from prefs: $e');
    }
    return AppThemeMode.system;
  }

  void setTheme(AppThemeMode mode) {
    state = mode;
    _saveToPrefs(mode);
  }

  void toggleTheme() {
    if (state == AppThemeMode.light) {
      setTheme(AppThemeMode.dark);
    } else {
      setTheme(AppThemeMode.light);
    }
  }

  Future<void> _saveToPrefs(AppThemeMode mode) async {
    if (_prefs == null) return;
    try {
      if (mode == AppThemeMode.light) {
        await _prefs!.setString(_key, 'light');
      } else if (mode == AppThemeMode.dark) {
        await _prefs!.setString(_key, 'dark');
      } else {
        await _prefs!.remove(_key);
      }
    } catch (e) {
      debugPrint('Error saving theme to prefs: $e');
    }
  }
}

/// Provider for theme mode
final themeNotifierProvider =
    StateNotifierProvider<ThemeNotifier, AppThemeMode>((ref) {
  SharedPreferences? prefs;
  try {
    prefs = ref.watch(sharedPreferencesProvider);
  } catch (_) {
    // Fallback if sharedPreferencesProvider throws
  }
  return ThemeNotifier(prefs);
});

/// Resolved ThemeMode based on AppThemeMode
final resolvedThemeModeProvider = Provider<ThemeMode>((ref) {
  final appThemeMode = ref.watch(themeNotifierProvider);
  switch (appThemeMode) {
    case AppThemeMode.light:
      return ThemeMode.light;
    case AppThemeMode.dark:
      return ThemeMode.dark;
    case AppThemeMode.system:
      return ThemeMode.system;
  }
});

/// Check if currently in dark mode (considers system)
final isDarkModeProvider = Provider<bool>((ref) {
  final appThemeMode = ref.watch(themeNotifierProvider);
  switch (appThemeMode) {
    case AppThemeMode.light:
      return false;
    case AppThemeMode.dark:
      return true;
    case AppThemeMode.system:
      final brightness =
          SchedulerBinding.instance.platformDispatcher.platformBrightness;
      return brightness == Brightness.dark;
  }
});

/// Dark theme colors (matching React Tailwind dark: classes)
class DarkColors {
  static const background = Color(0xFF111827); // gray-900
  static const surface = Color(0xFF1F2937); // gray-800
  static const surfaceAlt = Color(0xFF374151); // gray-700
  static const border = Color(0xFF374151); // gray-700
  static const text = Color(0xFFF9FAFB); // gray-50
  static const textMuted = Color(0xFF9CA3AF); // gray-400
  static const textSecondary = Color(0xFF6B7280); // gray-500
}

/// Light theme colors
class LightColors {
  static const background = Color(0xFFF8FAFC); // slate-50
  static const surface = Colors.white;
  static const surfaceAlt = Color(0xFFF1F5F9); // slate-100
  static const border = Color(0xFFE2E8F0); // slate-200
  static const text = Color(0xFF1E293B); // slate-800
  static const textMuted = Color(0xFF64748B); // slate-500
  static const textSecondary = Color(0xFF94A3B8); // slate-400
}

/// Light theme
final lightTheme = _buildTheme(Brightness.light);

/// Dark theme
final darkTheme = _buildTheme(Brightness.dark);

ThemeData _buildTheme(Brightness brightness) {
  final isDark = brightness == Brightness.dark;

  // Use Inter for core text, Outfit for headlines
  final baseTextTheme = GoogleFonts.interTextTheme(
    isDark ? ThemeData.dark().textTheme : ThemeData.light().textTheme,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: brightness,
      surface: isDark ? DarkColors.surface : LightColors.surface,
      onSurface: isDark ? DarkColors.text : LightColors.text,
      outline: isDark ? DarkColors.border : LightColors.border,
    ),
    scaffoldBackgroundColor:
        isDark ? DarkColors.background : LightColors.background,
    cardColor: isDark ? DarkColors.surface : LightColors.surface,
    dividerColor: isDark ? DarkColors.border : LightColors.border,
    appBarTheme: AppBarTheme(
      backgroundColor: isDark ? DarkColors.surface : LightColors.surface,
      foregroundColor: isDark ? DarkColors.text : LightColors.text,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      titleTextStyle: GoogleFonts.outfit(
        color: isDark ? DarkColors.text : LightColors.text,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
    iconTheme: IconThemeData(
        color: isDark ? DarkColors.textMuted : LightColors.textMuted),
    textTheme: baseTextTheme.copyWith(
      displayLarge: GoogleFonts.outfit(
        textStyle: baseTextTheme.displayLarge,
        fontWeight: FontWeight.bold,
        color: isDark ? DarkColors.text : LightColors.text,
      ),
      displayMedium: GoogleFonts.outfit(
        textStyle: baseTextTheme.displayMedium,
        fontWeight: FontWeight.bold,
        color: isDark ? DarkColors.text : LightColors.text,
      ),
      displaySmall: GoogleFonts.outfit(
        textStyle: baseTextTheme.displaySmall,
        fontWeight: FontWeight.bold,
        color: isDark ? DarkColors.text : LightColors.text,
      ),
      headlineLarge: GoogleFonts.outfit(
        textStyle: baseTextTheme.headlineLarge,
        fontWeight: FontWeight.w600,
        color: isDark ? DarkColors.text : LightColors.text,
      ),
      headlineMedium: GoogleFonts.outfit(
        textStyle: baseTextTheme.headlineMedium,
        fontWeight: FontWeight.w600,
        color: isDark ? DarkColors.text : LightColors.text,
      ),
      headlineSmall: GoogleFonts.outfit(
        textStyle: baseTextTheme.headlineSmall,
        fontWeight: FontWeight.w600,
        color: isDark ? DarkColors.text : LightColors.text,
      ),
      titleLarge: GoogleFonts.outfit(
        textStyle: baseTextTheme.titleLarge,
        fontWeight: FontWeight.w600,
        color: isDark ? DarkColors.text : LightColors.text,
      ),
      titleMedium: baseTextTheme.titleMedium?.copyWith(
        color: isDark ? DarkColors.text : LightColors.text,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: baseTextTheme.bodyLarge?.copyWith(
        color: isDark ? DarkColors.text : LightColors.text,
      ),
      bodyMedium: baseTextTheme.bodyMedium?.copyWith(
        color: isDark ? DarkColors.text : LightColors.text,
      ),
      bodySmall: baseTextTheme.bodySmall?.copyWith(
        color: isDark ? DarkColors.textMuted : LightColors.textMuted,
      ),
      labelLarge: baseTextTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: isDark ? DarkColors.surfaceAlt : LightColors.surfaceAlt,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide:
            BorderSide(color: isDark ? DarkColors.border : LightColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide:
            BorderSide(color: isDark ? DarkColors.border : LightColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.blue, width: 2),
      ),
      hintStyle: TextStyle(
          color: isDark ? DarkColors.textMuted : LightColors.textMuted),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        side:
            BorderSide(color: isDark ? DarkColors.border : LightColors.border),
        foregroundColor: isDark ? DarkColors.text : LightColors.text,
        textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14),
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
              color: isDark ? DarkColors.border : LightColors.border)),
      color: isDark ? DarkColors.surface : LightColors.surface,
      margin: EdgeInsets.zero,
    ),
    dialogTheme: DialogThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: isDark ? DarkColors.surface : LightColors.surface,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: GoogleFonts.outfit(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: isDark ? DarkColors.text : LightColors.text,
      ),
    ),
    dataTableTheme: DataTableThemeData(
      headingRowColor: WidgetStateProperty.all(
          isDark ? DarkColors.surfaceAlt : LightColors.surfaceAlt),
      dataRowColor: WidgetStateProperty.all(
          isDark ? DarkColors.surface : LightColors.surface),
      dividerThickness: 1,
      horizontalMargin: 24,
      columnSpacing: 24,
      headingTextStyle: GoogleFonts.inter(
          fontWeight: FontWeight.bold,
          color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
          fontSize: 13),
    ),
  );
}
