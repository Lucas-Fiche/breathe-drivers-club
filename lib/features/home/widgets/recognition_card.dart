import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/providers/providers.dart';

/// Card de reconhecimento: valoriza o autocuidado (pausas), nunca o excesso de
/// corridas.
class RecognitionCard extends ConsumerWidget {
  const RecognitionCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final int breaks = ref.watch(planProvider).workDay.breaksTaken;
    final int earned = breaks * PointRewards.perBreak;

    final String message = breaks == 0
        ? 'Nenhuma pausa ainda. Quando parar para respirar, a gente reconhece.'
        : 'Você fez $breaks ${breaks == 1 ? 'pausa' : 'pausas'} hoje. '
            'Cuidar de você também é trabalho.';

    return BreatheCard(
      child: Row(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: const BoxDecoration(
              color: AppColors.mint,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.emoji_events_outlined,
                color: AppColors.primary),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(message, style: textTheme.bodyLarge),
                if (earned > 0) ...<Widget>[
                  const SizedBox(height: AppSpacing.sm),
                  TagBadge(label: '+$earned pontos'),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
