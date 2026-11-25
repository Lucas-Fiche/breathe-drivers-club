import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/widgets.dart';

/// Tela temporária (`/componentes`) que exibe todos os componentes base do
/// Design System para conferência visual. Será acessível só por URL depois da
/// Fase 2.
class ComponentsGalleryScreen extends StatefulWidget {
  const ComponentsGalleryScreen({super.key});

  @override
  State<ComponentsGalleryScreen> createState() =>
      _ComponentsGalleryScreenState();
}

class _ComponentsGalleryScreenState extends State<ComponentsGalleryScreen> {
  int _mood = 0;
  int _ridesGoal = 10;
  bool _consent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          BreatheHeader(
            title: 'Componentes',
            subtitle: 'Catálogo do Design System · dados fictícios',
            onHelp: () => _snack(context, 'Ação de Ajuda'),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _section('Logo'),
                const Row(
                  children: <Widget>[
                    BreatheLogo(size: 40),
                    SizedBox(width: AppSpacing.lg),
                    BreatheLogo(size: 64),
                    SizedBox(width: AppSpacing.lg),
                    BreatheLogo(size: 96),
                  ],
                ),

                _section('Botões'),
                PrimaryButton(
                  label: 'Iniciar pausa de 1 minuto',
                  onPressed: () => _snack(context, 'CTA principal'),
                ),
                const SizedBox(height: AppSpacing.md),
                PrimaryButton(
                  label: 'Pedir acolhimento',
                  icon: Icons.favorite_rounded,
                  onPressed: () => _snack(context, 'CTA com ícone'),
                ),
                const SizedBox(height: AppSpacing.md),
                const PrimaryButton(label: 'Desabilitado', onPressed: null),
                const SizedBox(height: AppSpacing.md),
                SecondaryButton(
                  label: 'Avançar uma etapa',
                  onPressed: () => _snack(context, 'Botão secundário'),
                ),

                _section('Cards'),
                const BreatheCard(
                  child: Text(
                    'Card padrão branco, borda fina, raio 20. Use para a maioria '
                    'dos blocos de conteúdo.',
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                const BreatheCard(
                  color: AppColors.coralSoft,
                  borderColor: AppColors.coralSoft,
                  child: Text(
                    'Card de alerta/pausa/ajuda (coralSoft). Usado em "Hora de '
                    'respirar" e no card de pontos.',
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                const BreatheCard(
                  color: AppColors.mint,
                  borderColor: AppColors.mint,
                  child: Text(
                    'Card de dica (mint). Usado em "Dica do assistente".',
                  ),
                ),

                _section('Seção com ação'),
                const BreatheCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SectionTitle(title: 'Metas de vida'),
                      SizedBox(height: AppSpacing.lg),
                      ProgressBarLabeled(value: 0.4, label: 'Concluir o ensino médio'),
                      SizedBox(height: AppSpacing.lg),
                      ProgressBarLabeled(value: 0.2, label: 'Curso de especialização'),
                      SizedBox(height: AppSpacing.lg),
                      ProgressBarLabeled(value: 0.55, label: 'Reserva de emergência'),
                    ],
                  ),
                ),

                _section('Chips (seleção única)'),
                BreatheCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SectionTitle(title: 'Como você está hoje?'),
                      const SizedBox(height: AppSpacing.lg),
                      ChipGroup(
                        options: const <String>[
                          'Bem',
                          'Cansado',
                          'Estressado',
                          'Sobrecarregado',
                        ],
                        selectedIndex: _mood,
                        onSelected: (int i) => setState(() => _mood = i),
                      ),
                    ],
                  ),
                ),

                _section('Contador (− número +)'),
                BreatheCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SectionTitle(title: 'Meta diária de corridas'),
                      const SizedBox(height: AppSpacing.lg),
                      StepperCounter(
                        value: _ridesGoal,
                        min: 1,
                        max: 20,
                        onChanged: (int v) => setState(() => _ridesGoal = v),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Você define o ritmo. O app lembra das pausas.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),

                _section('Etiquetas'),
                const Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: <Widget>[
                    TagBadge(label: 'Trabalho'),
                    TagBadge(label: 'Saúde'),
                    TagBadge(label: 'Estudos'),
                    TagBadge(
                      label: 'Pausa',
                      background: AppColors.coralSoft,
                      foreground: AppColors.coral,
                      icon: Icons.self_improvement_rounded,
                    ),
                  ],
                ),

                _section('Campo e checkbox'),
                const TextField(
                  decoration: InputDecoration(hintText: 'Ex.: 123456'),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: <Widget>[
                    Checkbox(
                      value: _consent,
                      onChanged: (bool? v) =>
                          setState(() => _consent = v ?? false),
                    ),
                    const Expanded(
                      child: Text(
                        'Li e aceito como meus dados são usados. Você escolhe o '
                        'que compartilha.',
                      ),
                    ),
                  ],
                ),

                _section('Formatadores'),
                BreatheCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _formatterLine('Moeda', formatCurrency(1234.56)),
                      _formatterLine('Moeda', formatCurrency(120)),
                      _formatterLine('Distância', formatDistance(250)),
                      _formatterLine('Distância', formatDistance(1200)),
                      _formatterLine(
                        'Duração',
                        formatDuration(const Duration(hours: 5, minutes: 20)),
                      ),
                      _formatterLine(
                        'Duração',
                        formatDuration(const Duration(minutes: 45)),
                      ),
                    ],
                  ),
                ),

                _section('Estado vazio'),
                const BreatheCard(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  child: EmptyState(
                    title: 'Em construção',
                    message: 'Esta tela faz parte do protótipo e será montada em '
                        'breve.',
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _section(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        top: AppSpacing.xxl,
        bottom: AppSpacing.md,
      ),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.textSecondary,
            ),
      ),
    );
  }

  Widget _formatterLine(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }

  void _snack(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
