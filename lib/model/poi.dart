import 'package:latlong2/latlong.dart';

class Poi {
  final String id;
  final String title;
  final String description;
  final LatLng location;
  final String country;
  final Iterable<String> subjects;
  bool isFavorite = false;

  Poi({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.country,
    required this.subjects,
  });

  factory Poi.fromJson(Map<String, dynamic> json) {
    // Parse the "lat, long" string (e.g., "42.37700, -71.11666")
    final locationParts = (json['location'] as String).split(',');
    final lat = double.parse(locationParts[0].trim());
    final lng = double.parse(locationParts[1].trim());

    return Poi(
      id: json['id'].toString(), // Convert int ID to String if needed
      title: json['title'] as String,
      description: json['description'] as String,
      location: LatLng(lat, lng),
      country: json['country'] as String,
      subjects: (json['subjects'] as List<dynamic>).cast<String>(),
    );
  }
}
