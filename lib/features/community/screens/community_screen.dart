import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/utils/navigation.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/models.dart';
import '../../../data/providers/providers.dart';
import '../widgets/community_rules_banner.dart';
import '../widgets/post_card.dart';
import '../widgets/publish_post_sheet.dart';

/// Tela Comunidade (`/comunidade`): regras de convivência, filtros por
/// categoria, feed de posts e botão "+ Publicar".
class CommunityScreen extends ConsumerStatefulWidget {
  const CommunityScreen({super.key});

  @override
  ConsumerState<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends ConsumerState<CommunityScreen> {
  /// Filtro ativo (nulo = "Todos").
  PostCategory? _filter;

  final ScrollController _scroll = ScrollController();

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _openPublish() async {
    final bool? published = await showPublishPostSheet(context);
    if (published != true || !mounted) return;
    // Mostra o post novo: limpa o filtro e volta ao topo do feed.
    setState(() => _filter = null);
    if (_scroll.hasClients) {
      _scroll.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Publicado! Obrigado por compartilhar.'),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final List<CommunityPost> all = ref.watch(communityProvider).posts;
    final List<CommunityPost> posts = _filter == null
        ? all
        : all.where((CommunityPost p) => p.category == _filter).toList();

    return BreatheScaffold(
      title: 'Comunidade',
      subtitle: 'Troque experiências com outros trabalhadores',
      onBack: () => popOrGo(context),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openPublish,
        backgroundColor: AppColors.coral,
        foregroundColor: AppColors.textPrimary,
        elevation: 2,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Publicar'),
      ),
      body: ListView(
        controller: _scroll,
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          // Espaço para o FAB não cobrir o último post.
          AppSpacing.xxxl * 3,
        ),
        children: <Widget>[
          const CommunityRulesBanner(),
          const SizedBox(height: AppSpacing.lg),
          _FilterChips(
            selected: _filter,
            onSelected: (PostCategory? c) => setState(() => _filter = c),
          ),
          const SizedBox(height: AppSpacing.lg),
          if (posts.isEmpty)
            const EmptyState(
              title: 'Nada por aqui ainda',
              message: 'Seja a primeira pessoa a publicar nesta categoria.',
              icon: Icons.forum_outlined,
            )
          else
            for (final CommunityPost p in posts) ...<Widget>[
              PostCard(key: ValueKey<String>(p.id), post: p),
              const SizedBox(height: AppSpacing.md),
            ],
        ],
      ),
    );
  }
}

/// Filtros do feed: Todos + uma pílula por categoria (rolagem horizontal).
class _FilterChips extends StatelessWidget {
  const _FilterChips({required this.selected, required this.onSelected});

  final PostCategory? selected;
  final ValueChanged<PostCategory?> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          PillChip(
            label: 'Todos',
            selected: selected == null,
            onTap: () => onSelected(null),
          ),
          for (final PostCategory c in PostCategory.values) ...<Widget>[
            const SizedBox(width: AppSpacing.sm),
            PillChip(
              label: c.filterLabel,
              selected: selected == c,
              onTap: () => onSelected(c),
            ),
          ],
        ],
      ),
    );
  }
}
