import 'package:latlong2/latlong.dart';

const List<Poi> pois = [
  Poi(
    id: 'poi-1',
    title: 'City Hall',
    description: 'The main city hall building.',
    location: LatLng(58.969975, 5.733107),
  ),
  Poi(
    id: 'poi-2',
    title: 'Museum',
    description: 'A local museum with historical exhibitions.',
    location: LatLng(58.970700, 5.730500),
  ),
  Poi(
    id: 'poi-3',
    title: 'Central Park',
    description: 'A nice green area in the city centre.',
    location: LatLng(58.972000, 5.735000),
  ),
];

class Poi {
  final String id;
  final String title;
  final String description;
  final LatLng location;

  const Poi({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
  });
}
