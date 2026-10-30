import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:universities_map/model/editor.dart';

import 'note_widget.dart';

class NotesList extends StatelessWidget {
  const NotesList({super.key});

  @override
  Widget build(BuildContext context) {
    final editor = StringPropertyChangeProvider.of<Editor, String>(
      context,
      properties: [Editor.poiNotesChanged],
    )!.value;
    final notes = editor.poiNotes.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return notes.isEmpty
        ? Center(child: Text('No notes yet.'))
        : ListView(
            shrinkWrap: true,
            children: notes.map((note) {
              return NoteWidget(note: note);
            }).toList(),
          );
  }
}
