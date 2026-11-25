import 'package:flutter/material.dart';

import '../../../core/widgets/widgets.dart';

/// Tela Benefícios e parcerias (`/beneficios`) — placeholder da Fase 2.
class BenefitsScreen extends StatelessWidget {
  const BenefitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BreatheScaffold(
      title: 'Benefícios e parcerias',
      subtitle: 'Vantagens para você e para o seu trabalho',
      body: EmptyState(
        title: 'Em construção',
        message: 'A lista de benefícios será montada em breve.',
        icon: Icons.loyalty_outlined,
      ),
    );
  }
}
