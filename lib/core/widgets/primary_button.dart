import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';

/// Botão principal (CTA): coral, texto escuro semibold, raio 14, altura ≥ 52.
///
/// Usa o `ElevatedButtonTheme` do app. [icon] é opcional. Com [expand] (padrão)
/// ocupa a largura disponível. [onPressed] nulo o deixa desabilitado.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.expand = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    // Sem expandir, a largura é definida pelo conteúdo (o tema força largura
    // infinita, o que estoura quando o botão fica numa Row sem Expanded).
    final ButtonStyle? style =
        expand ? null : ElevatedButton.styleFrom(minimumSize: const Size(0, 52));
    final Widget button = icon == null
        ? ElevatedButton(
            onPressed: onPressed,
            style: style,
            child: Text(label),
          )
        : ElevatedButton.icon(
            onPressed: onPressed,
            style: style,
            icon: Icon(icon, size: 20),
            label: Text(label),
          );

    if (!expand) {
      return button;
    }
    return SizedBox(
      width: double.infinity,
      child: button,
    );
  }
}

/// Variante do CTA com altura menor, para uso dentro de cards compactos.
class PrimaryButtonSmall extends StatelessWidget {
  const PrimaryButtonSmall({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
      minimumSize: const Size(0, 44),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
    );
    return icon == null
        ? ElevatedButton(onPressed: onPressed, style: style, child: Text(label))
        : ElevatedButton.icon(
            onPressed: onPressed,
            style: style,
            icon: Icon(icon, size: 18),
            label: Text(label),
          );
  }
}
