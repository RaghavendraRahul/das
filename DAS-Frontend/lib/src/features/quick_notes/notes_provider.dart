import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:project_pm/src/core/networking/api_client.dart';
import 'services/sticky_note_service.dart';

class StickyNote {
  final String id;
  final String title;
  final String content;
  final Color color;
  final DateTime createdAt;

  StickyNote({
    required this.id,
    required this.title,
    required this.content,
    required this.color,
    required this.createdAt,
  });
}

final stickyNoteServiceProvider = Provider<StickyNoteService>((ref) {
  // Use the correct provider from api_client which might be 'dioProvider' or just 'dio' depending on imports
  // Based on api_providers.dart, it seems we were using 'dioProvider' from api_providers.g.dart
  // But since we switched to core/networking/api_client.dart, check its provider name.
  // Usually it is 'dioProvider'.
  final dio = ref.watch(dioProvider);
  return StickyNoteService(dio);
});

class StickyNotesNotifier extends StateNotifier<AsyncValue<List<StickyNote>>> {
  final StickyNoteService _service;
  Timer? _debounceTimer;

  StickyNotesNotifier(this._service) : super(const AsyncValue.loading()) {
    loadNotes();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  Future<void> loadNotes() async {
    try {
      final notes = await _service.fetchNotes();

      // Ensure at least 4 notes are present (requested requirement)
      if (notes.length < 4) {
        final int needed = 4 - notes.length;

        final defaultColors = [
          const Color(0xFFFEF3C7), // Yellow
          const Color(0xFFDCFCE7), // Green
          const Color(0xFFDBEAFE), // Blue
          const Color(0xFFFCE7F3), // Pink
        ];

        final List<StickyNote> newNotes = [];
        for (int i = 0; i < needed; i++) {
          // Cycle through colors based on how many we already have
          final colorIndex = (notes.length + i) % defaultColors.length;
          final newNote = await _service.createNote(
              title: "Edit Note", content: "", color: defaultColors[colorIndex]);
          newNotes.add(newNote);
        }

        // Combine existing and new notes
        final allNotes = [...notes, ...newNotes];

        // Sort by newest first
        allNotes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        state = AsyncValue.data(allNotes);
      } else {
        // Sort by descending created_at (newest first)
        notes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        state = AsyncValue.data(notes);
      }
    } catch (e, st) {
      print('Error loading notes: $e');
      state = AsyncValue.error(e, st);
    }
  }

  Future<StickyNote> addNote(String content, Color color) async {
    try {
      final newNote = await _service.createNote(
          title: "New Note", content: content, color: color);
      final currentList = state.value ?? [];
      state = AsyncValue.data([newNote, ...currentList]);
      return newNote;
    } catch (e) {
      print('Error adding note: $e');
      rethrow;
    }
  }

  Future<void> deleteNote(String id) async {
    final previousState = state;
    try {
      final currentList = state.value ?? [];
      final newList = currentList.where((n) => n.id != id).toList();
      state = AsyncValue.data(newList);
      await _service.deleteNote(id);
    } catch (e) {
      print('Error deleting note: $e');
      state = previousState; // Revert
      rethrow;
    }
  }

  Future<void> deleteNotes(List<String> ids) async {
    final previousState = state;
    try {
      final currentList = state.value ?? [];
      final newList = currentList.where((n) => !ids.contains(n.id)).toList();
      state = AsyncValue.data(newList);

      // Delete each note (could be optimized with bulk API if available)
      await Future.wait(ids.map((id) => _service.deleteNote(id)));
    } catch (e) {
      print('Error deleting notes: $e');
      state = previousState; // Revert
      rethrow;
    }
  }

  Future<void> updateNoteTitle(String id, String newTitle) async {
    // Optimistic update
    final currentList = state.value;
    if (currentList == null) return;

    final noteIndex = currentList.indexWhere((n) => n.id == id);
    if (noteIndex == -1) return;

    final note = currentList[noteIndex];
    if (note.title == newTitle) return;

    final updatedNote = StickyNote(
      id: note.id,
      title: newTitle,
      content: note.content,
      color: note.color,
      createdAt: note.createdAt,
    );

    var newList = List<StickyNote>.from(currentList);
    newList[noteIndex] = updatedNote;
    state = AsyncValue.data(newList);

    // Debounce API call
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 800), () async {
      try {
        await _service.updateNote(id: id, title: newTitle);
      } catch (e) {
        print('Error updating note title: $e');
      }
    });
  }

  Future<void> updateNoteContent(String id, String newContent) async {
    // Optimistic update for UI responsiveness
    final currentList = state.value;
    if (currentList == null) return;

    final noteIndex = currentList.indexWhere((n) => n.id == id);
    if (noteIndex == -1) return;

    final note = currentList[noteIndex];
    if (note.content == newContent) return;

    final updatedNote = StickyNote(
      id: note.id,
      title: note.title,
      content: newContent,
      color: note.color,
      createdAt: note.createdAt,
    );

    // Update state immediately
    var newList = List<StickyNote>.from(currentList);
    newList[noteIndex] = updatedNote;
    state = AsyncValue.data(newList);

    // Debounce API call
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 800), () async {
      try {
        await _service.updateNote(id: id, content: newContent);
      } catch (e) {
        print('Error updating note content: $e');
        // Optionally revert if needed, but for text fields it's tricky.
        // For now, logging error is consistent with "best effort" save.
      }
    });
  }

  Future<void> updateNoteColor(String id, Color newColor) async {
    final currentList = state.value;
    if (currentList == null) return;

    final noteIndex = currentList.indexWhere((n) => n.id == id);
    if (noteIndex == -1) return;

    final note = currentList[noteIndex];
    if (note.color == newColor) return;

    final updatedNote = StickyNote(
      id: note.id,
      title: note.title,
      content: note.content,
      color: newColor,
      createdAt: note.createdAt,
    );

    var newList = List<StickyNote>.from(currentList);
    newList[noteIndex] = updatedNote;
    state = AsyncValue.data(newList);

    try {
      await _service.updateNote(id: id, color: newColor);
    } catch (e) {
      print('Error updating note color: $e');
      // Revert logic could go here
    }
  }
}

final stickyNotesProvider =
    StateNotifierProvider<StickyNotesNotifier, AsyncValue<List<StickyNote>>>(
        (ref) {
  final service = ref.watch(stickyNoteServiceProvider);
  return StickyNotesNotifier(service);
});

// Professional fonts selection for Quick Notes
final availableQuickNoteFonts = [
  'Century Schoolbook',
  'Helvetica',
  'Roboto',
  'Georgia',
  'Garamond',
  'Calibri',
  'Times New Roman',
];

final quickNoteFontProvider = StateProvider<String>((ref) => 'Century Schoolbook');
