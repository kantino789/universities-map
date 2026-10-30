import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:universities_map/data/data_provider_interface.dart';
import 'package:universities_map/model/poi.dart';

import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:universities_map/model/poi_note.dart';

class Editor extends StringPropertyChangeNotifier {
  final IDataProvider _dataProvider;

  final Map<String, Poi> _poisById = {};
  Iterable<Poi> get displayedPois => _filteredPois();
  Iterable<Poi> get favoritePois =>
      _poisById.values.where((poi) => poi.isFavorite);

  final Map<String, PoiNote> _poiNotesById = {};
  Iterable<PoiNote> get poiNotes => _poiNotesById.values;

  final List<String> _filters = [];
  Iterable<String> get filters => _filters;

  static const String poisFavoriteChanged = 'poisFavoriteChanged';
  static const String filtersChanged = 'filtersChanged';
  static const String filtersReseted = 'filtersReseted';
  static const String poiNotesChanged = 'poiNotesChanged';

  Editor(this._dataProvider);

  Future<bool> initializeData() async {
    try {
      final String response = await rootBundle.loadString(
        'assets/universities.json',
      );

      // 2. Decode the raw JSON string to a List
      final List<dynamic> data = json.decode(response);

      // 3. Map each JSON object to a Poi instance
      _poisById.clear();
      for (final jsonItem in data) {
        final poi = Poi.fromJson(jsonItem as Map<String, dynamic>);
        _poisById[poi.id] = poi;
      }
      await _populateNotes();
      return true;
    } catch (e) {
      return false;
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

  void toggleFavorite(Poi poi) {
    poi.isFavorite = !poi.isFavorite;
    notifyListeners(poisFavoriteChanged);
    notifyListeners("$poisFavoriteChanged:${poi.id}");
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
    if (_filters.isEmpty) {
      return _poisById.values;
    }
    return _poisById.values.where(
      (poi) => _filters.any((filter) => poi.subjects.contains(filter)),
    );
  }
}
