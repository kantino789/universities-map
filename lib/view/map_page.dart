import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:flutter_map_vector_tiles/flutter_map_vector_tiles.dart' as vt;
import 'package:latlong2/latlong.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:universities_map/model/editor.dart';
import 'package:universities_map/model/poi.dart';
import 'package:universities_map/view/cluster_marker.dart';
import 'package:universities_map/view/poi_details.dart';
import 'package:universities_map/view/poi_marker.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController _mapController = MapController();
  late final Editor editor;

  late final Future<vt.Style> _styleFuture;

  final List<Poi> pois = [];

  @override
  void initState() {
    super.initState();
    editor = StringPropertyChangeProvider.of<Editor, String>(
      context,
      listen: false,
    )!.value;
    pois.addAll(editor.pois);
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

  // ==========================================================
  // BUILD MARKERS
  // ==========================================================

  List<Marker> _buildMarkers() {
    return pois.map((poi) {
      return Marker(
        point: poi.location,
        width: 50,
        height: 50,

        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              _showPoiDetails(poi);
            },

            child: PoiMarker(poi: poi),
          ),
        ),
      );
    }).toList();
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

                  MarkerClusterLayerWidget(
                    options: MarkerClusterLayerOptions(
                      // Distance in pixels at which markers
                      // start being grouped.
                      maxClusterRadius: 50,

                      // Size of the cluster widget.
                      size: const Size(55, 55),

                      // Don't cluster after zoom 10.
                      disableClusteringAtZoom: 10,

                      // Maximum zoom when automatically
                      // zooming into a cluster.
                      maxZoom: 11,

                      // When a cluster is tapped,
                      // automatically zoom to its bounds.
                      zoomToBoundsOnClick: true,

                      // Center marker when appropriate.
                      centerMarkerOnClick: true,

                      showPolygon: false,

                      // Our markers.
                      markers: _buildMarkers(),

                      // ------------------------------------------------
                      // CUSTOM CLUSTER ICON
                      // ------------------------------------------------
                      builder: (context, markers) {
                        final count = markers.length;

                        return ClusterMarker(count: count);
                      },

                      // ------------------------------------------------
                      // CLUSTER TAP
                      // ------------------------------------------------
                      onClusterTap: (cluster) {
                        // The package already handles
                        // zoomToBoundsOnClick.
                        //
                        // You can add custom behavior here
                        // if you want.
                      },
                    ),
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
            ],
          );
        },
      ),
    );
  }
}
