import 'package:flutter/material.dart';

import '../../../core/widgets/widgets.dart';

/// Tela Mais (`/mais`) — placeholder da Fase 2.
///
/// Reúne Comunidade, Questionário, Privacidade e dados, e Sobre o app.
class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BreatheScaffold(
      title: 'Mais',
      subtitle: 'Perfil, privacidade e outros recursos',
      body: EmptyState(
        title: 'Em construção',
        message: 'O menu "Mais" será montado em breve.',
        icon: Icons.more_horiz_rounded,
      ),
    );
  }
}
