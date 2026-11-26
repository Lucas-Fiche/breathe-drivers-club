import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/models.dart';
import '../../../data/providers/providers.dart';
import '../widgets/consent_widgets.dart';

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
          const CompanySeesCard(),
          const SizedBox(height: AppSpacing.lg),
          Text('O que você compartilha', style: textTheme.titleMedium),
          const SizedBox(height: AppSpacing.md),
          ConsentSwitches(
            consent: _draft,
            onChanged: (ConsentSettings c) => setState(() => _draft = c),
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
