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

  /// Publica um novo post, assinado pela pessoa ativa.
  void publish({required String text, required String category}) {
    final String trimmed = text.trim();
    if (trimmed.isEmpty) return;
    final String author = ref.read(profileProvider).profile.name;
    final CommunityPost post = CommunityPost(
      id: 'post-${DateTime.now().microsecondsSinceEpoch}',
      author: author,
      category: category,
      text: trimmed,
      likes: 0,
      comments: 0,
      date: DateTime.now(),
    );
    state = state.copyWith(
      posts: <CommunityPost>[post, ...state.posts],
    );
  }

  /// Alterna a curtida de um post.
  void toggleLike(String postId) {
    final List<CommunityPost> updated = <CommunityPost>[
      for (final CommunityPost p in state.posts)
        if (p.id == postId)
          p.copyWith(
            liked: !p.liked,
            likes: p.liked ? p.likes - 1 : p.likes + 1,
          )
        else
          p,
    ];
    state = state.copyWith(posts: updated);
  }
}

final NotifierProvider<CommunityNotifier, CommunityState> communityProvider =
    NotifierProvider<CommunityNotifier, CommunityState>(CommunityNotifier.new);
