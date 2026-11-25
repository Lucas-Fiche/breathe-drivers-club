import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/models.dart';
import '../repositories/repositories.dart';
import 'persona_provider.dart';
import 'profile_provider.dart';
import 'repository_providers.dart';
import 'rewards.dart';

/// Estado do questionário: perguntas, respostas e se já foi enviado.
class SurveyState {
  const SurveyState({
    required this.questions,
    this.answers = const <SurveyAnswer>[],
    this.submitted = false,
  });

  final List<SurveyQuestion> questions;
  final List<SurveyAnswer> answers;
  final bool submitted;

  int get answeredCount => answers.length;

  bool get isComplete =>
      questions.isNotEmpty && answers.length == questions.length;

  /// Índice escolhido para uma pergunta (nulo se ainda não respondida).
  int? answerFor(String questionId) {
    for (final SurveyAnswer a in answers) {
      if (a.questionId == questionId) return a.optionIndex;
    }
    return null;
  }

  SurveyState copyWith({
    List<SurveyQuestion>? questions,
    List<SurveyAnswer>? answers,
    bool? submitted,
  }) {
    return SurveyState(
      questions: questions ?? this.questions,
      answers: answers ?? this.answers,
      submitted: submitted ?? this.submitted,
    );
  }
}

class SurveyNotifier extends Notifier<SurveyState> {
  @override
  SurveyState build() {
    final Persona persona = ref.watch(personaProvider);
    final SurveyRepository repo = ref.read(surveyRepositoryProvider);
    return SurveyState(
      questions: repo.loadQuestions(persona),
      answers: repo.loadAnswers(persona),
    );
  }

  /// Registra (ou troca) a resposta de uma pergunta.
  void answer(String questionId, int optionIndex) {
    final List<SurveyAnswer> updated = <SurveyAnswer>[
      for (final SurveyAnswer a in state.answers)
        if (a.questionId != questionId) a,
      SurveyAnswer(questionId: questionId, optionIndex: optionIndex),
    ];
    state = state.copyWith(answers: updated);
  }

  /// Envia o questionário. Só envia se todas as perguntas foram respondidas;
  /// credita pontos uma única vez.
  bool submit() {
    if (!state.isComplete || state.submitted) return false;
    state = state.copyWith(submitted: true);
    ref.read(profileProvider.notifier).addPoints(PointRewards.perSurvey);
    return true;
  }
}

final NotifierProvider<SurveyNotifier, SurveyState> surveyProvider =
    NotifierProvider<SurveyNotifier, SurveyState>(SurveyNotifier.new);
