import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../mock/mock_repositories.dart';
import '../repositories/repositories.dart';

/// Providers das implementações de repositório.
///
/// Hoje apontam para as versões Mock*. Para trocar por uma API depois, basta
/// sobrescrever estes providers (ou mudar a implementação aqui).

final Provider<ProfileRepository> profileRepositoryProvider =
    Provider<ProfileRepository>((Ref ref) => const MockProfileRepository());

final Provider<PlanRepository> planRepositoryProvider =
    Provider<PlanRepository>((Ref ref) => const MockPlanRepository());

final Provider<FinanceRepository> financeRepositoryProvider =
    Provider<FinanceRepository>((Ref ref) => const MockFinanceRepository());

final Provider<BenefitsRepository> benefitsRepositoryProvider =
    Provider<BenefitsRepository>((Ref ref) => const MockBenefitsRepository());

final Provider<SupportRepository> supportRepositoryProvider =
    Provider<SupportRepository>((Ref ref) => const MockSupportRepository());

final Provider<CommunityRepository> communityRepositoryProvider =
    Provider<CommunityRepository>((Ref ref) => const MockCommunityRepository());

final Provider<SurveyRepository> surveyRepositoryProvider =
    Provider<SurveyRepository>((Ref ref) => const MockSurveyRepository());
