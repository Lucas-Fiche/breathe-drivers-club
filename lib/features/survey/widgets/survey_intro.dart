import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/providers/rewards.dart';
import '../survey_items.dart';

/// Introdução do questionário: para que serve, tempo, privacidade e pontos.
class SurveyIntro extends StatelessWidget {
  const SurveyIntro({
    super.key,
    required this.questionCount,
    required this.onStart,
  });

  final int questionCount;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: <Widget>[
        BreatheCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Como você está?', style: textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'A cada 6 meses, perguntamos sobre bem-estar, cansaço, sono e '
                'o apoio que você sente da empresa. Com isso, o clube sabe o '
                'que melhorar, e você recebe dicas para o seu momento.',
                style: textTheme.bodyLarge,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _InfoRow(
          icon: Icons.timer_outlined,
          title: '$kSurveyEstimatedTime · $questionCount frases',
          text:
              'Toque na opção que mais combina com você. Não há resposta '
              'certa ou errada.',
        ),
        const SizedBox(height: AppSpacing.md),
        const _InfoRow(
          icon: Icons.lock_outline_rounded,
          title: 'Suas respostas são suas',
          text:
              'Suas respostas individuais não são vistas pela empresa; ela '
              'vê só médias de todos.',
        ),
        const SizedBox(height: AppSpacing.md),
        const _InfoRow(
          icon: Icons.stars_rounded,
          title: '+${PointRewards.perSurvey} pontos ao concluir',
          text: 'Você pode trocar os pontos por benefícios.',
          highlight: true,
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(
          'Se estiver dirigindo, pare em local seguro antes de começar.',
          textAlign: TextAlign.center,
          style: textTheme.bodySmall,
        ),
        const SizedBox(height: AppSpacing.md),
        PrimaryButton(label: 'Começar', onPressed: onStart),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.title,
    required this.text,
    this.highlight = false,
  });

  final IconData icon;
  final String title;
  final String text;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Color background = highlight ? AppColors.coralSoft : AppColors.mint;
    return BreatheCard(
      color: background,
      borderColor: background,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, color: highlight ? AppColors.coral : AppColors.primary),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(title, style: textTheme.labelLarge),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  text,
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
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
