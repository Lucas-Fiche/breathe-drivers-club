/// Dimensões avaliadas no questionário semestral.
enum SurveyDimension { bemEstar, fadiga, sono, suporte }

/// Afirmação do questionário semestral, respondida numa escala de
/// concordância de 1 a 5 (índices 0 a 4).
///
/// Os itens são **provisórios** (ver `features/survey/survey_items.dart`) e
/// serão trocados pelos instrumentos validados pela equipe de Psicologia.
class SurveyQuestion {
  const SurveyQuestion({
    required this.id,
    required this.text,
    required this.dimension,
    this.reversed = false,
  });

  final String id;
  final String text;
  final SurveyDimension dimension;

  /// Item invertido: concordar indica *menos* da dimensão (ex.: "Durmo mal"
  /// na dimensão Sono). A pontuação é espelhada no cálculo.
  final bool reversed;
}

/// Resposta dada a uma [SurveyQuestion], pelo índice da opção escolhida
/// (0 = Discordo totalmente … 4 = Concordo totalmente).
class SurveyAnswer {
  const SurveyAnswer({required this.questionId, required this.optionIndex});

  final String questionId;
  final int optionIndex;

  SurveyAnswer copyWith({String? questionId, int? optionIndex}) {
    return SurveyAnswer(
      questionId: questionId ?? this.questionId,
      optionIndex: optionIndex ?? this.optionIndex,
    );
  }
}
