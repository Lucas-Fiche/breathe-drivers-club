import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/app_spacing.dart';
import '../../data/providers/providers.dart';
import 'alerts_providers.dart';
import 'break_reminder_banner.dart';
import 'long_journey_alert.dart';
import 'recognition_toast.dart';

/// Camada global dos alertas, por cima de todas as telas (dentro da moldura
/// de celular na web):
/// - alerta de jornada longa, em tela cheia, só no Início (`/inicio`);
/// - banner de lembrete de pausa, no topo, em qualquer tela;
/// - toast de reconhecimento, embaixo.
///
/// Fica acima do Navigator, por isso navega com o [router] recebido.
class AppAlertsOverlay extends ConsumerStatefulWidget {
  const AppAlertsOverlay({
    super.key,
    required this.router,
    required this.child,
  });

  final GoRouter router;
  final Widget child;

  @override
  ConsumerState<AppAlertsOverlay> createState() => _AppAlertsOverlayState();
}

class _AppAlertsOverlayState extends ConsumerState<AppAlertsOverlay> {
  String _path = '';

  @override
  void initState() {
    super.initState();
    widget.router.routerDelegate.addListener(_onRouteChanged);
    _path = _currentPath();
  }

  @override
  void dispose() {
    widget.router.routerDelegate.removeListener(_onRouteChanged);
    super.dispose();
  }

  String _currentPath() =>
      widget.router.routerDelegate.currentConfiguration.uri.path;

  /// O router avisa a troca de rota durante o próprio build, e este widget
  /// fica acima dele na árvore: o setState é adiado para depois do frame.
  void _onRouteChanged() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final String path = _currentPath();
      if (mounted && path != _path) setState(() => _path = path);
    });
  }

  void _startBreak() => widget.router.push('/inicio/pausa');

  @override
  Widget build(BuildContext context) {
    final bool journeyDue =
        ref.watch(longJourneyDueProvider) && _path == '/inicio';
    final bool reminder = ref.watch(breakReminderProvider);
    final RecognitionEvent? recognition = ref.watch(recognitionProvider);
    final EdgeInsets safe = MediaQuery.of(context).padding;

    return Stack(
      children: <Widget>[
        widget.child,
        if (journeyDue)
          Positioned.fill(
            child: LongJourneyAlert(
              hours: ref.watch(planProvider).workDay.onlineHours,
              onPause: () {
                ref.read(longJourneyAlertProvider.notifier).acknowledge();
                _startBreak();
              },
              onSnooze: () =>
                  ref.read(longJourneyAlertProvider.notifier).snooze(),
            ),
          ),
        Positioned(
          left: AppSpacing.md,
          right: AppSpacing.md,
          top: safe.top + AppSpacing.md,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (Widget child, Animation<double> a) =>
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, -1.2),
                    end: Offset.zero,
                  ).animate(a),
                  child: child,
                ),
            child: reminder
                ? BreakReminderBanner(
                    key: const ValueKey<String>('break-reminder'),
                    onPause: () {
                      ref.read(breakReminderProvider.notifier).dismiss();
                      _startBreak();
                    },
                    onDismiss: () =>
                        ref.read(breakReminderProvider.notifier).dismiss(),
                  )
                : const SizedBox.shrink(),
          ),
        ),
        if (recognition != null)
          Positioned(
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            bottom: safe.bottom + AppSpacing.xxxl * 3,
            child: Center(
              child: RecognitionToast(
                key: ValueKey<int>(recognition.id),
                points: recognition.points,
                message: recognition.message,
                onDone: () => ref.read(recognitionProvider.notifier).clear(),
              ),
            ),
          ),
      ],
    );
  }
}
