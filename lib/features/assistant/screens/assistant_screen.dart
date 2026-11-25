import 'package:flutter/material.dart';

import '../../../core/widgets/widgets.dart';

/// Tela Assistente (`/assistente`) — placeholder da Fase 2.
class AssistantScreen extends StatelessWidget {
  const AssistantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BreatheScaffold(
      title: 'Assistente',
      subtitle: 'Tire dúvidas e organize seu plano',
      body: EmptyState(
        title: 'Em construção',
        message: 'O assistente roteirizado será montado em breve.',
        icon: Icons.chat_bubble_outline_rounded,
      ),
    );
  }
}
