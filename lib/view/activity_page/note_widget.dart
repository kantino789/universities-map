import 'package:flag/flag_widget.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:universities_map/helpers.dart';
import 'package:universities_map/model/editor.dart';
import 'package:universities_map/model/poi.dart';
import 'package:universities_map/model/poi_note.dart';
import 'package:universities_map/view/markers/poi_details.dart';

class NoteWidget extends StatelessWidget {
  final PoiNote note;

  const NoteWidget({super.key, required this.note});

  void _showPoiDetails(BuildContext context, Poi poi) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return PoiDetails(poi: poi);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final editor = StringPropertyChangeProvider.of<Editor, String>(
      context,
      listen: false,
    )!.value;
    final poi = editor.getPoiById(note.poiId);

    return poi != null
        ? Card(
            child: ListTile(
              onTap: () => _showPoiDetails(context, poi),
              leading: Flag.fromString(poi.country, width: 32, height: 32),
              title: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dateFormatter.format(note.createdAt),
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(note.note),
                ],
              ),
              trailing: Text(poi.title),
            ),
          )
        : SizedBox.shrink();
  }
}
