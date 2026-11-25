/// Categoria de uma meta de vida.
enum GoalCategory { estudos, financas, saude, trabalho, pessoal }

/// Meta de vida do trabalhador (ex.: concluir o ensino médio).
///
/// O progresso (0–1) é derivado de [completedSteps] / [totalSteps], garantindo
/// que nunca passe de 100%.
class LifeGoal {
  const LifeGoal({
    required this.id,
    required this.title,
    required this.category,
    required this.totalSteps,
    required this.completedSteps,
  });

  final String id;
  final String title;
  final GoalCategory category;
  final int totalSteps;
  final int completedSteps;

  /// Progresso de 0 a 1.
  double get progress =>
      totalSteps == 0 ? 0 : (completedSteps / totalSteps).clamp(0, 1);

  bool get isComplete => completedSteps >= totalSteps;

  LifeGoal copyWith({
    String? id,
    String? title,
    GoalCategory? category,
    int? totalSteps,
    int? completedSteps,
  }) {
    return LifeGoal(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      totalSteps: totalSteps ?? this.totalSteps,
      completedSteps: completedSteps ?? this.completedSteps,
    );
  }
}
