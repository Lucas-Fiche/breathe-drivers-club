import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/health_limits.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/providers/providers.dart';

/// Card "Seu dia": tempo online, pausas feitas e tempo desde a última pausa,
/// com uma barra do tempo online até o limite saudável de 10h.
class DayCard extends ConsumerWidget {
  const DayCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final workDay = ref.watch(planProvider).workDay;

    final Duration online = Duration(minutes: (workDay.onlineHours * 60).round());
    final bool nearLimit = workDay.onlineHours >= 8;
    final double barValue =
        (workDay.onlineHours / HealthLimits.longJourneyHours).clamp(0.0, 1.0);

    final String sinceBreak = workDay.lastBreak == null
        ? '—'
        : formatDuration(_nonNegative(DateTime.now().difference(workDay.lastBreak!)));

    return BreatheCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SectionTitle(title: 'Seu dia'),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: <Widget>[
              _Stat(label: 'Online hoje', value: formatDuration(online)),
              _Stat(label: 'Pausas', value: '${workDay.breaksTaken}'),
              _Stat(label: 'Última pausa', value: sinceBreak),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          ProgressBarLabeled(
            value: barValue,
            showPercent: false,
            color: nearLimit ? AppColors.coral : AppColors.primary,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            nearLimit
                ? 'Você já está perto de 10h online. Vale pensar em encerrar.'
                : 'Tempo online hoje, até o limite saudável de 10h.',
            style: textTheme.bodyMedium?.copyWith(
              color: nearLimit ? AppColors.coral : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Duration _nonNegative(Duration d) => d.isNegative ? Duration.zero : d;
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            value,
            style: textTheme.titleLarge?.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: 2),
          Text(label, style: textTheme.bodyMedium),
        ],
      ),
    );
  }
}
