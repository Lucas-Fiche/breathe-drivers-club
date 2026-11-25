import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';

/// Pílula selecionável.
///
/// Não selecionada: fundo branco, borda fina, texto escuro.
/// Selecionada: fundo [AppColors.primary], texto branco (como no protótipo).
class PillChip extends StatelessWidget {
  const PillChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Color background = selected ? AppColors.primary : AppColors.surface;
    final Color foreground = selected ? Colors.white : AppColors.textPrimary;

    return Material(
      color: background,
      shape: StadiumBorder(
        side: BorderSide(
          color: selected ? AppColors.primary : AppColors.border,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        customBorder: const StadiumBorder(),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Text(
            label,
            style: textTheme.labelLarge?.copyWith(
              color: foreground,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

/// Grupo de [PillChip] com seleção única, quebrando em linhas (wrap).
///
/// [options] são os rótulos; [selectedIndex] é o índice marcado;
/// [onSelected] devolve o índice tocado.
class ChipGroup extends StatelessWidget {
  const ChipGroup({
    super.key,
    required this.options,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<String> options;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: <Widget>[
        for (int i = 0; i < options.length; i++)
          PillChip(
            label: options[i],
            selected: i == selectedIndex,
            onTap: () => onSelected(i),
          ),
      ],
    );
  }
}
