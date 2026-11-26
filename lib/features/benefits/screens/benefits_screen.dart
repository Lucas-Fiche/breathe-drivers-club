import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/models.dart';
import '../../../data/providers/providers.dart';
import '../widgets/benefit_card.dart';
import '../widgets/highlight_driver_card.dart';
import '../widgets/points_card.dart';
import '../widgets/study_programs_section.dart';

/// Tela Benefícios (`/beneficios`): pontos, filtros, parceiros, programas de
/// estudo e motorista destaque. Aceita o filtro inicial pela rota
/// (`?filtro=estudos`).
class BenefitsScreen extends ConsumerStatefulWidget {
  const BenefitsScreen({super.key, this.initialFilter});

  final String? initialFilter;

  @override
  ConsumerState<BenefitsScreen> createState() => _BenefitsScreenState();
}

class _BenefitsScreenState extends ConsumerState<BenefitsScreen> {
  /// Índice 0 = Todos; demais seguem [_categories].
  static const List<BenefitCategory> _categories = <BenefitCategory>[
    BenefitCategory.trabalho,
    BenefitCategory.saude,
    BenefitCategory.estudos,
    BenefitCategory.financas,
  ];

  late int _filterIndex;

  @override
  void initState() {
    super.initState();
    final BenefitCategory? fromRoute =
        BenefitCategoryX.fromSlug(widget.initialFilter);
    _filterIndex =
        fromRoute == null ? 0 : _categories.indexOf(fromRoute) + 1;
  }

  BenefitCategory? get _selectedCategory =>
      _filterIndex == 0 ? null : _categories[_filterIndex - 1];

  bool get _showStudyPrograms =>
      _filterIndex == 0 || _selectedCategory == BenefitCategory.estudos;

  @override
  Widget build(BuildContext context) {
    final List<Benefit> benefits = ref.watch(benefitsProvider).benefits;
    final List<Benefit> filtered = _selectedCategory == null
        ? benefits
        : benefits
            .where((Benefit b) => b.category == _selectedCategory)
            .toList();

    return BreatheScaffold(
      title: 'Benefícios e parcerias',
      subtitle: 'Vantagens para você e para o seu trabalho',
      scrollable: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const PointsCard(),
          const SizedBox(height: AppSpacing.lg),
          ChipGroup(
            options: const <String>[
              'Todos',
              'Trabalho',
              'Saúde',
              'Estudos',
              'Finanças',
            ],
            selectedIndex: _filterIndex,
            onSelected: (int i) => setState(() => _filterIndex = i),
          ),
          const SizedBox(height: AppSpacing.lg),
          for (final Benefit b in filtered) ...<Widget>[
            BenefitCard(benefit: b),
            const SizedBox(height: AppSpacing.md),
          ],
          if (_showStudyPrograms) ...<Widget>[
            const SizedBox(height: AppSpacing.sm),
            const StudyProgramsSection(),
          ],
          const SizedBox(height: AppSpacing.sm),
          const HighlightDriverCard(),
          const SizedBox(height: AppSpacing.sm),
        ],
      ),
    );
  }
}
