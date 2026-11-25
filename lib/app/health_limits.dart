/// ⚠️ PROVISÓRIO — limites de saúde do app.
///
/// Estes valores são provisórios e servem só para o protótipo. Os números
/// definitivos virão da equipe de Psicologia/Saúde. Mantidos num único arquivo
/// para facilitar o ajuste.
abstract final class HealthLimits {
  /// Alerta de jornada longa a partir de 10 horas online no dia.
  static const double longJourneyHours = 10;

  /// Lembrete de pausa a cada 2 horas online.
  static const double breakReminderHours = 2;

  /// Acima de 14 corridas na meta diária, o app mostra orientação de descanso
  /// (nunca incentiva aumentar a jornada).
  static const int dailyRidesGuidanceThreshold = 14;
}
