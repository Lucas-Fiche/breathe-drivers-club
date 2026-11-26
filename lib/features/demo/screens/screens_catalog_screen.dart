import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../demo_actions.dart';
import '../widgets/catalog_actions.dart';

/// Catálogo de telas (`/telas`) para navegação rápida durante a apresentação.
///
/// Agrupa todas as telas e abre cada uma ao toque. Em "Estados especiais",
/// os itens já disparam o estado (alerta, lembrete, reconhecimento…).
class ScreensCatalogScreen extends StatelessWidget {
  const ScreensCatalogScreen({super.key});

  static const List<_CatalogGroup> _groups = <_CatalogGroup>[
    _CatalogGroup(
      title: 'Onboarding',
      entries: <_CatalogEntry>[
        _CatalogEntry('Acesso', 'Entrada pelo número da empresa', '/acesso'),
        _CatalogEntry(
          'Consentimento',
          'Escolha do que é compartilhado',
          '/consentimento',
        ),
        _CatalogEntry(
          'Perfil inicial',
          'Primeiros dados do motorista',
          '/perfil-inicial',
        ),
      ],
    ),
    _CatalogGroup(
      title: 'Abas principais',
      entries: <_CatalogEntry>[
        _CatalogEntry('Início', 'Meta do dia, humor e pausa', '/inicio'),
        _CatalogEntry('Meu plano', 'Metas de vida e meta diária', '/plano'),
        _CatalogEntry('Finanças', 'Ganhos, gastos e cofrinho', '/financas'),
        _CatalogEntry('Pontos de apoio', 'Descanso e eventos perto', '/apoio'),
        _CatalogEntry('Benefícios', 'Parcerias e pontos', '/beneficios'),
      ],
    ),
    _CatalogGroup(
      title: 'Outras telas',
      entries: <_CatalogEntry>[
        _CatalogEntry('Assistente', 'Ajuda roteirizada', '/assistente'),
        _CatalogEntry('Comunidade', 'Troca entre trabalhadores', '/comunidade'),
        _CatalogEntry('Questionário', 'Pesquisa semestral', '/questionario'),
        _CatalogEntry(
          'Pausa guiada',
          'Um minuto para respirar',
          '/inicio/pausa',
        ),
        _CatalogEntry('Ajuda', 'Acolhimento e canais', '/ajuda'),
        _CatalogEntry('Mais', 'Menu de recursos extras', '/mais'),
        _CatalogEntry(
          'Privacidade e dados',
          'O que a empresa vê',
          '/privacidade',
        ),
      ],
    ),
    _CatalogGroup(
      title: 'Estados especiais',
      entries: <_CatalogEntry>[
        _CatalogEntry.action(
          'Alerta de jornada longa',
          'Simula 10h online e abre o Início',
          catalogLongJourney,
          icon: Icons.schedule_rounded,
        ),
        _CatalogEntry.action(
          'Lembrete de pausa',
          'Banner no topo da tela',
          catalogBreakReminder,
          icon: Icons.notifications_active_outlined,
        ),
        _CatalogEntry.action(
          'Reconhecimento',
          '+$kDemoRecognitionPoints pontos por cuidar de si',
          catalogRecognition,
          icon: Icons.stars_rounded,
        ),
        _CatalogEntry.action(
          'Questionário já respondido',
          'Responde e abre o questionário',
          catalogSurveyDone,
          icon: Icons.task_alt_rounded,
        ),
        _CatalogEntry.action(
          'Trocar persona',
          'Alterna entre Carlos e Joana',
          catalogPersona,
          icon: Icons.switch_account_outlined,
        ),
        _CatalogEntry(
          'Devolutiva do questionário',
          'Exemplo, se ainda não respondeu',
          '/questionario/resultado',
        ),
        _CatalogEntry(
          'Atendimento psicológico',
          'Simulação de conexão',
          '/ajuda/psicologo',
        ),
        _CatalogEntry.action(
          'Modo apresentação',
          'Mesmo menu do gesto escondido',
          catalogDemoSheet,
          icon: Icons.slideshow_rounded,
        ),
        _CatalogEntry.action(
          'Resetar dados',
          'Volta tudo ao início, com Carlos',
          catalogReset,
          icon: Icons.restart_alt_rounded,
        ),
        _CatalogEntry(
          'Componentes',
          'Catálogo do Design System',
          '/componentes',
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BreatheScaffold(
      title: 'Todas as telas',
      subtitle: 'Catálogo para apresentação',
      scrollable: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          for (final _CatalogGroup group in _groups) ...<Widget>[
            Padding(
              padding: const EdgeInsets.only(
                top: AppSpacing.lg,
                bottom: AppSpacing.md,
              ),
              child: Text(
                group.title.toUpperCase(),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            for (final _CatalogEntry entry in group.entries) ...<Widget>[
              _CatalogTile(entry: entry),
              const SizedBox(height: AppSpacing.sm),
            ],
          ],
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}

class _CatalogTile extends ConsumerWidget {
  const _CatalogTile({required this.entry});

  final _CatalogEntry entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return BreatheCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      onTap: () {
        final _CatalogAction? action = entry.action;
        if (action != null) {
          action(context, ref);
        } else {
          context.go(entry.route!);
        }
      },
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(entry.name, style: textTheme.titleMedium),
                const SizedBox(height: 2),
                Text(entry.description, style: textTheme.bodyMedium),
              ],
            ),
          ),
          Icon(
            entry.icon ?? Icons.chevron_right_rounded,
            color: entry.action != null
                ? AppColors.primary
                : AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}

class _CatalogGroup {
  const _CatalogGroup({required this.title, required this.entries});

  final String title;
  final List<_CatalogEntry> entries;
}

/// Ação de um item do catálogo (dispara um estado especial).
typedef _CatalogAction = void Function(BuildContext context, WidgetRef ref);

/// Item do catálogo: abre uma [route] ou executa uma [action].
class _CatalogEntry {
  const _CatalogEntry(this.name, this.description, String this.route)
    : action = null,
      icon = null;

  const _CatalogEntry.action(
    this.name,
    this.description,
    _CatalogAction this.action, {
    this.icon,
  }) : route = null;

  final String name;
  final String description;
  final String? route;
  final _CatalogAction? action;

  /// Ícone à direita (ações); rotas usam a seta.
  final IconData? icon;
}
