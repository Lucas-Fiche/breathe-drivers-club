import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/models.dart';
import '../demo_actions.dart';
import 'demo_sheet.dart';

// Ações dos estados especiais do catálogo (`/telas`). Funções de topo, para
// caberem nas listas const do catálogo.

void _snack(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(behavior: SnackBarBehavior.floating, content: Text(message)),
    );
}

void catalogLongJourney(BuildContext context, WidgetRef ref) {
  simulateLongJourney(ref);
  context.go('/inicio');
}

void catalogBreakReminder(BuildContext context, WidgetRef ref) =>
    triggerBreakReminder(ref);

void catalogRecognition(BuildContext context, WidgetRef ref) => showRecognition(ref);

void catalogSurveyDone(BuildContext context, WidgetRef ref) {
  markSurveyAnswered(ref);
  context.go('/questionario');
}

void catalogPersona(BuildContext context, WidgetRef ref) {
  final Persona now = togglePersona(ref);
  _snack(context, 'Agora você está vendo o app como ${now.displayName}.');
}

void catalogDemoSheet(BuildContext context, WidgetRef ref) => showDemoSheet(context);

void catalogReset(BuildContext context, WidgetRef ref) {
  resetDemoData(ref);
  _snack(context, 'Dados fictícios restaurados.');
}
