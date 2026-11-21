import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:universities_map/data/debug_data_provider.dart';
import 'package:universities_map/model/editor.dart';
import 'package:universities_map/model/poi.dart';
import 'package:universities_map/view/markers/cluster_marker.dart';
import 'package:universities_map/view/markers/markers_layer.dart';
import 'package:universities_map/view/markers/poi_marker.dart';

class _MarkersEditor extends Editor {
  _MarkersEditor(this.displayedPois) : super(DebugDataProvider());

  @override
  final Iterable<Poi> displayedPois;
}

void main() {
  const location = LatLng(48.39080, -4.48640);

  List<Poi> schools(int count, {double latitudeStep = 0}) => List.generate(
    count,
    (index) => Poi(
      id: '$index',
      title: 'School $index',
      type: 'university',
      description: '',
      location: LatLng(
        location.latitude + index * latitudeStep,
        location.longitude,
      ),
      country: 'FR',
      subjects: [],
      website: '',
    ),
  );

  Future<void> mountMap(
    WidgetTester tester, {
    required Editor editor,
    required MapController controller,
    required double zoom,
    required void Function(Poi) onPoiTap,
  }) async {
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox.shrink());
      controller.dispose();
      editor.dispose();
    });
    await tester.pumpWidget(
      StringPropertyChangeProvider<Editor>(
        value: editor,
        child: MaterialApp(
          home: Scaffold(
            body: FlutterMap(
              mapController: controller,
              options: MapOptions(
                initialCenter: location,
                initialZoom: zoom,
                minZoom: 3,
                maxZoom: 19,
              ),
              children: [MarkersLayer(onPoiTap: onPoiTap)],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  for (final count in [2, 8, 12]) {
    testWidgets(
      '$count coincident schools spread into individually selectable markers at maximum zoom',
      (tester) async {
        final pois = schools(count);
        final selected = <String>[];
        await mountMap(
          tester,
          editor: _MarkersEditor(pois),
          controller: MapController(),
          zoom: 19,
          onPoiTap: (poi) => selected.add(poi.id),
        );
        expect(find.byType(ClusterMarker), findsOneWidget);
        expect(find.byType(PoiMarker), findsNothing);

        await tester.tap(find.byType(ClusterMarker));
        await tester.pumpAndSettle();
        expect(find.byType(PoiMarker), findsNWidgets(count));

        final bounds = tester
            .elementList(find.byType(PoiMarker))
            .map((element) => tester.getRect(find.byWidget(element.widget)))
            .toList();
        for (var i = 0; i < bounds.length; i++) {
          for (var j = i + 1; j < bounds.length; j++) {
            expect(
              bounds[i].overlaps(bounds[j]),
              isFalse,
              reason: 'Marker hit targets $i and $j must not overlap',
            );
          }
        }

        for (final poi in pois) {
          await tester.tap(
            find.byWidgetPredicate(
              (widget) => widget is PoiMarker && widget.poi.id == poi.id,
            ),
          );
          await tester.pumpAndSettle();
        }
        expect(selected, pois.map((poi) => poi.id).toList());
        expect(pois.every((poi) => poi.location == location), isTrue);

        await tester.tap(find.byType(ClusterMarker));
        await tester.pumpAndSettle();
        expect(find.byType(PoiMarker), findsNothing);
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets('zooming collapses coincident markers after spiderfying', (
    tester,
  ) async {
    final controller = MapController();
    await mountMap(
      tester,
      editor: _MarkersEditor(schools(2)),
      controller: controller,
      zoom: 14,
      onPoiTap: (_) {},
    );
    await tester.tap(find.byType(ClusterMarker));
    await tester.pumpAndSettle();
    expect(find.byType(PoiMarker), findsNWidgets(2));

    controller.move(location, 15);
    await tester.pumpAndSettle();
    expect(find.byType(PoiMarker), findsNothing);
    expect(find.byType(ClusterMarker), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('nearby distinct schools still zoom apart before spiderfying', (
    tester,
  ) async {
    final controller = MapController();
    final selected = <String>[];
    final pois = schools(2, latitudeStep: 0.02);
    await mountMap(
      tester,
      editor: _MarkersEditor(pois),
      controller: controller,
      zoom: 3,
      onPoiTap: (poi) => selected.add(poi.id),
    );
    expect(find.byType(ClusterMarker), findsOneWidget);

    await tester.tap(find.byType(ClusterMarker));
    await tester.pumpAndSettle();
    expect(controller.camera.zoom, greaterThan(3));
    expect(find.byType(ClusterMarker), findsNothing);
    expect(find.byType(PoiMarker), findsNWidgets(2));

    await tester.tap(find.byType(PoiMarker).first);
    await tester.pumpAndSettle();
    expect(selected, hasLength(1));
    expect(tester.takeException(), isNull);
  });
}
