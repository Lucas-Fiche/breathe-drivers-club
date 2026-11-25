/// Publicação na comunidade de trabalhadores.
class CommunityPost {
  const CommunityPost({
    required this.id,
    required this.author,
    required this.category,
    required this.text,
    required this.likes,
    required this.comments,
    required this.date,
    this.liked = false,
  });

  final String id;
  final String author;

  /// Categoria do post (ex.: "Dica", "Desabafo", "Conquista", "Pergunta").
  final String category;

  final String text;
  final int likes;
  final int comments;
  final DateTime date;

  /// Se a pessoa atual curtiu (estado local do protótipo).
  final bool liked;

  CommunityPost copyWith({
    String? id,
    String? author,
    String? category,
    String? text,
    int? likes,
    int? comments,
    DateTime? date,
    bool? liked,
  }) {
    return CommunityPost(
      id: id ?? this.id,
      author: author ?? this.author,
      category: category ?? this.category,
      text: text ?? this.text,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      date: date ?? this.date,
      liked: liked ?? this.liked,
    );
  }
}
