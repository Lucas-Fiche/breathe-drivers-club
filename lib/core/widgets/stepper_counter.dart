import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';

/// Contador com botões − e + e um número central de destaque.
///
/// Botões redondos em [AppColors.mint], número em [AppColors.primary].
/// Respeita [min] e [max] (botões desabilitam nos limites). [label] opcional
/// aparece depois do número (ex.: "de 10 corridas").
class StepperCounter extends StatelessWidget {
  const StepperCounter({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 99,
    this.step = 1,
    this.label,
  });

  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;
  final int step;
  final String? label;

  bool get _canDecrement => value - step >= min;
  bool get _canIncrement => value + step <= max;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _RoundButton(
          icon: Icons.remove_rounded,
          onPressed: _canDecrement ? () => onChanged(value - step) : null,
          semanticLabel: 'Diminuir',
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: <Widget>[
              Text(
                '$value',
                style: textTheme.headlineMedium,
              ),
              if (label != null) ...<Widget>[
                const SizedBox(width: AppSpacing.sm),
                Flexible(
                  child: Text(
                    label!,
                    style: textTheme.titleMedium?.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        _RoundButton(
          icon: Icons.add_rounded,
          onPressed: _canIncrement ? () => onChanged(value + step) : null,
          semanticLabel: 'Aumentar',
        ),
      ],
    );
  }
}

class _RoundButton extends StatelessWidget {
  const _RoundButton({
    required this.icon,
    required this.onPressed,
    required this.semanticLabel,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final bool enabled = onPressed != null;
    return Material(
      color: enabled ? AppColors.mint : AppColors.mint.withValues(alpha: 0.5),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: SizedBox.square(
          dimension: 48,
          child: Icon(
            icon,
            semanticLabel: semanticLabel,
            color: enabled ? AppColors.primary : AppColors.textSecondary,
            size: 24,
          ),
        ),
      ),
    );
  }
}
