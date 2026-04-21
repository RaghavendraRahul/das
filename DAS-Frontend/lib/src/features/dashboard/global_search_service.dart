import 'package:project_pm/src/features/projects/services/task_api_service.dart';
import 'package:flutter/material.dart';
import 'models/search_result.dart';

class GlobalSearchService {
  final TaskApiService _apiService;

  GlobalSearchService(this._apiService);

  Future<List<GlobalSearchResult>> search(String query) async {
    try {
      final response = await _apiService.dio.get(
        'global-search/',
        queryParameters: {'q': query},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => GlobalSearchResult.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('Error in global search: $e');
      return [];
    }
  }
}
