/// Pergunta do questionário semestral.
///
/// Os itens são **provisórios** (ver survey_questions.dart) e serão trocados
/// pelos instrumentos validados pela equipe de Psicologia.
class SurveyQuestion {
  const SurveyQuestion({
    required this.id,
    required this.text,
    required this.options,
  });

  final String id;
  final String text;

  /// Opções de resposta, em ordem (ex.: escala de "Nunca" a "Sempre").
  final List<String> options;
}

/// Resposta dada a uma [SurveyQuestion], pelo índice da opção escolhida.
class SurveyAnswer {
  const SurveyAnswer({
    required this.questionId,
    required this.optionIndex,
  });

  final String questionId;
  final int optionIndex;

  SurveyAnswer copyWith({
    String? questionId,
    int? optionIndex,
  }) {
    return SurveyAnswer(
      questionId: questionId ?? this.questionId,
      optionIndex: optionIndex ?? this.optionIndex,
    );
  }
}
