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

  /// Pontuação de uma dimensão, de 0 a 1 (média das respostas, com itens
  /// invertidos espelhados). Nula se nenhum item da dimensão foi respondido.
  ///
  /// 1 = "muito" da dimensão (ex.: Fadiga 1 = muita fadiga; Sono 1 = dorme
  /// bem). Quem decide se alto é bom ou ruim é a tela de resultado.
  double? scoreFor(SurveyDimension dimension) {
    double total = 0;
    int count = 0;
    for (final SurveyQuestion q in questions) {
      if (q.dimension != dimension) continue;
      final int? index = answerFor(q.id);
      if (index == null) continue;
      final double value = index / 4;
      total += q.reversed ? 1 - value : value;
      count++;
    }
    return count == 0 ? null : total / count;
  }

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
