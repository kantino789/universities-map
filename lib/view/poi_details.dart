import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:universities_map/model/editor.dart';
import 'package:universities_map/model/poi.dart';
import 'package:universities_map/model/subjects_lists.dart';

class PoiDetails extends StatefulWidget {
  const PoiDetails({super.key, required this.poi});

  final Poi poi;

  @override
  State<StatefulWidget> createState() => _PoiDetailsState();
}

class _PoiDetailsState extends State<PoiDetails> {
  Poi get poi => widget.poi;

  late final Iterable<String> poiNaturalSciencesSubjects = poi.subjects
      .where((subject) => naturalSciencesSubjects.contains(subject))
      .toList();
  late final Iterable<String> poiEngineeringSubjects = poi.subjects
      .where((subject) => engineeringSubjects.contains(subject))
      .toList();
  late final Iterable<String> poiLifeSciencesSubjects = poi.subjects
      .where((subject) => lifeSciencesSubjects.contains(subject))
      .toList();
  late final Iterable<String> poiMedicalSciencesSubjects = poi.subjects
      .where((subject) => medicalSciencesSubjects.contains(subject))
      .toList();
  late final Iterable<String> poiSocialSciencesSubjects = poi.subjects
      .where((subject) => socialSciencesSubjects.contains(subject))
      .toList();

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
                      if (poiNaturalSciencesSubjects.isNotEmpty) ...[
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 4,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Natural Sciences",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 4,
                              runSpacing: 4,
                              children: poiNaturalSciencesSubjects
                                  .map((subject) => Chip(label: Text(subject)))
                                  .toList(),
                            ),
                          ],
                        ),
                      ],
                      if (poiEngineeringSubjects.isNotEmpty) ...[
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 4,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Engineering",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 4,
                              runSpacing: 4,
                              children: poiEngineeringSubjects
                                  .map((subject) => Chip(label: Text(subject)))
                                  .toList(),
                            ),
                          ],
                        ),
                      ],
                      if (poiLifeSciencesSubjects.isNotEmpty) ...[
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 4,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Life Sciences",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 4,
                              runSpacing: 4,
                              children: poiLifeSciencesSubjects
                                  .map((subject) => Chip(label: Text(subject)))
                                  .toList(),
                            ),
                          ],
                        ),
                      ],
                      if (poiMedicalSciencesSubjects.isNotEmpty) ...[
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 4,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Medical Sciences",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 4,
                              runSpacing: 4,
                              children: poiMedicalSciencesSubjects
                                  .map((subject) => Chip(label: Text(subject)))
                                  .toList(),
                            ),
                          ],
                        ),
                      ],
                      if (poiSocialSciencesSubjects.isNotEmpty) ...[
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 4,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Social Sciences",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 4,
                              runSpacing: 4,
                              children: poiSocialSciencesSubjects
                                  .map((subject) => Chip(label: Text(subject)))
                                  .toList(),
                            ),
                          ],
                        ),
                      ],
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
