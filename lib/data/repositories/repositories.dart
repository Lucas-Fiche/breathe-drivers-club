import '../models/models.dart';

/// Interfaces abstratas por domínio.
///
/// Cada método recebe a [Persona] ativa para carregar o conjunto de dados
/// correspondente. As telas/providers dependem apenas destas interfaces; a
/// implementação fictícia (mock) pode ser trocada por uma que consome API sem
/// alterar o resto do app.

abstract interface class ProfileRepository {
  UserProfile loadProfile(Persona persona);
  ConsentSettings loadConsent(Persona persona);
}

abstract interface class PlanRepository {
  List<LifeGoal> loadGoals(Persona persona);
  DailyGoal loadDailyGoal(Persona persona);
  WorkDay loadWorkDay(Persona persona);
  List<MoodEntry> loadMoods(Persona persona);
}

abstract interface class FinanceRepository {
  List<Transaction> loadTransactions(Persona persona);
  PiggyBank loadPiggyBank(Persona persona);
}

abstract interface class BenefitsRepository {
  List<Benefit> loadBenefits(Persona persona);
  List<StudyProgram> loadStudyPrograms(Persona persona);
}

abstract interface class SupportRepository {
  List<SupportPoint> loadSupportPoints(Persona persona);
  List<Event> loadEvents(Persona persona);
}

abstract interface class CommunityRepository {
  List<CommunityPost> loadPosts(Persona persona);
}

abstract interface class SurveyRepository {
  List<SurveyQuestion> loadQuestions(Persona persona);
  List<SurveyAnswer> loadAnswers(Persona persona);
}
