import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/models.dart';
import '../../../data/providers/providers.dart';

/// Card do perfil: iniciais, nome, tipo, cidade, pontos e selo de destaque
/// (só quando conquistado).
class ProfileCard extends ConsumerWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final UserProfile profile = ref.watch(profileProvider).profile;
    final bool highlight = ref.watch(highlightProvider).achieved;

    return BreatheCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 60,
                height: 60,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.mint,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  initialsOf(profile.name),
                  style: textTheme.titleLarge?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(profile.name, style: textTheme.titleMedium),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '${profile.type.label} · ${profile.vehicle} · '
                      '${profile.city}',
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: <Widget>[
              AnimatedNumber(
                value: profile.points,
                style: textTheme.headlineMedium,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text('pontos', style: textTheme.bodyLarge),
              const Spacer(),
              if (highlight)
                const TagBadge(
                  label: 'Destaque do mês',
                  icon: Icons.workspace_premium_rounded,
                  background: AppColors.coralSoft,
                  foreground: AppColors.primaryDark,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
