import 'package:flutter/material.dart';

import '../../../core/widgets/widgets.dart';

/// Tela de pausa guiada (`/inicio/pausa`) — placeholder da Fase 2.
///
/// É uma rota de tela cheia (sem barra inferior), aberta a partir do Início.
class BreakScreen extends StatelessWidget {
  const BreakScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BreatheScaffold(
      title: 'Pausa guiada',
      subtitle: 'Um minuto para respirar',
      body: EmptyState(
        title: 'Em construção',
        message: 'A pausa guiada será montada em breve. '
            'Lembre de parar em local seguro antes de usar o app.',
        icon: Icons.self_improvement_rounded,
      ),
    );
  }
}
