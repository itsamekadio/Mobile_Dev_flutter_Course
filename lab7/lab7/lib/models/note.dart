class Note {

final int id;
final String title;
final String body;
final int createdAt;
Note({
  required this.id,
  required this.title,
  required this.body,
  required this.createdAt,});
  Map<String, dynamic> ConvertNoteToMap(Note note) {
    return <String, dynamic>{
      'id': note.id,
      'title': note.title,
      'body': note.body,
      'createdAt': note.createdAt,
    };
  }
}