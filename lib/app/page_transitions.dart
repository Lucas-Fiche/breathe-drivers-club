import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Duração da entrada das telas cheias.
const Duration kPageTransitionDuration = Duration(milliseconds: 280);

/// Página de tela cheia com transição suave: aparece com fade e sobe um
/// pouquinho (4% da altura). Mais calma que o deslize lateral padrão, no tom
/// do app. As abas não usam isto (trocam na hora, como esperado numa barra
/// de abas).
CustomTransitionPage<void> fadeSlidePage(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: kPageTransitionDuration,
    reverseTransitionDuration: const Duration(milliseconds: 220),
    transitionsBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
    ) {
      final Animation<double> curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.04),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}
