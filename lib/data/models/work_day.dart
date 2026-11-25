/// Estado da jornada do dia: tempo online, pausas feitas e horário da última.
///
/// Usado para os lembretes de pausa e o alerta de jornada longa (ver
/// health_limits).
class WorkDay {
  const WorkDay({
    this.onlineHours = 0,
    this.breaksTaken = 0,
    this.lastBreak,
  });

  /// Horas online hoje.
  final double onlineHours;

  /// Quantidade de pausas feitas hoje.
  final int breaksTaken;

  /// Momento da última pausa (nulo se ainda não pausou hoje).
  final DateTime? lastBreak;

  WorkDay copyWith({
    double? onlineHours,
    int? breaksTaken,
    DateTime? lastBreak,
  }) {
    return WorkDay(
      onlineHours: onlineHours ?? this.onlineHours,
      breaksTaken: breaksTaken ?? this.breaksTaken,
      lastBreak: lastBreak ?? this.lastBreak,
    );
  }
}
