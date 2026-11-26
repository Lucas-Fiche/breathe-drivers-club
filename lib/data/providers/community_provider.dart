import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/models.dart';
import '../repositories/repositories.dart';
import 'persona_provider.dart';
import 'profile_provider.dart';
import 'repository_providers.dart';

/// Estado da comunidade: lista de posts (mais recentes primeiro).
class CommunityState {
  const CommunityState({required this.posts});

  final List<CommunityPost> posts;

  CommunityState copyWith({List<CommunityPost>? posts}) {
    return CommunityState(posts: posts ?? this.posts);
  }
}

class CommunityNotifier extends Notifier<CommunityState> {
  @override
  CommunityState build() {
    final Persona persona = ref.watch(personaProvider);
    final CommunityRepository repo = ref.read(communityRepositoryProvider);
    return CommunityState(posts: repo.loadPosts(persona));
  }

  /// Limite de caracteres de uma publicação.
  static const int maxLength = 500;

  /// Publica um novo post no topo do feed, assinado pela pessoa ativa.
  /// Texto vazio é ignorado; acima de [maxLength] é cortado.
  void publish({required String text, required PostCategory category}) {
    String trimmed = text.trim();
    if (trimmed.isEmpty) return;
    if (trimmed.length > maxLength) trimmed = trimmed.substring(0, maxLength);
    final UserProfile profile = ref.read(profileProvider).profile;
    final CommunityPost post = CommunityPost(
      id: 'post-${DateTime.now().microsecondsSinceEpoch}',
      author: profile.name,
      authorType: profile.type,
      category: category,
      text: trimmed,
      likes: 0,
      date: DateTime.now(),
    );
    state = state.copyWith(posts: <CommunityPost>[post, ...state.posts]);
  }

  /// Alterna a curtida de um post.
  void toggleLike(String postId) {
    _update(
      postId,
      (CommunityPost p) => p.copyWith(
        liked: !p.liked,
        likes: p.liked ? p.likes - 1 : p.likes + 1,
      ),
    );
  }

  /// Marca o post como denunciado (no protótipo, só registra localmente;
  /// na versão real iria para a moderação).
  void report(String postId) {
    _update(postId, (CommunityPost p) => p.copyWith(reported: true));
  }

  void _update(String postId, CommunityPost Function(CommunityPost) change) {
    state = state.copyWith(
      posts: <CommunityPost>[
        for (final CommunityPost p in state.posts)
          if (p.id == postId) change(p) else p,
      ],
    );
  }
}

final NotifierProvider<CommunityNotifier, CommunityState> communityProvider =
    NotifierProvider<CommunityNotifier, CommunityState>(CommunityNotifier.new);
