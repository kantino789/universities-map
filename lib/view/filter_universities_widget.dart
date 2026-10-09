import 'package:flutter/material.dart';
import 'package:universities_map/model/subjects_groups_maps.dart';
import 'package:universities_map/view/filter_section.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:universities_map/model/editor.dart';

class FilterUniversitiesWidget extends StatelessWidget {
  const FilterUniversitiesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 16,
        children: [
          TextButton(
            onPressed: () {
              final editor = StringPropertyChangeProvider.of<Editor, String>(
                context,
                listen: false,
              )!.value;
              editor.resetFilters();
            },
            child: const Text('Reset Filters'),
          ),
          ...subjectsGroupsMap.entries.map((entry) {
            return FilterSection(title: entry.key, items: entry.value);
          }),
        ],
      ),
    );
  }
}
