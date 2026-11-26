import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/models.dart';
import '../../../data/providers/providers.dart';
import '../widgets/choice_tile.dart';
import '../widgets/onboarding_hint.dart';

/// Tela de perfil inicial (`/perfil-inicial`).
///
/// Questionário curto, uma pergunta por vez, com barra de progresso e chips
/// grandes. Ao final, um resumo e o botão "Começar" leva ao Início. Nada é
/// obrigatório para o resto do app funcionar.
class InitialProfileScreen extends ConsumerStatefulWidget {
  const InitialProfileScreen({super.key});

  @override
  ConsumerState<InitialProfileScreen> createState() =>
      _InitialProfileScreenState();
}

class _InitialProfileScreenState extends ConsumerState<InitialProfileScreen> {
  static const List<String> _workOptions = <String>[
    'Corridas de carro',
    'Entregas de moto',
    'Entregas de bike',
    'Outro',
  ];
  static const List<String> _timeOptions = <String>[
    'Menos de 1 ano',
    '1 a 3 anos',
    '3 a 6 anos',
    '6 anos ou mais',
  ];
  static const List<String> _hoursOptions = <String>[
    'Até 6 horas',
    '6 a 8 horas',
    '8 a 10 horas',
    'Mais de 10 horas',
  ];
  static const List<String> _wantsOptions = <String>[
    'Terminar os estudos',
    'Organizar o dinheiro',
    'Descansar melhor',
    'Ter benefícios',
    'Conhecer outros trabalhadores',
  ];

  /// Quantidade de perguntas (o resumo é o passo final extra).
  static const int _questionCount = 4;

  int _step = 0;
  int? _work;
  int? _time;
  int? _hours;
  final Set<int> _wants = <int>{};

  bool get _isSummary => _step == _questionCount;
  bool get _longHours => _hours == _hoursOptions.length - 1;

  bool get _canContinue {
    switch (_step) {
      case 0:
        return _work != null;
      case 1:
        return _time != null;
      case 2:
        return _hours != null;
      default:
        return true; // múltipla escolha e resumo não travam.
    }
  }

  void _back() {
    if (_step == 0) {
      context.go('/acesso');
    } else {
      setState(() => _step--);
    }
  }

  void _next() {
    if (!_canContinue) return;
    setState(() => _step++);
  }

  void _finish() {
    final (DriverType type, String vehicle) = _workMapping(_work);
    ref.read(profileProvider.notifier).updateProfile(
          type: type,
          vehicle: vehicle,
          yearsOnApp: _yearsMapping(_time),
        );
    context.go('/inicio');
  }

  (DriverType, String) _workMapping(int? index) {
    switch (index) {
      case 1:
        return (DriverType.entregador, 'Moto');
      case 2:
        return (DriverType.entregador, 'Bicicleta');
      case 3:
        return (DriverType.motorista, 'Outro');
      case 0:
      default:
        return (DriverType.motorista, 'Carro');
    }
  }

  int _yearsMapping(int? index) => const <int>[0, 2, 4, 6][index ?? 0];

  @override
  Widget build(BuildContext context) {
    final String firstName =
        ref.watch(profileProvider).profile.name.split(' ').first;

    return BreatheScaffold(
      title: 'Seu perfil',
      subtitle: 'Leva menos de 1 minuto. Nada é obrigatório.',
      onBack: _back,
      body: Column(
        children: <Widget>[
          _ProgressStrip(
            progress: (_step + 1) / (_questionCount + 1),
            caption: _isSummary
                ? 'Resumo'
                : 'Pergunta ${_step + 1} de $_questionCount',
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: _isSummary ? _buildSummary(firstName) : _buildQuestion(),
            ),
          ),
          _BottomBar(
            label: _isSummary ? 'Começar' : 'Continuar',
            enabled: _isSummary ? true : _canContinue,
            onPressed: _isSummary ? _finish : _next,
          ),
        ],
      ),
    );
  }

  Widget _buildQuestion() {
    switch (_step) {
      case 0:
        return _SingleChoice(
          title: 'Com o que você trabalha?',
          options: _workOptions,
          selected: _work,
          onSelected: (int i) => setState(() => _work = i),
        );
      case 1:
        return _SingleChoice(
          title: 'Há quanto tempo?',
          options: _timeOptions,
          selected: _time,
          onSelected: (int i) => setState(() => _time = i),
        );
      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _SingleChoice(
              title: 'Quantas horas por dia, em média?',
              options: _hoursOptions,
              selected: _hours,
              onSelected: (int i) => setState(() => _hours = i),
            ),
            if (_longHours) ...<Widget>[
              const SizedBox(height: AppSpacing.lg),
              const OnboardingHint(
                text:
                    'Mais de 10 horas na estrada cansa bastante. Sem julgamento: o Breathe '
                    'está aqui para te ajudar a encaixar pausas e cuidar de '
                    'você ao longo do dia.',
              ),
            ],
          ],
        );
      case 3:
      default:
        return _MultiChoice(
          title: 'O que você mais quer agora?',
          subtitle: 'Pode escolher mais de um.',
          options: _wantsOptions,
          selected: _wants,
          onToggled: (int i) => setState(() {
            if (!_wants.remove(i)) _wants.add(i);
          }),
        );
    }
  }

  Widget _buildSummary(String firstName) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final String wants = _wants.isEmpty
        ? '—'
        : (_wants.toList()..sort())
            .map((int i) => _wantsOptions[i])
            .join(', ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const SizedBox(height: AppSpacing.sm),
        const Center(child: BreatheLogo(size: 72)),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Tudo pronto, $firstName!',
          textAlign: TextAlign.center,
          style: textTheme.titleLarge,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Guardamos suas respostas para deixar o app com a sua cara. Você pode '
          'mudar tudo depois.',
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium,
        ),
        const SizedBox(height: AppSpacing.xl),
        BreatheCard(
          child: Column(
            children: <Widget>[
              _SummaryRow(label: 'Você trabalha com', value: _valueOf(_workOptions, _work)),
              const SizedBox(height: AppSpacing.md),
              _SummaryRow(label: 'Tempo de app', value: _valueOf(_timeOptions, _time)),
              const SizedBox(height: AppSpacing.md),
              _SummaryRow(label: 'Horas por dia', value: _valueOf(_hoursOptions, _hours)),
              const SizedBox(height: AppSpacing.md),
              _SummaryRow(label: 'Você quer', value: wants),
            ],
          ),
        ),
        if (_longHours) ...<Widget>[
          const SizedBox(height: AppSpacing.lg),
          const OnboardingHint(
            text:
                'Combinado: vamos te lembrar das pausas para o seu dia ficar '
                'mais leve e mais seguro.',
          ),
        ],
      ],
    );
  }

  String _valueOf(List<String> options, int? index) =>
      index == null ? '—' : options[index];
}

/// Faixa de progresso abaixo do cabeçalho, com a legenda da etapa.
class _ProgressStrip extends StatelessWidget {
  const _ProgressStrip({required this.progress, required this.caption});

  final double progress;
  final String caption;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ProgressBarLabeled(value: progress, showPercent: false, height: 8),
          const SizedBox(height: AppSpacing.sm),
          Text(caption, style: textTheme.bodyMedium),
        ],
      ),
    );
  }
}

/// Barra inferior com o botão principal.
class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.label,
    required this.enabled,
    required this.onPressed,
  });

  final String label;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      child: PrimaryButton(
        label: label,
        onPressed: enabled ? onPressed : null,
      ),
    );
  }
}

class _SingleChoice extends StatelessWidget {
  const _SingleChoice({
    required this.title,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  final String title;
  final List<String> options;
  final int? selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: AppSpacing.xl),
        for (int i = 0; i < options.length; i++) ...<Widget>[
          ChoiceTile(
            label: options[i],
            selected: selected == i,
            onTap: () => onSelected(i),
          ),
          if (i < options.length - 1) const SizedBox(height: AppSpacing.md),
        ],
      ],
    );
  }
}

class _MultiChoice extends StatelessWidget {
  const _MultiChoice({
    required this.title,
    required this.subtitle,
    required this.options,
    required this.selected,
    required this.onToggled,
  });

  final String title;
  final String subtitle;
  final List<String> options;
  final Set<int> selected;
  final ValueChanged<int> onToggled;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(title, style: textTheme.titleLarge),
        const SizedBox(height: AppSpacing.xs),
        Text(subtitle, style: textTheme.bodyMedium),
        const SizedBox(height: AppSpacing.xl),
        for (int i = 0; i < options.length; i++) ...<Widget>[
          ChoiceTile(
            label: options[i],
            selected: selected.contains(i),
            multiSelect: true,
            onTap: () => onToggled(i),
          ),
          if (i < options.length - 1) const SizedBox(height: AppSpacing.md),
        ],
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Text(label, style: textTheme.bodyMedium),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          flex: 3,
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: textTheme.titleMedium,
          ),
        ),
      ],
    );
  }
}
