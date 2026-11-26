import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/health_limits.dart';
import '../../data/providers/providers.dart';

// Providers dos alertas globais (lembrete de pausa, jornada longa e
// reconhecimento). No protótipo, quem os aciona é o modo apresentação; na
// versão real, os mesmos métodos seriam chamados pela lógica de jornada
// (ex.: um timer de horas online vindo da plataforma).

// ---------------------------------------------------------------------------
// Lembrete de pausa (banner no topo)
// ---------------------------------------------------------------------------

/// Visibilidade do banner de lembrete de pausa.
class BreakReminderNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void show() => state = true;

  void dismiss() => state = false;
}

final NotifierProvider<BreakReminderNotifier, bool> breakReminderProvider =
    NotifierProvider<BreakReminderNotifier, bool>(BreakReminderNotifier.new);

// ---------------------------------------------------------------------------
// Jornada longa (alerta em tela cheia no Início)
// ---------------------------------------------------------------------------

/// O que a pessoa já fez com o alerta de jornada longa hoje.
class LongJourneyAlertState {
  const LongJourneyAlertState({
    this.acknowledged = false,
    this.snoozed = false,
  });

  /// Tocou em "Fazer pausa agora".
  final bool acknowledged;

  /// Tocou em "Lembrar em 30 min" (volta sozinho depois do prazo).
  final bool snoozed;
}

class LongJourneyAlertNotifier extends Notifier<LongJourneyAlertState> {
  /// Prazo do "Lembrar em 30 min".
  static const Duration snoozeDuration = Duration(minutes: 30);

  Timer? _snoozeTimer;

  @override
  LongJourneyAlertState build() {
    ref.onDispose(() => _snoozeTimer?.cancel());
    return const LongJourneyAlertState();
  }

  void acknowledge() {
    _snoozeTimer?.cancel();
    state = const LongJourneyAlertState(acknowledged: true);
  }

  void snooze() {
    _snoozeTimer?.cancel();
    _snoozeTimer = Timer(snoozeDuration, rearm);
    state = const LongJourneyAlertState(snoozed: true);
  }

  /// Volta a permitir o alerta (ex.: depois do adiamento ou numa nova
  /// simulação de jornada).
  void rearm() {
    _snoozeTimer?.cancel();
    state = const LongJourneyAlertState();
  }
}

final NotifierProvider<LongJourneyAlertNotifier, LongJourneyAlertState>
longJourneyAlertProvider =
    NotifierProvider<LongJourneyAlertNotifier, LongJourneyAlertState>(
      LongJourneyAlertNotifier.new,
    );

/// Verdadeiro quando o alerta de jornada longa deve aparecer (horas online
/// no limite de [HealthLimits.longJourneyHours] e sem resposta da pessoa).
final Provider<bool> longJourneyDueProvider = Provider<bool>((Ref ref) {
  final double hours = ref.watch(planProvider).workDay.onlineHours;
  final LongJourneyAlertState alert = ref.watch(longJourneyAlertProvider);
  return hours >= HealthLimits.longJourneyHours &&
      !alert.acknowledged &&
      !alert.snoozed;
});

// ---------------------------------------------------------------------------
// Reconhecimento (toast "+20 pontos")
// ---------------------------------------------------------------------------

/// Um reconhecimento a exibir. [id] muda a cada evento para reiniciar a
/// animação mesmo com o mesmo texto.
class RecognitionEvent {
  const RecognitionEvent({
    required this.id,
    required this.points,
    required this.message,
  });

  final int id;
  final int points;
  final String message;
}

class RecognitionNotifier extends Notifier<RecognitionEvent?> {
  int _counter = 0;

  @override
  RecognitionEvent? build() => null;

  /// Credita [points] e mostra o reconhecimento. Pontos vêm de cuidado
  /// (pausas, metas, questionário), nunca de fazer mais corridas.
  void celebrate({required int points, required String message}) {
    ref.read(profileProvider.notifier).addPoints(points);
    state = RecognitionEvent(id: ++_counter, points: points, message: message);
  }

  void clear() => state = null;
}

final NotifierProvider<RecognitionNotifier, RecognitionEvent?>
recognitionProvider = NotifierProvider<RecognitionNotifier, RecognitionEvent?>(
  RecognitionNotifier.new,
);
