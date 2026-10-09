import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:universities_map/model/editor.dart';

class FilterItem extends StatefulWidget {
  const FilterItem({super.key, required this.item});

  final String item;

  @override
  State<FilterItem> createState() => _FilterItemState();
}

class _FilterItemState extends State<FilterItem> {
  String get item => widget.item;
  late final Editor editor;
  late bool isActive;

  @override
  void initState() {
    super.initState();
    editor = StringPropertyChangeProvider.of<Editor, String>(
      context,
      listen: false,
    )!.value;
    isActive = editor.isFilterActive(item);
    editor.addListener(onFiltersReseted, [Editor.filtersReseted]);
  }

  @override
  void dispose() {
    editor.removeListener(onFiltersReseted, [Editor.filtersReseted]);
    super.dispose();
  }

  void onFiltersReseted(String? msg) {
    setState(() {
      isActive = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isActive = editor.toggleFilter(item);
        });
      },
      child: Chip(
        label: Text(item),
        backgroundColor: isActive ? Colors.blue : null,
      ),
    );
  }
}
