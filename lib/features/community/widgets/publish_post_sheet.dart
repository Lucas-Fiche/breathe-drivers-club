import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/models.dart';
import '../../../data/providers/providers.dart';

/// Abre o bottom sheet "Nova publicação". Devolve true se publicou.
Future<bool?> showPublishPostSheet(BuildContext context) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.background,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppRadius.header),
      ),
    ),
    builder: (BuildContext context) => const _PublishSheet(),
  );
}

class _PublishSheet extends ConsumerStatefulWidget {
  const _PublishSheet();

  @override
  ConsumerState<_PublishSheet> createState() => _PublishSheetState();
}

class _PublishSheetState extends ConsumerState<_PublishSheet> {
  final TextEditingController _text = TextEditingController();
  PostCategory _category = PostCategory.dica;

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  bool get _canPublish => _text.text.trim().isNotEmpty;

  void _publish() {
    if (!_canPublish) return;
    ref
        .read(communityProvider.notifier)
        .publish(text: _text.text, category: _category);
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.xl,
        right: AppSpacing.xl,
        top: AppSpacing.xl,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.xl,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: Container(
                width: 40,
                height: AppSpacing.xs,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(AppSpacing.xs),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Nova publicação', style: textTheme.titleLarge),
            const SizedBox(height: AppSpacing.xl),
            Text('Categoria', style: textTheme.titleMedium),
            const SizedBox(height: AppSpacing.md),
            ChipGroup(
              options: <String>[
                for (final PostCategory c in PostCategory.values) c.label,
              ],
              selectedIndex: _category.index,
              onSelected: (int i) =>
                  setState(() => _category = PostCategory.values[i]),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('O que você quer compartilhar?', style: textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _text,
              autofocus: true,
              minLines: 4,
              maxLines: 8,
              maxLength: CommunityNotifier.maxLength,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                hintText: 'Uma dica, uma conquista, um desabafo…',
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            const _PrivacyWarning(),
            const SizedBox(height: AppSpacing.xl),
            PrimaryButton(
              label: 'Publicar',
              onPressed: _canPublish ? _publish : null,
            ),
          ],
        ),
      ),
    );
  }
}

/// Aviso "Não compartilhe dados pessoais".
class _PrivacyWarning extends StatelessWidget {
  const _PrivacyWarning();

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return BreatheCard(
      color: AppColors.coralSoft,
      borderColor: AppColors.coralSoft,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: <Widget>[
          const Icon(Icons.lock_outline_rounded, color: AppColors.primaryDark),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              'Não compartilhe dados pessoais: telefone, endereço, placa ou '
              'documentos.',
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
