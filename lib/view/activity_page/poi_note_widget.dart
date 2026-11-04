import 'package:flutter/material.dart';
import 'package:universities_map/l10n/app_localizations.dart';
import 'package:universities_map/helpers.dart';
import 'package:universities_map/model/poi_note.dart';

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
    return !isEditing
        ? Card(
            child: ListTile(
              title: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dateFormatter.format(widget.poiNote.createdAt),
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(widget.poiNote.note),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: AppLocalizations.of(context)!.editNote,
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      setState(() {
                        isEditing = true;
                      });
                    },
                  ),
                  IconButton(
                    tooltip: AppLocalizations.of(context)!.deleteNote,
                    icon: Icon(Icons.clear, color: Colors.red),
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
                  Text(
                    dateFormatter.format(widget.poiNote.createdAt),
                    style: TextStyle(fontSize: 12, color: Colors.grey),
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
                icon: Icon(Icons.check),
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
