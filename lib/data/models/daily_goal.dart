/// Meta diária de corridas, definida pelo próprio trabalhador.
///
/// Atenção de produto: metas altas apenas exibem orientação de descanso; o app
/// nunca incentiva aumentar a jornada.
class DailyGoal {
  const DailyGoal({
    required this.targetRides,
    this.completedRides = 0,
  });

  final int targetRides;
  final int completedRides;

  double get progress =>
      targetRides == 0 ? 0 : (completedRides / targetRides).clamp(0, 1);

  DailyGoal copyWith({
    int? targetRides,
    int? completedRides,
  }) {
    return DailyGoal(
      targetRides: targetRides ?? this.targetRides,
      completedRides: completedRides ?? this.completedRides,
    );
  }
}
