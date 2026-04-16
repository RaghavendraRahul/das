import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:project_pm/src/features/quick_notes/notes_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';

@RoutePage()
class QuickNotesPage extends HookConsumerWidget {
  const QuickNotesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncNotes = ref.watch(stickyNotesProvider);
    final userNotes = asyncNotes.valueOrNull ?? [];
    final isLoading = asyncNotes.isLoading;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    // State for the currently selected/active note
    final selectedNoteId = useState<String?>(null);
    final isSelectionMode = useState(false);
    final selectedIds = useState<Set<String>>({});
    final selectedFont = ref.watch(quickNoteFontProvider);

    // If notes exist but none selected, select the first one
    useEffect(() {
      if (userNotes.isNotEmpty && selectedNoteId.value == null) {
        selectedNoteId.value = userNotes.first.id;
      }
      return null;
    }, [userNotes.length]);

    // Ensure selected note still exists (handled by firstWhere orElse)
    final activeNote = userNotes.firstWhere(
      (n) => n.id == selectedNoteId.value,
      orElse: () => StickyNote(
        id: 'placeholder',
        title: '',
        content: '',
        color: const Color(0xFFFEF3C7),
        createdAt: DateTime.now(),
      ),
    );

    final mousePos = useState<Offset>(Offset.zero);

    if (isLoading && userNotes.isEmpty) {
      return Scaffold(
        backgroundColor: isDark ? const Color(0xFF1F2937) : Colors.white,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (asyncNotes.hasError) {
      return Scaffold(
        backgroundColor: isDark ? const Color(0xFF1F2937) : Colors.white,
        body: Center(child: Text('Error: ${asyncNotes.error}')),
      );
    }

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1F2937) : Colors.white,
      body: Row(
        children: [
          // Left Sidebar for Sticky Note Templates
          _StickyNotesSidebar(
            isDark: isDark,
            isSelectionMode: isSelectionMode,
            selectedIds: selectedIds,
            onAddNote: (color) async {
              try {
                // Return the new note so we can select it
                final newNote = await ref
                    .read(stickyNotesProvider.notifier)
                    .addNote("New Note", color);
                selectedNoteId.value = newNote.id;
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Failed to create note: $e")),
                );
              }
            },
            onSelectNote: (id) {
              selectedNoteId.value = id;
            },
            onDeleteNotes: (ids) async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Delete Selected Notes?'),
                  content: Text(
                      'Are you sure you want to delete ${ids.length} notes?'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text('Cancel')),
                    TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        style:
                            TextButton.styleFrom(foregroundColor: Colors.red),
                        child: const Text('Delete')),
                  ],
                ),
              );

              if (confirm == true) {
                await ref.read(stickyNotesProvider.notifier).deleteNotes(ids);
                isSelectionMode.value = false;
                selectedIds.value = {};
                // If the currently selected note was deleted, reset selection
                if (ids.contains(selectedNoteId.value)) {
                  selectedNoteId.value = null; // Will auto-select next
                }
              }
            },
            notes: userNotes, // Pass notes to sidebar if we want to list them
            selectedNoteId: selectedNoteId.value,
          ),

          // Main Canvas Area
          Expanded(
            child: MouseRegion(
              onHover: (event) => mousePos.value = event.localPosition,
              child: Column(
                children: [
                  // Canvas with Dotted Background
                  Expanded(
                    child: Stack(
                      children: [
                        // Background Pattern
                        Positioned.fill(
                          child: CustomPaint(
                            painter: _DottedBackgroundPainter(
                              color: isDark
                                  ? Colors.white.withOpacity(0.05)
                                  : Colors.grey.shade300,
                              mousePosition: mousePos.value,
                            ),
                          ),
                        ),

                        // The Active Note (Large View)
                        if (userNotes.isNotEmpty &&
                            selectedNoteId.value != null &&
                            activeNote.id != 'placeholder')
                          Positioned.fill(
                            child: _EditableStickyNote(
                              key: ValueKey(
                                  activeNote.id), // Important for state reset
                              note: activeNote,
                              isDark: isDark,
                              onUpdate: (content) {
                                ref
                                    .read(stickyNotesProvider.notifier)
                                    .updateNoteContent(activeNote.id, content);
                              },
                              onTitleUpdate: (title) {
                                ref
                                    .read(stickyNotesProvider.notifier)
                                    .updateNoteTitle(activeNote.id, title);
                              },
                              onDelete: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text('Delete Note?'),
                                    content: const Text(
                                        'Are you sure you want to delete this note?'),
                                    actions: [
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.pop(ctx, false),
                                          child: const Text('Cancel')),
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.pop(ctx, true),
                                          style: TextButton.styleFrom(
                                              foregroundColor: Colors.red),
                                          child: const Text('Delete')),
                                    ],
                                  ),
                                );

                                if (confirm == true) {
                                  await ref
                                      .read(stickyNotesProvider.notifier)
                                      .deleteNote(activeNote.id);
                                  selectedNoteId.value =
                                      null; // Will auto-select next
                                }
                              },
                            ),
                          )
                        else if (userNotes.isEmpty)
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.note_add_outlined,
                                    size: 48,
                                    color: isDark
                                        ? Colors.grey
                                        : Colors.grey.shade400),
                                const SizedBox(height: 16),
                                Text(
                                  "No notes created yet.\nSelect a color from the sidebar to start.",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    color: isDark
                                        ? Colors.grey.shade400
                                        : Colors.grey.shade500,
                                    fontSize: 15,
                                    height: 1.5,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.touch_app_outlined,
                                    size: 48,
                                    color: isDark
                                        ? Colors.grey
                                        : Colors.grey.shade400),
                                const SizedBox(height: 16),
                                Text(
                                  "Select a note to view details",
                                  style: GoogleFonts.inter(
                                    color: isDark
                                        ? Colors.grey
                                        : Colors.grey.shade500,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StickyNotesSidebar extends HookWidget {
  final bool isDark;
  final Function(Color) onAddNote;
  final Function(String) onSelectNote;
  final Function(List<String>) onDeleteNotes;
  final List<StickyNote> notes;
  final String? selectedNoteId;
  final ValueNotifier<bool> isSelectionMode;
  final ValueNotifier<Set<String>> selectedIds;

  const _StickyNotesSidebar({
    required this.isDark,
    required this.onAddNote,
    required this.onSelectNote,
    required this.onDeleteNotes,
    required this.isSelectionMode,
    required this.selectedIds,
    this.notes = const [],
    this.selectedNoteId,
  });

  final List<Color> _templates = const [
    Color(0xFFFEF3C7), // Yellow
    Color(0xFFDCFCE7), // Green
    Color(0xFFDBEAFE), // Blue
    Color(0xFFFFF7ED), // Orange/Peach
    Color(0xFFFCE7F3), // Pink
    Color(0xFFF3E8FF), // Purple
  ];

  @override
  Widget build(BuildContext context) {
    // Sort notes: Newest first (standard for "quick notes")
    final sortedNotes = List<StickyNote>.from(notes)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF111827).withOpacity(0.8)
            : Colors.white.withOpacity(0.8),
        border: Border(
            right: BorderSide(
                color: isDark ? Colors.white10 : Colors.grey.shade200)),
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                child: isSelectionMode.value
                    ? Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              isSelectionMode.value = false;
                              selectedIds.value = {};
                            },
                            icon: const Icon(Icons.close, size: 20),
                            color: isDark
                                ? Colors.grey.shade400
                                : Colors.grey.shade600,
                          ),
                          Text(
                            "${selectedIds.value.length}",
                            style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black87),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              if (selectedIds.value.length ==
                                  sortedNotes.length) {
                                selectedIds.value = {};
                              } else {
                                selectedIds.value =
                                    sortedNotes.map((n) => n.id).toSet();
                              }
                            },
                            icon: Icon(
                              selectedIds.value.length == sortedNotes.length
                                  ? Icons.deselect_outlined
                                  : Icons.select_all,
                              size: 20,
                            ),
                            color: isDark ? Colors.blue.shade300 : Colors.blue,
                          ),
                          IconButton(
                            onPressed: () {
                              if (selectedIds.value.isNotEmpty) {
                                onDeleteNotes(selectedIds.value.toList());
                              }
                            },
                            icon: const Icon(Icons.delete_outline, size: 20),
                            color: Colors.red.withOpacity(0.8),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Text("Sticky Notes",
                              style: GoogleFonts.outfit(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.5,
                                  color:
                                      isDark ? Colors.white : Colors.black87)),
                          const Spacer(),
                          Container(
                            decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.grey.shade800
                                    : Colors.grey.shade100,
                                shape: BoxShape.circle),
                            child: IconButton(
                                onPressed: () {
                                  final randomColor = _templates[
                                      DateTime.now().millisecond %
                                          _templates.length];
                                  onAddNote(randomColor);
                                },
                                icon: const Icon(Icons.add, size: 20),
                                color: isDark ? Colors.white : Colors.black87),
                          ),
                        ],
                      ),
              ),
              const Divider(height: 1),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: sortedNotes.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.9,
                  ),
                  itemBuilder: (context, index) {
                    final note = sortedNotes[index];
                    return _SidebarNoteItem(
                      index: index,
                      note: note,
                      isSelected: note.id == selectedNoteId,
                      isMultiSelected: selectedIds.value.contains(note.id),
                      isSelectionMode: isSelectionMode.value,
                      isDark: isDark,
                      onTap: () {
                        if (isSelectionMode.value) {
                          final newSet = Set<String>.from(selectedIds.value);
                          if (newSet.contains(note.id)) {
                            newSet.remove(note.id);
                          } else {
                            newSet.add(note.id);
                          }
                          selectedIds.value = newSet;
                        } else {
                          onSelectNote(note.id);
                        }
                      },
                      onLongPress: () {
                        isSelectionMode.value = true;
                        selectedIds.value = {...selectedIds.value, note.id};
                      },
                      onDelete: () => onDeleteNotes([note.id]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SidebarNoteItem extends HookConsumerWidget {
  final int index;
  final StickyNote note;
  final bool isSelected;
  final bool isMultiSelected;
  final bool isSelectionMode;
  final bool isDark;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onDelete;

  const _SidebarNoteItem({
    required this.index,
    required this.note,
    required this.isSelected,
    required this.isMultiSelected,
    required this.isSelectionMode,
    required this.isDark,
    required this.onTap,
    required this.onLongPress,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isHovered = useState(false);
    final selectedFont = ref.watch(quickNoteFontProvider);

    return GestureDetector(
      onLongPress: onLongPress,
      onTap: onTap,
      child: MouseRegion(
        onEnter: (_) => isHovered.value = true,
        onExit: (_) => isHovered.value = false,
        child: Transform.rotate(
          angle: (index % 3 - 1) * 0.05, // Subtle organic rotation
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Washi Tape Selection (Organic)
              if (isSelected && !isSelectionMode)
                Positioned(
                  top: -10,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Transform.rotate(
                      angle: -0.1,
                      child: Container(
                        width: 60,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: CustomPaint(
                          painter: _TapeTexturePainter(),
                        ),
                      ),
                    ),
                  ).animate().fadeIn().scale(curve: Curves.elasticOut),
                ),

              // Multi-selection halo
              if (isSelectionMode && isMultiSelected)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue, width: 2)),
                  ),
                ),

              // Main Note
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: CustomPaint(
                  painter:
                      _StickyNotePainter(color: note.color, isDark: isDark),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 20),
                    width: double.infinity,
                    height: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (note.title.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Text(
                              note.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  color: Colors.black.withOpacity(0.8),
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        Expanded(
                          child: Text(
                            note.content.isEmpty ? "Empty" : note.content,
                            maxLines: note.title.isNotEmpty ? 3 : 4,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.getFont(
                              selectedFont,
                              fontSize: 13,
                              color: Colors.black.withOpacity(0.7),
                              height: 1.25,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Quick Action UI (Fades in on hover)
              if (!isSelectionMode)
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: AnimatedOpacity(
                    duration: 200.ms,
                    opacity: isHovered.value ? 1 : 0,
                    child: _QuickActionButton(
                      icon: Icons.delete_outline,
                      color: Colors.red.shade400,
                      onPressed: onDelete,
                    ),
                  ),
                ),

              if (isSelectionMode)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    decoration: BoxDecoration(
                        color: isMultiSelected
                            ? Colors.blue
                            : Colors.white.withOpacity(0.8),
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: isMultiSelected
                                ? Colors.blue
                                : Colors.grey.shade400)),
                    padding: const EdgeInsets.all(4),
                    child: Icon(Icons.check,
                        size: 10,
                        color: isMultiSelected
                            ? Colors.white
                            : Colors.transparent),
                  ),
                ),
            ],
          ),
        )
            .animate(target: isHovered.value ? 1 : 0)
            .scale(end: const Offset(1.05, 1.05), duration: 200.ms)
            .moveY(end: -4, duration: 200.ms),
      ),
    );
  }
}

class _StickyNotePainter extends CustomPainter {
  final Color color;
  final bool isDark;

  _StickyNotePainter({required this.color, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    const foldSize = 20.0;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Dynamic coloring for depth
    final hsl = HSLColor.fromColor(color);
    final darkColor =
        hsl.withLightness((hsl.lightness - 0.1).clamp(0, 1)).toColor();
    final lightColor =
        hsl.withLightness((hsl.lightness + 0.05).clamp(0, 1)).toColor();

    final paperPath = Path()
      ..moveTo(0, 0)
      ..lineTo(w, 0)
      ..lineTo(w, h - foldSize)
      ..lineTo(w - foldSize, h)
      ..lineTo(0, h)
      ..close();

    // Shadow
    canvas.drawShadow(paperPath, Colors.black.withOpacity(0.2), 4.0, true);

    // Main Paper with Subtle Gradient
    final paperGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [lightColor, color],
    );
    paint.shader = paperGradient.createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawPath(paperPath, paint);

    // Realistic Fold
    final foldPath = Path()
      ..moveTo(w - foldSize, h)
      ..lineTo(w, h - foldSize)
      ..lineTo(w - foldSize, h - foldSize)
      ..close();

    final foldPaint = Paint()
      ..color = darkColor
      ..style = PaintingStyle.fill;

    // Add shadow UNDER the fold for 3D look
    canvas.drawPath(
        foldPath.shift(const Offset(-1, -1)),
        Paint()
          ..color = Colors.black26
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2));

    canvas.drawPath(foldPath, foldPaint);

    // Highlight on fold edge
    canvas.drawLine(
        Offset(w - foldSize, h - foldSize),
        Offset(w, h - foldSize),
        Paint()
          ..color = Colors.white30
          ..strokeWidth = 0.5);
    canvas.drawLine(
        Offset(w - foldSize, h - foldSize),
        Offset(w - foldSize, h),
        Paint()
          ..color = Colors.white30
          ..strokeWidth = 0.5);
  }

  @override
  bool shouldRepaint(covariant _StickyNotePainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.isDark != isDark;
}

class _TapeTexturePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..strokeWidth = 1;

    // Draw some subtle "fiber" lines for tape texture
    for (double i = 0; i < size.width; i += 4) {
      canvas.drawLine(Offset(i, 0), Offset(i + 2, size.height), paint);
    }

    // Rough edges
    final roughPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    final path = Path();
    for (double i = 0; i < size.width; i += 5) {
      path.lineTo(i, (i % 3) == 0 ? 2 : 0);
    }
    canvas.drawPath(path, roughPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? color;

  const _QuickActionButton({
    required this.icon,
    required this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon, size: 14, color: color ?? Colors.black54),
        onPressed: onPressed,
      ),
    );
  }
}

class _EditableStickyNote extends HookConsumerWidget {
  final StickyNote note;
  final bool isDark;
  final Function(String) onUpdate;
  final Function(String) onTitleUpdate;
  final VoidCallback onDelete;

  const _EditableStickyNote({
    super.key,
    required this.note,
    required this.isDark,
    required this.onUpdate,
    required this.onTitleUpdate,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController(text: note.content);
    final titleController = useTextEditingController(text: note.title);
    final focusNode = useFocusNode();
    final selectedFont = ref.watch(quickNoteFontProvider);

    // Sync if note changes externally
    useEffect(() {
      if (controller.text != note.content) {
        controller.text = note.content;
      }
      if (titleController.text != note.title) {
        titleController.text = note.title;
      }
      return null;
    }, [note.id]);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Dynamic Shadow with Parallax Effect
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 30,
                    spreadRadius: 2,
                    offset: const Offset(10, 20),
                  ),
                ],
              ),
            )
                .animate(
                    onPlay: (controller) => controller.repeat(reverse: true))
                .moveY(
                    begin: 10,
                    end: -10,
                    duration: 3.seconds,
                    curve: Curves.easeInOut),
          ),

          // Main Paper Component
          Positioned.fill(
            child: CustomPaint(
              painter: _StickyNotePainter(color: note.color, isDark: isDark),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      child: Row(
                        children: [
                          const Icon(Icons.edit_note_rounded,
                              size: 20, color: Colors.black54),
                          Expanded(
                            child: TextField(
                              controller: titleController,
                              onChanged: onTitleUpdate,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Untitled Note",
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                              style: GoogleFonts.outfit(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.2,
                                color: Colors.black.withOpacity(0.8),
                              ),
                            ),
                          ),
                          const Spacer(),
                          const _QuickNoteFontSelector(),
                          IconButton(
                            onPressed: onDelete,
                            icon: const Icon(Icons.delete_outline, size: 20),
                            color: Colors.red.shade700.withOpacity(0.7),
                            tooltip: "Delete Note",
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1, color: Colors.black12),
                    // Editor Area
                    Expanded(
                      child: TextField(
                        controller: controller,
                        focusNode: focusNode,
                        autofocus: true,
                        textAlignVertical: TextAlignVertical.top,
                        onChanged: onUpdate,
                        maxLines: null,
                        expands: true,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          filled: false,
                          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 40),
                          hintText: "Start typing your note here...",
                          hintStyle: TextStyle(color: Colors.black38),
                        ),
                        style: GoogleFonts.getFont(
                          selectedFont,
                          fontSize: 18,
                          height: 1.6,
                          color: Colors.black.withOpacity(0.85),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DottedBackgroundPainter extends CustomPainter {
  final Color color;
  final Offset mousePosition;

  _DottedBackgroundPainter({required this.color, required this.mousePosition});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    const double spacing = 40.0;
    const double baseRadius = 1.2;
    const double maxInteractionRadius = 150.0;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        final dotPos = Offset(x, y);
        final distance = (mousePosition - dotPos).distance;

        double radius = baseRadius;
        if (distance < maxInteractionRadius) {
          // Glow and scale dots near the cursor
          final scale = 1.0 + (1.5 * (1.0 - (distance / maxInteractionRadius)));
          radius = baseRadius * scale;

          final interactionColor = color.withOpacity((color.opacity +
                  (0.3 * (1.0 - (distance / maxInteractionRadius))))
              .clamp(0.0, 1.0));
          paint.color = interactionColor;
        } else {
          paint.color = color;
        }

        canvas.drawCircle(dotPos, radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DottedBackgroundPainter oldDelegate) {
    return oldDelegate.mousePosition != mousePosition ||
        oldDelegate.color != color;
  }
}

class _QuickNoteFontSelector extends ConsumerWidget {
  const _QuickNoteFontSelector();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFont = ref.watch(quickNoteFontProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.title_rounded,
            size: 14,
            color: Colors.black.withOpacity(0.5),
          ),
          const SizedBox(width: 4),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedFont,
              isDense: true,
              icon: Icon(Icons.keyboard_arrow_down_rounded,
                  size: 16, color: Colors.black.withOpacity(0.5)),
              dropdownColor: isDark ? const Color(0xFF1F2937) : Colors.white,
              style: GoogleFonts.getFont(
                selectedFont,
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Colors.black.withOpacity(0.7),
              ),
              items: availableQuickNoteFonts
                  .map((font) => DropdownMenuItem<String>(
                        value: font,
                        child: Text(
                          font,
                          style: GoogleFonts.getFont(
                            font,
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                            color: isDark ? Colors.white : const Color(0xFF05263E),
                          ),
                        ),
                      ))
                  .toList(),
              onChanged: (newFont) {
                if (newFont != null) {
                  ref.read(quickNoteFontProvider.notifier).state = newFont;
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
