import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:universities_map/model/poi.dart';
import 'package:universities_map/view/markers/cluster_marker.dart';
import 'package:universities_map/view/markers/poi_marker.dart';
import 'package:universities_map/model/editor.dart';

class MarkersLayer extends StatefulWidget {
  const MarkersLayer({super.key, required this.onPoiTap});

  final Function(Poi) onPoiTap;

  @override
  State<MarkersLayer> createState() => _MarkersLayerState();
}

class _MarkersLayerState extends State<MarkersLayer> {
  late final Editor editor;

  @override
  void initState() {
    super.initState();
    editor = StringPropertyChangeProvider.of<Editor, String>(
      context,
      listen: false,
    )!.value;
    editor.addListener(onFiltersChanged, [
      Editor.filtersChanged,
      Editor.filtersReseted,
    ]);
  }

  @override
  void dispose() {
    editor.removeListener(onFiltersChanged, [
      Editor.filtersChanged,
      Editor.filtersReseted,
    ]);
    super.dispose();
  }

  void onFiltersChanged(String? msg) {
    setState(() {
      // Rebuild markers when filters change.
    });
  }

  List<Marker> _buildMarkers() {
    return editor.displayedPois.map((poi) {
      return Marker(
        point: poi.location,
        width: 50,
        height: 50,

        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              widget.onPoiTap(poi);
            },

            child: PoiMarker(poi: poi),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return MarkerClusterLayerWidget(
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
    );
  }
}
