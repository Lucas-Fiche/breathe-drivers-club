import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/models.dart';
import '../../../data/providers/providers.dart';

/// Abre o bottom sheet de registro de ganho/gasto.
Future<void> showRegisterTransactionSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.background,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.header)),
    ),
    builder: (BuildContext context) => const _RegisterSheet(),
  );
}

class _RegisterSheet extends ConsumerStatefulWidget {
  const _RegisterSheet();

  @override
  ConsumerState<_RegisterSheet> createState() => _RegisterSheetState();
}

class _RegisterSheetState extends ConsumerState<_RegisterSheet> {
  static const List<String> _incomeCategories = <String>[
    'Corridas',
    'Entregas',
    'Gorjeta',
    'Outros',
  ];
  static const List<String> _expenseCategories = <String>[
    'Combustível',
    'Manutenção',
    'Alimentação',
    'Celular/internet',
    'Outros',
  ];

  final TextEditingController _amountController =
      TextEditingController(text: formatCurrency(0));
  final TextEditingController _descriptionController = TextEditingController();

  TransactionType _type = TransactionType.expense;
  double _amount = 0;
  int _categoryIndex = 0;

  List<String> get _categories =>
      _type == TransactionType.income ? _incomeCategories : _expenseCategories;

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _onTypeChanged(int index) {
    setState(() {
      _type = index == 0 ? TransactionType.income : TransactionType.expense;
      _categoryIndex = 0;
    });
  }

  /// Interpreta os dígitos como centavos e mostra formatado em BRL.
  void _onAmountChanged(String raw) {
    final String digits = raw.replaceAll(RegExp(r'\D'), '');
    final int cents = int.tryParse(digits) ?? 0;
    _amount = cents / 100.0;
    final String formatted = formatCurrency(_amount);
    _amountController.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
    setState(() {});
  }

  void _save() {
    if (_amount <= 0) return;
    ref.read(financeProvider.notifier).registerTransaction(
          type: _type,
          category: _categories[_categoryIndex],
          amount: _amount,
          description: _descriptionController.text,
        );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.xl,
        right: AppSpacing.xl,
        top: AppSpacing.xl,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.xl,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Registrar movimentação', style: textTheme.titleLarge),
            const SizedBox(height: AppSpacing.xl),
            ChipGroup(
              options: const <String>['Ganho', 'Gasto'],
              selectedIndex: _type == TransactionType.income ? 0 : 1,
              onSelected: _onTypeChanged,
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('Valor', style: textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              onChanged: _onAmountChanged,
              style: textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('Categoria', style: textTheme.titleMedium),
            const SizedBox(height: AppSpacing.md),
            ChipGroup(
              options: _categories,
              selectedIndex: _categoryIndex,
              onSelected: (int i) => setState(() => _categoryIndex = i),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('Descrição (opcional)', style: textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _descriptionController,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                hintText: 'Ex.: abastecimento no Posto Aurora',
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            PrimaryButton(
              label: 'Salvar',
              onPressed: _amount > 0 ? _save : null,
            ),
          ],
        ),
      ),
    );
  }
}
