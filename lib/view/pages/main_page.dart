import 'package:flutter/material.dart';
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
  static const _titles = ['Map', 'Favorites', 'Activity', 'Settings'];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: _selectedIndex == 0
          ? null
          : AppBar(title: Text(_titles[_selectedIndex])),
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          MapPage(),
          FavoritesPage(),
          ActivityPage(),
          SettingsPage(),
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
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.map_outlined),
              selectedIcon: Icon(Icons.map),
              label: 'Map',
            ),
            NavigationDestination(
              icon: Icon(Icons.star_border),
              selectedIcon: Icon(Icons.star),
              label: 'Favorites',
            ),
            NavigationDestination(icon: Icon(Icons.history), label: 'Activity'),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
