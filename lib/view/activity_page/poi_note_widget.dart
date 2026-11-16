import 'package:flutter/material.dart';
import 'package:universities_map/l10n/app_localizations.dart';
import 'package:universities_map/helpers.dart';
import 'package:universities_map/model/poi_note.dart';
import 'package:universities_map/view/activity_page/date_text.dart';
import 'package:universities_map/view/activity_page/time_text.dart';

class PoiNoteWidget extends StatefulWidget {
  const PoiNoteWidget({
    super.key,
    required this.poiNote,
    required this.onNoteChanged,
    required this.onNoteDeleted,
  });

  final PoiNote poiNote;
  final ValueChanged<PoiNote> onNoteChanged;
  final VoidCallback onNoteDeleted;

  @override
  State<PoiNoteWidget> createState() => _PoiNoteWidgetState();
}

class _PoiNoteWidgetState extends State<PoiNoteWidget> {
  bool isEditing = false;
  late final TextEditingController _controller = TextEditingController(
    text: widget.poiNote.note,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return !isEditing
        ? Card(
            child: ListTile(
              title: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    spacing: 8,
                    children: [
                      DateText(
                        date: widget.poiNote.createdAt,
                        style: textTheme.labelMedium?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                      TimeText(
                        time: widget.poiNote.createdAt,
                        style: textTheme.labelMedium?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(widget.poiNote.note, style: textTheme.bodyLarge),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: AppLocalizations.of(context)!.editNote,
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () {
                      setState(() {
                        isEditing = true;
                      });
                    },
                  ),
                  IconButton(
                    tooltip: AppLocalizations.of(context)!.deleteNote,
                    icon: Icon(Icons.delete_outline, color: colors.error),
                    onPressed: widget.onNoteDeleted,
                  ),
                ],
              ),
            ),
          )
        : Card(
            child: ListTile(
              title: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    spacing: 8,
                    children: [
                      DateText(
                        date: widget.poiNote.createdAt,
                        style: textTheme.labelMedium?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                      TimeText(
                        time: widget.poiNote.createdAt,
                        style: textTheme.labelMedium?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  TextField(
                    controller: _controller,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.editNote,
                    ),
                    onChanged: (value) {
                      widget.poiNote.note = value;
                    },
                  ),
                ],
              ),
              trailing: IconButton(
                tooltip: AppLocalizations.of(context)!.saveNote,
                icon: const Icon(Icons.check_outlined, color: Colors.green),
                onPressed: () {
                  if (_controller.text.isEmpty) return;
                  setState(() {
                    isEditing = false;
                  });
                  widget.onNoteChanged(widget.poiNote);
                },
              ),
            ),
          );
  }
}
