import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uuid/uuid.dart';

class StickyNote {
  final String id;
  final String content;
  final Color color;
  final DateTime createdAt;

  StickyNote({
    required this.id,
    required this.content,
    required this.color,
    required this.createdAt,
  });
}

class StickyNoteBoard extends StatefulWidget {
  const StickyNoteBoard({super.key});

  @override
  State<StickyNoteBoard> createState() => _StickyNoteBoardState();
}

class _StickyNoteBoardState extends State<StickyNoteBoard> {
  bool isExpanded = true;
  final List<StickyNote> notes = [
    // Mock initial note
    StickyNote(
        id: "1",
        content: "Discuss deployment timeline with team",
        color: Colors.yellow.shade100,
        createdAt: DateTime.now()),
  ];

  void _addNote() {
    showDialog(
        context: context,
        builder: (context) => _AddNoteDialog(
              onAdd: (content, color) {
                setState(() {
                  notes.insert(
                      0,
                      StickyNote(
                        id: const Uuid().v4(),
                        content: content,
                        color: color,
                        createdAt: DateTime.now(),
                      ));
                });
              },
            ));
  }

  void _deleteNote(String id) {
    setState(() {
      notes.removeWhere((n) => n.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () => setState(() => isExpanded = !isExpanded),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_right,
                    size: 20,
                    color: Colors.grey),
                const SizedBox(width: 8),
                Text("QUICK NOTES",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade500,
                        letterSpacing: 1.0)),
                const SizedBox(width: 8),
                if (!isExpanded)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12)),
                    child: Text("${notes.length}",
                        style: const TextStyle(
                            fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
          ),
        ),
        if (isExpanded) ...[
          const SizedBox(height: 4),
          // "Take a note..." input style trigger
          InkWell(
            onTap: _addNote,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4)
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Take a note...",
                      style: TextStyle(color: Colors.grey.shade400)),
                  const Icon(FontAwesomeIcons.plus,
                      size: 16, color: Colors.grey),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),

          if (notes.isEmpty)
            const Padding(
                padding: EdgeInsets.all(16),
                child: Text("No notes yet.",
                    style: TextStyle(color: Colors.grey))),

          SizedBox(
            height: 180,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: notes.length,
              separatorBuilder: (c, i) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final note = notes[index];
                return Stack(
                  children: [
                    Container(
                      width: 180,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: note.color,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 4)
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              note.content,
                              style: const TextStyle(fontSize: 13, height: 1.4),
                              maxLines: 6,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            "${note.createdAt.day}/${note.createdAt.month}/${note.createdAt.year}",
                            style: TextStyle(
                                fontSize: 10,
                                color: Colors.black.withValues(alpha: 0.4)),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: InkWell(
                        onTap: () => _deleteNote(note.id),
                        child: Icon(Icons.close,
                            size: 16,
                            color: Colors.black.withValues(alpha: 0.3)),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ]
      ],
    );
  }
}

class _AddNoteDialog extends StatefulWidget {
  final Function(String, Color) onAdd;
  const _AddNoteDialog({required this.onAdd});

  @override
  State<_AddNoteDialog> createState() => _AddNoteDialogState();
}

class _AddNoteDialogState extends State<_AddNoteDialog> {
  final _ctrl = TextEditingController();
  Color _selectedColor = Colors.yellow.shade100;

  final _colors = [
    Colors.yellow.shade100,
    Colors.blue.shade100,
    Colors.green.shade100,
    Colors.pink.shade100,
    Colors.purple.shade100,
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(24),
        width: 400,
        decoration: BoxDecoration(
          color: _selectedColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("New Note",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 16),
            TextField(
              controller: _ctrl,
              maxLines: 5,
              decoration: const InputDecoration.collapsed(
                  hintText: "What's on your mind?"),
              style: const TextStyle(fontSize: 16),
              autofocus: true,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                ..._colors.map((c) => Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: InkWell(
                        onTap: () => setState(() => _selectedColor = c),
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: c,
                            shape: BoxShape.circle,
                            border: _selectedColor == c
                                ? Border.all(color: Colors.black54, width: 2)
                                : Border.all(color: Colors.black12),
                          ),
                        ),
                      ),
                    )),
                const Spacer(),
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel")),
                ElevatedButton(
                  onPressed: () {
                    if (_ctrl.text.trim().isNotEmpty) {
                      widget.onAdd(_ctrl.text.trim(), _selectedColor);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Add"),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
