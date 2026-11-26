import 'package:breathe_drivers_club/features/assistant/assistant_script.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Roteiro do assistente', () {
    test('todas as sugestões apontam para tópicos existentes', () {
      for (final AssistantTopic t in kAssistantTopics.values) {
        expect(t.suggestions.length, inInclusiveRange(2, 3), reason: t.id);
        for (final String s in t.suggestions) {
          expect(kAssistantTopics.containsKey(s), isTrue, reason: s);
        }
      }
      for (final String id in kEntryTopics) {
        expect(kAssistantTopics.containsKey(id), isTrue, reason: id);
      }
    });

    test('estudos leva aos programas de estudo', () {
      expect(
        kAssistantTopics['estudos']!.action!.route,
        '/beneficios?filtro=estudos',
      );
    });

    test('palavras-chave levam ao tópico certo', () {
      expect(matchTopicId('Quero voltar pra escola'), 'estudos');
      expect(matchTopicId('Como guardar dinheiro?'), 'financas');
      expect(matchTopicId('Tô cansado'), 'pausas');
      expect(matchTopicId('Tem seguro?'), 'beneficios');
      expect(matchTopicId('qual a previsão do tempo'), isNull);
    });

    test('detecta sinais de sofrimento, com ou sem acento', () {
      expect(isDistressText('Estou muito estressado'), isTrue);
      expect(isDistressText('não aguento mais'), isTrue);
      expect(isDistressText('nao aguento'), isTrue);
      expect(isDistressText('ando ansioso'), isTrue);
      expect(isDistressText('quero estudar'), isFalse);
    });
  });
}
