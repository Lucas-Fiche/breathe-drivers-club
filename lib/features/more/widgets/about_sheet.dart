import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';

/// Abre "Sobre o Breathe": a proposta do app em poucas linhas.
Future<void> showAboutBreatheSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.background,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppRadius.header),
      ),
    ),
    builder: (BuildContext context) => const _AboutSheet(),
  );
}

const List<(IconData, String, String)> _points = <(IconData, String, String)>[
  (
    Icons.handshake_outlined,
    'Oferecido pela plataforma',
    'A empresa para quem você trabalha oferece o app para apoiar o seu dia.',
  ),
  (
    Icons.money_off_rounded,
    'Gratuito para você',
    'Não há mensalidade nem cobrança escondida.',
  ),
  (
    Icons.verified_user_outlined,
    'Dados para apoio, nunca para punição',
    'A empresa vê só números gerais e anônimos, para prevenir cansaço e '
        'acidentes. Nada aqui afeta suas corridas ou sua avaliação.',
  ),
  (
    Icons.spa_outlined,
    'Pausa é positiva',
    'Os pontos vêm de pausas, metas e do questionário, nunca de fazer mais '
        'corridas.',
  ),
];

class _AboutSheet extends StatelessWidget {
  const _AboutSheet();

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                const BreatheLogo(size: 40),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text('Sobre o Breathe', style: textTheme.titleLarge),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Um app de bem-estar, planejamento de vida e apoio para '
              'motoristas e entregadores.',
              style: textTheme.bodyLarge,
            ),
            const SizedBox(height: AppSpacing.lg),
            for (final (IconData icon, String title, String text)
                in _points) ...<Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Icon(icon, color: AppColors.primary),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(title, style: textTheme.labelLarge),
                        const SizedBox(height: AppSpacing.xs),
                        Text(text, style: textTheme.bodyMedium),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
            Text(
              'Protótipo acadêmico · dados fictícios',
              textAlign: TextAlign.center,
              style: textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
