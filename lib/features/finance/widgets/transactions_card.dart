import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/models.dart';
import '../../../data/providers/providers.dart';
import 'all_transactions_sheet.dart';
import 'transaction_tile.dart';

/// Card "Últimas movimentações": as 5 mais recentes e o acesso à lista completa.
class TransactionsCard extends ConsumerWidget {
  const TransactionsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final List<Transaction> all = ref.watch(financeProvider).transactions;
    final List<Transaction> recent = all.take(5).toList();

    return BreatheCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const SectionTitle(title: 'Últimas movimentações'),
          const SizedBox(height: AppSpacing.sm),
          if (recent.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Text(
                'Nenhuma movimentação ainda. Toque em "Registrar ganho ou gasto".',
                style: textTheme.bodyMedium,
              ),
            )
          else
            for (int i = 0; i < recent.length; i++) ...<Widget>[
              TransactionTile(transaction: recent[i]),
              if (i < recent.length - 1) const Divider(height: 1),
            ],
          if (all.length > recent.length) ...<Widget>[
            const SizedBox(height: AppSpacing.sm),
            SecondaryButton(
              label: 'Ver todas',
              onPressed: () => showAllTransactionsSheet(context, all),
            ),
          ],
        ],
      ),
    );
  }
}
