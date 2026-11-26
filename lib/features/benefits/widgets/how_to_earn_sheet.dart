import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../data/providers/providers.dart';

/// Abre o bottom sheet explicando como ganhar pontos.
Future<void> showHowToEarnSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.background,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.header)),
    ),
    builder: (BuildContext context) => const _HowToEarnSheet(),
  );
}

class _HowToEarnSheet extends StatelessWidget {
  const _HowToEarnSheet();

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    // Rolável: com texto ampliado, a lista pode passar da altura do sheet.
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: AppSpacing.xl,
        right: AppSpacing.xl,
        top: AppSpacing.xl,
        bottom: MediaQuery.of(context).padding.bottom + AppSpacing.xl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('Como ganhar pontos', style: textTheme.titleLarge),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Os pontos reconhecem o seu cuidado e o seu planejamento.',
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.xl),
          const _EarnRow(
            icon: Icons.self_improvement_rounded,
            title: 'Fazer pausas',
            points: '+${PointRewards.perBreak} por pausa',
          ),
          const _EarnRow(
            icon: Icons.flag_rounded,
            title: 'Concluir etapas de metas',
            points: '+${PointRewards.perGoalStep} por etapa',
          ),
          const _EarnRow(
            icon: Icons.assignment_turned_in_outlined,
            title: 'Responder o questionário',
            points: '+${PointRewards.perSurvey}',
          ),
          const _EarnRow(
            icon: Icons.mood_rounded,
            title: 'Registrar como você está',
            points: '+${PointRewards.perMood} por registro',
          ),
          const _EarnRow(
            icon: Icons.event_available_outlined,
            title: 'Mostrar interesse em eventos do clube',
            points: '+${PointRewards.perEventInterest} por evento',
          ),
          const SizedBox(height: AppSpacing.lg),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.coralSoft,
              borderRadius: BorderRadius.circular(AppRadius.button),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Icon(Icons.info_outline_rounded, color: AppColors.coral),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'Pontos não vêm de fazer mais corridas. Eles valorizam o '
                    'seu bem-estar, não a sua jornada.',
                    style: textTheme.bodyMedium
                        ?.copyWith(color: AppColors.textPrimary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EarnRow extends StatelessWidget {
  const _EarnRow({
    required this.icon,
    required this.title,
    required this.points,
  });

  final IconData icon;
  final String title;
  final String points;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Row(
        children: <Widget>[
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColors.mint,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: AppColors.primary),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: Text(title, style: textTheme.titleMedium)),
          const SizedBox(width: AppSpacing.sm),
          Text(
            points,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
