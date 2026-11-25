import 'package:flutter/material.dart';

import '../core/widgets/device_frame.dart';
import 'router.dart';
import 'theme/app_theme.dart';

/// Raiz do app: `MaterialApp.router` com o tema e a moldura de celular (web)
/// em volta de todas as telas.
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
        return DeviceFrame(child: child ?? const SizedBox.shrink());
      },
    );
  }
}
