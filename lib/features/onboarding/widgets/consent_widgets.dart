import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/models.dart';

/// Interruptores de consentimento, um por tipo de dado. Usados no
/// Consentimento (onboarding, com rascunho salvo no fim) e em Privacidade e
/// dados (salvando direto no mesmo provider).
class ConsentSwitches extends StatelessWidget {
  const ConsentSwitches({
    super.key,
    required this.consent,
    required this.onChanged,
  });

  final ConsentSettings consent;
  final ValueChanged<ConsentSettings> onChanged;

  @override
  Widget build(BuildContext context) {
    return BreatheCard(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Column(
        children: <Widget>[
          _ConsentSwitch(
            title: 'Metas e finanças',
            subtitle: 'Ficam só com você; a empresa vê apenas números gerais.',
            value: consent.shareFinances,
            onChanged: (bool v) =>
                onChanged(consent.copyWith(shareFinances: v)),
          ),
          const _ConsentDivider(),
          _ConsentSwitch(
            title: 'Dados de trabalho da plataforma',
            subtitle: 'Horas, ganhos e aceitação, para apoio e prevenção.',
            value: consent.shareWorkHours,
            onChanged: (bool v) =>
                onChanged(consent.copyWith(shareWorkHours: v)),
          ),
          const _ConsentDivider(),
          _ConsentSwitch(
            title: 'Questionário de bem-estar',
            subtitle: 'Dados de saúde, com proteção reforçada.',
            value: consent.shareSurvey,
            onChanged: (bool v) => onChanged(consent.copyWith(shareSurvey: v)),
          ),
          const _ConsentDivider(),
          _ConsentSwitch(
            title: 'Uso do app',
            subtitle: 'Telas visitadas e frequência, para melhorar o app.',
            value: consent.shareUsage,
            onChanged: (bool v) => onChanged(consent.copyWith(shareUsage: v)),
          ),
        ],
      ),
    );
  }
}

/// Bloco de destaque: o que a empresa realmente vê.
class CompanySeesCard extends StatelessWidget {
  const CompanySeesCard({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return BreatheCard(
      color: AppColors.mint,
      borderColor: AppColors.mint,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const Icon(
                Icons.verified_user_outlined,
                color: AppColors.primary,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text('O que a empresa vê', style: textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Apenas números agregados e anônimos de todos os trabalhadores. '
            'A empresa nunca vê os seus dados individuais e nunca os usa para '
            'punição — só para apoio e prevenção.',
            style: textTheme.bodyMedium?.copyWith(color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}

class _ConsentSwitch extends StatelessWidget {
  const _ConsentSwitch({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return SwitchListTile.adaptive(
      value: value,
      onChanged: onChanged,
      activeThumbColor: AppColors.primary,
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      title: Text(title, style: textTheme.titleMedium),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Text(subtitle, style: textTheme.bodyMedium),
      ),
    );
  }
}

class _ConsentDivider extends StatelessWidget {
  const _ConsentDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      indent: AppSpacing.lg,
      endIndent: AppSpacing.lg,
    );
  }
}
