import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/providers/providers.dart';

/// Card "Meu cofrinho": saldo em destaque (animado), barra até a meta, % da
/// meta e botões de depósito rápido. Permite editar a meta.
class PiggyBankCard extends ConsumerWidget {
  const PiggyBankCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final piggy = ref.watch(financeProvider).piggyBank;
    final int percent = (piggy.progress * 100).round();

    return BreatheCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              const Expanded(child: SectionTitle(title: 'Meu cofrinho')),
              TextButton(
                onPressed: () => _editGoal(context, ref, piggy.goal),
                child: const Text('Editar meta'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: piggy.balance),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
            builder: (BuildContext context, double value, _) {
              return Text(
                formatCurrency(value),
                style: textTheme.displaySmall,
              );
            },
          ),
          const SizedBox(height: AppSpacing.md),
          ProgressBarLabeled(value: piggy.progress, showPercent: false),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '$percent% da meta de ${formatCurrency(piggy.goal)}',
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: <Widget>[
              for (final double amount in <double>[10, 50, 100]) ...<Widget>[
                Expanded(
                  child: SecondaryButton(
                    label: '+ ${formatCurrency(amount)}',
                    onPressed: () =>
                        ref.read(financeProvider.notifier).addToPiggyBank(amount),
                  ),
                ),
                if (amount != 100) const SizedBox(width: AppSpacing.sm),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _editGoal(
    BuildContext context,
    WidgetRef ref,
    double currentGoal,
  ) async {
    final TextEditingController controller = TextEditingController(
      text: currentGoal.toStringAsFixed(0),
    );
    final double? result = await showDialog<double>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: const Text('Editar meta do cofrinho'),
          content: TextField(
            controller: controller,
            autofocus: true,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: const InputDecoration(
              prefixText: 'R\$ ',
              hintText: '500',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                final double? v = double.tryParse(controller.text);
                Navigator.of(context).pop(v);
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
    controller.dispose();
    if (result != null && result > 0) {
      ref.read(financeProvider.notifier).setPiggyGoal(result);
    }
  }
}
