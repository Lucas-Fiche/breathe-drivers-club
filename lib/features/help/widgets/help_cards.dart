import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';

/// Ícone redondo suave (mint) usado no topo dos cards da Ajuda.
class HelpIconBadge extends StatelessWidget {
  const HelpIconBadge({super.key, required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: const BoxDecoration(
        color: AppColors.mint,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: AppColors.primary),
    );
  }
}

/// Card principal: falar com um psicólogo agora.
class TalkNowCard extends StatelessWidget {
  const TalkNowCard({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return BreatheCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const HelpIconBadge(icon: Icons.support_agent_rounded),
          const SizedBox(height: AppSpacing.md),
          Text('Falar com um psicólogo agora', style: textTheme.titleMedium),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Atendimento gratuito, oferecido pela plataforma. Você fala com '
            'um profissional por chat ou ligação.',
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.lg),
          PrimaryButton(
            label: 'Falar agora',
            icon: Icons.chat_rounded,
            onPressed: () => context.push('/ajuda/psicologo'),
          ),
        ],
      ),
    );
  }
}

/// Atalho para a pausa guiada.
class QuickExerciseCard extends StatelessWidget {
  const QuickExerciseCard({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return BreatheCard(
      color: AppColors.mint,
      borderColor: AppColors.mint,
      onTap: () => context.push('/inicio/pausa'),
      child: Row(
        children: <Widget>[
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.air_rounded, color: AppColors.primary),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Exercício rápido', style: textTheme.titleMedium),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '1 minuto de respiração guiada para acalmar.',
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.primary),
        ],
      ),
    );
  }
}

/// Nota de privacidade no fim da tela.
class HelpPrivacyNote extends StatelessWidget {
  const HelpPrivacyNote({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Icon(
          Icons.lock_outline_rounded,
          size: 20,
          color: AppColors.primary,
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            'Seu pedido de ajuda é sigiloso. A empresa não sabe quem pediu.',
            style: textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
