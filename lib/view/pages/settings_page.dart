import 'package:flutter/material.dart';
import 'package:universities_map/translations.dart';
import 'package:universities_map/view/settings_page/about_settings_tab_widget.dart';
import 'package:universities_map/view/settings_page/switchs_settings_tab_widget.dart';
import 'package:universities_map/view/settings_page/view_settings.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<StatefulWidget> createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: DefaultTabController(
        length: 3,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //const AdBannerWidget(),
            TabBar(
              labelColor: Theme.of(context).iconTheme.color,
              tabs: [
                Tab(
                  text: translate("General"),
                  icon: const Icon(Icons.toggle_on),
                ),
                Tab(text: translate("About"), icon: const Icon(Icons.info)),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Flex(
                    direction: Axis.vertical,
                    children: [
                      SwitchsSettingsTabWidget(
                        settingsCategory: ViewSettings.globalSettingsCategory,
                      ),
                    ],
                  ),
                  AboutSettingsTabWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
