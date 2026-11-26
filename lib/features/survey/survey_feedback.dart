// Devolutiva do questionário ao trabalhador.
//
// Frases acolhedoras e sugestões práticas ligadas ao app. Sem diagnóstico e
// sem rótulos clínicos: os níveis descrevem só "como você respondeu agora".
// Os cortes (1/3 e 2/3) são provisórios, como os itens.

import 'package:flutter/material.dart';

import '../../data/models/survey.dart';

/// Faixa favorável de uma dimensão (já considerando se alto é bom ou ruim).
enum FeedbackLevel { attention, middle, good }

/// Converte uma pontuação favorável (0–1) em faixa.
FeedbackLevel levelFor(double favorable) {
  if (favorable >= 2 / 3) return FeedbackLevel.good;
  if (favorable >= 1 / 3) return FeedbackLevel.middle;
  return FeedbackLevel.attention;
}

/// Textos e regras de exibição de uma dimensão.
class DimensionInfo {
  const DimensionInfo({
    required this.label,
    required this.icon,
    required this.higherIsBetter,
    required this.levelWords,
    required this.phrases,
  });

  final String label;
  final IconData icon;

  /// Fadiga: alto é ruim. Demais: alto é bom.
  final bool higherIsBetter;

  /// Palavra curta do nível da pontuação bruta [baixo, médio, alto], com a
  /// concordância de cada dimensão (ex.: "Fadiga alta").
  final List<String> levelWords;

  /// Frase acolhedora por faixa favorável [atenção, meio, bom].
  final List<String> phrases;

  /// Pontuação favorável: 1 = melhor situação.
  double favorable(double score) => higherIsBetter ? score : 1 - score;

  String levelWord(double score) {
    if (score >= 2 / 3) return levelWords[2];
    if (score >= 1 / 3) return levelWords[1];
    return levelWords[0];
  }

  String phrase(double score) => phrases[levelFor(favorable(score)).index];
}

const Map<SurveyDimension, DimensionInfo>
kDimensionInfo = <SurveyDimension, DimensionInfo>{
  SurveyDimension.bemEstar: DimensionInfo(
    label: 'Bem-estar',
    icon: Icons.spa_outlined,
    higherIsBetter: true,
    levelWords: <String>['Baixo', 'Médio', 'Alto'],
    phrases: <String>[
      'Parece que as coisas andam pesadas. Você merece cuidado, e não precisa '
          'dar conta de tudo de uma vez.',
      'Alguns dias bons, outros nem tanto. É normal, e pequenas pausas ajudam.',
      'Que bom que você tem se sentido bem. Continue cuidando de você.',
    ],
  ),
  SurveyDimension.fadiga: DimensionInfo(
    label: 'Fadiga',
    icon: Icons.battery_3_bar_rounded,
    higherIsBetter: false,
    levelWords: <String>['Baixa', 'Média', 'Alta'],
    phrases: <String>[
      'O cansaço tem aparecido bastante. Parar um pouco não é perder tempo: '
          'é cuidar de você e da sua segurança.',
      'O cansaço aparece às vezes. Fique de olho nos sinais do corpo.',
      'Você tem conseguido manter o cansaço sob controle. Siga com as pausas.',
    ],
  ),
  SurveyDimension.sono: DimensionInfo(
    label: 'Sono',
    icon: Icons.bedtime_outlined,
    higherIsBetter: true,
    levelWords: <String>['Pouco descanso', 'Razoável', 'Bom descanso'],
    phrases: <String>[
      'O descanso não tem sido suficiente. Dormir bem também faz parte do '
          'trabalho seguro.',
      'Seu sono está razoável. Uma rotina parecida todo dia pode ajudar.',
      'Você tem descansado bem. Isso faz diferença no dia a dia.',
    ],
  ),
  SurveyDimension.suporte: DimensionInfo(
    label: 'Suporte da empresa',
    icon: Icons.handshake_outlined,
    higherIsBetter: true,
    levelWords: <String>['Baixo', 'Médio', 'Alto'],
    phrases: <String>[
      'Você sente pouco apoio da empresa. Sua resposta, somada à de todos, '
          'ajuda a mudar isso.',
      'Você sente algum apoio, mas dá para melhorar. Conte com o clube.',
      'Você sente que tem apoio. Que bom: o clube existe para isso.',
    ],
  ),
};

/// Sugestão prática que leva a uma tela do app.
class SurveySuggestion {
  const SurveySuggestion({
    required this.icon,
    required this.title,
    required this.text,
    required this.route,
  });

  final IconData icon;
  final String title;
  final String text;
  final String route;
}

const SurveySuggestion _pause = SurveySuggestion(
  icon: Icons.air_rounded,
  title: 'Fazer uma pausa guiada',
  text: '1 minuto de respiração. Pausas também somam pontos.',
  route: '/inicio/pausa',
);
const SurveySuggestion _supportPoints = SurveySuggestion(
  icon: Icons.place_outlined,
  title: 'Ver pontos de apoio',
  text: 'Lugares para descansar, ir ao banheiro e tomar água.',
  route: '/apoio',
);
const SurveySuggestion _benefits = SurveySuggestion(
  icon: Icons.card_giftcard_rounded,
  title: 'Conhecer os benefícios',
  text: 'Descontos em saúde, oficina e estudos com parceiros.',
  route: '/beneficios',
);
const SurveySuggestion _assistant = SurveySuggestion(
  icon: Icons.chat_bubble_outline_rounded,
  title: 'Tirar dúvidas com o assistente',
  text: 'Ele explica o que a empresa oferece, sem enrolação.',
  route: '/assistente',
);
const SurveySuggestion _help = SurveySuggestion(
  icon: Icons.favorite_border_rounded,
  title: 'Conversar com um profissional',
  text: 'Acolhimento gratuito e sigiloso.',
  route: '/ajuda',
);
const SurveySuggestion _community = SurveySuggestion(
  icon: Icons.groups_outlined,
  title: 'Trocar ideia na comunidade',
  text: 'Dicas e apoio de quem vive a mesma rotina.',
  route: '/comunidade',
);
const SurveySuggestion _plan = SurveySuggestion(
  icon: Icons.flag_outlined,
  title: 'Atualizar suas metas',
  text: 'Aproveite o bom momento para avançar no seu plano.',
  route: '/plano',
);

/// Sugestões por dimensão, quando ela pede atenção (ou fica no meio).
const Map<SurveyDimension, List<SurveySuggestion>> _byDimension =
    <SurveyDimension, List<SurveySuggestion>>{
      SurveyDimension.fadiga: <SurveySuggestion>[_pause, _supportPoints],
      SurveyDimension.suporte: <SurveySuggestion>[_benefits, _assistant],
      SurveyDimension.bemEstar: <SurveySuggestion>[_help, _community],
      SurveyDimension.sono: <SurveySuggestion>[_pause, _help],
    };

/// Monta 2–3 sugestões, começando pelas dimensões menos favoráveis. Se tudo
/// estiver bem, sugere manter as pausas e avançar nas metas.
List<SurveySuggestion> suggestionsFor(Map<SurveyDimension, double> scores) {
  final List<MapEntry<SurveyDimension, double>> needing =
      <MapEntry<SurveyDimension, double>>[
        for (final MapEntry<SurveyDimension, double> e in scores.entries)
          if (levelFor(kDimensionInfo[e.key]!.favorable(e.value)) !=
              FeedbackLevel.good)
            MapEntry<SurveyDimension, double>(
              e.key,
              kDimensionInfo[e.key]!.favorable(e.value),
            ),
      ]..sort(
        (
          MapEntry<SurveyDimension, double> a,
          MapEntry<SurveyDimension, double> b,
        ) => a.value.compareTo(b.value),
      );

  final List<SurveySuggestion> result = <SurveySuggestion>[];
  for (final MapEntry<SurveyDimension, double> e in needing) {
    for (final SurveySuggestion s in _byDimension[e.key]!) {
      if (!result.contains(s)) result.add(s);
    }
  }
  if (result.isEmpty) return const <SurveySuggestion>[_pause, _plan];
  return result.take(3).toList();
}
