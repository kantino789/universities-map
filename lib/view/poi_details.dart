import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  poi.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Row(
                  spacing: 4,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          editor.toggleFavorite(poi);
                        });
                      },
                      icon: Icon(
                        poi.isFavorite ? Icons.star : Icons.star_border,
                        color: poi.isFavorite ? Colors.deepPurpleAccent : null,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ],
            ),
            if (poi.subjects.isNotEmpty) ...[
              Text("Recognized for its excellence in the following subjects:"),
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
                                    Chip(label: Text(subject)),
                                ],
                              ),
                            ],
                          ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
