import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/models.dart';
import '../repositories/repositories.dart';
import 'persona_provider.dart';
import 'profile_provider.dart';
import 'repository_providers.dart';
import 'rewards.dart';

/// Estado dos pontos de apoio: locais, eventos, seleção, interesses e
/// avaliações do usuário.
class SupportState {
  const SupportState({
    required this.supportPoints,
    required this.events,
    this.activePointId,
    this.interestedEventIds = const <String>{},
    this.userRatings = const <String, int>{},
  });

  final List<SupportPoint> supportPoints;
  final List<Event> events;

  /// Ponto com "rota ativa no mapa" (simulado).
  final String? activePointId;

  /// Eventos em que a pessoa marcou interesse.
  final Set<String> interestedEventIds;

  /// Avaliações dadas pela pessoa (id do ponto → estrelas 1–5).
  final Map<String, int> userRatings;

  bool isInterested(String eventId) => interestedEventIds.contains(eventId);

  int? ratingFor(String pointId) => userRatings[pointId];

  SupportState copyWith({
    List<SupportPoint>? supportPoints,
    List<Event>? events,
    String? activePointId,
    Set<String>? interestedEventIds,
    Map<String, int>? userRatings,
  }) {
    return SupportState(
      supportPoints: supportPoints ?? this.supportPoints,
      events: events ?? this.events,
      activePointId: activePointId ?? this.activePointId,
      interestedEventIds: interestedEventIds ?? this.interestedEventIds,
      userRatings: userRatings ?? this.userRatings,
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

  /// Alterna o interesse num evento, somando/retirando pontos simbólicos.
  void toggleEventInterest(String eventId) {
    final Set<String> updated = <String>{...state.interestedEventIds};
    if (updated.remove(eventId)) {
      ref.read(profileProvider.notifier).spendPoints(PointRewards.perEventInterest);
    } else {
      updated.add(eventId);
      ref.read(profileProvider.notifier).addPoints(PointRewards.perEventInterest);
    }
    state = state.copyWith(interestedEventIds: updated);
  }

  /// Registra a avaliação (1–5) de um ponto pela pessoa.
  void rateSupportPoint(String pointId, int stars) {
    if (stars < 1 || stars > 5) return;
    state = state.copyWith(
      userRatings: <String, int>{...state.userRatings, pointId: stars},
    );
  }
}

final NotifierProvider<SupportNotifier, SupportState> supportProvider =
    NotifierProvider<SupportNotifier, SupportState>(SupportNotifier.new);
