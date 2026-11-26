import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/providers/providers.dart';
import '../widgets/breathe_break_card.dart';
import '../widgets/daily_goal_card.dart';
import '../widgets/day_card.dart';
import '../widgets/home_shortcuts.dart';
import '../widgets/mood_card.dart';
import '../widgets/recognition_card.dart';

/// Tela Início (`/inicio`): resumo do dia, meta, humor, pausa, reconhecimento e
/// atalhos. O cabeçalho traz a saudação pelo horário (o avatar do perfil vem
/// do [BreatheScaffold], como em todas as telas).
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String firstName =
        ref.watch(profileProvider).profile.name.split(' ').first;

    return BreatheScaffold(
      title: '${_greeting()}, $firstName',
      subtitle: 'Vamos fazer um dia equilibrado',
      scrollable: true,
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          DayCard(),
          SizedBox(height: AppSpacing.lg),
          DailyGoalCard(),
          SizedBox(height: AppSpacing.lg),
          MoodCard(),
          SizedBox(height: AppSpacing.lg),
          BreatheBreakCard(),
          SizedBox(height: AppSpacing.lg),
          RecognitionCard(),
          SizedBox(height: AppSpacing.lg),
          HomeShortcuts(),
          SizedBox(height: AppSpacing.sm),
        ],
      ),
    );
  }

  String _greeting() {
    final int hour = DateTime.now().hour;
    if (hour < 12) return 'Bom dia';
    if (hour < 18) return 'Boa tarde';
    return 'Boa noite';
  }
}
