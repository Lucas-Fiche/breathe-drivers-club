import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/alerts/app_alerts_overlay.dart';
import '../core/widgets/device_frame.dart';
import '../core/widgets/secret_gesture.dart';
import '../features/demo/widgets/demo_sheet.dart';
import 'router.dart';
import 'theme/app_theme.dart';

/// Raiz do app: `MaterialApp.router` com o tema. Em volta de todas as telas:
/// - a moldura de celular (web);
/// - a camada global de alertas (lembrete de pausa, jornada longa,
///   reconhecimento), dentro da moldura;
/// - o gesto escondido que abre o modo apresentação.
class BreatheApp extends StatelessWidget {
  const BreatheApp({super.key, this.router});

  /// Roteador a usar (padrão: [appRouter]). Os testes passam um novo.
  final GoRouter? router;

  @override
  Widget build(BuildContext context) {
    final GoRouter router = this.router ?? appRouter;
    return MaterialApp.router(
      title: 'Breathe Drivers Club',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      routerConfig: router,
      builder: (BuildContext context, Widget? child) {
        return DeviceFrame(
          child: SecretGestureScope(
            onTrigger: showDemoSheet,
            child: AppAlertsOverlay(
              router: router,
              child: child ?? const SizedBox.shrink(),
            ),
          ),
        );
      },
    );
  }
}
