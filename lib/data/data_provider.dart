import 'package:universities_map/data/data_provider_interface.dart';
import 'package:universities_map/model/poi_note.dart';

class DataProvider implements IDataProvider {
  @override
  Future<Iterable<PoiNote>?> loadNotes() async {
    throw Exception('Load notes not implemented');
  }

  @override
  Future<bool> addNote(PoiNote note) async {
    throw Exception('Add note not implemented');
  }

  @override
  Future<bool> updateNote(PoiNote note) async {
    throw Exception('Update note not implemented');
  }

  @override
  Future<bool> deleteNote(String noteId) async {
    throw Exception('Delete note not implemented');
  }
}
