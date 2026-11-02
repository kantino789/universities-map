import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:universities_map/model/editor.dart';
import 'package:universities_map/model/poi_note.dart';

import 'day_notes_widget.dart';

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

    final Map<DateTime, List<PoiNote>> groupedNotes = {};
    for (final note in notes) {
      final date = DateTime(
        note.createdAt.year,
        note.createdAt.month,
        note.createdAt.day,
      );
      groupedNotes.putIfAbsent(date, () => []).add(note);
    }
    return notes.isEmpty
        ? Center(child: Text('No notes yet.'))
        : ListView(
            shrinkWrap: true,
            children: groupedNotes.entries.map((entry) {
              return DayNotesWidget(date: entry.key, notes: entry.value);
            }).toList(),
          );
  }
}
