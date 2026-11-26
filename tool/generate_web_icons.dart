// Gera os ícones da web (favicon e ícones do manifest) a partir do widget
// BreatheLogo real, para o ícone da aba ser idêntico ao logo do app.
//
// Uso (na raiz do projeto):
//   flutter test tool/generate_web_icons.dart
//
// Fica em tool/ (e não em test/) para o `flutter test` normal não
// regenerar os arquivos.

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:breathe_drivers_club/app/theme/app_colors.dart';
import 'package:breathe_drivers_club/core/widgets/breathe_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

/// Um ícone a gerar.
class _Icon {
  const _Icon(this.path, this.size, {required this.logoFraction, this.round});

  final String path;
  final int size;

  /// Fração do lado ocupada pelo volante. Ícones "maskable" usam ~0,55 para
  /// o volante ficar dentro da zona segura (círculo de 80%).
  final double logoFraction;

  /// Raio dos cantos do fundo (fração do lado); nulo = quadrado cheio.
  final double? round;
}

const List<_Icon> _icons = <_Icon>[
  _Icon('web/favicon.png', 64, logoFraction: 0.78, round: 0.22),
  _Icon('web/icons/Icon-192.png', 192, logoFraction: 0.7, round: 0.22),
  _Icon('web/icons/Icon-512.png', 512, logoFraction: 0.7, round: 0.22),
  _Icon('web/icons/Icon-maskable-192.png', 192, logoFraction: 0.55),
  _Icon('web/icons/Icon-maskable-512.png', 512, logoFraction: 0.55),
];

void main() {
  for (final _Icon icon in _icons) {
    testWidgets('gera ${icon.path}', (WidgetTester tester) async {
      final GlobalKey key = GlobalKey();
      final double side = icon.size.toDouble();
      tester.view.physicalSize = Size(side, side);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: RepaintBoundary(
              key: key,
              child: Container(
                width: side,
                height: side,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primaryDark,
                  borderRadius: icon.round == null
                      ? null
                      : BorderRadius.circular(side * icon.round!),
                ),
                child: BreatheLogo(size: side * icon.logoFraction),
              ),
            ),
          ),
        ),
      );

      await tester.runAsync(() async {
        final RenderRepaintBoundary boundary = key.currentContext!
            .findRenderObject()! as RenderRepaintBoundary;
        final ui.Image image = await boundary.toImage();
        final ByteData? png =
            await image.toByteData(format: ui.ImageByteFormat.png);
        File(icon.path).writeAsBytesSync(png!.buffer.asUint8List());
      });
    });
  }
}
