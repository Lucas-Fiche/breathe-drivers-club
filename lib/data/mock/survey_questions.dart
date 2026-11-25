import '../models/survey.dart';

/// ⚠️ PROVISÓRIO — itens do questionário semestral.
///
/// Estes itens são um rascunho para o protótipo e **serão substituídos pelos
/// instrumentos validados** pela equipe de Psicologia (ex.: escalas de
/// Percepção de Suporte Organizacional). Mantidos num único arquivo para
/// facilitar a troca. Não tratar como instrumento final.
const List<String> kSurveyScale = <String>[
  'Nunca',
  'Raramente',
  'Às vezes',
  'Quase sempre',
  'Sempre',
];

const List<SurveyQuestion> kSurveyQuestions = <SurveyQuestion>[
  SurveyQuestion(
    id: 'q1',
    text: 'Sinto que a plataforma se preocupa com o meu bem-estar.',
    options: kSurveyScale,
  ),
  SurveyQuestion(
    id: 'q2',
    text: 'Consigo fazer pausas quando preciso durante o trabalho.',
    options: kSurveyScale,
  ),
  SurveyQuestion(
    id: 'q3',
    text: 'Tenho conseguido descansar o suficiente entre as jornadas.',
    options: kSurveyScale,
  ),
  SurveyQuestion(
    id: 'q4',
    text: 'Sinto que o meu trabalho é reconhecido.',
    options: kSurveyScale,
  ),
  SurveyQuestion(
    id: 'q5',
    text: 'Consigo equilibrar o trabalho com a minha vida pessoal.',
    options: kSurveyScale,
  ),
  SurveyQuestion(
    id: 'q6',
    text: 'Sei onde buscar apoio quando estou sobrecarregado.',
    options: kSurveyScale,
  ),
];
