import '../models/models.dart';
import '../repositories/repositories.dart';
import 'mock_data.dart';

/// Implementações fictícias dos repositórios: leem o pacote de [mockDataFor]
/// da persona ativa. Devolvem cópias das listas para o estado não mexer na
/// semente.

class MockProfileRepository implements ProfileRepository {
  const MockProfileRepository();

  @override
  UserProfile loadProfile(Persona persona) => mockDataFor(persona).profile;

  @override
  ConsentSettings loadConsent(Persona persona) => mockDataFor(persona).consent;
}

class MockPlanRepository implements PlanRepository {
  const MockPlanRepository();

  @override
  List<LifeGoal> loadGoals(Persona persona) =>
      List<LifeGoal>.of(mockDataFor(persona).goals);

  @override
  DailyGoal loadDailyGoal(Persona persona) => mockDataFor(persona).dailyGoal;

  @override
  WorkDay loadWorkDay(Persona persona) => mockDataFor(persona).workDay;

  @override
  List<MoodEntry> loadMoods(Persona persona) =>
      List<MoodEntry>.of(mockDataFor(persona).moods);
}

class MockFinanceRepository implements FinanceRepository {
  const MockFinanceRepository();

  @override
  List<Transaction> loadTransactions(Persona persona) =>
      List<Transaction>.of(mockDataFor(persona).transactions);

  @override
  PiggyBank loadPiggyBank(Persona persona) => mockDataFor(persona).piggyBank;
}

class MockBenefitsRepository implements BenefitsRepository {
  const MockBenefitsRepository();

  @override
  List<Benefit> loadBenefits(Persona persona) =>
      List<Benefit>.of(mockDataFor(persona).benefits);

  @override
  List<StudyProgram> loadStudyPrograms(Persona persona) =>
      List<StudyProgram>.of(mockDataFor(persona).studyPrograms);
}

class MockSupportRepository implements SupportRepository {
  const MockSupportRepository();

  @override
  List<SupportPoint> loadSupportPoints(Persona persona) =>
      List<SupportPoint>.of(mockDataFor(persona).supportPoints);

  @override
  List<Event> loadEvents(Persona persona) =>
      List<Event>.of(mockDataFor(persona).events);
}

class MockCommunityRepository implements CommunityRepository {
  const MockCommunityRepository();

  @override
  List<CommunityPost> loadPosts(Persona persona) =>
      List<CommunityPost>.of(mockDataFor(persona).posts);
}

class MockSurveyRepository implements SurveyRepository {
  const MockSurveyRepository();

  @override
  List<SurveyQuestion> loadQuestions(Persona persona) =>
      List<SurveyQuestion>.of(mockDataFor(persona).surveyQuestions);

  @override
  List<SurveyAnswer> loadAnswers(Persona persona) => const <SurveyAnswer>[];
}
