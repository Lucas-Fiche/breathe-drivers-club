import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/models.dart';
import '../../../data/providers/providers.dart';

/// Abre o bottom sheet de nova meta.
Future<void> showNewGoalSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.background,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.header)),
    ),
    builder: (BuildContext context) => const _NewGoalSheet(),
  );
}

class _NewGoalSheet extends ConsumerStatefulWidget {
  const _NewGoalSheet();

  @override
  ConsumerState<_NewGoalSheet> createState() => _NewGoalSheetState();
}

class _NewGoalSheetState extends ConsumerState<_NewGoalSheet> {
  static const List<GoalCategory> _categories = <GoalCategory>[
    GoalCategory.estudos,
    GoalCategory.financas,
    GoalCategory.saude,
    GoalCategory.familia,
    GoalCategory.outro,
  ];

  final TextEditingController _nameController = TextEditingController();
  int _categoryIndex = 0;
  int _steps = 5;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  bool get _canSave => _nameController.text.trim().isNotEmpty;

  void _save() {
    if (!_canSave) return;
    ref.read(planProvider.notifier).addGoal(
          title: _nameController.text,
          category: _categories[_categoryIndex],
          totalSteps: _steps,
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
          Text('Nova meta', style: textTheme.titleLarge),
          const SizedBox(height: AppSpacing.xl),
          Text('Qual é a meta?', style: textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            controller: _nameController,
            textCapitalization: TextCapitalization.sentences,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              hintText: 'Ex.: Tirar a CNH tipo D',
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('Categoria', style: textTheme.titleMedium),
          const SizedBox(height: AppSpacing.md),
          ChipGroup(
            options: <String>[
              for (final GoalCategory c in _categories) c.label,
            ],
            selectedIndex: _categoryIndex,
            onSelected: (int i) => setState(() => _categoryIndex = i),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('Em quantas etapas?', style: textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          StepperCounter(
            value: _steps,
            min: 1,
            max: 20,
            label: _steps == 1 ? 'etapa' : 'etapas',
            onChanged: (int v) => setState(() => _steps = v),
          ),
          const SizedBox(height: AppSpacing.xl),
          PrimaryButton(
            label: 'Adicionar meta',
            onPressed: _canSave ? _save : null,
          ),
        ],
      ),
    );
  }
}
