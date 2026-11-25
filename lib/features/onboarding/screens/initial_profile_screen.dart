import 'package:flutter/material.dart';

import '../../../core/widgets/widgets.dart';

/// Tela de perfil inicial (`/perfil-inicial`) — placeholder da Fase 2.
class InitialProfileScreen extends StatelessWidget {
  const InitialProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BreatheScaffold(
      title: 'Seu perfil',
      subtitle: 'Conte um pouco sobre você',
      body: EmptyState(
        title: 'Em construção',
        message: 'O cadastro inicial do perfil será montado em breve.',
        icon: Icons.person_outline_rounded,
      ),
    );
  }
}
