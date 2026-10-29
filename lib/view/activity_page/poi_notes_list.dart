import 'package:flutter/material.dart';
import 'package:universities_map/model/poi.dart';
import 'package:universities_map/model/poi_note.dart';
import 'package:universities_map/view/activity_page/poi_note_widget.dart';

class PoiNotesList extends StatefulWidget {
  const PoiNotesList({super.key, required this.poi});

  final Poi poi;

  @override
  State<PoiNotesList> createState() => _PoiNotesListState();
}

class _PoiNotesListState extends State<PoiNotesList> {
  Poi get poi => widget.poi;
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            onPressed: () {
              if (_noteController.text.isEmpty) return;
              setState(() {
                poi.notes.add(
                  PoiNote(
                    poiId: poi.id,
                    note: _noteController.text,
                    createdAt: DateTime.now(),
                  ),
                );
              });
              _noteController.clear();
            },
            child: Text("Save"),
          ),
        ),
        if (poi.notes.isNotEmpty) ...[
          for (final note in poi.notes)
            PoiNoteWidget(
              poiNote: note,
              onNoteChanged: (updatedNote) {
                setState(() {
                  final index = poi.notes.indexOf(note);
                  if (index != -1) {
                    poi.notes[index] = updatedNote;
                  }
                });
              },
              onNoteDeleted: () {
                setState(() {
                  poi.notes.remove(note);
                });
              },
            ),
        ],
      ],
    );
  }
}
