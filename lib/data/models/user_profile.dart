/// Tipo de trabalhador atendido pelo app.
enum DriverType { motorista, entregador }

extension DriverTypeX on DriverType {
  /// Rótulo em português (ex.: "Motorista").
  String get label {
    switch (this) {
      case DriverType.motorista:
        return 'Motorista';
      case DriverType.entregador:
        return 'Entregador';
    }
  }
}

/// Perfil do trabalhador (dados fictícios, em memória).
class UserProfile {
  const UserProfile({
    required this.name,
    required this.type,
    required this.vehicle,
    required this.yearsOnApp,
    required this.city,
    required this.points,
  });

  final String name;
  final DriverType type;

  /// Descrição curta do veículo (ex.: "Carro", "Moto").
  final String vehicle;

  /// Há quantos anos usa o app de plataforma.
  final int yearsOnApp;

  final String city;

  /// Pontos acumulados (reconhecimento por pausas, metas e questionário —
  /// nunca por fazer mais corridas).
  final int points;

  UserProfile copyWith({
    String? name,
    DriverType? type,
    String? vehicle,
    int? yearsOnApp,
    String? city,
    int? points,
  }) {
    return UserProfile(
      name: name ?? this.name,
      type: type ?? this.type,
      vehicle: vehicle ?? this.vehicle,
      yearsOnApp: yearsOnApp ?? this.yearsOnApp,
      city: city ?? this.city,
      points: points ?? this.points,
    );
  }
}
