import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/models.dart';
import '../../../data/providers/providers.dart';
import 'goal_tile.dart';
import 'new_goal_sheet.dart';

/// Card "Metas de vida": lista as metas ativas e o botão de nova meta.
class LifeGoalsCard extends ConsumerWidget {
  const LifeGoalsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final List<LifeGoal> active = ref
        .watch(planProvider)
        .goals
        .where((LifeGoal g) => !g.isComplete)
        .toList();

    return BreatheCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const SectionTitle(title: 'Metas de vida'),
          const SizedBox(height: AppSpacing.lg),
          if (active.isEmpty)
            Text(
              'Você ainda não tem metas ativas. Que tal começar uma?',
              style: textTheme.bodyMedium,
            )
          else
            for (int i = 0; i < active.length; i++) ...<Widget>[
              GoalTile(goal: active[i]),
              if (i < active.length - 1)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                  child: Divider(height: 1),
                ),
            ],
          const SizedBox(height: AppSpacing.lg),
          SecondaryButton(
            label: 'Nova meta',
            icon: Icons.add_rounded,
            onPressed: () => showNewGoalSheet(context),
          ),
        ],
      ),
    );
  }
}
