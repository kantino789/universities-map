import 'package:universities_map/model/poi.dart';
import 'package:universities_map/model/poi_note.dart';

abstract class IDataProvider {
  Future<Iterable<PoiNote>?> loadNotes();
  Future<Iterable<String>> loadFavoritePoiIds();
  Future<bool> addNote(PoiNote note);
  Future<bool> updateNote(PoiNote note);
  Future<bool> deleteNote(String noteId);
  Future<bool> addFavorite(Poi poi);
  Future<bool> removeFavorite(String poiId);
}
