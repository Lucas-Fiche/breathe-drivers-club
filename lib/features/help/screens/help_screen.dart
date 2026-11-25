import 'package:flutter/material.dart';

import '../../../core/widgets/widgets.dart';

/// Tela Ajuda / acolhimento (`/ajuda`) — placeholder da Fase 2.
///
/// Não mostra o próprio ícone de Ajuda no cabeçalho (evita o laço para si
/// mesma).
class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BreatheScaffold(
      title: 'Ajuda e acolhimento',
      subtitle: 'Estamos aqui com você',
      showHelp: false,
      body: EmptyState(
        title: 'Em construção',
        message: 'Os canais de acolhimento serão montados em breve. '
            'Se precisar falar agora, procure um profissional de confiança.',
        icon: Icons.favorite_rounded,
      ),
    );
  }
}
