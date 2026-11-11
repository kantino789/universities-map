import 'package:flutter/material.dart';
import 'package:universities_map/helpers.dart';
import 'package:universities_map/view/settings_page/view_settings.dart';

class DateText extends StatefulWidget {
  final DateTime date;
  final TextStyle? style;

  const DateText({super.key, required this.date, this.style});
  @override
  State<DateText> createState() => _DateTextState();
}

class _DateTextState extends State<DateText> {
  @override
  void initState() {
    super.initState();
    viewSettings.addListener(onDateFormatterChanged, [
      ViewSettings.use24HoursProperty,
    ]);
  }

  @override
  void dispose() {
    viewSettings.removeListener(onDateFormatterChanged, [
      ViewSettings.use24HoursProperty,
    ]);
    super.dispose();
  }

  void onDateFormatterChanged(String? msg) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Text(dateFormatter.format(widget.date), style: widget.style);
  }
}
