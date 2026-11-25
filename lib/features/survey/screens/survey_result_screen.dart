import 'package:flutter/material.dart';

import '../../../core/widgets/widgets.dart';

/// Tela de resultado do questionário (`/questionario/resultado`) — placeholder.
class SurveyResultScreen extends StatelessWidget {
  const SurveyResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BreatheScaffold(
      title: 'Seu resultado',
      subtitle: 'O que você compartilhou',
      body: EmptyState(
        title: 'Em construção',
        message: 'O resultado do questionário será montado em breve.',
        icon: Icons.insights_outlined,
      ),
    );
  }
}
