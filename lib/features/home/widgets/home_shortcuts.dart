import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';

/// Atalhos do Início: Comunidade, Questionário (com selo "novo") e Pontos de
/// apoio. Os três cards têm sempre a mesma altura (a do maior rótulo).
class HomeShortcuts extends StatelessWidget {
  const HomeShortcuts({super.key});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: _Shortcut(
              icon: Icons.groups_outlined,
              label: 'Comunidade',
              onTap: () => context.push('/comunidade'),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: _Shortcut(
              icon: Icons.assignment_outlined,
              label: 'Questionário',
              badge: 'novo',
              onTap: () => context.push('/questionario'),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: _Shortcut(
              icon: Icons.place_outlined,
              label: 'Pontos de apoio',
              onTap: () => context.go('/apoio'),
            ),
          ),
        ],
      ),
    );
  }
}

class _Shortcut extends StatelessWidget {
  const _Shortcut({
    required this.icon,
    required this.label,
    required this.onTap,
    this.badge,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return BreatheCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.lg,
      ),
      onTap: onTap,
      child: Column(
        children: <Widget>[
          Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              Icon(icon, color: AppColors.primary, size: 28),
              if (badge != null)
                Positioned(
                  top: -8,
                  right: -14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 1,
                    ),
                    decoration: const ShapeDecoration(
                      color: AppColors.coral,
                      shape: StadiumBorder(),
                    ),
                    child: Text(
                      badge!,
                      // Texto escuro sobre coral: contraste 6,7:1.
                      style: textTheme.labelSmall?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: textTheme.bodyMedium?.copyWith(color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}
