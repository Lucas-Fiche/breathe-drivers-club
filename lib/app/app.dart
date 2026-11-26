import 'package:flutter/material.dart';

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
  const BreatheApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Breathe Drivers Club',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      routerConfig: appRouter,
      builder: (BuildContext context, Widget? child) {
        return DeviceFrame(
          child: SecretGestureScope(
            onTrigger: showDemoSheet,
            child: AppAlertsOverlay(
              router: appRouter,
              child: child ?? const SizedBox.shrink(),
            ),
          ),
        );
      },
    );
  }
}
