import 'user_profile.dart';

/// Categoria de uma publicação na comunidade.
enum PostCategory { dica, pontoDeApoio, conquista, desabafo }

extension PostCategoryX on PostCategory {
  /// Rótulo no singular, exibido na etiqueta do post.
  String get label {
    switch (this) {
      case PostCategory.dica:
        return 'Dica';
      case PostCategory.pontoDeApoio:
        return 'Ponto de apoio';
      case PostCategory.conquista:
        return 'Conquista';
      case PostCategory.desabafo:
        return 'Desabafo';
    }
  }

  /// Rótulo no plural, usado nos filtros do feed.
  String get filterLabel {
    switch (this) {
      case PostCategory.dica:
        return 'Dicas';
      case PostCategory.pontoDeApoio:
        return 'Pontos de apoio';
      case PostCategory.conquista:
        return 'Conquistas';
      case PostCategory.desabafo:
        return 'Desabafo';
    }
  }
}

/// Comentário numa publicação.
class PostComment {
  const PostComment({
    required this.author,
    required this.text,
    required this.date,
  });

  final String author;
  final String text;
  final DateTime date;
}

/// Publicação na comunidade de trabalhadores.
class CommunityPost {
  const CommunityPost({
    required this.id,
    required this.author,
    required this.authorType,
    required this.category,
    required this.text,
    required this.likes,
    required this.date,
    this.comments = const <PostComment>[],
    this.liked = false,
    this.reported = false,
  });

  final String id;
  final String author;
  final DriverType authorType;
  final PostCategory category;
  final String text;
  final int likes;
  final DateTime date;

  /// Comentários, do mais antigo para o mais recente.
  final List<PostComment> comments;

  /// Se a pessoa atual curtiu (estado local do protótipo).
  final bool liked;

  /// Se a pessoa atual já denunciou este post.
  final bool reported;

  int get commentCount => comments.length;

  CommunityPost copyWith({
    String? id,
    String? author,
    DriverType? authorType,
    PostCategory? category,
    String? text,
    int? likes,
    DateTime? date,
    List<PostComment>? comments,
    bool? liked,
    bool? reported,
  }) {
    return CommunityPost(
      id: id ?? this.id,
      author: author ?? this.author,
      authorType: authorType ?? this.authorType,
      category: category ?? this.category,
      text: text ?? this.text,
      likes: likes ?? this.likes,
      date: date ?? this.date,
      comments: comments ?? this.comments,
      liked: liked ?? this.liked,
      reported: reported ?? this.reported,
    );
  }
}
