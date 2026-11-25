import 'package:flutter/material.dart';

import '../../../core/widgets/widgets.dart';

/// Tela Questionário (`/questionario`) — placeholder da Fase 2.
class SurveyScreen extends StatelessWidget {
  const SurveyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BreatheScaffold(
      title: 'Questionário',
      subtitle: 'Como tem sido o seu trabalho',
      body: EmptyState(
        title: 'Em construção',
        message: 'O questionário semestral será montado em breve.',
        icon: Icons.assignment_outlined,
      ),
    );
  }
}
