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
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 4),
          child: DateText(
            date: date,
            style: Theme.of(context).textTheme.titleSmall
                ?.copyWith(color: colors.primary, fontWeight: FontWeight.w700),
          ),
        ),
        for (final note in sortedNotes) NoteWidget(note: note),
      ],
    );
  }
}
