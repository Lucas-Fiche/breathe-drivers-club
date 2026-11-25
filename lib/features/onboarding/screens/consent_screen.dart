import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/models.dart';
import '../../../data/providers/providers.dart';

/// Tela de consentimento (`/consentimento`).
///
/// Deixa claro, para a LGPD, o que a empresa vê (apenas dados agregados e
/// anônimos, nunca individuais e nunca para punição) e permite ligar/desligar
/// cada tipo de dado.
class ConsentScreen extends ConsumerStatefulWidget {
  const ConsentScreen({super.key});

  @override
  ConsumerState<ConsentScreen> createState() => _ConsentScreenState();
}

class _ConsentScreenState extends ConsumerState<ConsentScreen> {
  late ConsentSettings _draft;

  @override
  void initState() {
    super.initState();
    _draft = ref.read(profileProvider).consent;
  }

  void _save() {
    ref.read(profileProvider.notifier).updateConsent(_draft);
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/inicio');
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return BreatheScaffold(
      title: 'Privacidade e consentimento',
      subtitle: 'Você escolhe o que compartilha',
      scrollable: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const _CompanySeesCard(),
          const SizedBox(height: AppSpacing.lg),
          Text('O que você compartilha', style: textTheme.titleMedium),
          const SizedBox(height: AppSpacing.md),
          BreatheCard(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
            child: Column(
              children: <Widget>[
                _ConsentSwitch(
                  title: 'Metas e finanças',
                  subtitle: 'Ficam só com você; a empresa vê apenas números gerais.',
                  value: _draft.shareFinances,
                  onChanged: (bool v) =>
                      setState(() => _draft = _draft.copyWith(shareFinances: v)),
                ),
                const _ConsentDivider(),
                _ConsentSwitch(
                  title: 'Dados de trabalho da plataforma',
                  subtitle: 'Horas, ganhos e aceitação, para apoio e prevenção.',
                  value: _draft.shareWorkHours,
                  onChanged: (bool v) =>
                      setState(() => _draft = _draft.copyWith(shareWorkHours: v)),
                ),
                const _ConsentDivider(),
                _ConsentSwitch(
                  title: 'Questionário de bem-estar',
                  subtitle: 'Dados de saúde, com proteção reforçada.',
                  value: _draft.shareSurvey,
                  onChanged: (bool v) =>
                      setState(() => _draft = _draft.copyWith(shareSurvey: v)),
                ),
                const _ConsentDivider(),
                _ConsentSwitch(
                  title: 'Uso do app',
                  subtitle: 'Telas visitadas e frequência, para melhorar o app.',
                  value: _draft.shareUsage,
                  onChanged: (bool v) =>
                      setState(() => _draft = _draft.copyWith(shareUsage: v)),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Icon(Icons.info_outline_rounded,
                  size: 18, color: AppColors.textSecondary),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'Você pode mudar isso quando quiser em Mais > Privacidade.',
                  style: textTheme.bodyMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          PrimaryButton(label: 'Salvar minhas escolhas', onPressed: _save),
          const SizedBox(height: AppSpacing.sm),
        ],
      ),
    );
  }
}

/// Bloco de destaque: o que a empresa realmente vê.
class _CompanySeesCard extends StatelessWidget {
  const _CompanySeesCard();

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
              const Icon(Icons.verified_user_outlined, color: AppColors.primary),
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
    return const Divider(height: 1, indent: AppSpacing.lg, endIndent: AppSpacing.lg);
  }
}
