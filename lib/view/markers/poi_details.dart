import 'package:flag/flag_widget.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:universities_map/view/activity_page/poi_notes_list.dart';
import 'package:universities_map/view/favorites_page/poi_favorite_icon.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:universities_map/model/editor.dart';
import 'package:universities_map/model/poi.dart';
import 'package:universities_map/model/subjects_groups_maps.dart';

class PoiDetails extends StatefulWidget {
  const PoiDetails({super.key, required this.poi});

  final Poi poi;

  @override
  State<StatefulWidget> createState() => _PoiDetailsState();
}

class _PoiDetailsState extends State<PoiDetails> {
  Poi get poi => widget.poi;

  late final Map<String, List<String>> poiSubjectsByGroup = () {
    final grouped = <String, List<String>>{
      for (final group in subjectsGroupsMap.keys) group: <String>[],
    };

    for (final subject in poi.subjects) {
      final group = subjectToGroup[subject];
      if (group != null) {
        grouped[group]!.add(subject);
      }
    }

    return grouped;
  }();

  @override
  Widget build(BuildContext context) {
    final editor = StringPropertyChangeProvider.of<Editor, String>(
      context,
      listen: false,
    )!.value;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 16,
                    children: [
                      Flag.fromString(poi.country, width: 24, height: 24),
                      Text(
                        poi.title,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                  Row(
                    spacing: 4,
                    children: [
                      PoiFavoriteIcon(poi: poi),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ],
              ),
              Tooltip(
                message: poi.website.isNotEmpty ? poi.website : null,
                child: OutlinedButton(
                  onPressed: () {
                    if (poi.website.isNotEmpty) {
                      launchUrl(Uri.parse(poi.website));
                    }
                  },
                  child: const Text('Visit Website'),
                ),
              ),
              if (poi.subjects.isNotEmpty) ...[
                Text(
                  "Recognized for its excellence in the following subjects:",
                ),
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 12,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final group in poiSubjectsByGroup.entries)
                          if (group.value.isNotEmpty)
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              spacing: 4,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  group.key,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  spacing: 4,
                                  runSpacing: 4,
                                  children: [
                                    for (final subject in group.value)
                                      Chip(
                                        label: Text(subject),
                                        backgroundColor:
                                            editor.isFilterActive(subject)
                                            ? Colors.blue
                                            : null,
                                      ),
                                  ],
                                ),
                              ],
                            ),
                      ],
                    ),
                  ),
                ),
              ],
              PoiNotesList(poiId: poi.id),
            ],
          ),
        ),
      ),
    );
  }
}
