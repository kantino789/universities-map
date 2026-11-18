import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:universities_map/config.dart';
import 'package:universities_map/model/editor.dart';
import 'package:universities_map/model/universitiies_package_enum.dart';

class FilterPackageSelection extends StatefulWidget {
  const FilterPackageSelection({super.key});

  @override
  State<FilterPackageSelection> createState() => _FilterPackageSelectionState();
}

class _FilterPackageSelectionState extends State<FilterPackageSelection> {
  late final List<DropdownMenuItem<int>> _packages;

  @override
  void initState() {
    super.initState();
    _packages = _getPackageDropdownItems();
  }

  List<DropdownMenuItem<int>> _getPackageDropdownItems() {
    // TODO: Translate package names
    final packages = [const DropdownMenuItem(value: 0, child: Text('World'))];
    if (loadFrenchData) {
      packages.add(const DropdownMenuItem(value: 1, child: Text('France')));
    }
    return packages;
  }

  @override
  Widget build(BuildContext context) {
    final editor = StringPropertyChangeProvider.of<Editor, String>(
      context,
      listen: false,
    )!.value;
    return _packages.length > 1
        ? DropdownButton<int>(
            value: editor.selectedPackage.index,
            items: _packages,
            onChanged: (value) {
              if (value != null) {
                final newPackage = UniversitiesPackage.values[value];
                setState(() {
                  editor.selectedPackage = newPackage;
                });
              }
            },
          )
        : const SizedBox.shrink();
  }
}
