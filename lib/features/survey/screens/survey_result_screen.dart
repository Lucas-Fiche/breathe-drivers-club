import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/utils/navigation.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/models.dart';
import '../../../data/providers/providers.dart';
import '../survey_feedback.dart';
import '../survey_items.dart';
import '../widgets/dimension_result_card.dart';

/// Pontuações usadas quando a tela é aberta direto pela URL sem o
/// questionário ter sido respondido (apresentações).
const Map<SurveyDimension, double> _exampleScores = <SurveyDimension, double>{
  SurveyDimension.bemEstar: 0.6,
  SurveyDimension.fadiga: 0.75,
  SurveyDimension.sono: 0.45,
  SurveyDimension.suporte: 0.3,
};

/// Devolutiva ao trabalhador (`/questionario/resultado`): resumo por
/// dimensão, frases acolhedoras, sugestões ligadas ao app e pontos ganhos.
/// Sem diagnóstico e sem rótulos clínicos.
class SurveyResultScreen extends ConsumerWidget {
  const SurveyResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final SurveyState survey = ref.watch(surveyProvider);
    final bool isExample = !survey.submitted;

    final Map<SurveyDimension, double> scores = isExample
        ? _exampleScores
        : <SurveyDimension, double>{
            for (final SurveyDimension d in SurveyDimension.values)
              if (survey.scoreFor(d) != null) d: survey.scoreFor(d)!,
          };
    final List<SurveySuggestion> suggestions = suggestionsFor(scores);

    return BreatheScaffold(
      title: 'Sua devolutiva',
      subtitle: 'Como você respondeu agora',
      onBack: () => popOrGo(context),
      scrollable: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (isExample)
            _ExampleBanner(onAnswer: () => context.go('/questionario'))
          else
            _PointsCard(total: ref.watch(profileProvider).profile.points),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Isto não é um diagnóstico. É um retrato de como você se sente '
            'hoje, para ajudar você a se cuidar.',
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.lg),
          for (final MapEntry<SurveyDimension, double> e
              in scores.entries) ...<Widget>[
            DimensionResultCard(info: kDimensionInfo[e.key]!, score: e.value),
            const SizedBox(height: AppSpacing.md),
          ],
          const SizedBox(height: AppSpacing.md),
          const SectionTitle(title: 'Sugestões para você'),
          const SizedBox(height: AppSpacing.md),
          for (final SurveySuggestion s in suggestions) ...<Widget>[
            SuggestionTile(suggestion: s, onTap: () => _open(context, s.route)),
            const SizedBox(height: AppSpacing.sm),
          ],
          const SizedBox(height: AppSpacing.lg),
          Row(
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
                  'Só você vê esta devolutiva. A empresa vê apenas médias de '
                  'todos, sem nomes. Próximo questionário: $kNextSurveyLabel.',
                  style: textTheme.bodyMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          PrimaryButton(
            label: 'Voltar ao início',
            onPressed: () => context.go('/inicio'),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }

  /// Abas usam `go` (troca de aba); as demais telas abrem por cima.
  void _open(BuildContext context, String route) {
    const List<String> tabs = <String>[
      '/inicio',
      '/plano',
      '/financas',
      '/apoio',
      '/beneficios',
    ];
    if (tabs.contains(route)) {
      context.go(route);
    } else {
      context.push(route);
    }
  }
}

/// "+50 pontos" somados, com o novo saldo.
class _PointsCard extends StatelessWidget {
  const _PointsCard({required this.total});

  final int total;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return BreatheCard(
      color: AppColors.coralSoft,
      borderColor: AppColors.coralSoft,
      child: Row(
        children: <Widget>[
          const Icon(Icons.stars_rounded, color: AppColors.coral, size: 40),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AnimatedNumber(
                  value: PointRewards.perSurvey,
                  format: (num v) => '+${v.round()} pontos',
                  style: textTheme.headlineMedium,
                  animateOnStart: true,
                ),
                Text(
                  'Obrigado por responder! Agora você tem $total pontos.',
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Aviso de devolutiva de exemplo (tela aberta sem ter respondido).
class _ExampleBanner extends StatelessWidget {
  const _ExampleBanner({required this.onAnswer});

  final VoidCallback onAnswer;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return BreatheCard(
      color: AppColors.mint,
      borderColor: AppColors.mint,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text('Exemplo de devolutiva', style: textTheme.titleMedium),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Você ainda não respondeu. Veja como fica, ou responda para ver a '
            'sua.',
            style: textTheme.bodyMedium?.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: AppSpacing.md),
          SecondaryButton(label: 'Responder agora', onPressed: onAnswer),
        ],
      ),
    );
  }
}
