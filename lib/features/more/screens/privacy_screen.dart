import 'package:flutter/material.dart';

import '../../../core/widgets/widgets.dart';

/// Tela Privacidade e dados (`/privacidade`) — placeholder da Fase 2.
class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BreatheScaffold(
      title: 'Privacidade e dados',
      subtitle: 'Como seus dados são usados',
      body: EmptyState(
        title: 'Em construção',
        message: 'A empresa vê apenas dados agregados e anônimos, para apoio e '
            'prevenção — nunca para punição. Os detalhes virão aqui.',
        icon: Icons.lock_outline_rounded,
      ),
    );
  }
}
