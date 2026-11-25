/// Ponto de apoio (descanso/convivência) exibido no mapa ilustrado.
class SupportPoint {
  const SupportPoint({
    required this.id,
    required this.name,
    required this.amenities,
    required this.distanceMeters,
    required this.minutes,
    required this.mapX,
    required this.mapY,
    required this.rating,
    required this.hours,
  });

  final String id;
  final String name;

  /// Comodidades (ex.: "Banheiro", "Água", "Descanso", "Recarga").
  final List<String> amenities;

  final double distanceMeters;

  /// Tempo estimado até o ponto, em minutos.
  final int minutes;

  /// Posição no mapa ilustrado, em fração de 0 a 1 (x = horizontal,
  /// y = vertical).
  final double mapX;
  final double mapY;

  /// Avaliação de 0 a 5.
  final double rating;

  /// Horário de funcionamento (ex.: "06h–22h", "24h").
  final String hours;

  SupportPoint copyWith({
    String? id,
    String? name,
    List<String>? amenities,
    double? distanceMeters,
    int? minutes,
    double? mapX,
    double? mapY,
    double? rating,
    String? hours,
  }) {
    return SupportPoint(
      id: id ?? this.id,
      name: name ?? this.name,
      amenities: amenities ?? this.amenities,
      distanceMeters: distanceMeters ?? this.distanceMeters,
      minutes: minutes ?? this.minutes,
      mapX: mapX ?? this.mapX,
      mapY: mapY ?? this.mapY,
      rating: rating ?? this.rating,
      hours: hours ?? this.hours,
    );
  }
}
