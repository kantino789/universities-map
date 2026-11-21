import 'package:flutter/material.dart';
import 'package:universities_map/view/filters/filter_package_categories_selection.dart';
import 'package:universities_map/view/filters/filter_package_selection.dart';
import 'package:universities_map/config.dart';
import 'package:universities_map/l10n/app_localizations.dart';
import 'package:universities_map/model/subjects_groups_maps.dart';
import 'package:universities_map/view/filters/filter_section.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:universities_map/model/editor.dart';

class FilterUniversitiesWidget extends StatelessWidget {
  const FilterUniversitiesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final editor = StringPropertyChangeProvider.of<Editor, String>(
      context,
      listen: false,
    )!.value;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 16,
        children: [
          if (loadFrenchData || loadGermanData) ...[
            FilterPackageSelection(),
            FilterPackageCategoriesSelection(),
          ],
          OutlinedButton(
            onPressed: () {
              editor.resetFilters();
            },
            child: Text(AppLocalizations.of(context)!.resetFilters),
          ),
          ...subjectsGroupsMap.entries.map((entry) {
            return FilterSection(title: entry.key, items: entry.value);
          }),
        ],
      ),
    );
  }
}
