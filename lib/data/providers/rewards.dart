/// Pontos de reconhecimento concedidos por ações de autocuidado e planejamento.
///
/// Princípio de produto: pontos vêm de **pausas, metas e questionário** — nunca
/// de fazer mais corridas.
abstract final class PointRewards {
  static const int perBreak = 10;
  static const int perGoalStep = 25;
  static const int perMood = 5;
  static const int perSurvey = 50;

  /// Pontos simbólicos por demonstrar interesse num evento do clube.
  static const int perEventInterest = 15;
}

/// Limites da meta diária de corridas (o usuário define o ritmo).
abstract final class DailyGoalLimits {
  static const int min = 1;
  static const int max = 20;
}
