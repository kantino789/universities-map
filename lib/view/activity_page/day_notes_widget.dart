import 'package:flutter/material.dart';
import 'package:universities_map/model/poi_note.dart';
import 'package:universities_map/view/activity_page/date_text.dart';

import 'note_widget.dart';

class DayNotesWidget extends StatelessWidget {
  final DateTime date;
  final Iterable<PoiNote> notes;

  const DayNotesWidget({super.key, required this.date, required this.notes});

  @override
  Widget build(BuildContext context) {
    final sortedNotes = notes.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return Column(
      children: [
        DateText(
          date: date,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        for (final note in sortedNotes) NoteWidget(note: note),
      ],
    );
  }
}
