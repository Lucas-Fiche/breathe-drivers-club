import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/models.dart';
import '../../../data/providers/providers.dart';

/// Dica contextual (fundo mint) conforme as metas do plano, com atalho para os
/// benefícios já filtrados pela categoria mais relevante.
class AssistantTipCard extends ConsumerWidget {
  const AssistantTipCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Set<GoalCategory> categories = ref
        .watch(planProvider)
        .goals
        .where((LifeGoal g) => !g.isComplete)
        .map((LifeGoal g) => g.category)
        .toSet();

    final _Tip tip = _tipFor(categories);

    return BreatheCard(
      color: AppColors.mint,
      borderColor: AppColors.mint,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const Icon(Icons.tips_and_updates_outlined,
                  color: AppColors.primary),
              const SizedBox(width: AppSpacing.sm),
              Text('Dica do assistente', style: textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            tip.text,
            style: textTheme.bodyMedium?.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: AppSpacing.lg),
          PrimaryButton(
            label: 'Ver programas',
            onPressed: () => context.go('/beneficios?categoria=${tip.filter}'),
          ),
        ],
      ),
    );
  }

  _Tip _tipFor(Set<GoalCategory> categories) {
    if (categories.contains(GoalCategory.estudos)) {
      return const _Tip(
        'Seu plano inclui estudos. A empresa tem programas de apoio à escola e '
        'à graduação.',
        'estudos',
      );
    }
    if (categories.contains(GoalCategory.financas)) {
      return const _Tip(
        'Dá para organizar o dinheiro aos poucos. Há parceiros com conta sem '
        'tarifa e educação financeira.',
        'financas',
      );
    }
    if (categories.contains(GoalCategory.saude)) {
      return const _Tip(
        'Cuidar da saúde é parte do plano. Veja os parceiros de consultas, '
        'exames e odontologia.',
        'saude',
      );
    }
    return const _Tip(
      'Seu plano, seu ritmo. Veja os benefícios e programas que o clube '
      'oferece para apoiar seus objetivos.',
      'trabalho',
    );
  }
}

class _Tip {
  const _Tip(this.text, this.filter);

  final String text;

  /// Categoria passada ao /beneficios como query parameter.
  final String filter;
}
