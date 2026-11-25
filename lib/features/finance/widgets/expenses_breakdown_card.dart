import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/providers/providers.dart';

/// Card "Para onde foi o dinheiro": barras horizontais por categoria de gasto,
/// com valor e porcentagem. Desenhado só com widgets do Flutter.
class ExpensesBreakdownCard extends ConsumerWidget {
  const ExpensesBreakdownCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final finance = ref.watch(financeProvider);
    final double total = finance.expenses;

    final List<MapEntry<String, double>> entries =
        finance.expensesByCategory.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

    return BreatheCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const SectionTitle(title: 'Para onde foi o dinheiro'),
          const SizedBox(height: AppSpacing.lg),
          if (entries.isEmpty)
            Text('Nenhum gasto registrado ainda.', style: textTheme.bodyMedium)
          else
            for (int i = 0; i < entries.length; i++) ...<Widget>[
              _CategoryBar(
                label: entries[i].key,
                amount: entries[i].value,
                fraction: total == 0 ? 0 : entries[i].value / total,
              ),
              if (i < entries.length - 1)
                const SizedBox(height: AppSpacing.lg),
            ],
        ],
      ),
    );
  }
}

class _CategoryBar extends StatelessWidget {
  const _CategoryBar({
    required this.label,
    required this.amount,
    required this.fraction,
  });

  final String label;
  final double amount;
  final double fraction;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final int percent = (fraction * 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(child: Text(label, style: textTheme.bodyLarge)),
            Text(formatCurrency(amount), style: textTheme.titleMedium),
            const SizedBox(width: AppSpacing.sm),
            SizedBox(
              width: 44,
              child: Text(
                '$percent%',
                textAlign: TextAlign.right,
                style: textTheme.bodyMedium,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: fraction.clamp(0.0, 1.0)),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
            builder: (BuildContext context, double value, _) {
              return LinearProgressIndicator(
                value: value,
                minHeight: 10,
                backgroundColor: AppColors.mintTrack,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColors.primary),
              );
            },
          ),
        ),
      ],
    );
  }
}
