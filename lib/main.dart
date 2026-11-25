import 'package:flutter/material.dart';

import 'app/theme/app_theme.dart';
import 'core/widgets/device_frame.dart';
import 'features/demo/screens/components_gallery_screen.dart';

void main() {
  runApp(const BreatheApp());
}

/// App da Fase 1. Aplica o tema e mostra o catálogo de componentes dentro da
/// moldura de celular. A navegação (go_router) entra na Fase 2, quando esta
/// tela vira a rota `/componentes`.
class BreatheApp extends StatelessWidget {
  const BreatheApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Breathe Drivers Club',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      builder: (BuildContext context, Widget? child) {
        return DeviceFrame(child: child ?? const SizedBox.shrink());
      },
      home: const ComponentsGalleryScreen(),
    );
  }
}
