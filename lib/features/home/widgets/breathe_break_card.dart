import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';

/// Card "Hora de respirar": reforço positivo da pausa, com o CTA que abre a
/// pausa guiada.
class BreatheBreakCard extends StatelessWidget {
  const BreatheBreakCard({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return BreatheCard(
      color: AppColors.coralSoft,
      borderColor: AppColors.coralSoft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SectionTitle(title: 'Hora de respirar'),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Um minuto de pausa ajuda a seguir com mais calma e segurança.',
            style: textTheme.bodyMedium?.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: AppSpacing.lg),
          PrimaryButton(
            label: 'Iniciar pausa de 1 minuto',
            icon: Icons.self_improvement_rounded,
            onPressed: () => context.push('/inicio/pausa'),
          ),
        ],
      ),
    );
  }
}
