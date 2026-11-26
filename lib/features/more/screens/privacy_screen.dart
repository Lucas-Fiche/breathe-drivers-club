import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/utils/navigation.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/models.dart';
import '../../../data/providers/providers.dart';
import '../../onboarding/widgets/consent_widgets.dart';
import '../widgets/data_rights_section.dart';

/// Privacidade e dados (`/privacidade`): os mesmos interruptores do
/// consentimento, salvando direto no mesmo provider, e os direitos da LGPD
/// (baixar e apagar os dados, simulados).
class PrivacyScreen extends ConsumerWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ConsentSettings consent = ref.watch(profileProvider).consent;

    return BreatheScaffold(
      title: 'Privacidade e dados',
      subtitle: 'Você escolhe o que compartilha',
      onBack: () => popOrGo(context),
      scrollable: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const CompanySeesCard(),
          const SizedBox(height: AppSpacing.lg),
          Text('O que você compartilha', style: textTheme.titleMedium),
          const SizedBox(height: AppSpacing.xs),
          Text('As mudanças valem na hora.', style: textTheme.bodyMedium),
          const SizedBox(height: AppSpacing.md),
          ConsentSwitches(
            consent: consent,
            onChanged: (ConsentSettings c) =>
                ref.read(profileProvider.notifier).updateConsent(c),
          ),
          const SizedBox(height: AppSpacing.xxl),
          const DataRightsSection(),
          const SizedBox(height: AppSpacing.lg),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Icon(
                Icons.gavel_rounded,
                size: 18,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'Esses direitos são garantidos pela LGPD (Lei Geral de '
                  'Proteção de Dados, Lei 13.709/2018).',
                  style: textTheme.bodySmall,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}
