import 'dart:async';

import 'package:flutter/material.dart';

/// Disponibiliza, para os componentes base, a ação do gesto escondido (no
/// protótipo, abrir o modo apresentação). O core não conhece a feature de
/// demo: quem decide o que acontece é quem monta este escopo (o `app.dart`).
class SecretGestureScope extends InheritedWidget {
  const SecretGestureScope({
    super.key,
    required this.onTrigger,
    required super.child,
  });

  /// Recebe o contexto de quem fez o gesto (dentro do Navigator), para poder
  /// abrir sheets e diálogos.
  final void Function(BuildContext context) onTrigger;

  /// Ação do gesto escondido, ou nula se não houver escopo.
  static void Function(BuildContext context)? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<SecretGestureScope>()
        ?.onTrigger;
  }

  @override
  bool updateShouldNotify(SecretGestureScope oldWidget) =>
      onTrigger != oldWidget.onTrigger;
}

/// Toque normal faz [onTap]; [taps] toques rápidos seguidos disparam o gesto
/// escondido do [SecretGestureScope].
///
/// Para distinguir os dois, o toque normal espera [window] sem novos toques
/// antes de agir (um atraso pequeno, imperceptível no uso).
class SecretTapDetector extends StatefulWidget {
  const SecretTapDetector({
    super.key,
    required this.onTap,
    required this.child,
    this.taps = 5,
    this.window = const Duration(milliseconds: 350),
  });

  final VoidCallback onTap;
  final Widget child;
  final int taps;
  final Duration window;

  @override
  State<SecretTapDetector> createState() => _SecretTapDetectorState();
}

class _SecretTapDetectorState extends State<SecretTapDetector> {
  int _count = 0;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _handleTap() {
    _timer?.cancel();
    _count++;
    final void Function(BuildContext)? secret = SecretGestureScope.maybeOf(
      context,
    );
    if (secret == null) {
      _count = 0;
      widget.onTap();
      return;
    }
    if (_count >= widget.taps) {
      _count = 0;
      secret(context);
      return;
    }
    _timer = Timer(widget.window, () {
      _count = 0;
      if (mounted) widget.onTap();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _handleTap,
        child: widget.child,
      ),
    );
  }
}
