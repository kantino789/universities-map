import 'package:universities_map/data/data_provider_interface.dart';
import 'package:universities_map/model/poi.dart';
import 'package:universities_map/model/poi_note.dart';

class DebugDataProvider implements IDataProvider {
  final List<PoiNote> _notes = [];
  final List<Poi> _favorites = [];

  @override
  Future<Iterable<PoiNote>?> loadNotes() async {
    return _notes;
  }

  @override
  Future<bool> addNote(PoiNote note) async {
    _notes.add(note);
    return true;
  }

  @override
  Future<bool> updateNote(PoiNote note) async {
    final index = _notes.indexWhere((n) => n.id == note.id);
    if (index != -1) {
      _notes[index] = note;
      return true;
    }
    return false;
  }

  @override
  Future<bool> deleteNote(String noteId) async {
    final index = _notes.indexWhere((n) => n.id == noteId);
    if (index != -1) {
      _notes.removeAt(index);
      return true;
    }
    return false;
  }

  @override
  Future<bool> addFavorite(Poi poi) async {
    _favorites.add(poi);
    return true;
  }

  @override
  Future<bool> removeFavorite(String poiId) async {
    final index = _favorites.indexWhere((p) => p.id == poiId);
    if (index != -1) {
      _favorites.removeAt(index);
      return true;
    }
    return false;
  }
}
