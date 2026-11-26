import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import 'breathe_logo.dart';

/// Cabeçalho padrão de tela.
///
/// Fundo [AppColors.primaryDark], cantos inferiores arredondados. Três linhas:
/// 1) logo do volante + "BREATHE DRIVERS CLUB" (caixa alta, espaçado);
/// 2) [title] da tela; 3) [subtitle] curto (opcional).
///
/// À direita da marca ficam a [action] opcional (ex.: avatar do "Mais") e o
/// ícone de Ajuda/acolhimento (coral), presente em todas as telas via
/// [onHelp] — oculto apenas quando [showHelp] for falso (ex.: tela de acesso).
class BreatheHeader extends StatelessWidget {
  const BreatheHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.action,
    this.onHelp,
    this.showHelp = true,
    this.onBack,
  });

  /// Se informado, mostra um botão de voltar à esquerda da marca.
  final VoidCallback? onBack;

  final String title;
  final String? subtitle;

  /// Ação opcional à direita da marca (ex.: avatar que leva a `/mais`).
  final Widget? action;

  /// Callback do ícone de Ajuda. Se nulo e [showHelp] for verdadeiro, o ícone
  /// aparece desabilitado (útil em telas ainda sem rota configurada).
  final VoidCallback? onHelp;

  final bool showHelp;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(AppRadius.header),
        ),
      ),
      padding: EdgeInsets.only(
        left: AppSpacing.xl,
        right: AppSpacing.xl,
        top: MediaQuery.of(context).padding.top + AppSpacing.lg,
        bottom: AppSpacing.xl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              if (onBack != null) ...<Widget>[
                _BackButton(onBack: onBack!),
                const SizedBox(width: AppSpacing.xs),
              ],
              const BreatheLogo(size: 26),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'BREATHE DRIVERS CLUB',
                  style: textTheme.titleSmall?.copyWith(color: Colors.white),
                ),
              ),
              if (action != null) ...<Widget>[
                action!,
                if (showHelp) const SizedBox(width: AppSpacing.sm),
              ],
              if (showHelp)
                _HelpButton(onHelp: onHelp),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            title,
            style: textTheme.titleLarge?.copyWith(color: Colors.white),
          ),
          if (subtitle != null) ...<Widget>[
            const SizedBox(height: AppSpacing.xs),
            Text(
              subtitle!,
              style: textTheme.bodyMedium?.copyWith(color: AppColors.mintTrack),
            ),
          ],
        ],
      ),
    );
  }
}

/// Botão de voltar, à esquerda da marca.
class _BackButton extends StatelessWidget {
  const _BackButton({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onBack,
      iconSize: 24,
      constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
      tooltip: 'Voltar',
      padding: EdgeInsets.zero,
      icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
    );
  }
}

/// Ícone de Ajuda/acolhimento (coração coral), toque ≥ 48 px.
class _HelpButton extends StatelessWidget {
  const _HelpButton({this.onHelp});

  final VoidCallback? onHelp;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onHelp,
      iconSize: 24,
      constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
      tooltip: 'Ajuda e acolhimento',
      style: IconButton.styleFrom(
        backgroundColor: Colors.white.withValues(alpha: 0.10),
        shape: const CircleBorder(),
      ),
      icon: const Icon(
        Icons.favorite_rounded,
        color: AppColors.coral,
      ),
    );
  }
}
