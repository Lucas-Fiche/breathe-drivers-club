import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Horário fictício para uma conversa agendada com um profissional.
class HelpSlot {
  const HelpSlot({required this.id, required this.day, required this.time});

  final String id;

  /// Dia relativo (sem data fixa, para valer em qualquer dia de
  /// apresentação). Ex.: "Amanhã".
  final String day;

  /// Ex.: "19h".
  final String time;

  String get label => '$day, às $time';
}

/// Os 3 horários fictícios oferecidos no protótipo.
const List<HelpSlot> kHelpSlots = <HelpSlot>[
  HelpSlot(id: 's1', day: 'Hoje', time: '21h'),
  HelpSlot(id: 's2', day: 'Amanhã', time: '8h'),
  HelpSlot(id: 's3', day: 'Depois de amanhã', time: '14h30'),
];

/// Conversa agendada (nula se nenhuma). Fica em memória e sobrevive à
/// navegação, para o card da Ajuda mostrar a confirmação ao voltar.
class ScheduledHelpNotifier extends Notifier<HelpSlot?> {
  @override
  HelpSlot? build() => null;

  void schedule(HelpSlot slot) => state = slot;

  void cancel() => state = null;
}

final NotifierProvider<ScheduledHelpNotifier, HelpSlot?> scheduledHelpProvider =
    NotifierProvider<ScheduledHelpNotifier, HelpSlot?>(
      ScheduledHelpNotifier.new,
    );
