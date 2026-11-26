import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../survey_feedback.dart';

/// Resumo de uma dimensão: nome, nível em palavras, barra e frase acolhedora.
///
/// A barra mostra a pontuação da própria dimensão (Fadiga cheia = muito
/// cansaço). Ela fica coral só quando o resultado pede atenção; nunca
/// vermelha.
class DimensionResultCard extends StatelessWidget {
  const DimensionResultCard({
    super.key,
    required this.info,
    required this.score,
  });

  final DimensionInfo info;

  /// Pontuação bruta da dimensão, 0–1.
  final double score;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final bool attention =
        levelFor(info.favorable(score)) == FeedbackLevel.attention;
    return BreatheCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(info.icon, color: AppColors.primary),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: Text(info.label, style: textTheme.titleMedium)),
              Text(
                info.levelWord(score),
                style: textTheme.labelLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Semantics(
            label: '${info.label}: ${info.levelWord(score)}',
            excludeSemantics: true,
            child: ProgressBarLabeled(
              value: score,
              showPercent: false,
              color: attention ? AppColors.coral : AppColors.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            info.phrase(score),
            style: textTheme.bodyMedium?.copyWith(color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}

/// Sugestão prática tocável, que leva a uma tela do app.
class SuggestionTile extends StatelessWidget {
  const SuggestionTile({
    super.key,
    required this.suggestion,
    required this.onTap,
  });

  final SurveySuggestion suggestion;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return BreatheCard(
      color: AppColors.mint,
      borderColor: AppColors.mint,
      padding: const EdgeInsets.all(AppSpacing.lg),
      onTap: onTap,
      child: Row(
        children: <Widget>[
          Icon(suggestion.icon, color: AppColors.primary),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(suggestion.title, style: textTheme.labelLarge),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  suggestion.text,
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.primary),
        ],
      ),
    );
  }
}
