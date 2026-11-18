import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:universities_map/data/debug_data_provider.dart';
import 'package:universities_map/l10n/app_localizations.dart';
import 'package:universities_map/model/editor.dart';
import 'package:universities_map/model/universitiies_package_enum.dart';
import 'package:universities_map/view/filters/filter_package_selection.dart';

void main() {
  testWidgets('package labels follow locale changes without changing values', (
    tester,
  ) async {
    final labels = {
      'en': ('World', 'France'),
      'fr': ('Monde', 'France'),
      'de': ('Welt', 'Frankreich'),
      'es': ('Mundo', 'Francia'),
      'it': ('Mondo', 'Francia'),
      'pt': ('Mundo', 'Fran\u00e7a'),
    };
    final editor = Editor(DebugDataProvider());
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox.shrink());
      editor.dispose();
    });
    State? previousState;
    List<DropdownMenuItem<int>>? cachedItems;
    for (final locale in AppLocalizations.supportedLocales) {
      final (world, france) = labels[locale.languageCode]!;
      final selectedBefore = editor.selectedPackage;
      await tester.pumpWidget(
        StringPropertyChangeProvider<Editor>(
          value: editor,
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: locale,
            home: const Scaffold(body: Center(child: FilterPackageSelection())),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final state = tester.state(find.byType(FilterPackageSelection));
      if (previousState != null) {
        expect(state, same(previousState));
      }
      previousState = state;
      expect(editor.selectedPackage, selectedBefore);
      expect(
        find.text(
          selectedBefore == UniversitiesPackage.general ? world : france,
        ),
        findsOneWidget,
      );

      final dropdown = find.byType(DropdownButton<int>);
      cachedItems ??= tester.widget<DropdownButton<int>>(dropdown).items;
      expect(
        tester.widget<DropdownButton<int>>(dropdown).items,
        same(cachedItems),
      );
      await tester.tap(dropdown);
      await tester.pumpAndSettle();
      expect(find.text(world).hitTestable(), findsWidgets);
      expect(find.text(france).hitTestable(), findsWidgets);
      await tester.tap(find.text(world).last);
      await tester.pumpAndSettle();
      expect(editor.selectedPackage, UniversitiesPackage.general);
      expect(tester.widget<DropdownButton<int>>(dropdown).value, 0);
      expect(
        tester.widget<DropdownButton<int>>(dropdown).items,
        same(cachedItems),
      );

      await tester.tap(dropdown);
      await tester.pumpAndSettle();
      await tester.tap(find.text(france).last);
      await tester.pumpAndSettle();
      expect(editor.selectedPackage, UniversitiesPackage.french);
      expect(tester.widget<DropdownButton<int>>(dropdown).value, 1);
      expect(
        tester.widget<DropdownButton<int>>(dropdown).items,
        same(cachedItems),
      );
      expect(find.text(france), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
  });
}
