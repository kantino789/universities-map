import 'package:flutter/material.dart';
import 'package:universities_map/view/settings_page/setting_switch_tile_widget.dart';
import 'package:universities_map/view/settings_page/view_settings.dart';

class SwitchsSettingsTabWidget extends StatelessWidget {
  const SwitchsSettingsTabWidget({
    super.key,
    required this.settingsCategory,
    this.otherChild,
  });

  final String settingsCategory;

  final Widget? otherChild;

  @override
  Widget build(BuildContext context) {
    var properties = viewSettings.getCategoryProperties(settingsCategory);
    int totalIndex = otherChild == null
        ? properties.length
        : properties.length + 1;
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemCount: totalIndex,
        itemBuilder: (BuildContext context, int index) {
          if (totalIndex != properties.length) {
            if (index == 0) {
              return otherChild!;
            } else {
              String property = properties[index - 1];
              return SettingSwitchTileWidget(property: property);
            }
          } else {
            String property = properties[index];
            return SettingSwitchTileWidget(property: property);
          }
        },
      ),
    );
  }
}
