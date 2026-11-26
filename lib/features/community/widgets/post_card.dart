import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/models.dart';
import '../../../data/providers/providers.dart';
import 'author_avatar.dart';
import 'comments_sheet.dart';

/// Card de uma publicação: autor, tipo, tempo, categoria, texto, curtir,
/// comentários e menu "⋯" com "Denunciar".
class PostCard extends ConsumerWidget {
  const PostCard({super.key, required this.post});

  final CommunityPost post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return BreatheCard(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AuthorAvatar(name: post.author),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(post.author, style: textTheme.titleMedium),
                    Text(
                      '${post.authorType.label} · ${formatTimeAgo(post.date)}',
                      style: textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              _PostMenu(post: post),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TagBadge(label: post.category.label),
                const SizedBox(height: AppSpacing.sm),
                Text(post.text, style: textTheme.bodyLarge),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: <Widget>[
              _ActionButton(
                icon: post.liked
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                color: post.liked ? AppColors.coral : AppColors.textSecondary,
                label: '${post.likes}',
                semanticLabel: post.liked
                    ? 'Descurtir. ${post.likes} curtidas'
                    : 'Curtir. ${post.likes} curtidas',
                onTap: () =>
                    ref.read(communityProvider.notifier).toggleLike(post.id),
              ),
              _ActionButton(
                icon: Icons.chat_bubble_outline_rounded,
                color: AppColors.textSecondary,
                label: '${post.commentCount}',
                semanticLabel: 'Ver ${post.commentCount} comentários',
                onTap: () => showCommentsSheet(context, post),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Botão de ação do rodapé do post (ícone + contador), toque ≥ 48 px.
class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.color,
    required this.label,
    required this.semanticLabel,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String label;
  final String semanticLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Semantics(
      button: true,
      label: semanticLabel,
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.button),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 48, minWidth: 64),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(icon, color: color, size: 22),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  label,
                  style: textTheme.labelLarge?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Menu "⋯" do post, com a opção "Denunciar".
class _PostMenu extends ConsumerWidget {
  const _PostMenu({required this.post});

  final CommunityPost post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<String>(
      tooltip: 'Mais opções',
      icon: const Icon(
        Icons.more_horiz_rounded,
        color: AppColors.textSecondary,
      ),
      color: AppColors.surface,
      onSelected: (_) => _report(context, ref),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'report',
          enabled: !post.reported,
          child: Row(
            children: <Widget>[
              const Icon(Icons.flag_outlined, color: AppColors.textSecondary),
              const SizedBox(width: AppSpacing.md),
              Text(post.reported ? 'Já denunciado' : 'Denunciar'),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _report(BuildContext context, WidgetRef ref) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Denunciar publicação?'),
        content: const Text(
          'Use quando o post desrespeita as regras de convivência. '
          'Quem publicou não vai saber que foi você.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Denunciar'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    ref.read(communityProvider.notifier).report(post.id);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Obrigado. Nossa moderação vai analisar.'),
        ),
      );
  }
}
