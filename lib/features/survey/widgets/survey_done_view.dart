import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/widgets.dart';
import '../survey_items.dart';

/// Estado "já respondido": mostrado ao voltar ao questionário depois de
/// enviar.
class SurveyDoneView extends StatelessWidget {
  const SurveyDoneView({super.key});

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.task_alt_rounded,
      title: 'Questionário já respondido',
      message: 'Obrigado por participar. O próximo será em $kNextSurveyLabel.',
      action: SecondaryButton(
        label: 'Ver minha devolutiva',
        expand: false,
        onPressed: () => context.push('/questionario/resultado'),
      ),
    );
  }
}
