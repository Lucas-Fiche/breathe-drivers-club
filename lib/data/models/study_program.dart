/// Programa de estudo oferecido pelo clube (parceria educacional fictícia).
class StudyProgram {
  const StudyProgram({
    required this.id,
    required this.title,
    required this.description,
    required this.provider,
  });

  final String id;
  final String title;
  final String description;

  /// Instituição parceira (fictícia).
  final String provider;

  StudyProgram copyWith({
    String? id,
    String? title,
    String? description,
    String? provider,
  }) {
    return StudyProgram(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      provider: provider ?? this.provider,
    );
  }
}
