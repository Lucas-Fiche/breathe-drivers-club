import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/models.dart';

/// Linha de uma movimentação: ícone, categoria/descrição, data e valor com
/// sinal e cor (ganho em [AppColors.primary], gasto em [AppColors.textPrimary]).
class TransactionTile extends StatelessWidget {
  const TransactionTile({super.key, required this.transaction, this.showDate = true});

  final Transaction transaction;
  final bool showDate;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final bool income = transaction.isIncome;
    final String sign = income ? '+ ' : '- ';
    final Color amountColor =
        income ? AppColors.primary : AppColors.textPrimary;

    final String subtitle = <String>[
      if (transaction.description.isNotEmpty) transaction.description,
      if (showDate) formatShortDate(transaction.date),
    ].join(' · ');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: <Widget>[
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: income ? AppColors.mint : AppColors.coralSoft,
              shape: BoxShape.circle,
            ),
            child: Icon(
              income ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
              size: 20,
              color: income ? AppColors.primary : AppColors.coral,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(transaction.category, style: textTheme.titleMedium),
                if (subtitle.isNotEmpty)
                  Text(subtitle, style: textTheme.bodyMedium),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            '$sign${formatCurrency(transaction.amount)}',
            style: textTheme.titleMedium?.copyWith(color: amountColor),
          ),
        ],
      ),
    );
  }
}
