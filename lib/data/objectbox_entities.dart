import 'package:objectbox/objectbox.dart';

@Entity()
class NoteEntity {
  @Id()
  int id = 0;

  @Unique()
  String noteId;

  String poiId;
  String text;
  int createdAtMilliseconds;

  NoteEntity({
    required this.noteId,
    required this.poiId,
    required this.text,
    required this.createdAtMilliseconds,
  });
}

@Entity()
class FavoriteEntity {
  @Id()
  int id = 0;

  @Unique()
  String poiId;

  FavoriteEntity({required this.poiId});
}