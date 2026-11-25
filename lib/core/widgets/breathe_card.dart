import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';

/// Card padrão do app: fundo branco, raio 20, borda fina, padding 16–20,
/// sem sombra forte.
///
/// Use [color] para variações (ex.: [AppColors.coralSoft] no card de pausa,
/// [AppColors.mint] no card de dica) e [onTap] para torná-lo tocável.
class BreatheCard extends StatelessWidget {
  const BreatheCard({
    super.key,
    required this.child,
    this.color = AppColors.surface,
    this.borderColor = AppColors.border,
    this.padding = const EdgeInsets.all(AppSpacing.xl),
    this.onTap,
  });

  final Widget child;
  final Color color;
  final Color borderColor;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = BorderRadius.circular(AppRadius.card);
    return Material(
      color: color,
      borderRadius: radius,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Ink(
          decoration: BoxDecoration(
            color: color,
            borderRadius: radius,
            border: Border.all(color: borderColor),
          ),
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
