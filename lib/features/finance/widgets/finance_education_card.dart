import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/providers/providers.dart';

/// Card expansível de educação financeira: explica recebimento, custo/
/// investimento e lucro com os números reais da pessoa, em linguagem simples.
class FinanceEducationCard extends ConsumerStatefulWidget {
  const FinanceEducationCard({super.key});

  @override
  ConsumerState<FinanceEducationCard> createState() =>
      _FinanceEducationCardState();
}

class _FinanceEducationCardState extends ConsumerState<FinanceEducationCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final finance = ref.watch(financeProvider);
    final double workCost = (finance.expensesByCategory['Combustível'] ?? 0) +
        (finance.expensesByCategory['Manutenção'] ?? 0);

    return BreatheCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Row(
              children: <Widget>[
                const Expanded(
                  child: SectionTitle(
                    title: 'Investimento, recebimento e lucro',
                  ),
                ),
                Icon(
                  _expanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 250),
            crossFadeState: _expanded
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: AppSpacing.md),
                _Concept(
                  title: 'Recebimento',
                  text: 'É todo o dinheiro que entra. Este mês entraram '
                      '${formatCurrency(finance.income)}.',
                ),
                _Concept(
                  title: 'Custo de trabalhar (investimento)',
                  text: 'Parte do que entra é o custo de rodar: combustível e '
                      'manutenção somaram ${formatCurrency(workCost)}. Esse '
                      'dinheiro não é lucro — é o que você gasta para poder '
                      'trabalhar.',
                ),
                _Concept(
                  title: 'Lucro',
                  text: 'É o que sobra de verdade depois de todos os gastos: '
                      '${formatCurrency(finance.saved)}. É com o lucro que dá '
                      'para guardar e realizar seus planos.',
                ),
                const SizedBox(height: AppSpacing.sm),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.mint,
                    borderRadius: BorderRadius.circular(AppRadius.button),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Icon(Icons.savings_outlined,
                          color: AppColors.primary),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          'Dica: separe um pouco do lucro no cofrinho assim que '
                          'receber. O que vai para a reserva não volta para o '
                          'combustível.',
                          style: textTheme.bodyMedium
                              ?.copyWith(color: AppColors.textPrimary),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            secondChild: const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }
}

class _Concept extends StatelessWidget {
  const _Concept({required this.title, required this.text});

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: textTheme.titleMedium?.copyWith(color: AppColors.primary)),
          const SizedBox(height: 2),
          Text(text, style: textTheme.bodyMedium),
        ],
      ),
    );
  }
}
