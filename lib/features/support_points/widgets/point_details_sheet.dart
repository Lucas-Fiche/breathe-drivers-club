import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/models.dart';
import '../../../data/providers/providers.dart';
import 'support_point_tile.dart';

/// Abre o bottom sheet de detalhes de um ponto de apoio.
Future<void> showPointDetailsSheet(BuildContext context, SupportPoint point) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.background,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.header)),
    ),
    builder: (BuildContext context) => _PointDetailsSheet(point: point),
  );
}

class _PointDetailsSheet extends ConsumerStatefulWidget {
  const _PointDetailsSheet({required this.point});

  final SupportPoint point;

  @override
  ConsumerState<_PointDetailsSheet> createState() => _PointDetailsSheetState();
}

class _PointDetailsSheetState extends ConsumerState<_PointDetailsSheet> {
  final TextEditingController _comment = TextEditingController();
  int _myStars = 0;

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  void _startRoute() {
    ref.read(supportProvider.notifier).startRoute(widget.point.id);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Rota iniciada até ${widget.point.name}. Dirija com calma.'),
        ),
      );
  }

  void _submitRating() {
    if (_myStars == 0) return;
    ref.read(supportProvider.notifier).rateSupportPoint(widget.point.id, _myStars);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Obrigado por avaliar! Isso ajuda outros motoristas.'),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final SupportPoint point = widget.point;

    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.xl,
        right: AppSpacing.xl,
        top: AppSpacing.xl,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.xl,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(point.name, style: textTheme.titleLarge),
            const SizedBox(height: AppSpacing.xs),
            _StarRow(rating: point.rating),
            const SizedBox(height: AppSpacing.lg),
            _InfoRow(
              icon: Icons.schedule_rounded,
              text: 'Horário: ${point.hours}',
            ),
            _InfoRow(
              icon: Icons.near_me_outlined,
              text: '${formatDistance(point.distanceMeters)} · ${point.minutes} min de você',
            ),
            _InfoRow(
              icon: Icons.place_outlined,
              text: '${point.name}, Brasília · DF (endereço fictício)',
            ),
            const SizedBox(height: AppSpacing.md),
            Text('Comodidades', style: textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.sm,
              children: <Widget>[
                for (final String a in point.amenities)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(amenityIcon(a), size: 18, color: AppColors.primary),
                      const SizedBox(width: AppSpacing.xs),
                      Text(a, style: textTheme.bodyMedium),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            PrimaryButton(
              label: 'Iniciar rota',
              icon: Icons.navigation_rounded,
              onPressed: _startRoute,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
              child: Divider(height: 1),
            ),
            Text('Avaliar este ponto', style: textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            _StarPicker(
              value: _myStars,
              onChanged: (int v) => setState(() => _myStars = v),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _comment,
              textCapitalization: TextCapitalization.sentences,
              maxLines: 2,
              decoration: const InputDecoration(
                hintText: 'Comentário (opcional)',
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            SecondaryButton(
              label: 'Enviar avaliação',
              onPressed: _myStars > 0 ? _submitRating : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _StarRow extends StatelessWidget {
  const _StarRow({required this.rating});

  final double rating;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        for (int i = 1; i <= 5; i++)
          Icon(
            i <= rating.round() ? Icons.star_rounded : Icons.star_outline_rounded,
            size: 20,
            color: AppColors.coral,
          ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          rating.toStringAsFixed(1),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class _StarPicker extends StatelessWidget {
  const _StarPicker({required this.value, required this.onChanged});

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        for (int i = 1; i <= 5; i++)
          IconButton(
            onPressed: () => onChanged(i),
            iconSize: 32,
            padding: const EdgeInsets.symmetric(horizontal: 2),
            constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
            icon: Icon(
              i <= value ? Icons.star_rounded : Icons.star_outline_rounded,
              color: AppColors.coral,
            ),
          ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: <Widget>[
          Icon(icon, size: 18, color: AppColors.textSecondary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
