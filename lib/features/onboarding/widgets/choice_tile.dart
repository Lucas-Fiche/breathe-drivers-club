import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';

/// Opção grande e tocável do questionário de perfil.
///
/// Não selecionada: fundo branco com borda. Selecionada: fundo
/// [AppColors.primary] com texto branco e um ícone de confirmação. Com
/// [multiSelect], o ícone vira um círculo de marcação (seleção múltipla).
class ChoiceTile extends StatelessWidget {
  const ChoiceTile({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.multiSelect = false,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool multiSelect;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Color background = selected ? AppColors.primary : AppColors.surface;
    final Color foreground = selected ? Colors.white : AppColors.textPrimary;
    final BorderRadius radius = BorderRadius.circular(AppRadius.button);

    final IconData icon = multiSelect
        ? (selected ? Icons.check_circle_rounded : Icons.circle_outlined)
        : (selected ? Icons.check_circle_rounded : Icons.radio_button_unchecked);

    return Material(
      color: background,
      borderRadius: radius,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Ink(
          decoration: BoxDecoration(
            color: background,
            borderRadius: radius,
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.border,
            ),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 56),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      label,
                      style: textTheme.titleMedium?.copyWith(color: foreground),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Icon(
                    icon,
                    color: selected ? Colors.white : AppColors.disabled,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
