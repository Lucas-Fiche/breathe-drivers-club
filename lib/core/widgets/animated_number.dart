import 'package:flutter/material.dart';

/// Número que anima quando muda (pontos, saldo do cofrinho), com
/// [TweenAnimationBuilder].
///
/// Por padrão aparece já no valor e só anima nas mudanças (ex.: +20 pontos).
/// Com [animateOnStart], conta a partir de zero ao abrir a tela. O leitor de
/// tela sempre lê o valor final, nunca os intermediários.
class AnimatedNumber extends StatelessWidget {
  const AnimatedNumber({
    super.key,
    required this.value,
    this.format,
    this.style,
    this.animateOnStart = false,
    this.duration = const Duration(milliseconds: 600),
  });

  final num value;

  /// Formata o valor (padrão: inteiro arredondado).
  final String Function(num value)? format;
  final TextStyle? style;
  final bool animateOnStart;
  final Duration duration;

  String _format(num v) => format?.call(v) ?? '${v.round()}';

  @override
  Widget build(BuildContext context) {
    final double end = value.toDouble();
    return Semantics(
      label: _format(value),
      excludeSemantics: true,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: animateOnStart ? 0 : end, end: end),
        duration: duration,
        curve: Curves.easeOutCubic,
        builder: (BuildContext context, double v, _) =>
            Text(_format(v), style: style),
      ),
    );
  }
}
