import 'package:flag/flag_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:universities_map/data/debug_data_provider.dart';
import 'package:universities_map/model/editor.dart';
import 'package:universities_map/model/poi.dart';
import 'package:universities_map/model/subjects_groups_maps.dart';
import 'package:universities_map/view/markers/poi_details.dart';

void main() {
  for (final hasSubjects in [true, false]) {
    testWidgets(
      'details keep the header fixed with ${hasSubjects ? 'long' : 'short'} content',
      (tester) async {
        tester.view.physicalSize = const Size(320, 640);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        final editor = Editor(DebugDataProvider());
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
        final websiteTop = tester.getTopLeft(find.text('Visit Website')).dy;

        if (hasSubjects) {
          await tester.drag(
            find.byType(SingleChildScrollView),
            const Offset(0, -250),
          );
          await tester.pumpAndSettle();
          expect(
            tester.getTopLeft(find.text('Visit Website')).dy,
            lessThan(websiteTop),
          );
          await tester.scrollUntilVisible(
            find.text('Save'),
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
        expect(find.text('Save').hitTestable(), findsOneWidget);

        await tester.tap(find.byIcon(Icons.star_border));
        await tester.pumpAndSettle();
        expect(poi.isFavorite, isTrue);
        await tester.tap(find.byIcon(Icons.close));
        await tester.pumpAndSettle();
        expect(find.byType(PoiDetails), findsNothing);
        expect(tester.takeException(), isNull);
      },
    );
  }
}
