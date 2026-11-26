import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/providers/providers.dart';
import 'how_to_earn_sheet.dart';

/// Card de pontos (coralSoft): saldo de pontos e atalho para "Como ganhar
/// pontos".
class PointsCard extends ConsumerWidget {
  const PointsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final int points = ref.watch(profileProvider).profile.points;

    return BreatheCard(
      color: AppColors.coralSoft,
      borderColor: AppColors.coralSoft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Seus pontos', style: textTheme.titleMedium),
                  const SizedBox(height: AppSpacing.xs),
                  AnimatedNumber(value: points, style: textTheme.displaySmall),
                ],
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.xs),
                  child: Text(
                    'Pausas, metas e o questionário viram pontos para trocar por vantagens.',
                    style: textTheme.bodyMedium
                        ?.copyWith(color: AppColors.textPrimary),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          SecondaryButton(
            label: 'Como ganhar pontos',
            icon: Icons.help_outline_rounded,
            onPressed: () => showHowToEarnSheet(context),
          ),
        ],
      ),
    );
  }
}
