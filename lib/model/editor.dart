import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:universities_map/config.dart';
import 'package:universities_map/data/data_provider_interface.dart';
import 'package:universities_map/model/poi.dart';

import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:universities_map/model/poi_note.dart';
import 'package:universities_map/model/universitiies_package_enum.dart';

class Editor extends StringPropertyChangeNotifier {
  final IDataProvider _dataProvider;

  final Map<String, Poi> _poisById = {};
  final Map<String, Poi> _frenchPoisById = {};
  Iterable<Poi> get displayedPois => _filteredPois();

  UniversitiesPackage _selectedPackage = UniversitiesPackage.general;
  UniversitiesPackage get selectedPackage => _selectedPackage;
  set selectedPackage(UniversitiesPackage package) {
    _selectedPackage = package;
    notifyListeners(filtersChanged);
  }

  final Map<String, Poi> _favoritesById = {};
  Iterable<Poi> get favoritePois => _favoritesById.values;

  final Map<String, PoiNote> _poiNotesById = {};
  Iterable<PoiNote> get poiNotes => _poiNotesById.values;

  final List<String> _filters = [];
  Iterable<String> get filters => _filters;
  int get filtersCount => _filters.length;

  static const String poisFavoriteChanged = 'poisFavoriteChanged';
  static const String filtersChanged = 'filtersChanged';
  static const String filtersReseted = 'filtersReseted';
  static const String poiNotesChanged = 'poiNotesChanged';

  Editor(this._dataProvider);

  Future<bool> initializeData() async {
    try {
      await _loadDataPackage(UniversitiesPackage.general);
      if (loadFrenchData) {
        await _loadDataPackage(UniversitiesPackage.french);
      }
      await Future.wait([_populateFavorites(), _populateNotes()]);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> _loadDataPackage(UniversitiesPackage package) async {
    final String assetPath;
    final Map<String, Poi> targetMap;
    switch (package) {
      case UniversitiesPackage.general:
        assetPath = 'assets/universities.json';
        targetMap = _poisById;
        break;
      case UniversitiesPackage.french:
        assetPath = 'assets/french_universities.json';
        targetMap = _frenchPoisById;
        break;
    }
    final String response = await rootBundle.loadString(assetPath);
    final List<dynamic> data = json.decode(response);
    targetMap.clear();
    for (final jsonItem in data) {
      try {
        final poi = Poi.fromJson(jsonItem as Map<String, dynamic>);
        targetMap[poi.id] = poi;
      } catch (e) {}
    }
  }

  Future<void> _populateNotes() async {
    final notes = await _dataProvider.loadNotes();
    if (notes != null) {
      _poiNotesById.clear();
      for (final note in notes) {
        _poiNotesById[note.id] = note;
      }
    }
  }

  Future<void> _populateFavorites() async {
    _favoritesById.clear();
    for (final poiId in await _dataProvider.loadFavoritePoiIds()) {
      final poi = _poisById[poiId];
      if (poi != null) {
        _favoritesById[poiId] = poi;
      }
    }
  }

  Iterable<PoiNote> getPoiNotesForId(String poiId) {
    return _poiNotesById.values.where((note) => note.poiId == poiId);
  }

  Future<bool> addNotes(PoiNote note) async {
    final result = await _dataProvider.addNote(note);
    if (result) {
      _poiNotesById[note.id] = note;
      notifyListeners(poiNotesChanged);
    }
    return result;
  }

  Future<bool> updateNote(PoiNote note) async {
    final result = await _dataProvider.updateNote(note);
    if (result) {
      _poiNotesById[note.id] = note;
      notifyListeners(poiNotesChanged);
    }
    return result;
  }

  Future<bool> deleteNote(PoiNote note) async {
    final result = await _dataProvider.deleteNote(note.id);
    if (result) {
      _poiNotesById.remove(note.id);
      notifyListeners(poiNotesChanged);
    }
    return result;
  }

  Future<void> toggleFavorite(Poi poi) async {
    if (_favoritesById.containsKey(poi.id)) {
      final result = await _dataProvider.removeFavorite(poi.id);
      if (result) {
        _favoritesById.remove(poi.id);
      }
    } else {
      final result = await _dataProvider.addFavorite(poi);
      if (result) {
        _favoritesById[poi.id] = poi;
      }
    }
    notifyListeners(poisFavoriteChanged);
    notifyListeners("$poisFavoriteChanged:${poi.id}");
  }

  Future<bool> resetAll() async {
    bool result = await _dataProvider.resetAll();
    if (result) {
      final favoritesIds = _favoritesById.keys.toList();
      _favoritesById.clear();
      _poiNotesById.clear();
      for (var id in favoritesIds) {
        notifyListeners("$poisFavoriteChanged:$id");
      }
      notifyListeners(poisFavoriteChanged);
      notifyListeners(poiNotesChanged);
    }

    return result;
  }

  bool isFavorite(Poi poi) {
    return _favoritesById.containsKey(poi.id);
  }

  void resetFilters() {
    _filters.clear();
    notifyListeners(filtersReseted);
  }

  bool toggleFilter(String filter) {
    final isRemoved = _filters.remove(filter);
    if (!isRemoved) {
      _filters.add(filter);
    }
    notifyListeners(filtersChanged);
    return !isRemoved;
  }

  bool isFilterActive(String filter) {
    return _filters.contains(filter);
  }

  Poi? getPoiById(String id) {
    return _poisById[id];
  }

  Iterable<Poi> _filteredPois() {
    final Map<String, Poi> targetMap;
    switch (selectedPackage) {
      case UniversitiesPackage.general:
        targetMap = _poisById;
        break;
      case UniversitiesPackage.french:
        targetMap = _frenchPoisById;
        break;
    }
    if (_filters.isEmpty) {
      return targetMap.values;
    }
    return targetMap.values.where(
      (poi) => _filters.any((filter) => poi.subjects.contains(filter)),
    );
  }
}
