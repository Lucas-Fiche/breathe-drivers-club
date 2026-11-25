import 'package:flutter/material.dart';

import '../../../core/widgets/widgets.dart';

/// Tela de consentimento (`/consentimento`) — placeholder da Fase 2.
class ConsentScreen extends StatelessWidget {
  const ConsentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BreatheScaffold(
      title: 'Privacidade e consentimento',
      subtitle: 'Você escolhe o que compartilha',
      body: EmptyState(
        title: 'Em construção',
        message: 'As escolhas de consentimento serão montadas em breve.',
        icon: Icons.verified_user_outlined,
      ),
    );
  }
}
