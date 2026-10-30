import 'package:universities_map/model/poi_note.dart';
import 'package:universities_map/config.dart';
import 'package:universities_map/data/debug_data_provider.dart';
import 'package:universities_map/data/data_provider.dart';

abstract class IDataProvider {
  Future<Iterable<PoiNote>?> loadNotes();
  Future<bool> addNote(PoiNote note);
  Future<bool> updateNote(PoiNote note);
  Future<bool> deleteNote(String noteId);

  factory IDataProvider.fromConfig(Config config) {
    switch (config) {
      case Config.debug:
        return DebugDataProvider();
      case Config.release:
        return DataProvider();
    }
  }
}
