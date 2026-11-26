import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/models.dart';
import '../../../data/providers/providers.dart';

const List<String> _monthsShort = <String>[
  'JAN', 'FEV', 'MAR', 'ABR', 'MAI', 'JUN',
  'JUL', 'AGO', 'SET', 'OUT', 'NOV', 'DEZ',
];

/// Item da lista de eventos: data em destaque, título, local e "Tenho
/// interesse".
class EventTile extends ConsumerWidget {
  const EventTile({
    super.key,
    required this.event,
    required this.selected,
    required this.onTap,
  });

  final Event event;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final bool interested = ref.watch(supportProvider).isInterested(event.id);

    return BreatheCard(
      color: selected ? AppColors.mint : AppColors.surface,
      borderColor: selected ? AppColors.primary : AppColors.border,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _DateBox(date: event.date),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(event.title, style: textTheme.titleMedium),
                    const SizedBox(height: AppSpacing.xxs),
                    Row(
                      children: <Widget>[
                        const Icon(Icons.place_outlined,
                            size: 15, color: AppColors.textSecondary),
                        const SizedBox(width: AppSpacing.xs),
                        Expanded(
                          child: Text(event.location, style: textTheme.bodyMedium),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(event.description, style: textTheme.bodyMedium),
          const SizedBox(height: AppSpacing.md),
          _InterestButton(
            interested: interested,
            onPressed: () =>
                ref.read(supportProvider.notifier).toggleEventInterest(event.id),
          ),
        ],
      ),
    );
  }
}

class _DateBox extends StatelessWidget {
  const _DateBox({required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      width: 54,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.coralSoft,
        borderRadius: BorderRadius.circular(AppRadius.button),
      ),
      child: Column(
        children: <Widget>[
          Text(
            '${date.day}',
            style: textTheme.titleLarge?.copyWith(color: AppColors.primaryDark),
          ),
          Text(
            _monthsShort[date.month - 1],
            style: textTheme.labelMedium?.copyWith(
              color: AppColors.primaryDark,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _InterestButton extends StatelessWidget {
  const _InterestButton({required this.interested, required this.onPressed});

  final bool interested;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    if (interested) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Material(
          color: AppColors.mint,
          borderRadius: BorderRadius.circular(AppRadius.button),
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(AppRadius.button),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Icon(Icons.check_circle_rounded,
                      size: 18, color: AppColors.primary),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'Tenho interesse · +${PointRewards.perEventInterest}',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppColors.primary,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return SecondaryButton(
      label: 'Tenho interesse',
      icon: Icons.star_outline_rounded,
      expand: false,
      onPressed: onPressed,
    );
  }
}
