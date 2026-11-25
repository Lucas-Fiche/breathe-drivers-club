import 'package:flutter/material.dart';

import '../../../core/widgets/widgets.dart';

/// Tela de acesso (`/acesso`) — placeholder da Fase 2.
class AccessScreen extends StatelessWidget {
  const AccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BreatheScaffold(
      title: 'Acesso',
      subtitle: 'Entre com o número da sua empresa',
      body: EmptyState(
        title: 'Em construção',
        message: 'A tela de acesso será montada em breve.',
        icon: Icons.login_rounded,
      ),
    );
  }
}
