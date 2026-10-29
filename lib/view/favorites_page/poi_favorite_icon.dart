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
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        final editor = StringPropertyChangeProvider.of<Editor, String>(
          context,
          listen: false,
        )!.value;
        setState(() {
          editor.toggleFavorite(widget.poi);
        });
      },
      icon: Icon(
        widget.poi.isFavorite ? Icons.star : Icons.star_border,
        color: widget.poi.isFavorite ? Colors.deepPurpleAccent : null,
      ),
    );
  }
}
