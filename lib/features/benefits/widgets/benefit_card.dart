import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/models.dart';
import '../../../data/providers/providers.dart';

/// Card de um parceiro: nome, categoria, descrição, custo em pontos e a ação de
/// resgatar (com confirmação e cupom).
class BenefitCard extends ConsumerWidget {
  const BenefitCard({super.key, required this.benefit});

  final Benefit benefit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final int points = ref.watch(profileProvider).profile.points;
    final bool redeemed =
        ref.watch(benefitsProvider).isRedeemed(benefit.id);
    final bool canAfford = points >= benefit.pointsCost;
    final int missing = benefit.pointsCost - points;

    return BreatheCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Text(benefit.partnerName, style: textTheme.titleMedium),
              ),
              const SizedBox(width: AppSpacing.sm),
              TagBadge(label: benefit.category.label),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '${benefit.discount} · ${benefit.description}',
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.lg),
          if (redeemed)
            _Coupon(benefit: benefit)
          else
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    '${benefit.pointsCost} pontos',
                    style: textTheme.titleMedium
                        ?.copyWith(color: AppColors.primary),
                  ),
                ),
                if (canAfford)
                  SecondaryButton(
                    label: 'Resgatar',
                    expand: false,
                    onPressed: () => _confirm(context, ref),
                  )
                else
                  SecondaryButton(
                    label: 'Faltam $missing pontos',
                    expand: false,
                    onPressed: null,
                  ),
              ],
            ),
        ],
      ),
    );
  }

  Future<void> _confirm(BuildContext context, WidgetRef ref) async {
    final int points = ref.read(profileProvider).profile.points;
    final bool? ok = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Resgatar benefício'),
        content: Text(
          '${benefit.partnerName} por ${benefit.pointsCost} pontos.\n'
          'Você ficará com ${points - benefit.pointsCost} pontos.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Resgatar'),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;

    final RedeemResult result =
        ref.read(benefitsProvider.notifier).redeem(benefit.id);
    if (result == RedeemResult.success && context.mounted) {
      await _showCoupon(context);
    }
  }

  Future<void> _showCoupon(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Benefício resgatado! 🎉'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('${benefit.discount} · ${benefit.partnerName}'),
            const SizedBox(height: AppSpacing.md),
            _CouponCode(code: _couponCode(benefit)),
            const SizedBox(height: AppSpacing.md),
            const Text('Apresente este código no parceiro.'),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Entendi'),
          ),
        ],
      ),
    );
  }
}

/// Cupom exibido no card depois de resgatado.
class _Coupon extends StatelessWidget {
  const _Coupon({required this.benefit});

  final Benefit benefit;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Row(
      children: <Widget>[
        const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 20),
        const SizedBox(width: AppSpacing.sm),
        Text('Resgatado', style: textTheme.bodyLarge),
        const Spacer(),
        _CouponCode(code: _couponCode(benefit)),
      ],
    );
  }
}

class _CouponCode extends StatelessWidget {
  const _CouponCode({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.mint,
        borderRadius: BorderRadius.circular(AppRadius.button),
        border: Border.all(color: AppColors.primary, width: 1.2),
      ),
      child: Text(
        code,
        style: textTheme.titleMedium?.copyWith(
          color: AppColors.primary,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}

/// Código de cupom fictício, estável por benefício.
String _couponCode(Benefit benefit) {
  final int n = benefit.id.hashCode.abs() % 900000 + 100000;
  return 'BDC-$n';
}
