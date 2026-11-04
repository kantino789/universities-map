import 'dart:convert';
import 'dart:io';

import 'package:flag/flag_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:universities_map/data/debug_data_provider.dart';
import 'package:universities_map/l10n/app_localizations.dart';
import 'package:universities_map/model/editor.dart';
import 'package:universities_map/model/poi.dart';
import 'package:universities_map/model/subjects_groups_maps.dart';
import 'package:universities_map/translations.dart';
import 'package:universities_map/view/filters/filter_section.dart';
import 'package:universities_map/view/markers/poi_details.dart';

void main() {
  test(
    'every category and field resolves to its ARB translation in every locale',
    () async {
      final english = jsonDecode(
        await File('lib/l10n/app_en.arb').readAsString(),
      ) as Map<String, dynamic>;
      final entries = english.entries
          .where(
            (entry) =>
                entry.key.startsWith('category') ||
                entry.key.startsWith('subject'),
          )
          .toList();
      expect(entries.map((entry) => entry.value).toSet(), {
        ...subjectsGroupsMap.keys,
        ...subjectToGroup.keys,
      });
      for (final locale in AppLocalizations.supportedLocales) {
        final catalog = jsonDecode(
          await File('lib/l10n/app_${locale.languageCode}.arb').readAsString(),
        ) as Map<String, dynamic>;
        final l10n = await AppLocalizations.delegate.load(locale);
        for (final entry in entries) {
          expect(
            catalog[entry.key],
            isA<String>(),
            reason: '${locale.languageCode}: ${entry.key}',
          );
          expect(
            l10n.subjectLabel(entry.value as String),
            catalog[entry.key],
            reason: '${locale.languageCode}: ${entry.key}',
          );
        }
        expect(l10n.subjectLabel('A future subject'), 'A future subject');
      }
    },
  );

  for (final locale in AppLocalizations.supportedLocales) {
    testWidgets(
      '${locale.languageCode} filter labels preserve canonical filter values',
      (tester) async {
        tester.view.physicalSize = const Size(320, 640);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        final editor = Editor(DebugDataProvider());
        addTearDown(() async {
          await tester.pumpWidget(const SizedBox.shrink());
          editor.dispose();
        });
        final l10n = await AppLocalizations.delegate.load(locale);
        await tester.pumpWidget(
          StringPropertyChangeProvider<Editor>(
            value: editor,
            child: MaterialApp(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              locale: locale,
              home: const Scaffold(
                body: FilterSection(
                  title: 'Natural Sciences',
                  items: ['Atmospheric Science', 'Chemistry'],
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text(l10n.categoryNaturalSciences), findsOneWidget);
        expect(find.text(l10n.subjectAtmosphericScience), findsOneWidget);
        await tester.tap(find.text(l10n.subjectChemistry));
        await tester.pump();
        expect(editor.isFilterActive('Chemistry'), isTrue);
        if (locale.languageCode != 'en') {
          expect(editor.isFilterActive(l10n.subjectChemistry), isFalse);
        }
        await tester.tap(find.text(l10n.subjectChemistry));
        await tester.pump();
        expect(editor.isFilterActive('Chemistry'), isFalse);
        expect(tester.takeException(), isNull);
      },
    );
  }

  for (final locale in AppLocalizations.supportedLocales) {
    for (final hasSubjects in [true, false]) {
      testWidgets(
        '${locale.languageCode} details keep the header fixed with ${hasSubjects ? 'long' : 'short'} content',
        (tester) async {
          tester.view.physicalSize = const Size(320, 640);
          tester.view.devicePixelRatio = 1;
          addTearDown(tester.view.reset);

          final editor = Editor(DebugDataProvider());
          final l10n = await AppLocalizations.delegate.load(locale);
          addTearDown(() async {
            await tester.pumpWidget(const SizedBox.shrink());
            editor.dispose();
          });
          final poi = Poi(
            id: 'test',
            title: 'A university with a long title',
            description: '',
            location: const LatLng(0, 0),
            country: 'FR',
            subjects: hasSubjects
                ? List.filled(30, subjectToGroup.keys.first)
                : [],
            website: 'https://example.com',
          );
          await tester.pumpWidget(
            StringPropertyChangeProvider<Editor>(
              value: editor,
              child: MaterialApp(
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                locale: locale,
                home: Scaffold(
                  body: Builder(
                    builder: (context) => TextButton(
                      onPressed: () => showModalBottomSheet<void>(
                        context: context,
                        isScrollControlled: true,
                        builder: (_) => PoiDetails(poi: poi),
                      ),
                      child: const Text('Open details'),
                    ),
                  ),
                ),
              ),
            ),
          );
          await tester.tap(find.text('Open details'));
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          expect(find.byType(SingleChildScrollView), findsOneWidget);

          final titleRect = tester.getRect(find.text(poi.title));
          final flagRect = tester.getRect(find.byType(Flag));
          final closeRect = tester.getRect(find.byIcon(Icons.close));
          final websiteTop = tester.getTopLeft(find.text(l10n.visitWebsite)).dy;

          if (hasSubjects) {
            expect(find.text(l10n.categoryNaturalSciences), findsOneWidget);
            expect(
              find.text(l10n.subjectAtmosphericScience),
              findsNWidgets(30),
            );
            await tester.drag(
              find.byType(SingleChildScrollView),
              const Offset(0, -250),
            );
            await tester.pumpAndSettle();
            expect(
              tester.getTopLeft(find.text(l10n.visitWebsite)).dy,
              lessThan(websiteTop),
            );
            await tester.scrollUntilVisible(
              find.text(l10n.addNote),
              250,
              scrollable: find
                  .descendant(
                    of: find.byType(SingleChildScrollView),
                    matching: find.byType(Scrollable),
                  )
                  .first,
            );
            await tester.pumpAndSettle();
          }

          expect(tester.getRect(find.text(poi.title)), titleRect);
          expect(tester.getRect(find.byType(Flag)), flagRect);
          expect(tester.getRect(find.byIcon(Icons.close)), closeRect);
          expect(find.text(l10n.addNote).hitTestable(), findsOneWidget);

          await tester.tap(find.byIcon(Icons.star_border));
          await tester.pumpAndSettle();
          await tester.tap(find.byIcon(Icons.close));
          await tester.pumpAndSettle();
          expect(find.byType(PoiDetails), findsNothing);
          expect(tester.takeException(), isNull);
        },
      );
    }
  }
}
