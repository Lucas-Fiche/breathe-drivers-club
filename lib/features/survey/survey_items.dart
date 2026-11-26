// ⚠️ itens provisórios — substituir pelos instrumentos validados escolhidos
// pela equipe de Psicologia.
//
// Este é o ÚNICO arquivo com o conteúdo do questionário (afirmações, escala e
// data da próxima rodada). Os textos abaixo são um rascunho para o protótipo,
// em linguagem simples e neutra em gênero, e NÃO são um instrumento validado.
// Ao trocar pelos instrumentos definitivos, manter: id único, dimensão e se o
// item é invertido (concordar = menos da dimensão).

import '../../data/models/survey.dart';

/// Opção da escala de concordância (1 a 5).
class SurveyScaleOption {
  const SurveyScaleOption({required this.label, required this.emoji});

  final String label;

  /// Emoji neutro: indica concordância, não humor (para não sugerir qual
  /// resposta é a "certa").
  final String emoji;
}

/// Escala de 1 a 5, de "Discordo totalmente" a "Concordo totalmente".
const List<SurveyScaleOption> kSurveyScale = <SurveyScaleOption>[
  SurveyScaleOption(label: 'Discordo totalmente', emoji: '🙅'),
  SurveyScaleOption(label: 'Discordo', emoji: '👎'),
  SurveyScaleOption(label: 'Nem concordo nem discordo', emoji: '🤷'),
  SurveyScaleOption(label: 'Concordo', emoji: '👍'),
  SurveyScaleOption(label: 'Concordo totalmente', emoji: '🙌'),
];

/// Afirmações provisórias: 4 dimensões, 2–3 itens cada (10 no total).
const List<SurveyQuestion> kSurveyItems = <SurveyQuestion>[
  // Bem-estar
  SurveyQuestion(
    id: 'be1',
    dimension: SurveyDimension.bemEstar,
    text: 'No geral, tenho me sentido bem.',
  ),
  SurveyQuestion(
    id: 'be2',
    dimension: SurveyDimension.bemEstar,
    text: 'Consigo tempo para coisas de que gosto fora do trabalho.',
  ),
  SurveyQuestion(
    id: 'be3',
    dimension: SurveyDimension.bemEstar,
    text: 'Tenho perdido a paciência com facilidade.',
    reversed: true,
  ),

  // Fadiga
  SurveyQuestion(
    id: 'fa1',
    dimension: SurveyDimension.fadiga,
    text: 'Termino o dia de trabalho sem energia.',
  ),
  SurveyQuestion(
    id: 'fa2',
    dimension: SurveyDimension.fadiga,
    text: 'Já senti sono ou cansaço forte no trânsito, durante o trabalho.',
  ),
  SurveyQuestion(
    id: 'fa3',
    dimension: SurveyDimension.fadiga,
    text: 'Consigo fazer pausas quando sinto que preciso.',
    reversed: true,
  ),

  // Sono
  SurveyQuestion(
    id: 'so1',
    dimension: SurveyDimension.sono,
    text: 'Durmo bem na maioria das noites.',
  ),
  SurveyQuestion(
    id: 'so2',
    dimension: SurveyDimension.sono,
    text: 'Acordo sem energia, mesmo depois de dormir.',
    reversed: true,
  ),

  // Suporte da empresa (PSO)
  SurveyQuestion(
    id: 'pso1',
    dimension: SurveyDimension.suporte,
    text: 'Sinto que a plataforma se importa com o meu bem-estar.',
  ),
  SurveyQuestion(
    id: 'pso2',
    dimension: SurveyDimension.suporte,
    text: 'Sei a quem pedir ajuda quando tenho um problema no trabalho.',
  ),
];

/// Quando abre a próxima rodada (semestral).
const String kNextSurveyLabel = 'maio de 2027';

/// Tempo estimado para responder, mostrado na introdução.
const String kSurveyEstimatedTime = '~3 min';
