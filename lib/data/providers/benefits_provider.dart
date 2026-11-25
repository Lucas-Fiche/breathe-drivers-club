import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/models.dart';
import '../repositories/repositories.dart';
import 'persona_provider.dart';
import 'profile_provider.dart';
import 'repository_providers.dart';

/// Resultado de uma tentativa de resgate de benefício.
enum RedeemResult {
  /// Resgatado com sucesso (pontos debitados).
  success,

  /// Pontos insuficientes.
  notEnoughPoints,

  /// Já havia sido resgatado.
  alreadyRedeemed,

  /// Benefício inexistente.
  notFound,
}

/// Estado dos benefícios: lista de parceiros, programas e resgatados.
class BenefitsState {
  const BenefitsState({
    required this.benefits,
    required this.studyPrograms,
    this.redeemedIds = const <String>{},
  });

  final List<Benefit> benefits;
  final List<StudyProgram> studyPrograms;
  final Set<String> redeemedIds;

  bool isRedeemed(String benefitId) => redeemedIds.contains(benefitId);

  BenefitsState copyWith({
    List<Benefit>? benefits,
    List<StudyProgram>? studyPrograms,
    Set<String>? redeemedIds,
  }) {
    return BenefitsState(
      benefits: benefits ?? this.benefits,
      studyPrograms: studyPrograms ?? this.studyPrograms,
      redeemedIds: redeemedIds ?? this.redeemedIds,
    );
  }
}

class BenefitsNotifier extends Notifier<BenefitsState> {
  @override
  BenefitsState build() {
    final Persona persona = ref.watch(personaProvider);
    final BenefitsRepository repo = ref.read(benefitsRepositoryProvider);
    return BenefitsState(
      benefits: repo.loadBenefits(persona),
      studyPrograms: repo.loadStudyPrograms(persona),
    );
  }

  /// Tenta resgatar um benefício, debitando os pontos do perfil.
  ///
  /// Só debita e marca como resgatado se houver saldo e ainda não tiver sido
  /// resgatado.
  RedeemResult redeem(String benefitId) {
    final int index =
        state.benefits.indexWhere((Benefit b) => b.id == benefitId);
    if (index == -1) return RedeemResult.notFound;
    if (state.isRedeemed(benefitId)) return RedeemResult.alreadyRedeemed;

    final Benefit benefit = state.benefits[index];
    final bool paid =
        ref.read(profileProvider.notifier).spendPoints(benefit.pointsCost);
    if (!paid) return RedeemResult.notEnoughPoints;

    state = state.copyWith(
      redeemedIds: <String>{...state.redeemedIds, benefitId},
    );
    return RedeemResult.success;
  }
}

final NotifierProvider<BenefitsNotifier, BenefitsState> benefitsProvider =
    NotifierProvider<BenefitsNotifier, BenefitsState>(BenefitsNotifier.new);
