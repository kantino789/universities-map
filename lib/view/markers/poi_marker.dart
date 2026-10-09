import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:universities_map/model/editor.dart';
import 'package:universities_map/model/poi.dart';

class PoiMarker extends StatefulWidget {
  final Poi poi;

  const PoiMarker({super.key, required this.poi});

  @override
  State<PoiMarker> createState() => _PoiMarkerState();
}

class _PoiMarkerState extends State<PoiMarker> {
  Poi get poi => widget.poi;
  late final Editor editor;
  @override
  void initState() {
    super.initState();
    editor = StringPropertyChangeProvider.of<Editor, String>(
      context,
      listen: false,
    )!.value;
    editor.addListener(onFavoriteChanged, [
      "${Editor.poisFavoriteChanged}:${poi.id}",
    ]);
  }

  @override
  void dispose() {
    editor.removeListener(onFavoriteChanged, [
      "${Editor.poisFavoriteChanged}:${poi.id}",
    ]);
    super.dispose();
  }

  void onFavoriteChanged(String? message) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.location_pin,
      size: 46,
      color: widget.poi.isFavorite ? Colors.deepPurpleAccent : Colors.red,
    );
  }
}
