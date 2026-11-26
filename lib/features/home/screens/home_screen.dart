import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/providers/providers.dart';
import '../widgets/breathe_break_card.dart';
import '../widgets/daily_goal_card.dart';
import '../widgets/day_card.dart';
import '../widgets/home_shortcuts.dart';
import '../widgets/mood_card.dart';
import '../widgets/recognition_card.dart';

/// Tela Início (`/inicio`): resumo do dia, meta, humor, pausa, reconhecimento e
/// atalhos. O cabeçalho traz saudação pelo horário e o avatar que leva a
/// `/mais`.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String firstName =
        ref.watch(profileProvider).profile.name.split(' ').first;

    return BreatheScaffold(
      title: '${_greeting()}, $firstName',
      subtitle: 'Vamos fazer um dia equilibrado',
      action: _ProfileAvatar(
        initials: initialsOf(ref.watch(profileProvider).profile.name),
        onTap: () => context.push('/mais'),
      ),
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

/// Avatar com as iniciais do motorista, no canto do cabeçalho.
class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({required this.initials, required this.onTap});

  final String initials;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.mint,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox.square(
          dimension: 44,
          child: Center(
            child: Text(
              initials,
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
