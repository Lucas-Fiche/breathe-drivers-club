import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';

/// Catálogo de telas (`/telas`) para navegação rápida durante a apresentação.
///
/// Agrupa todas as telas e abre cada uma ao toque.
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
        _CatalogEntry('Pausa guiada', 'Um minuto para respirar', '/inicio/pausa'),
        _CatalogEntry('Ajuda', 'Acolhimento e canais', '/ajuda'),
        _CatalogEntry('Mais', 'Menu de recursos extras', '/mais'),
        _CatalogEntry('Privacidade e dados', 'O que a empresa vê', '/privacidade'),
      ],
    ),
    _CatalogGroup(
      title: 'Estados especiais',
      entries: <_CatalogEntry>[
        _CatalogEntry(
          'Resultado do questionário',
          'Devolutiva da pesquisa',
          '/questionario/resultado',
        ),
        _CatalogEntry(
          'Atendimento psicológico',
          'Simulação de conexão',
          '/ajuda/psicologo',
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

class _CatalogTile extends StatelessWidget {
  const _CatalogTile({required this.entry});

  final _CatalogEntry entry;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return BreatheCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      onTap: () => context.go(entry.route),
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
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textSecondary,
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

class _CatalogEntry {
  const _CatalogEntry(this.name, this.description, this.route);

  final String name;
  final String description;
  final String route;
}
