import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:universities_map/model/editor.dart';
import 'package:universities_map/model/poi.dart';

class PoiFavoriteIcon extends StatefulWidget {
  const PoiFavoriteIcon({super.key, required this.poi});

  final Poi poi;

  @override
  State<PoiFavoriteIcon> createState() => _PoiFavoriteIconState();
}

class _PoiFavoriteIconState extends State<PoiFavoriteIcon> {
  late final Editor editor;

  @override
  void initState() {
    super.initState();
    editor = StringPropertyChangeProvider.of<Editor, String>(
      context,
      listen: false,
    )!.value;
  }

  @override
  Widget build(BuildContext context) {
    final isFavorite = editor.isFavorite(widget.poi);
    return IconButton(
      onPressed: () {
        setState(() {
          editor.toggleFavorite(widget.poi);
        });
      },
      icon: Icon(
        isFavorite ? Icons.star : Icons.star_border,
        color: isFavorite ? Colors.deepPurpleAccent : null,
      ),
    );
  }
}
