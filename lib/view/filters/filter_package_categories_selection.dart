import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:universities_map/model/editor.dart';
import 'package:universities_map/model/universitiies_package_enum.dart';

class FilterPackageCategoriesSelection extends StatefulWidget {
  const FilterPackageCategoriesSelection({super.key});

  @override
  State<StatefulWidget> createState() => _FilterPackageCategoriesSelection();
}

class _FilterPackageCategoriesSelection
    extends State<FilterPackageCategoriesSelection> {
  late final Editor editor;

  Iterable<String> categories = [];

  void onEditorSelectedPackageChanged(String? msg) {
    setState(() {
      categories = getPackageCategories(editor.selectedPackage);
    });
  }

  @override
  void initState() {
    super.initState();
    editor = StringPropertyChangeProvider.of<Editor, String>(
      context,
      listen: false,
    )!.value;
    categories = getPackageCategories(editor.selectedPackage);
    editor.addListener(onEditorSelectedPackageChanged, [
      Editor.selectedPackageChanged,
    ]);
  }

  @override
  void dispose() {
    editor.removeListener(onEditorSelectedPackageChanged, [
      Editor.selectedPackageChanged,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return categories.length > 1
        ? DropdownButton<String>(
            value: editor.selectedPackageCategory,
            // TODO: Translate All, and decide if type should be translated
            items: categories
                .map((c) => DropdownMenuItem<String>(value: c, child: Text(c)))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  editor.selectedPackageCategory = value;
                });
              }
            },
          )
        : const SizedBox.shrink();
  }
}
