import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:universities_map/model/editor.dart';
import 'package:universities_map/model/poi.dart';

class PoiDetails extends StatefulWidget {
  const PoiDetails({super.key, required this.poi});

  final Poi poi;

  @override
  State<StatefulWidget> createState() => _PoiDetailsState();
}

class _PoiDetailsState extends State<PoiDetails> {
  Poi get poi => widget.poi;

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
            Text(poi.description),
          ],
        ),
      ),
    );
  }
}
