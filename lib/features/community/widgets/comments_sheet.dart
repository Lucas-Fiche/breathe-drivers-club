import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/models.dart';
import 'author_avatar.dart';

/// Abre a lista simples de comentários de um post.
Future<void> showCommentsSheet(BuildContext context, CommunityPost post) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.background,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppRadius.header),
      ),
    ),
    builder: (BuildContext context) => _CommentsSheet(post: post),
  );
}

class _CommentsSheet extends StatelessWidget {
  const _CommentsSheet({required this.post});

  final CommunityPost post;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final double maxHeight = MediaQuery.of(context).size.height * 0.7;
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const _Handle(),
            const SizedBox(height: AppSpacing.lg),
            Text(
              post.commentCount == 1
                  ? '1 comentário'
                  : '${post.commentCount} comentários',
              style: textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.lg),
            if (post.comments.isEmpty)
              const EmptyState(
                title: 'Nenhum comentário ainda',
                message: 'Quando alguém responder, aparece aqui.',
                icon: Icons.chat_bubble_outline_rounded,
              )
            else
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: post.comments.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.md),
                  itemBuilder: (BuildContext context, int i) =>
                      _CommentTile(comment: post.comments[i]),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _CommentTile extends StatelessWidget {
  const _CommentTile({required this.comment});

  final PostComment comment;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        AuthorAvatar(name: comment.author, size: 36),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: BreatheCard(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${comment.author} · ${formatTimeAgo(comment.date)}',
                  style: textTheme.bodySmall,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(comment.text, style: textTheme.bodyLarge),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Handle extends StatelessWidget {
  const _Handle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 40,
        height: AppSpacing.xs,
        decoration: BoxDecoration(
          color: AppColors.border,
          borderRadius: BorderRadius.circular(AppSpacing.xs),
        ),
      ),
    );
  }
}
