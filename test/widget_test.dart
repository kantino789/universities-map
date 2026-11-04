import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universities_map/app_info.dart';
import 'package:universities_map/data/debug_data_provider.dart';
import 'package:universities_map/l10n/app_localizations.dart';
import 'package:universities_map/main.dart';
import 'package:universities_map/model/editor.dart';
import 'package:universities_map/shared_preferences.dart';
import 'package:universities_map/view/pages/map_page.dart';
import 'package:universities_map/view/settings_page/view_settings.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({ViewSettings.languageProperty: 0});
    sharedPreferencesInstance = SharedPreferencesInstance(
      await SharedPreferences.getInstance(),
    );
    viewSettings = ViewSettings(sharedPreferencesInstance);
    viewSettings.addListener(
      sharedPreferencesInstance.onViewSettingsChangedNotifications,
    );
    packageInfo = PackageInfo(
      appName: 'Universities Map',
      packageName: 'universities_map',
      version: '1.0.0',
      buildNumber: '1',
    );
  });

  setUp(() {
    viewSettings.updateProperty<int>(
      ViewSettings.languageProperty,
      newValue: Language.english.index,
    );
  });

  testWidgets('tabs select their pages and preserve map state', (tester) async {
    await tester.pumpWidget(MyApp(editor: Editor(DebugDataProvider())));

    final destinations = tester
        .widgetList<NavigationDestination>(find.byType(NavigationDestination))
        .toList();
    expect(destinations.map((destination) => destination.label), [
      'Map',
      'Favorites',
      'Notes',
      'Settings',
    ]);
    final mapState = tester.state(find.byType(MapPage));
    expect(
      tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
      0,
    );
    expect(find.byType(AppBar), findsNothing);
    expect(find.byType(Scaffold), findsOneWidget);
    expect(
      tester.widget<NavigationBar>(find.byType(NavigationBar)).labelBehavior,
      NavigationDestinationLabelBehavior.alwaysShow,
    );

    const labels = ['Map', 'Favorites', 'Notes', 'Settings'];
    const messages = ['', 'No favorites yet.', 'No notes yet.', 'General'];
    for (var index = 1; index < labels.length; index++) {
      await tester.tap(find.byType(NavigationDestination).at(index));
      await tester.pump(const Duration(milliseconds: 400));

      expect(
        tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
        index,
      );
      expect(
        tester.widget<IndexedStack>(find.byType(IndexedStack).first).index,
        index,
      );
      expect(find.text(messages[index]), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(AppBar),
          matching: find.text(labels[index]),
        ),
        findsOneWidget,
      );
      final navTheme = tester
          .widget<NavigationBarTheme>(find.byType(NavigationBarTheme))
          .data;
      expect(
        navTheme.labelTextStyle!.resolve({WidgetState.selected})!.fontWeight,
        FontWeight.w700,
      );
      expect(navTheme.labelTextStyle!.resolve({})!.fontWeight, FontWeight.w400);
    }

    await tester.tap(find.byType(NavigationDestination).first);
    await tester.pump(const Duration(milliseconds: 400));
    expect(
      tester.widget<IndexedStack>(find.byType(IndexedStack).first).index,
      0,
    );
    expect(tester.state(find.byType(MapPage)), same(mapState));
    expect(find.byType(AppBar), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'navigation labels fit a narrow screen and respect bottom inset',
    (tester) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1;
      tester.view.padding = const FakeViewPadding(bottom: 24);
      addTearDown(tester.view.reset);
      await tester.pumpWidget(MyApp(editor: Editor(DebugDataProvider())));

      for (final label in ['Map', 'Favorites', 'Notes', 'Settings']) {
        final labelRect = tester.getRect(find.text(label));
        expect(labelRect.left, greaterThanOrEqualTo(0));
        expect(labelRect.right, lessThanOrEqualTo(320));
        expect(labelRect.bottom, lessThanOrEqualTo(616));
      }
      final navRect = tester.getRect(find.byType(NavigationBar));
      final bodyRect = tester.getRect(find.byType(IndexedStack).first);
      expect(bodyRect.bottom, lessThanOrEqualTo(navRect.top));
      expect(navRect.bottom, 640);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('language dropdown updates the locale without replacing pages', (
    tester,
  ) async {
    await tester.pumpWidget(MyApp(editor: Editor(DebugDataProvider())));
    final mapState = tester.state(find.byType(MapPage));
    await tester.tap(find.byType(NavigationDestination).last);
    await tester.pump(const Duration(milliseconds: 400));

    await tester.tap(find.byType(DropdownButton<int>));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Deutsch'), findsOneWidget);
    expect(find.text('Português'), findsOneWidget);
    await tester.tap(find.text('Français').last);
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 400));

    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).locale,
      const Locale('fr'),
    );
    expect(
      tester.widget<IndexedStack>(find.byType(IndexedStack).first).index,
      3,
    );
    expect(
      tester.state(find.byType(MapPage, skipOffstage: false)),
      same(mapState),
    );
    expect(find.text('Général'), findsOneWidget);
    expect(find.text('Langue'), findsOneWidget);
    expect(
      sharedPreferencesInstance.sharedPreferences.getInt(
        ViewSettings.languageProperty,
      ),
      Language.french.index,
    );

    await tester.tap(find.text('À propos'));
    await tester.pumpAndSettle();
    expect(find.text('Version 1.0.0'), findsOneWidget);
    await tester.tap(find.text("Réinitialiser l'application"));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('RÉINITIALISER'), findsOneWidget);
    await tester.tap(find.text('RETOUR'));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.byType(AlertDialog), findsNothing);
    expect(tester.takeException(), isNull);
  });

  for (final language in Language.values) {
    testWidgets('${language.name} labels fit on a narrow screen', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      viewSettings.updateProperty<int>(
        ViewSettings.languageProperty,
        newValue: language.index,
      );
      await tester.pumpWidget(MyApp(editor: Editor(DebugDataProvider())));
      await tester.pump(const Duration(milliseconds: 400));

      final context = tester.element(find.byType(NavigationBar));
      final l10n = AppLocalizations.of(context)!;
      for (final label in [
        l10n.mapTab,
        l10n.favoritesTab,
        l10n.notesTab,
        l10n.settingsTab,
      ]) {
        final rect = tester.getRect(find.text(label));
        expect(rect.left, greaterThanOrEqualTo(0));
        expect(rect.right, lessThanOrEqualTo(320));
      }
      await tester.tap(find.byType(NavigationDestination).last);
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.text(l10n.language), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
