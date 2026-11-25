import 'package:flutter/material.dart';

import '../../../core/widgets/widgets.dart';

/// Tela Meu plano (`/plano`) — placeholder da Fase 2.
class PlanScreen extends StatelessWidget {
  const PlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BreatheScaffold(
      title: 'Meu plano',
      subtitle: 'Seus objetivos, no seu ritmo',
      body: EmptyState(
        title: 'Em construção',
        message: 'As metas de vida serão montadas em breve.',
        icon: Icons.flag_outlined,
      ),
    );
  }
}
