import 'package:flutter/material.dart';
import 'package:universities_map/l10n/app_localizations.dart';
import 'package:universities_map/translations.dart';

import 'filter_item.dart';

class FilterSection extends StatelessWidget {
  const FilterSection({super.key, required this.title, required this.items});

  final String title;
  final Iterable<String> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.subjectLabel(title),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: items.map((option) {
            return FilterItem(item: option);
          }).toList(),
        ),
      ],
    );
  }
}
