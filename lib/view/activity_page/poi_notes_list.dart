import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:universities_map/model/editor.dart';
import 'package:universities_map/model/poi_note.dart';
import 'package:universities_map/view/activity_page/poi_note_widget.dart';

class PoiNotesList extends StatefulWidget {
  const PoiNotesList({super.key, required this.poiId});

  final String poiId;

  @override
  State<PoiNotesList> createState() => _PoiNotesListState();
}

class _PoiNotesListState extends State<PoiNotesList> {
  String get poiId => widget.poiId;
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final editor = StringPropertyChangeProvider.of<Editor, String>(
      context,
      properties: [Editor.poiNotesChanged],
    )!.value;
    final notes = editor.getPoiNotesForId(poiId).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: 12,
      children: [
        Text("Notes:"),
        TextField(
          maxLines: null,
          decoration: const InputDecoration(hintText: 'Enter a note'),
          controller: _noteController,
        ),
        Center(
          child: OutlinedButton(
            onPressed: () async {
              if (_noteController.text.isEmpty) return;
              final newNote = PoiNote(
                poiId: poiId,
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                note: _noteController.text,
                createdAt: DateTime.now(),
              );
              await editor.addNotes(newNote);
              _noteController.clear();
            },
            child: Text("Save"),
          ),
        ),
        if (notes.isNotEmpty) ...[
          for (final note in notes.reversed)
            PoiNoteWidget(
              poiNote: note,
              onNoteChanged: (updatedNote) async {
                await editor.updateNote(updatedNote);
              },
              onNoteDeleted: () async {
                await editor.deleteNote(note);
              },
            ),
        ],
      ],
    );
  }
}
