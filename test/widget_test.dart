import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:universities_map/main.dart';
import 'package:universities_map/model/editor.dart';
import 'package:universities_map/view/pages/map_page.dart';

void main() {
  testWidgets('tabs select their pages and preserve map state', (tester) async {
    await tester.pumpWidget(MyApp(editor: Editor()));

    final destinations = tester
        .widgetList<NavigationDestination>(find.byType(NavigationDestination))
        .toList();
    expect(destinations.map((destination) => destination.label), [
      'Map',
      'Favorites',
      'Activity',
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

    const labels = ['Map', 'Favorites', 'Activity', 'Settings'];
    const messages = [
      '',
      'No favorites yet.',
      'No activity yet.',
      'No settings available.',
    ];
    for (var index = 1; index < labels.length; index++) {
      await tester.tap(find.byType(NavigationDestination).at(index));
      await tester.pump(const Duration(milliseconds: 400));

      expect(
        tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
        index,
      );
      expect(
        tester.widget<IndexedStack>(find.byType(IndexedStack)).index,
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
    expect(tester.widget<IndexedStack>(find.byType(IndexedStack)).index, 0);
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
      await tester.pumpWidget(MyApp(editor: Editor()));

      for (final label in ['Map', 'Favorites', 'Activity', 'Settings']) {
        final labelRect = tester.getRect(find.text(label));
        expect(labelRect.left, greaterThanOrEqualTo(0));
        expect(labelRect.right, lessThanOrEqualTo(320));
        expect(labelRect.bottom, lessThanOrEqualTo(616));
      }
      final navRect = tester.getRect(find.byType(NavigationBar));
      final bodyRect = tester.getRect(find.byType(IndexedStack));
      expect(bodyRect.bottom, lessThanOrEqualTo(navRect.top));
      expect(navRect.bottom, 640);
      expect(tester.takeException(), isNull);
    },
  );
}
