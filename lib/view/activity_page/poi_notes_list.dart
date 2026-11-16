import 'package:flutter/material.dart';
import 'package:universities_map/l10n/app_localizations.dart';
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
        Text(
          AppLocalizations.of(context)!.notesHeading,
          style: Theme.of(context).textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        TextField(
          minLines: 2,
          maxLines: 4,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.enterNote,
          ),
          controller: _noteController,
          onChanged: (_) => setState(() {}),
        ),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: FilledButton.icon(
            onPressed: _noteController.text.trim().isEmpty
                ? null
                : () async {
                    final noteText = _noteController.text.trim();
                    final newNote = PoiNote(
                      poiId: poiId,
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      note: noteText,
                      createdAt: DateTime.now(),
                    );
                    await editor.addNotes(newNote);
                    _noteController.clear();
                    setState(() {});
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
            icon: const Icon(Icons.add),
            label: Text(AppLocalizations.of(context)!.addNote),
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
