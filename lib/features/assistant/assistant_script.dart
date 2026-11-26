// Roteiro do assistente (sem IA real).
//
// Cada tópico tem uma resposta curta, sugestões de continuação e, quando faz
// sentido, uma ação que navega para a tela certa. Há também correspondência
// simples por palavras-chave e detecção de sinais de sofrimento.

/// Ação opcional de uma resposta (botão que navega para uma rota).
class AssistantAction {
  const AssistantAction({required this.label, required this.route});

  final String label;
  final String route;
}

/// Um tópico do roteiro.
class AssistantTopic {
  const AssistantTopic({
    required this.id,
    required this.chipLabel,
    required this.response,
    this.suggestions = const <String>[],
    this.action,
  });

  final String id;

  /// Rótulo exibido no chip de sugestão.
  final String chipLabel;

  final String response;

  /// Ids de tópicos sugeridos como continuação.
  final List<String> suggestions;

  final AssistantAction? action;
}

/// Mensagem inicial do assistente, com o primeiro nome da pessoa.
String assistantGreeting(String firstName) =>
    'Oi, $firstName! Posso ajudar com benefícios, estudos e pausas.';

/// Resposta padrão quando nada corresponde.
const String kAssistantFallback =
    'Ainda estou aprendendo. Posso te ajudar com benefícios, estudos, pausas e '
    'finanças. Sobre o que você quer falar?';

/// Resposta acolhedora quando há sinais de sofrimento.
const String kAssistantDistress =
    'Sinto muito que você esteja passando por isso. Você tem apoio aqui, e '
    'pedir ajuda é um sinal de força. Se puder, pare em local seguro e fale '
    'com o acolhimento.';

/// Ids dos tópicos de entrada (chips acima do campo de texto).
const List<String> kEntryTopics = <String>[
  'beneficios',
  'estudos',
  'pausas',
  'financas',
  'empresa',
];

/// Todos os tópicos do roteiro.
const Map<String, AssistantTopic> kAssistantTopics = <String, AssistantTopic>{
  'beneficios': AssistantTopic(
    id: 'beneficios',
    chipLabel: 'Benefícios',
    response:
        'Com os seus pontos você troca por descontos em oficina, saúde, estudos '
        'e finanças. Os pontos vêm de pausas, metas e do questionário — nunca de '
        'fazer mais corridas. É só abrir os Benefícios para ver o que dá para '
        'resgatar.',
    suggestions: <String>['estudos', 'financas', 'empresa'],
    action: AssistantAction(label: 'Ver benefícios', route: '/beneficios'),
  ),
  'estudos': AssistantTopic(
    id: 'estudos',
    chipLabel: 'Estudos',
    response:
        'Dá para terminar o ensino médio ou fazer um curso com apoio do clube. '
        'Há bolsas e parcerias com escolas. Você escolhe o ritmo, sem pressa.',
    suggestions: <String>['beneficios', 'financas'],
    action: AssistantAction(
      label: 'Ver programas de estudo',
      route: '/beneficios?filtro=estudos',
    ),
  ),
  'pausas': AssistantTopic(
    id: 'pausas',
    chipLabel: 'Pausas',
    response:
        'Pausas curtas ajudam o corpo e a cabeça, e ainda somam pontos. Que tal '
        'uma pausa de 1 minuto agora? Pare em local seguro antes de começar.',
    suggestions: <String>['beneficios', 'empresa'],
    action: AssistantAction(
      label: 'Iniciar pausa de 1 minuto',
      route: '/inicio/pausa',
    ),
  ),
  'financas': AssistantTopic(
    id: 'financas',
    chipLabel: 'Finanças',
    response:
        'Em Finanças você vê o que entra, o que sai e o que sobra. Dá para '
        'separar um pouco no cofrinho a cada recebimento. Pouquinho por dia já '
        'faz diferença.',
    suggestions: <String>['estudos', 'beneficios'],
    action: AssistantAction(label: 'Abrir Finanças', route: '/financas'),
  ),
  'empresa': AssistantTopic(
    id: 'empresa',
    chipLabel: 'O que a empresa oferece?',
    response:
        'A empresa oferece este app com pausas, metas, finanças, benefícios de '
        'parceiros e pontos de apoio, para te dar mais suporte. Sendo '
        'transparente: o app não muda o valor das suas corridas, e os descontos '
        'dependem de cada parceiro. Ela também só vê dados agregados e anônimos, '
        'nunca os seus dados individuais.',
    suggestions: <String>['beneficios', 'pausas'],
    action: AssistantAction(
      label: 'Como meus dados são usados',
      route: '/privacidade',
    ),
  ),
};

/// Palavras que indicam sofrimento e disparam o card de acolhimento.
const List<String> _distressKeywords = <String>[
  'estressad', 'estresse', 'nao aguento', 'ansios', 'ansiedade',
  'sobrecarregad', 'exaust', 'triste', 'deprimid', 'sozinho', 'desanimad',
  'panico', 'cansado demais', 'nao consigo',
];

/// Pares (palavras-chave → tópico), em ordem de prioridade.
const List<(List<String>, String)> _keywordTopics = <(List<String>, String)>[
  (<String>['estud', 'escola', 'faculdade', 'curso', 'formar'], 'estudos'),
  (
    <String>['dinheiro', 'financ', 'cofrinho', 'guardar', 'grana', 'economi'],
    'financas',
  ),
  (<String>['pausa', 'descans', 'respir', 'cansa'], 'pausas'),
  (
    <String>['seguro', 'benefic', 'desconto', 'parceiro', 'ponto', 'resgat'],
    'beneficios',
  ),
  (<String>['empresa', 'oferece', 'plataforma', 'uber', 'ifood'], 'empresa'),
];

/// Normaliza o texto: minúsculas e sem acentos, para a busca por palavras.
String _normalize(String text) {
  final String lower = text.toLowerCase();
  const Map<String, String> map = <String, String>{
    'á': 'a', 'à': 'a', 'ã': 'a', 'â': 'a',
    'é': 'e', 'ê': 'e',
    'í': 'i',
    'ó': 'o', 'ô': 'o', 'õ': 'o',
    'ú': 'u',
    'ç': 'c',
  };
  final StringBuffer buffer = StringBuffer();
  for (final int rune in lower.runes) {
    final String ch = String.fromCharCode(rune);
    buffer.write(map[ch] ?? ch);
  }
  return buffer.toString();
}

/// Verdadeiro se o texto tem sinais de sofrimento.
bool isDistressText(String text) {
  final String n = _normalize(text);
  return _distressKeywords.any((String k) => n.contains(k));
}

/// Tópico correspondente ao texto por palavra-chave (nulo se nenhum).
String? matchTopicId(String text) {
  final String n = _normalize(text);
  for (final (List<String>, String) entry in _keywordTopics) {
    if (entry.$1.any((String k) => n.contains(k))) {
      return entry.$2;
    }
  }
  return null;
}
