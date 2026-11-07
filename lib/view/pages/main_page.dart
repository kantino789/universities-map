import 'package:flutter/material.dart';
import 'package:universities_map/l10n/app_localizations.dart';
import 'package:universities_map/view/ad_banner_widget.dart';
import 'package:universities_map/view/pages/activity_page.dart';
import 'package:universities_map/view/pages/favorites_page.dart';
import 'package:universities_map/view/pages/map_page.dart';
import 'package:universities_map/view/pages/settings_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final titles = [
      l10n.mapTab,
      l10n.favoritesTab,
      l10n.notesTab,
      l10n.settingsTab,
    ];

    return Scaffold(
      appBar: _selectedIndex == 0
          ? null
          : AppBar(title: Text(titles[_selectedIndex])),
      body: Column(
        children: [
          //AdBannerWidget(),
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: const [
                MapPage(),
                FavoritesPage(),
                ActivityPage(),
                SettingsPage(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: colors.secondaryContainer,
          iconTheme: WidgetStateProperty.resolveWith((states) {
            return IconThemeData(
              color: states.contains(WidgetState.selected)
                  ? colors.onSecondaryContainer
                  : colors.onSurfaceVariant,
            );
          }),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            final selected = states.contains(WidgetState.selected);
            return Theme.of(context).textTheme.labelMedium!.copyWith(
              color: selected ? colors.onSurface : colors.onSurfaceVariant,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
            );
          }),
        ),
        child: NavigationBar(
          selectedIndex: _selectedIndex,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          onDestinationSelected: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.map_outlined),
              selectedIcon: Icon(Icons.map),
              label: l10n.mapTab,
            ),
            NavigationDestination(
              icon: Icon(Icons.star_border),
              selectedIcon: Icon(Icons.star),
              label: l10n.favoritesTab,
            ),
            NavigationDestination(
              icon: Icon(Icons.note_alt_outlined),
              selectedIcon: Icon(Icons.note_alt),
              label: l10n.notesTab,
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings),
              label: l10n.settingsTab,
            ),
          ],
        ),
      ),
    );
  }
}
