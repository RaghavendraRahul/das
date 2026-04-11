import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:project_pm/src/core/networking/api_client.dart';
import 'package:project_pm/src/features/today/models/catalog_model.dart';

part 'catalog_service.g.dart';

@riverpod
CatalogService catalogService(CatalogServiceRef ref) {
  return CatalogService(ref.watch(dioProvider));
}

class CatalogService {
  final Dio _dio;

  CatalogService(this._dio);

  Future<CatalogItem> createCatalog(CreateCatalogRequest request) async {
    try {
      final response = await _dio.post(
        '/catalog/',
        data: {
          'name': request.name,
          'description': request.description,
          'catalog_type': request.catalogType,
          'is_active': request.isActive,
        },
      );

      return CatalogItem.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to create catalog: ${e.message}');
    }
  }

  Future<List<CatalogItem>> getCatalogs() async {
    try {
      final response = await _dio.get('/catalog/');
      return (response.data as List)
          .map((item) => CatalogItem.fromJson(item))
          .toList();
    } on DioException catch (e) {
      throw Exception('Failed to fetch catalogs: ${e.message}');
    }
  }

  Future<void> deleteCatalog(int id) async {
    try {
      await _dio.delete('/catalog/$id/');
    } on DioException catch (e) {
      throw Exception('Failed to delete catalog: ${e.message}');
    }
  }
}
