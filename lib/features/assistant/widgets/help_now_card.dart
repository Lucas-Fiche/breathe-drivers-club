import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';

/// Card de acolhimento "Precisa de ajuda agora?" (coralSoft).
class HelpNowCard extends StatelessWidget {
  const HelpNowCard({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return BreatheCard(
      color: AppColors.coralSoft,
      borderColor: AppColors.coralSoft,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Precisa de ajuda agora?', style: textTheme.titleMedium),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Se o estresse estiver pesado ou o dia difícil, fale com um '
            'profissional. É gratuito e sigiloso.',
            style: textTheme.bodyMedium?.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: AppSpacing.md),
          PrimaryButton(
            label: 'Pedir acolhimento',
            onPressed: () => context.push('/ajuda'),
          ),
        ],
      ),
    );
  }
}
