import 'package:flutter/material.dart';

void main() {
  runApp(const BreatheApp());
}

/// App mínimo da Fase 0. O tema, a navegação (go_router) e o estado
/// (Riverpod) entram nas fases seguintes.
class BreatheApp extends StatelessWidget {
  const BreatheApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Breathe Drivers Club',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Text('Breathe'),
        ),
      ),
    );
  }
}
