import 'package:universities_map/data/data_provider_interface.dart';
import 'package:universities_map/model/poi_note.dart';
import 'package:universities_map/model/poi.dart';
import 'package:universities_map/data/objectbox_entities.dart';
import 'package:universities_map/objectbox.g.dart';

class DataProvider implements IDataProvider {
  final Store _store;
  late final Box<NoteEntity> _notes = _store.box<NoteEntity>();
  late final Box<FavoriteEntity> _favorites = _store.box<FavoriteEntity>();

  DataProvider._(this._store);

  static Future<DataProvider> open({String? directory}) async {
    return DataProvider._(await openStore(directory: directory));
  }

  void close() {
    _store.close();
  }

  @override
  Future<Iterable<PoiNote>?> loadNotes() async {
    return _notes
        .getAll()
        .map(
          (entity) => PoiNote(
            id: entity.noteId,
            poiId: entity.poiId,
            note: entity.text,
            createdAt: DateTime.fromMillisecondsSinceEpoch(
              entity.createdAtMilliseconds,
            ),
          ),
        )
        .toList();
  }

  @override
  Future<Iterable<String>> loadFavoritePoiIds() async {
    return _favorites.getAll().map((favorite) => favorite.poiId).toList();
  }

  @override
  Future<bool> addNote(PoiNote note) async {
    if (_findNote(note.id) != null) {
      return false;
    }
    _notes.put(
      NoteEntity(
        noteId: note.id,
        poiId: note.poiId,
        text: note.note,
        createdAtMilliseconds: note.createdAt.millisecondsSinceEpoch,
      ),
    );
    return true;
  }

  @override
  Future<bool> updateNote(PoiNote note) async {
    final entity = _findNote(note.id);
    if (entity == null) {
      return false;
    }
    entity
      ..poiId = note.poiId
      ..text = note.note
      ..createdAtMilliseconds = note.createdAt.millisecondsSinceEpoch;
    _notes.put(entity);
    return true;
  }

  @override
  Future<bool> deleteNote(String noteId) async {
    final entity = _findNote(noteId);
    return entity != null && _notes.remove(entity.id);
  }

  @override
  Future<bool> addFavorite(Poi poi) async {
    if (_findFavorite(poi.id) != null) {
      return false;
    }
    _favorites.put(FavoriteEntity(poiId: poi.id));
    return true;
  }

  @override
  Future<bool> removeFavorite(String poiId) async {
    final favorite = _findFavorite(poiId);
    return favorite != null && _favorites.remove(favorite.id);
  }

  NoteEntity? _findNote(String noteId) {
    final query = _notes.query(NoteEntity_.noteId.equals(noteId)).build();
    try {
      return query.findFirst();
    } finally {
      query.close();
    }
  }

  FavoriteEntity? _findFavorite(String poiId) {
    final query = _favorites.query(FavoriteEntity_.poiId.equals(poiId)).build();
    try {
      return query.findFirst();
    } finally {
      query.close();
    }
  }
}
