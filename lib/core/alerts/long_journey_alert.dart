import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../widgets/widgets.dart';

/// Alerta de jornada longa em tela cheia (fundo coralSoft). Tom de cuidado,
/// sem culpa: sugere encerrar ou fazer uma pausa longa.
class LongJourneyAlert extends StatelessWidget {
  const LongJourneyAlert({
    super.key,
    required this.hours,
    required this.onPause,
    required this.onSnooze,
  });

  /// Horas online (arredondadas para exibição).
  final double hours;
  final VoidCallback onPause;
  final VoidCallback onSnooze;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Semantics(
      liveRegion: true,
      scopesRoute: true,
      explicitChildNodes: true,
      child: Material(
        color: AppColors.coralSoft,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Spacer(),
                const Center(
                  child: CircleAvatar(
                    radius: 44,
                    backgroundColor: AppColors.surface,
                    child: Icon(
                      Icons.nights_stay_outlined,
                      size: 44,
                      color: AppColors.coral,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
                Text(
                  'Você está há ${hours.floor()}h online.',
                  textAlign: TextAlign.center,
                  style: textTheme.titleLarge,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Que tal encerrar ou fazer uma pausa longa?',
                  textAlign: TextAlign.center,
                  style: textTheme.bodyLarge,
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Icon(
                      Icons.warning_amber_rounded,
                      size: 20,
                      color: AppColors.primaryDark,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Flexible(
                      child: Text(
                        'Pare em local seguro.',
                        style: textTheme.labelLarge,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                PrimaryButton(
                  label: 'Fazer pausa agora',
                  icon: Icons.air_rounded,
                  onPressed: onPause,
                ),
                const SizedBox(height: AppSpacing.md),
                SecondaryButton(
                  label: 'Lembrar em 30 min',
                  onPressed: onSnooze,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
