import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';

/// Mensagem acolhedora (sem julgamento) exibida no onboarding, por exemplo
/// quando a pessoa informa jornadas muito longas.
class OnboardingHint extends StatelessWidget {
  const OnboardingHint({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return BreatheCard(
      color: AppColors.coralSoft,
      borderColor: AppColors.coralSoft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Icon(Icons.favorite_rounded, color: AppColors.coral),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              text,
              style: textTheme.bodyMedium?.copyWith(color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
