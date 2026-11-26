import 'package:flutter/material.dart';

/// Botão secundário: pílula branca com borda fina.
///
/// Usa o `OutlinedButtonTheme` do app. Com [expand] (padrão) ocupa a largura
/// disponível. [onPressed] nulo o deixa desabilitado.
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
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
        expand ? null : OutlinedButton.styleFrom(minimumSize: const Size(0, 52));
    final Widget button = icon == null
        ? OutlinedButton(
            onPressed: onPressed,
            style: style,
            child: Text(label),
          )
        : OutlinedButton.icon(
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
