import 'package:shared_preferences/shared_preferences.dart';

class SearchHistoryService {
  static const String _key = 'global_search_history';
  static const int _maxItems = 5;

  Future<List<String>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  Future<void> addToHistory(String query) async {
    if (query.trim().isEmpty) return;
    
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList(_key) ?? [];
    
    // Remove if already exists to move to top
    history.removeWhere((item) => item.toLowerCase() == query.toLowerCase());
    
    // Add to front
    history.insert(0, query.trim());
    
    // Keep only last N items
    if (history.length > _maxItems) {
      history.removeRange(_maxItems, history.length);
    }
    
    await prefs.setStringList(_key, history);
  }

  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
