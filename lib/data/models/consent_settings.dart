/// Escolhas de consentimento: um booleano por tipo de dado compartilhado.
///
/// A empresa só vê dados **agregados e anônimos**; estas escolhas controlam o
/// que entra nesse agregado. Nada é usado para punição (LGPD).
class ConsentSettings {
  const ConsentSettings({
    this.shareLocation = false,
    this.shareWorkHours = true,
    this.shareFinances = false,
    this.shareMood = true,
    this.shareSurvey = true,
    this.shareUsage = true,
  });

  /// Localização aproximada (para pontos de apoio próximos).
  final bool shareLocation;

  /// Horas de jornada (para alertas de descanso e prevenção).
  final bool shareWorkHours;

  /// Dados financeiros (para orientações de finanças).
  final bool shareFinances;

  /// Registros de humor.
  final bool shareMood;

  /// Respostas do questionário.
  final bool shareSurvey;

  /// Dados de uso do app (telas visitadas, frequência).
  final bool shareUsage;

  ConsentSettings copyWith({
    bool? shareLocation,
    bool? shareWorkHours,
    bool? shareFinances,
    bool? shareMood,
    bool? shareSurvey,
    bool? shareUsage,
  }) {
    return ConsentSettings(
      shareLocation: shareLocation ?? this.shareLocation,
      shareWorkHours: shareWorkHours ?? this.shareWorkHours,
      shareFinances: shareFinances ?? this.shareFinances,
      shareMood: shareMood ?? this.shareMood,
      shareSurvey: shareSurvey ?? this.shareSurvey,
      shareUsage: shareUsage ?? this.shareUsage,
    );
  }
}
