import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/models.dart';
import 'plan_provider.dart';
import 'survey_provider.dart';

/// Progresso rumo ao selo "destaque do mês".
///
/// Conta só ações de cuidado (etapas de metas, pausas e questionário), nunca
/// volume de corridas.
class HighlightProgress {
  const HighlightProgress({required this.value, required this.target});

  final int value;
  final int target;

  double get progress => (value / target).clamp(0.0, 1.0);
  int get missing => (target - value).clamp(0, target);
  bool get achieved => value >= target;
}

/// Quantas ações de cuidado fecham o selo do mês (provisório).
const int kHighlightTarget = 25;

/// Ações de cuidado que o questionário respondido vale no selo.
const int kHighlightSurveyWeight = 5;

final Provider<HighlightProgress> highlightProvider =
    Provider<HighlightProgress>((Ref ref) {
      final PlanState plan = ref.watch(planProvider);
      final bool survey = ref.watch(surveyProvider).submitted;
      final int steps = plan.goals.fold<int>(
        0,
        (int sum, LifeGoal g) => sum + g.completedSteps,
      );
      return HighlightProgress(
        value:
            steps +
            plan.workDay.breaksTaken +
            (survey ? kHighlightSurveyWeight : 0),
        target: kHighlightTarget,
      );
    });
