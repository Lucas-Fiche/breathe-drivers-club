import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/providers/providers.dart';

/// Tela de pausa guiada (`/inicio/pausa`), em tela cheia sobre [primaryDark].
///
/// Um círculo respira (Inspire 4s, Segure 2s, Solte 4s) por 60s. Ao terminar,
/// registra a pausa, soma os pontos e volta ao Início. Usa apenas
/// AnimationController (sem pacotes).
class BreakScreen extends ConsumerStatefulWidget {
  const BreakScreen({super.key});

  @override
  ConsumerState<BreakScreen> createState() => _BreakScreenState();
}

class _BreakScreenState extends ConsumerState<BreakScreen>
    with TickerProviderStateMixin {
  // Ciclo de respiração de 10s: 4s inspira, 2s segura, 4s solta.
  late final AnimationController _breathing = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 10),
  );

  // Contagem regressiva de 60s.
  late final AnimationController _countdown = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 60),
  );

  bool _finished = false;

  @override
  void initState() {
    super.initState();
    _breathing.repeat();
    _countdown.addStatusListener(_onCountdown);
    _countdown.forward();
  }

  void _onCountdown(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _complete();
    }
  }

  @override
  void dispose() {
    _countdown.removeStatusListener(_onCountdown);
    _breathing.dispose();
    _countdown.dispose();
    super.dispose();
  }

  /// Conclusão natural: registra a pausa (soma pontos) e volta após um instante.
  Future<void> _complete() async {
    if (_finished) return;
    setState(() => _finished = true);
    _breathing.stop();
    ref.read(planProvider.notifier).registerBreak();
    await Future<void>.delayed(const Duration(milliseconds: 1800));
    if (mounted) _leave();
  }

  /// Saída antecipada pelo botão "Encerrar": não registra pausa.
  void _dismiss() {
    if (_finished) return;
    _leave();
  }

  void _leave() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/inicio');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: _finished ? const _Completed() : _buildBreathing(),
        ),
      ),
    );
  }

  Widget _buildBreathing() {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Column(
      children: <Widget>[
        const Spacer(),
        AnimatedBuilder(
          animation: Listenable.merge(<Listenable>[_breathing, _countdown]),
          builder: (BuildContext context, _) {
            final _Phase phase = _phaseFor(_breathing.value);
            final int secondsLeft =
                (60 * (1 - _countdown.value)).ceil().clamp(0, 60);
            return Column(
              children: <Widget>[
                _BreathingCircle(scale: phase.scale, label: phase.label),
                const SizedBox(height: AppSpacing.xxl),
                Text(
                  '$secondsLeft s',
                  style: textTheme.titleLarge?.copyWith(
                    color: AppColors.onDark.withValues(alpha: 0.85),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Pare em um local seguro antes de começar.',
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium?.copyWith(
            color: AppColors.onDark.withValues(alpha: 0.6),
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: _dismiss,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.onDark.withValues(alpha: 0.7),
          ),
          child: const Text('Encerrar'),
        ),
      ],
    );
  }

  /// Converte o progresso do ciclo (0–1) em escala e rótulo da fase.
  _Phase _phaseFor(double t) {
    const double minScale = 0.55;
    const double maxScale = 1.0;
    if (t < 0.4) {
      final double p = Curves.easeInOut.transform(t / 0.4);
      return _Phase('Inspire', minScale + (maxScale - minScale) * p);
    }
    if (t < 0.6) {
      return const _Phase('Segure', maxScale);
    }
    final double p = Curves.easeInOut.transform((t - 0.6) / 0.4);
    return _Phase('Solte', maxScale - (maxScale - minScale) * p);
  }
}

class _Phase {
  const _Phase(this.label, this.scale);

  final String label;
  final double scale;
}

class _BreathingCircle extends StatelessWidget {
  const _BreathingCircle({required this.scale, required this.label});

  final double scale;
  final String label;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return SizedBox.square(
      dimension: 280,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          // Halo estático.
          Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.onDark.withValues(alpha: 0.06),
            ),
          ),
          // Círculo que respira.
          Transform.scale(
            scale: scale,
            child: Container(
              width: 220,
              height: 220,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.mint,
              ),
              alignment: Alignment.center,
              child: Text(
                label,
                style: textTheme.titleLarge?.copyWith(
                  color: AppColors.primaryDark,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Tela de conclusão, com aparição suave.
class _Completed extends StatelessWidget {
  const _Completed();

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: 1),
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOut,
        builder: (BuildContext context, double t, Widget? child) {
          return Opacity(
            opacity: t,
            child: Transform.scale(scale: 0.9 + 0.1 * t, child: child),
          );
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const BreatheLogo(size: 96),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Pausa concluída',
              style: textTheme.titleLarge?.copyWith(color: AppColors.onDark),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              '+${PointRewards.perBreak} pontos',
              style: textTheme.titleMedium?.copyWith(color: AppColors.coral),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Cuidar de você também é trabalho.',
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.onDark.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
