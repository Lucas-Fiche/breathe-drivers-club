/// Evento presencial do clube (encontro, roda de conversa, mutirão etc.).
class Event {
  const Event({
    required this.id,
    required this.title,
    required this.date,
    required this.location,
    required this.description,
  });

  final String id;
  final String title;
  final DateTime date;
  final String location;
  final String description;

  Event copyWith({
    String? id,
    String? title,
    DateTime? date,
    String? location,
    String? description,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      location: location ?? this.location,
      description: description ?? this.description,
    );
  }
}
