import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/providers/providers.dart';

/// Card "Sua meta de hoje": corridas feitas de X com −/+, barra e uma frase que
/// muda conforme o progresso. Ao bater a meta, reconhece e sugere descansar —
/// nunca "faça mais".
class DailyGoalCard extends ConsumerWidget {
  const DailyGoalCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final dailyGoal = ref.watch(planProvider).dailyGoal;
    final bool reached = dailyGoal.completedRides >= dailyGoal.targetRides;

    return BreatheCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SectionTitle(title: 'Sua meta de hoje'),
          const SizedBox(height: AppSpacing.sm),
          StepperCounter(
            value: dailyGoal.completedRides,
            min: 0,
            max: dailyGoal.targetRides,
            label: 'de ${dailyGoal.targetRides} corridas',
            onChanged: (int v) =>
                ref.read(planProvider.notifier).setCompletedRides(v),
          ),
          const SizedBox(height: AppSpacing.lg),
          ProgressBarLabeled(value: dailyGoal.progress, showPercent: false),
          const SizedBox(height: AppSpacing.md),
          if (reached)
            _ReachedMessage()
          else
            Text(
              _phrase(dailyGoal.progress),
              style: textTheme.bodyMedium,
            ),
        ],
      ),
    );
  }

  String _phrase(double progress) {
    if (progress <= 0) {
      return 'Vamos com calma. Um passo de cada vez.';
    }
    if (progress < 0.5) {
      return 'Bom começo. Siga no seu ritmo.';
    }
    return 'Bom ritmo. Lembre de fazer pausas ao longo do dia.';
  }
}

class _ReachedMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.mint,
        borderRadius: BorderRadius.circular(AppRadius.button),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Icon(Icons.verified_rounded, color: AppColors.primary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'Meta do dia batida! Você mandou bem. Que tal encerrar ou '
              'descansar um pouco? Você merece.',
              style: textTheme.bodyMedium?.copyWith(color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
