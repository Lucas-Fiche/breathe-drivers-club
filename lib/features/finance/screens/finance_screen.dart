import 'package:flutter/material.dart';

import '../../../core/widgets/widgets.dart';

/// Tela Finanças (`/financas`) — placeholder da Fase 2.
class FinanceScreen extends StatelessWidget {
  const FinanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BreatheScaffold(
      title: 'Finanças',
      subtitle: 'Quanto entra, sai e sobra',
      body: EmptyState(
        title: 'Em construção',
        message: 'O controle financeiro será montado em breve.',
        icon: Icons.account_balance_wallet_outlined,
      ),
    );
  }
}
