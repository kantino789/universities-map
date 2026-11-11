import 'package:flutter/material.dart';
import 'package:universities_map/helpers.dart';
import 'package:universities_map/view/settings_page/view_settings.dart';

class TimeText extends StatefulWidget {
  final DateTime time;

  const TimeText({super.key, required this.time});

  @override
  State<TimeText> createState() => _TimeTextState();
}

class _TimeTextState extends State<TimeText> {
  @override
  void initState() {
    super.initState();
    viewSettings.addListener(onTimeFormatterChanged, [
      ViewSettings.use24HoursProperty,
    ]);
  }

  @override
  void dispose() {
    viewSettings.removeListener(onTimeFormatterChanged, [
      ViewSettings.use24HoursProperty,
    ]);
    super.dispose();
  }

  void onTimeFormatterChanged(String? msg) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Text(timeFormatter.format(widget.time));
  }
}
