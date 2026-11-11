import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:universities_map/l10n/app_localizations.dart';
import 'package:universities_map/model/editor.dart';
import 'package:universities_map/view/filters/filter_universities_widget.dart';

class FiltersFloatingButton extends StatelessWidget {
  const FiltersFloatingButton({super.key});

  Future<void> _showFilterOptions(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.filterOptions),
          content: const FilterUniversitiesWidget(),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.close),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final editor = StringPropertyChangeProvider.of<Editor, String>(
      context,
      properties: [Editor.filtersChanged, Editor.filtersReseted],
    )!.value;
    return Stack(
      children: [
        FloatingActionButton(
          tooltip: AppLocalizations.of(context)!.filterOptions,
          onPressed: () => _showFilterOptions(context),
          child: Icon(Icons.filter_list),
        ),
        if (editor.filtersCount > 0)
          Positioned(
            right: 0,
            child: CircleAvatar(
              radius: 10,
              backgroundColor: Colors.red,
              child: Text(
                '${editor.filtersCount}',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
      ],
    );
  }
}
