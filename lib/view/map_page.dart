import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_vector_tiles/flutter_map_vector_tiles.dart' as vt;
import 'package:latlong2/latlong.dart';
import 'package:universities_map/model/poi.dart';
import 'package:universities_map/view/filters/filter_universities_widget.dart';
import 'package:universities_map/view/markers/markers_layer.dart';
import 'package:universities_map/view/markers/poi_details.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController _mapController = MapController();

  late final Future<vt.Style> _styleFuture;

  @override
  void initState() {
    super.initState();
    // OpenFreeMap:
    // Free and no API key required.
    _styleFuture = vt.StyleReader(
      uri: 'https://tiles.openfreemap.org/styles/liberty',
    ).read();
  }

  @override
  void dispose() {
    _styleFuture.then((style) {
      style.dispose();
    });
    super.dispose();
  }

  void _showPoiDetails(Poi poi) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return PoiDetails(poi: poi);
      },
    );
  }

  Future<void> _showFilterOptions() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Filter Options'),
          content: const FilterUniversitiesWidget(),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<vt.Style>(
        future: _styleFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Could not load map:\n${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            );
          }

          final style = snapshot.data!;

          return Stack(
            children: [
              FlutterMap(
                mapController: _mapController,

                options: MapOptions(
                  initialCenter: const LatLng(58.9700, 5.7330),
                  initialZoom: 14,
                  minZoom: 3,
                  maxZoom: 19,
                ),

                children: [
                  // --------------------------------------------------
                  // OpenFreeMap base map
                  // --------------------------------------------------
                  vt.VectorTileLayer(
                    theme: style.theme,
                    tileProviders: style.providers,
                    rasterSources: style.rasterSources,
                    sprites: style.sprites,
                  ),

                  MarkersLayer(
                    onPoiTap: (poi) {
                      _showPoiDetails(poi);
                    },
                  ),

                  // =================================================
                  // ATTRIBUTION
                  // =================================================
                  SimpleAttributionWidget(
                    source: Text(
                      style.attributions.map((a) => a.text).join(' · '),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 10,
                left: 10,
                child: FloatingActionButton(
                  onPressed: _showFilterOptions,
                  child: Icon(Icons.filter_list),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
