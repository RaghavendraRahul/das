import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../notes_provider.dart'; // For StickyNote model

class StickyNoteService {
  final Dio _dio;
  StickyNoteService(this._dio);

  Future<List<StickyNote>> fetchNotes() async {
    try {
      final response = await _dio.get('/sticky-notes/');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data is List
            ? response.data
            : (response.data['results'] ?? []);

        return data.map((json) => _fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching notes: $e');
      rethrow;
    }
  }

  Future<StickyNote> createNote(
      {required String title, required String content, required Color color}) async {
    try {
      final response = await _dio.post(
        '/sticky-notes/',
        data: {
          'title': title,
          'content': content,
          'color': _colorToHex(color),
        },
      );
      return _fromJson(response.data);
    } catch (e) {
      print('Error creating note: $e');
      rethrow;
    }
  }

  Future<StickyNote> updateNote(
      {required String id,
      String? title,
      String? content,
      Color? color,
      int? order}) async {
    try {
      final Map<String, dynamic> data = {};
      if (title != null) data['title'] = title;
      if (content != null) data['content'] = content;
      if (color != null) data['color'] = _colorToHex(color);
      if (order != null) data['order'] = order;

      final response = await _dio.patch(
        '/sticky-notes/$id/',
        data: data,
      );
      return _fromJson(response.data);
    } catch (e) {
      print('Error updating note: $e');
      rethrow;
    }
  }

  Future<void> deleteNote(String id) async {
    try {
      await _dio.delete('/sticky-notes/$id/');
    } catch (e) {
      print('Error deleting note: $e');
      rethrow;
    }
  }

  StickyNote _fromJson(Map<String, dynamic> json) {
    return StickyNote(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      color: _hexToColor(json['color']),
      order: json['order'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  String _colorToHex(Color color) {
    return '0x${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
  }

  Color _hexToColor(String? hex) {
    if (hex == null || hex.isEmpty) return const Color(0xFFFEF3C7);
    try {
      // Handle 0xFF... or #...
      if (hex.startsWith('0x')) {
        return Color(int.parse(hex));
      } else if (hex.startsWith('#')) {
        return Color(int.parse(hex.replaceAll('#', '0xFF')));
      }
      return Color(int.parse(hex));
    } catch (e) {
      return const Color(0xFFFEF3C7);
    }
  }
}
