/// Estado de humor que a pessoa pode registrar (sem culpa, só para si).
enum Mood { bem, cansado, estressado, sobrecarregado }

/// Registro de humor feito num momento do dia.
class MoodEntry {
  const MoodEntry({
    required this.mood,
    required this.date,
  });

  final Mood mood;
  final DateTime date;

  MoodEntry copyWith({
    Mood? mood,
    DateTime? date,
  }) {
    return MoodEntry(
      mood: mood ?? this.mood,
      date: date ?? this.date,
    );
  }
}
