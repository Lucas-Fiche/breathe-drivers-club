import 'package:flutter/material.dart';

import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../widgets/achievements_section.dart';
import '../widgets/assistant_tip_card.dart';
import '../widgets/daily_rides_card.dart';
import '../widgets/life_goals_card.dart';

/// Tela Meu plano (`/plano`): metas de vida, meta diária, dica do assistente e
/// metas conquistadas.
class PlanScreen extends StatelessWidget {
  const PlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BreatheScaffold(
      title: 'Meu plano',
      subtitle: 'Seus objetivos, no seu ritmo',
      scrollable: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          LifeGoalsCard(),
          SizedBox(height: AppSpacing.lg),
          DailyRidesCard(),
          SizedBox(height: AppSpacing.lg),
          AssistantTipCard(),
          SizedBox(height: AppSpacing.lg),
          AchievementsSection(),
          SizedBox(height: AppSpacing.sm),
        ],
      ),
    );
  }
}
