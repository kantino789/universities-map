import 'package:flutter/material.dart';
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
        ? ListTile(
            title: Text(widget.poiNote.note),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    setState(() {
                      isEditing = true;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.clear, color: Colors.red),
                  onPressed: widget.onNoteDeleted,
                ),
              ],
            ),
          )
        : ListTile(
            title: TextField(
              controller: _controller,
              maxLines: null,
              decoration: const InputDecoration(hintText: 'Edit note'),
              onChanged: (value) {
                widget.poiNote.note = value;
              },
            ),
            trailing: IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                if (_controller.text.isEmpty) return;
                setState(() {
                  isEditing = false;
                });
                widget.onNoteChanged(widget.poiNote);
              },
            ),
          );
  }
}
