import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/models.dart';

/// Ícone para uma comodidade do ponto de apoio.
IconData amenityIcon(String amenity) {
  switch (amenity.toLowerCase()) {
    case 'banheiro':
      return Icons.wc_rounded;
    case 'água':
    case 'agua':
      return Icons.water_drop_outlined;
    case 'descanso':
      return Icons.weekend_outlined;
    case 'recarga':
      return Icons.bolt_rounded;
    case 'café':
    case 'cafe':
      return Icons.local_cafe_outlined;
    case 'estacionamento':
      return Icons.local_parking_outlined;
    default:
      return Icons.check_circle_outline_rounded;
  }
}

/// Item da lista de pontos de apoio. Selecionado: fundo mint, borda primary,
/// "Rota ativa no mapa" e "Toque para iniciar".
class SupportPointTile extends StatelessWidget {
  const SupportPointTile({
    super.key,
    required this.point,
    required this.selected,
    required this.onTap,
  });

  final SupportPoint point;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final BorderRadius radius = BorderRadius.circular(AppRadius.card);

    return Material(
      color: selected ? AppColors.mint : AppColors.surface,
      borderRadius: radius,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Ink(
          decoration: BoxDecoration(
            color: selected ? AppColors.mint : AppColors.surface,
            borderRadius: radius,
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.border,
              width: selected ? 1.4 : 1,
            ),
          ),
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Text(point.name, style: textTheme.titleMedium),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    '${formatDistance(point.distanceMeters)} · ${point.minutes} min',
                    style: textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.md,
                runSpacing: AppSpacing.xs,
                children: <Widget>[
                  for (final String a in point.amenities)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(amenityIcon(a), size: 15, color: AppColors.textSecondary),
                        const SizedBox(width: AppSpacing.xs),
                        Text(a, style: textTheme.bodySmall),
                      ],
                    ),
                ],
              ),
              if (selected) ...<Widget>[
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: <Widget>[
                    const Icon(Icons.navigation_rounded,
                        size: 16, color: AppColors.primary),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      'Rota ativa no mapa',
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Toque para iniciar',
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
