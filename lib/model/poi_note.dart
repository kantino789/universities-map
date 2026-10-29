class PoiNote {
  final String poiId;
  String note;
  final DateTime createdAt;
  DateTime? editedAt;

  PoiNote({required this.poiId, required this.note, required this.createdAt});
}
