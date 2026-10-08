import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:universities_map/model/poi.dart';

import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

class Editor extends StringPropertyChangeNotifier {
  final List<Poi> _pois = [];
  Iterable<Poi> get pois => _pois;

  static const String poisFavoriteChanged = 'poisFavoriteChanged';

  Future<bool> loadPois() async {
    try {
      final String response = await rootBundle.loadString(
        'assets/universities.json',
      );

      // 2. Decode the raw JSON string to a List
      final List<dynamic> data = json.decode(response);

      // 3. Map each JSON object to a Poi instance
      _pois.clear();
      _pois.addAll(
        data
            .map((jsonItem) => Poi.fromJson(jsonItem as Map<String, dynamic>))
            .toList(),
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  void toggleFavorite(Poi poi) {
    poi.isFavorite = !poi.isFavorite;
    notifyListeners("$poisFavoriteChanged:${poi.id}");
  }
}
