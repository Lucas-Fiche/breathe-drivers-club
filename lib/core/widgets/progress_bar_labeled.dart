import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';

/// Barra de progresso com rótulo e porcentagem.
///
/// Linha superior: [label] à esquerda e a porcentagem à direita (ex.: "40%").
/// Abaixo, a barra: trilho [AppColors.mintTrack], preenchimento
/// [AppColors.primary], cantos arredondados. [value] vai de 0 a 1.
class ProgressBarLabeled extends StatelessWidget {
  const ProgressBarLabeled({
    super.key,
    required this.value,
    this.label,
    this.showPercent = true,
    this.height = 10,
    this.color = AppColors.primary,
  });

  final double value;
  final String? label;
  final bool showPercent;
  final double height;

  /// Cor do preenchimento (o trilho é sempre [AppColors.mintTrack]).
  final Color color;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final double clamped = value.clamp(0.0, 1.0);
    final int percent = (clamped * 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (label != null || showPercent) ...<Widget>[
          Row(
            children: <Widget>[
              if (label != null)
                Expanded(
                  child: Text(
                    label!,
                    style: textTheme.titleMedium,
                  ),
                )
              else
                const Spacer(),
              if (showPercent)
                Text(
                  '$percent%',
                  style: textTheme.titleMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        ClipRRect(
          borderRadius: BorderRadius.circular(height),
          child: LinearProgressIndicator(
            value: clamped,
            minHeight: height,
            backgroundColor: AppColors.mintTrack,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
