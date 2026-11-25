import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/models.dart';
import '../../../data/providers/providers.dart';

/// Linha de uma meta ativa: barra animada com rótulo/porcentagem e o botão
/// "Avançar uma etapa". Ao concluir, dispara uma celebração discreta.
class GoalTile extends ConsumerWidget {
  const GoalTile({super.key, required this.goal});

  final LifeGoal goal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: goal.progress),
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
          builder: (BuildContext context, double value, _) {
            return ProgressBarLabeled(label: goal.title, value: value);
          },
        ),
        const SizedBox(height: AppSpacing.md),
        SecondaryButton(
          label: 'Avançar uma etapa',
          onPressed: () => _advance(context, ref),
        ),
      ],
    );
  }

  void _advance(BuildContext context, WidgetRef ref) {
    final bool willComplete = goal.completedSteps + 1 >= goal.totalSteps;
    ref.read(planProvider.notifier).advanceGoal(goal.id);
    if (willComplete) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('🎉 Meta conquistada: ${goal.title}!'),
          ),
        );
    }
  }
}
