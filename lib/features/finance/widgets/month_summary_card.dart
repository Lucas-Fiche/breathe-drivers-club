import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/providers/providers.dart';

/// Card "Este mês": ganhos, gastos e lucro (ganhos − gastos), com o lucro em
/// destaque.
class MonthSummaryCard extends ConsumerWidget {
  const MonthSummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final finance = ref.watch(financeProvider);

    return BreatheCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const SectionTitle(title: 'Este mês'),
          const SizedBox(height: AppSpacing.lg),
          _Line(label: 'Ganhos', value: formatCurrency(finance.income)),
          const SizedBox(height: AppSpacing.md),
          _Line(label: 'Gastos', value: formatCurrency(finance.expenses)),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: Divider(height: 1),
          ),
          _Line(
            label: 'Lucro',
            value: formatCurrency(finance.saved),
            highlight: true,
          ),
        ],
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            label,
            style: highlight ? textTheme.titleMedium : textTheme.bodyLarge,
          ),
        ),
        Text(
          value,
          style: highlight
              ? textTheme.titleLarge?.copyWith(color: AppColors.primary)
              : textTheme.titleMedium,
        ),
      ],
    );
  }
}
