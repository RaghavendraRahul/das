import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_pm/src/core/theme/theme_provider.dart';

part 'planner_settings_provider.g.dart';

@riverpod
class PlannerSettings extends _$PlannerSettings {
  static const _isQuadrantViewKey = 'planner_is_quadrant_view';

  @override
  bool build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return prefs.getBool(_isQuadrantViewKey) ?? true;
  }

  Future<void> toggleLayout() async {
    final prefs = ref.read(sharedPreferencesProvider);
    final newValue = !state;
    await prefs.setBool(_isQuadrantViewKey, newValue);
    state = newValue;
  }

  Future<void> setQuadrantView(bool enabled) async {
    if (state == enabled) return;
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(_isQuadrantViewKey, enabled);
    state = enabled;
  }
}
