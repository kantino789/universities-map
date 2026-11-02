import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:universities_map/data/data_provider.dart';
import 'package:universities_map/model/poi.dart';
import 'package:universities_map/model/poi_note.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late Directory directory;
  late DataProvider provider;

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('universities_map_');
    provider = await DataProvider.open(directory: directory.path);
  });

  tearDown(() async {
    provider.close();
    await directory.delete(recursive: true);
  });

  testWidgets('persists notes and favorites after reopening the store', (
    tester,
  ) async {
    final note = PoiNote(
      id: 'note-1',
      poiId: 'poi-1',
      note: 'Visit the library',
      createdAt: DateTime.utc(2026, 1, 2),
    );
    final poi = Poi(
      id: 'poi-1',
      title: 'University',
      description: '',
      location: const LatLng(0, 0),
      country: 'FR',
      subjects: const [],
      website: '',
    );

    expect(await provider.addNote(note), isTrue);
    expect(await provider.addFavorite(poi), isTrue);
    provider.close();
    provider = await DataProvider.open(directory: directory.path);

    final notes = await provider.loadNotes();
    expect(notes?.single.note, note.note);
    expect(notes?.single.createdAt, note.createdAt);
    expect(await provider.loadFavoritePoiIds(), contains(poi.id));
  });

  testWidgets('supports CRUD and rejects duplicate records', (tester) async {
    final note = PoiNote(
      id: 'note-1',
      poiId: 'poi-1',
      note: 'First version',
      createdAt: DateTime.utc(2026, 1, 2),
    );
    final updatedNote = PoiNote(
      id: note.id,
      poiId: note.poiId,
      note: 'Updated version',
      createdAt: note.createdAt,
    );
    final poi = Poi(
      id: 'poi-1',
      title: 'University',
      description: '',
      location: const LatLng(0, 0),
      country: 'FR',
      subjects: const [],
      website: '',
    );

    expect(await provider.addNote(note), isTrue);
    expect(await provider.addNote(note), isFalse);
    expect(await provider.updateNote(updatedNote), isTrue);
    expect((await provider.loadNotes())?.single.note, updatedNote.note);
    expect(await provider.deleteNote(note.id), isTrue);
    expect(await provider.deleteNote(note.id), isFalse);

    expect(await provider.addFavorite(poi), isTrue);
    expect(await provider.addFavorite(poi), isFalse);
    expect(await provider.removeFavorite(poi.id), isTrue);
    expect(await provider.removeFavorite(poi.id), isFalse);
  });
}