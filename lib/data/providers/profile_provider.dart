import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/models.dart';
import '../repositories/repositories.dart';
import 'persona_provider.dart';
import 'repository_providers.dart';

/// Estado do perfil: dados do trabalhador e escolhas de consentimento.
class ProfileState {
  const ProfileState({
    required this.profile,
    required this.consent,
  });

  final UserProfile profile;
  final ConsentSettings consent;

  ProfileState copyWith({
    UserProfile? profile,
    ConsentSettings? consent,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      consent: consent ?? this.consent,
    );
  }
}

class ProfileNotifier extends Notifier<ProfileState> {
  @override
  ProfileState build() {
    final Persona persona = ref.watch(personaProvider);
    final ProfileRepository repo = ref.read(profileRepositoryProvider);
    return ProfileState(
      profile: repo.loadProfile(persona),
      consent: repo.loadConsent(persona),
    );
  }

  /// Credita pontos (reconhecimento por pausas, metas e questionário).
  void addPoints(int amount) {
    if (amount <= 0) return;
    state = state.copyWith(
      profile: state.profile.copyWith(points: state.profile.points + amount),
    );
  }

  /// Gasta pontos ao resgatar um benefício. Devolve `false` (sem alterar nada)
  /// se não houver saldo suficiente.
  bool spendPoints(int amount) {
    if (amount <= 0) return true;
    if (state.profile.points < amount) return false;
    state = state.copyWith(
      profile: state.profile.copyWith(points: state.profile.points - amount),
    );
    return true;
  }

  void updateConsent(ConsentSettings consent) {
    state = state.copyWith(consent: consent);
  }
}

final NotifierProvider<ProfileNotifier, ProfileState> profileProvider =
    NotifierProvider<ProfileNotifier, ProfileState>(ProfileNotifier.new);
