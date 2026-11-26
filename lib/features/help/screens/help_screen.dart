import 'package:flutter/material.dart';

import '../../../app/theme/app_spacing.dart';
import '../../../core/utils/navigation.dart';
import '../../../core/widgets/widgets.dart';
import '../widgets/emergency_section.dart';
import '../widgets/help_cards.dart';
import '../widgets/schedule_card.dart';

/// Tela Ajuda / acolhimento (`/ajuda`). Tom calmo: verde e branco, coral só
/// no botão principal, nada de vermelho alarmante.
///
/// Não mostra o próprio ícone de Ajuda no cabeçalho (evita o laço para si
/// mesma).
class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BreatheScaffold(
      title: 'Ajuda',
      subtitle: 'Você não está sozinho',
      showHelp: false,
      onBack: () => popOrGo(context),
      scrollable: true,
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TalkNowCard(),
          SizedBox(height: AppSpacing.md),
          ScheduleCard(),
          SizedBox(height: AppSpacing.md),
          QuickExerciseCard(),
          SizedBox(height: AppSpacing.xxl),
          EmergencySection(),
          SizedBox(height: AppSpacing.lg),
          HelpPrivacyNote(),
          SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}
