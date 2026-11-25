import 'package:flutter/material.dart';

import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../widgets/expenses_breakdown_card.dart';
import '../widgets/finance_education_card.dart';
import '../widgets/month_summary_card.dart';
import '../widgets/piggy_bank_card.dart';
import '../widgets/register_transaction_sheet.dart';
import '../widgets/transactions_card.dart';

/// Tela Finanças (`/financas`): resumo do mês, para onde foi o dinheiro,
/// cofrinho, movimentações e educação financeira.
class FinanceScreen extends StatelessWidget {
  const FinanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BreatheScaffold(
      title: 'Finanças',
      subtitle: 'Quanto entra, sai e sobra',
      scrollable: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const MonthSummaryCard(),
          const SizedBox(height: AppSpacing.md),
          SecondaryButton(
            label: 'Registrar ganho ou gasto',
            icon: Icons.add_rounded,
            onPressed: () => showRegisterTransactionSheet(context),
          ),
          const SizedBox(height: AppSpacing.lg),
          const ExpensesBreakdownCard(),
          const SizedBox(height: AppSpacing.lg),
          const PiggyBankCard(),
          const SizedBox(height: AppSpacing.lg),
          const TransactionsCard(),
          const SizedBox(height: AppSpacing.lg),
          const FinanceEducationCard(),
          const SizedBox(height: AppSpacing.sm),
        ],
      ),
    );
  }
}
