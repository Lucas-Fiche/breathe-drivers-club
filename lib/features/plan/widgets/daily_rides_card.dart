import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/health_limits.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/providers/providers.dart';

/// Card "Meta diária de corridas": o usuário define o ritmo. Acima do limite
/// saudável, mostra orientação gentil (sem bloquear).
class DailyRidesCard extends ConsumerWidget {
  const DailyRidesCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final int target = ref.watch(planProvider).dailyGoal.targetRides;
    final bool aboveLimit = target > HealthLimits.dailyRidesGuidanceThreshold;

    return BreatheCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const SectionTitle(title: 'Meta diária de corridas'),
          const SizedBox(height: AppSpacing.md),
          StepperCounter(
            value: target,
            min: DailyGoalLimits.min,
            max: DailyGoalLimits.max,
            onChanged: (int v) =>
                ref.read(planProvider.notifier).setDailyTarget(v),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Você define o ritmo. O app lembra das pausas.',
            style: textTheme.bodyMedium,
          ),
          if (aboveLimit) ...<Widget>[
            const SizedBox(height: AppSpacing.lg),
            _LimitHint(),
          ],
        ],
      ),
    );
  }
}

class _LimitHint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.coralSoft,
        borderRadius: BorderRadius.circular(AppRadius.button),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Icon(Icons.favorite_rounded, color: AppColors.coral),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'Metas acima de ${HealthLimits.dailyRidesGuidanceThreshold} '
              'corridas costumam exigir jornadas longas. Tudo bem mirar alto — '
              'só lembre de respeitar seus limites e descansar. Você decide.',
              style: textTheme.bodyMedium?.copyWith(color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
