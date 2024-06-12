class Note {
  String id;
  String description;
  DateTime date;
  String status;
  bool important;

  Note({
    required this.id,
    required this.description,
    required this.date,
    required this.status,
    required this.important,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'date': date.toIso8601String(),
      'status': status,
      'important': important,
    };
  }

  static Note fromMap(Map<String, dynamic> map, String id) {
    return Note(
      id: id,
      description: map['description'],
      date: DateTime.parse(map['date']),
      status: map['status'],
      important: map['important'],
    );
  }
}
