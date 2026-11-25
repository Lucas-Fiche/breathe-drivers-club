import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/models.dart';
import '../repositories/repositories.dart';
import 'persona_provider.dart';
import 'repository_providers.dart';

/// Estado dos pontos de apoio: locais e eventos.
class SupportState {
  const SupportState({
    required this.supportPoints,
    required this.events,
    this.activePointId,
  });

  final List<SupportPoint> supportPoints;
  final List<Event> events;

  /// Ponto com "rota ativa no mapa" (simulado).
  final String? activePointId;

  SupportState copyWith({
    List<SupportPoint>? supportPoints,
    List<Event>? events,
    String? activePointId,
  }) {
    return SupportState(
      supportPoints: supportPoints ?? this.supportPoints,
      events: events ?? this.events,
      activePointId: activePointId ?? this.activePointId,
    );
  }
}

class SupportNotifier extends Notifier<SupportState> {
  @override
  SupportState build() {
    final Persona persona = ref.watch(personaProvider);
    final SupportRepository repo = ref.read(supportRepositoryProvider);
    return SupportState(
      supportPoints: repo.loadSupportPoints(persona),
      events: repo.loadEvents(persona),
    );
  }

  /// Marca um ponto como rota ativa no mapa (simulação).
  void startRoute(String pointId) {
    state = state.copyWith(activePointId: pointId);
  }
}

final NotifierProvider<SupportNotifier, SupportState> supportProvider =
    NotifierProvider<SupportNotifier, SupportState>(SupportNotifier.new);
