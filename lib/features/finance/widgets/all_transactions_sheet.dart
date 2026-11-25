import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/models.dart';
import 'transaction_tile.dart';

/// Abre a lista completa de movimentações, agrupada por dia.
Future<void> showAllTransactionsSheet(
  BuildContext context,
  List<Transaction> transactions,
) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.background,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.header)),
    ),
    builder: (BuildContext context) => _AllTransactionsSheet(transactions: transactions),
  );
}

class _AllTransactionsSheet extends StatelessWidget {
  const _AllTransactionsSheet({required this.transactions});

  final List<Transaction> transactions;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Map<String, List<Transaction>> byDay = _groupByDay(transactions);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      maxChildSize: 0.92,
      builder: (BuildContext context, ScrollController controller) {
        return Column(
          children: <Widget>[
            const SizedBox(height: AppSpacing.md),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text('Todas as movimentações',
                        style: textTheme.titleLarge),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Expanded(
              child: ListView(
                controller: controller,
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xl,
                  0,
                  AppSpacing.xl,
                  AppSpacing.xl,
                ),
                children: <Widget>[
                  for (final MapEntry<String, List<Transaction>> day
                      in byDay.entries) ...<Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                        top: AppSpacing.lg,
                        bottom: AppSpacing.xs,
                      ),
                      child: Text(
                        day.key,
                        style: textTheme.titleSmall
                            ?.copyWith(color: AppColors.textSecondary),
                      ),
                    ),
                    for (final Transaction t in day.value)
                      TransactionTile(transaction: t, showDate: false),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  /// Agrupa por dia preservando a ordem (mais recente primeiro).
  Map<String, List<Transaction>> _groupByDay(List<Transaction> items) {
    final List<Transaction> sorted = List<Transaction>.of(items)
      ..sort((Transaction a, Transaction b) => b.date.compareTo(a.date));
    final Map<String, List<Transaction>> result =
        <String, List<Transaction>>{};
    for (final Transaction t in sorted) {
      final String key = formatDayHeader(t.date);
      result.putIfAbsent(key, () => <Transaction>[]).add(t);
    }
    return result;
  }
}
