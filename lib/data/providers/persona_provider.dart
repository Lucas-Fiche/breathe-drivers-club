import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/persona.dart';

/// Persona ativa do protótipo. Trocá-la faz os providers de domínio
/// reconstruírem (eles observam este provider), recarregando todos os dados.
class PersonaNotifier extends Notifier<Persona> {
  @override
  Persona build() => Persona.carlos;

  /// Seleciona uma persona específica.
  void select(Persona persona) => state = persona;

  /// Alterna entre Carlos e Joana (usado no modo apresentação).
  void toggle() => state =
      state == Persona.carlos ? Persona.joana : Persona.carlos;
}

final NotifierProvider<PersonaNotifier, Persona> personaProvider =
    NotifierProvider<PersonaNotifier, Persona>(PersonaNotifier.new);
