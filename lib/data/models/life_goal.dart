/// Categoria de uma meta de vida.
enum GoalCategory { estudos, financas, saude, trabalho, pessoal, familia, outro }

extension GoalCategoryX on GoalCategory {
  /// Rótulo em português para exibição.
  String get label {
    switch (this) {
      case GoalCategory.estudos:
        return 'Estudos';
      case GoalCategory.financas:
        return 'Dinheiro';
      case GoalCategory.saude:
        return 'Saúde';
      case GoalCategory.trabalho:
        return 'Trabalho';
      case GoalCategory.pessoal:
        return 'Pessoal';
      case GoalCategory.familia:
        return 'Família';
      case GoalCategory.outro:
        return 'Outro';
    }
  }
}

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
