import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/models.dart';
import '../repositories/repositories.dart';
import 'persona_provider.dart';
import 'profile_provider.dart';
import 'repository_providers.dart';
import 'rewards.dart';

/// Estado do plano: metas de vida, meta diária, jornada e humores.
class PlanState {
  const PlanState({
    required this.goals,
    required this.dailyGoal,
    required this.workDay,
    required this.moods,
  });

  final List<LifeGoal> goals;
  final DailyGoal dailyGoal;
  final WorkDay workDay;
  final List<MoodEntry> moods;

  PlanState copyWith({
    List<LifeGoal>? goals,
    DailyGoal? dailyGoal,
    WorkDay? workDay,
    List<MoodEntry>? moods,
  }) {
    return PlanState(
      goals: goals ?? this.goals,
      dailyGoal: dailyGoal ?? this.dailyGoal,
      workDay: workDay ?? this.workDay,
      moods: moods ?? this.moods,
    );
  }
}

class PlanNotifier extends Notifier<PlanState> {
  @override
  PlanState build() {
    final Persona persona = ref.watch(personaProvider);
    final PlanRepository repo = ref.read(planRepositoryProvider);
    return PlanState(
      goals: repo.loadGoals(persona),
      dailyGoal: repo.loadDailyGoal(persona),
      workDay: repo.loadWorkDay(persona),
      moods: repo.loadMoods(persona),
    );
  }

  /// Avança uma etapa de uma meta. Nunca passa de 100% (se já concluída, não
  /// faz nada). Credita pontos quando há avanço.
  void advanceGoal(String goalId) {
    final int index = state.goals.indexWhere((LifeGoal g) => g.id == goalId);
    if (index == -1) return;
    final LifeGoal goal = state.goals[index];
    if (goal.isComplete) return;

    final List<LifeGoal> updated = List<LifeGoal>.of(state.goals);
    updated[index] = goal.copyWith(completedSteps: goal.completedSteps + 1);
    state = state.copyWith(goals: updated);
    ref.read(profileProvider.notifier).addPoints(PointRewards.perGoalStep);
  }

  /// Adiciona uma nova meta de vida (começa em 0 etapas concluídas).
  void addGoal({
    required String title,
    required GoalCategory category,
    required int totalSteps,
  }) {
    final String trimmed = title.trim();
    if (trimmed.isEmpty || totalSteps < 1) return;
    final LifeGoal goal = LifeGoal(
      id: 'goal-${DateTime.now().microsecondsSinceEpoch}',
      title: trimmed,
      category: category,
      totalSteps: totalSteps,
      completedSteps: 0,
    );
    state = state.copyWith(goals: <LifeGoal>[...state.goals, goal]);
  }

  /// Define a meta diária de corridas, respeitando os limites.
  void setDailyTarget(int target) {
    final int clamped = target.clamp(DailyGoalLimits.min, DailyGoalLimits.max);
    state = state.copyWith(
      dailyGoal: state.dailyGoal.copyWith(targetRides: clamped),
    );
  }

  /// Registra quantas corridas já foram feitas hoje (nunca negativo).
  ///
  /// Apenas acompanhamento: não concede pontos (o reconhecimento vem de pausas,
  /// metas e questionário, nunca de fazer mais corridas).
  void setCompletedRides(int value) {
    final int safe = value < 0 ? 0 : value;
    state = state.copyWith(
      dailyGoal: state.dailyGoal.copyWith(completedRides: safe),
    );
  }

  /// Registra o humor atual (sem culpa, só para a pessoa). Credita pontos.
  void registerMood(Mood mood) {
    state = state.copyWith(
      moods: <MoodEntry>[
        MoodEntry(mood: mood, date: DateTime.now()),
        ...state.moods,
      ],
    );
    ref.read(profileProvider.notifier).addPoints(PointRewards.perMood);
  }

  /// Atualiza as horas online de hoje (nunca negativo). No protótipo, usado
  /// pelo modo apresentação; na versão real, viria da plataforma.
  void setOnlineHours(double hours) {
    state = state.copyWith(
      workDay: state.workDay.copyWith(onlineHours: hours < 0 ? 0 : hours),
    );
  }

  /// Registra uma pausa (reforço positivo). Credita pontos.
  void registerBreak() {
    final WorkDay w = state.workDay;
    state = state.copyWith(
      workDay: w.copyWith(
        breaksTaken: w.breaksTaken + 1,
        lastBreak: DateTime.now(),
      ),
    );
    ref.read(profileProvider.notifier).addPoints(PointRewards.perBreak);
  }
}

final NotifierProvider<PlanNotifier, PlanState> planProvider =
    NotifierProvider<PlanNotifier, PlanState>(PlanNotifier.new);
