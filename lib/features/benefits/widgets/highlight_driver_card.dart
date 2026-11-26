import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/providers/providers.dart';

/// Card "Motorista destaque": selo baseado em metas e autocuidado (nunca em
/// volume de corridas), com o progresso rumo ao selo do mês.
class HighlightDriverCard extends ConsumerWidget {
  const HighlightDriverCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final HighlightProgress highlight = ref.watch(highlightProvider);
    final double progress = highlight.progress;
    final int missing = highlight.missing;

    return BreatheCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: const BoxDecoration(
                  color: AppColors.coralSoft,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.workspace_premium_rounded,
                    color: AppColors.coral),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text('Motorista destaque', style: textTheme.titleMedium),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'O selo do mês valoriza quem cuida de si e segue o próprio plano: '
            'pausas, etapas de metas e o questionário respondido. Ele não '
            'depende de fazer mais corridas.',
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.lg),
          ProgressBarLabeled(value: progress, showPercent: true),
          const SizedBox(height: AppSpacing.sm),
          Text(
            missing == 0
                ? 'Selo deste mês conquistado. Mandou muito bem!'
                : 'Faltam $missing ações de cuidado para o selo deste mês.',
            style: textTheme.bodyMedium?.copyWith(
              color: missing == 0 ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
