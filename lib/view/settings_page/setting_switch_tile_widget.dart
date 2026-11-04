import 'package:flutter/material.dart';
import 'package:universities_map/l10n/app_localizations.dart';
import 'package:universities_map/view/settings_page/settings_property.dart';
import 'package:universities_map/view/settings_page/view_settings.dart';

class SettingSwitchTileWidget extends StatefulWidget {
  const SettingSwitchTileWidget({super.key, required this.property});

  final String property;

  @override
  State<StatefulWidget> createState() => _SettingSwitchTileWidget();
}

class _SettingSwitchTileWidget extends State<SettingSwitchTileWidget> {
  late final SettingsProperty settingsProperty = viewSettings
      .getSettingsProperty(widget.property);
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final label = switch (widget.property) {
      ViewSettings.themeProperty => l10n.darkMode,
      ViewSettings.use24HoursProperty => l10n.use24Hours,
      ViewSettings.displayMonthBeforeDayProperty => l10n.monthBeforeDay,
      ViewSettings.languageProperty => l10n.language,
      _ => settingsProperty.label,
    };
    if (settingsProperty.value is bool) {
      return SwitchListTile(
        title: Text(label),
        secondary: settingsProperty.icon,
        value: settingsProperty.value,
        onChanged: (value) {
          // TODO: Check if anything to do
          // if (widget.property == ViewSettings.themeProperty) {
          //   Navigator.of(context).pushAndRemoveUntil(
          //     PageRouteBuilder(
          //       pageBuilder: (_, __, ___) => const SettingsPage(),
          //     ),
          //     (route) => false,
          //   );
          // }
          setState(() {
            viewSettings.updateProperty<bool>(widget.property);
          });
        },
      );
    } else if (settingsProperty.value is int) {
      List<DropdownMenuItem<int>> items = [];
      SettingsProperty.getChoices(widget.property).forEach(
        (key, value) =>
            items.add(DropdownMenuItem<int>(value: key, child: Text(value))),
      );
      return ListTile(
        title: Text(label),
        leading: settingsProperty.icon,
        trailing: items.isNotEmpty
            ? DropdownButton<int>(
                underline: const DropdownButtonHideUnderline(
                  child: SizedBox.shrink(),
                ),
                value: settingsProperty.value,
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    viewSettings.updateProperty<int>(
                      widget.property,
                      newValue: value,
                    );
                  });
                },
                items: items,
              )
            : SizedBox.shrink(),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
