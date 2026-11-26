import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/survey.dart';
import '../survey_feedback.dart';
import '../survey_items.dart';

/// Uma afirmação por tela: progresso, dimensão, frase e a escala de 1 a 5 em
/// botões grandes. Tocar numa opção responde (o avanço é feito pela tela).
class SurveyQuestionView extends StatelessWidget {
  const SurveyQuestionView({
    super.key,
    required this.question,
    required this.index,
    required this.total,
    required this.selected,
    required this.onSelect,
  });

  final SurveyQuestion question;
  final int index;
  final int total;

  /// Índice já escolhido (ao voltar para uma pergunta respondida).
  final int? selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final DimensionInfo info = kDimensionInfo[question.dimension]!;
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: <Widget>[
        Semantics(
          label: 'Frase ${index + 1} de $total',
          excludeSemantics: true,
          child: ProgressBarLabeled(
            value: (index + 1) / total,
            label: '${index + 1} de $total',
            showPercent: false,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Align(
          alignment: Alignment.centerLeft,
          child: TagBadge(label: info.label, icon: info.icon),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(question.text, style: textTheme.titleLarge),
        const SizedBox(height: AppSpacing.xs),
        Text('O quanto você concorda?', style: textTheme.bodyMedium),
        const SizedBox(height: AppSpacing.xl),
        for (int i = 0; i < kSurveyScale.length; i++) ...<Widget>[
          _ScaleButton(
            option: kSurveyScale[i],
            selected: selected == i,
            onTap: () => onSelect(i),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }
}

/// Botão grande da escala (emoji + rótulo), altura ≥ 56.
class _ScaleButton extends StatelessWidget {
  const _ScaleButton({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final SurveyScaleOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Semantics(
      button: true,
      selected: selected,
      label: option.label,
      excludeSemantics: true,
      child: BreatheCard(
        color: selected ? AppColors.primary : AppColors.surface,
        borderColor: selected ? AppColors.primary : AppColors.border,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 32),
          child: Row(
            children: <Widget>[
              Text(option.emoji, style: textTheme.titleLarge),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  option.label,
                  style: textTheme.labelLarge?.copyWith(
                    color: selected ? AppColors.onDark : AppColors.textPrimary,
                  ),
                ),
              ),
              if (selected)
                const Icon(Icons.check_rounded, color: AppColors.onDark),
            ],
          ),
        ),
      ),
    );
  }
}
