import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_vector_tiles/flutter_map_vector_tiles.dart' as vt;
import 'package:latlong2/latlong.dart';
import 'package:universities_map/l10n/app_localizations.dart';
import 'package:universities_map/model/poi.dart';
import 'package:universities_map/view/helpers/localized_style_client.dart';
import 'package:universities_map/view/filters/filters_floating_button.dart';
import 'package:universities_map/view/markers/markers_layer.dart';
import 'package:universities_map/view/markers/poi_details.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController _mapController = MapController();

  final LocalizedStyleClient _styleClient = LocalizedStyleClient();

  late Future<vt.Style> _styleFuture;
  String? _language;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final language = Localizations.localeOf(context).languageCode;
    if (language == _language) return;

    final previous = _language == null ? null : _styleFuture;
    _language = language;
    // OpenFreeMap:
    // Free and no API key required. Labels follow the app language.
    _styleFuture = vt.StyleReader(
      uri: localizedStyleUri(language),
      httpClient: _styleClient,
    ).read();

    if (previous != null) {
      // The previous map stays on screen until the new style is ready.
      void disposePrevious() => WidgetsBinding.instance.addPostFrameCallback(
        (_) => previous.then((style) => style.dispose(), onError: (_) {}),
      );
      _styleFuture.then(
        (_) => disposePrevious(),
        onError: (_) => disposePrevious(),
      );
    }
  }

  @override
  void dispose() {
    _styleFuture.then((style) {
      style.dispose();
    }, onError: (_) {});
    _styleClient.close();
    super.dispose();
  }

  void _showPoiDetails(Poi poi) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: PoiDetails(poi: poi),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<vt.Style>(
      future: _styleFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData && !snapshot.hasError) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              AppLocalizations.of(context)!.mapLoadError('${snapshot.error}'),
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
                initialCenter: const LatLng(55.9700, 12.7330),
                initialZoom: 3,
                minZoom: 3,
                maxZoom: 19,
                interactionOptions: InteractionOptions(
                  flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                ),
              ),

              children: [
                // --------------------------------------------------
                // OpenFreeMap base map
                // --------------------------------------------------
                vt.VectorTileLayer(
                  key: ObjectKey(style),
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
                RichAttributionWidget(
                  attributions: style.attributions
                      .map(
                        (attribution) => TextSourceAttribution(
                          attribution.text,
                          prependCopyright: false,
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
            Positioned(top: 40, left: 20, child: FiltersFloatingButton()),
          ],
        );
      },
    );
  }
}
