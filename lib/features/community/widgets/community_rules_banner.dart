import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';

/// Regras de convivência da comunidade.
const List<(IconData, String)> _rules = <(IconData, String)>[
  (Icons.favorite_border_rounded, 'Respeito com todo mundo, sempre.'),
  (
    Icons.lock_outline_rounded,
    'Não publique dados pessoais seus ou de outros.',
  ),
  (Icons.block_rounded, 'Sem discurso de ódio, preconceito ou ofensa.'),
  (Icons.verified_user_outlined, 'O conteúdo é moderado pela equipe do clube.'),
];

/// Banner recolhível "Regras de convivência" (mint). Começa aberto; um toque
/// no título recolhe ou expande.
class CommunityRulesBanner extends StatefulWidget {
  const CommunityRulesBanner({super.key});

  @override
  State<CommunityRulesBanner> createState() => _CommunityRulesBannerState();
}

class _CommunityRulesBannerState extends State<CommunityRulesBanner> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return BreatheCard(
      color: AppColors.mint,
      borderColor: AppColors.mint,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(AppRadius.card),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 48),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                child: Row(
                  children: <Widget>[
                    const Icon(
                      Icons.handshake_outlined,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        'Regras de convivência',
                        style: textTheme.titleMedium,
                      ),
                    ),
                    Icon(
                      _expanded
                          ? Icons.expand_less_rounded
                          : Icons.expand_more_rounded,
                      color: AppColors.primary,
                      semanticLabel: _expanded ? 'Recolher' : 'Expandir',
                    ),
                  ],
                ),
              ),
            ),
          ),
          // AnimatedSize (e não CrossFade) para que, recolhido, o texto saia
          // da árvore e o leitor de tela não leia regras escondidas.
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            alignment: Alignment.topCenter,
            child: _expanded
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      0,
                      AppSpacing.lg,
                      AppSpacing.lg,
                    ),
                    child: Column(
                      children: <Widget>[
                        for (final (IconData icon, String text) in _rules)
                          Padding(
                            padding: const EdgeInsets.only(top: AppSpacing.sm),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Icon(icon, size: 18, color: AppColors.primary),
                                const SizedBox(width: AppSpacing.sm),
                                Expanded(
                                  child: Text(
                                    text,
                                    style: textTheme.bodyMedium?.copyWith(
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  )
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }
}
