import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/models.dart';
import '../../../data/providers/providers.dart';

/// Card "Motorista destaque": selo baseado em metas e autocuidado (nunca em
/// volume de corridas), com o progresso rumo ao selo do mês.
class HighlightDriverCard extends ConsumerWidget {
  const HighlightDriverCard({super.key});

  /// Quantas "ações de cuidado" fecham o selo do mês (provisório).
  static const int _target = 25;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final plan = ref.watch(planProvider);
    final bool survey = ref.watch(surveyProvider).submitted;

    final int completedSteps = plan.goals
        .fold<int>(0, (int sum, LifeGoal g) => sum + g.completedSteps);
    final int value =
        completedSteps + plan.workDay.breaksTaken + (survey ? 5 : 0);
    final double progress = (value / _target).clamp(0.0, 1.0);
    final int missing = (_target - value).clamp(0, _target);

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
