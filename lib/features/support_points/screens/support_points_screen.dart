import 'package:flutter/material.dart';

import '../../../core/widgets/widgets.dart';

/// Tela Pontos de apoio (`/apoio`) — placeholder da Fase 2.
class SupportPointsScreen extends StatelessWidget {
  const SupportPointsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BreatheScaffold(
      title: 'Pontos de apoio',
      subtitle: 'Descanso, convivência e eventos perto de você',
      body: EmptyState(
        title: 'Em construção',
        message: 'O mapa de pontos de apoio será montado em breve.',
        icon: Icons.place_outlined,
      ),
    );
  }
}
