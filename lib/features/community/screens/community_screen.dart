import 'package:flutter/material.dart';

import '../../../core/widgets/widgets.dart';

/// Tela Comunidade (`/comunidade`) — placeholder da Fase 2.
class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BreatheScaffold(
      title: 'Comunidade',
      subtitle: 'Você não está sozinho na estrada',
      body: EmptyState(
        title: 'Em construção',
        message: 'O espaço da comunidade será montado em breve.',
        icon: Icons.groups_outlined,
      ),
    );
  }
}
