import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/health_limits.dart';
import '../../core/alerts/alerts_providers.dart';
import '../../data/models/models.dart';
import '../../data/providers/providers.dart';
import '../help/providers.dart';

// Ações do modo apresentação. Usadas pelo bottom sheet e pelo catálogo de
// telas (`/telas` > Estados especiais). Todas mexem só nos dados fictícios em
// memória e usam os mesmos providers que a lógica real usaria.

/// Pontos do reconhecimento de demonstração.
const int kDemoRecognitionPoints = 20;

/// Coloca a jornada em [HealthLimits.longJourneyHours] e rearma o alerta, que
/// aparece ao abrir o Início.
void simulateLongJourney(WidgetRef ref) {
  ref.read(planProvider.notifier).setOnlineHours(HealthLimits.longJourneyHours);
  ref.read(longJourneyAlertProvider.notifier).rearm();
}

void triggerBreakReminder(WidgetRef ref) {
  ref.read(breakReminderProvider.notifier).show();
}

void showRecognition(WidgetRef ref) {
  ref
      .read(recognitionProvider.notifier)
      .celebrate(
        points: kDemoRecognitionPoints,
        message: 'você cuidou de você hoje',
      );
}

/// Alterna Carlos ↔ Joana e devolve a persona ativa.
Persona togglePersona(WidgetRef ref) {
  ref.read(personaProvider.notifier).toggle();
  return ref.read(personaProvider);
}

/// Responde o questionário (respostas neutras) e envia, para mostrar o estado
/// "já respondido". Não faz nada se já foi enviado.
void markSurveyAnswered(WidgetRef ref) {
  final SurveyNotifier survey = ref.read(surveyProvider.notifier);
  if (ref.read(surveyProvider).submitted) return;
  for (final SurveyQuestion q in ref.read(surveyProvider).questions) {
    survey.answer(q.id, 2);
  }
  survey.submit();
}

/// Volta todos os dados fictícios ao estado inicial (persona Carlos).
void resetDemoData(WidgetRef ref) {
  ref
    ..invalidate(personaProvider)
    ..invalidate(profileProvider)
    ..invalidate(planProvider)
    ..invalidate(financeProvider)
    ..invalidate(benefitsProvider)
    ..invalidate(supportProvider)
    ..invalidate(communityProvider)
    ..invalidate(surveyProvider)
    ..invalidate(scheduledHelpProvider)
    ..invalidate(breakReminderProvider)
    ..invalidate(longJourneyAlertProvider)
    ..invalidate(recognitionProvider);
}

extension PersonaNameX on Persona {
  /// Nome da persona, para os textos do modo apresentação.
  String get displayName =>
      this == Persona.carlos ? 'Carlos Souza' : 'Joana Lima';
}
