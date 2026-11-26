import 'dart:io';

import 'package:breathe_drivers_club/app/app.dart';
import 'package:breathe_drivers_club/app/router.dart';
import 'package:breathe_drivers_club/app/theme/app_typography.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Tamanhos de celular usados na revisão: pequeno e grande.
const Size kSmallPhone = Size(360, 740);
const Size kLargePhone = Size(430, 932);

bool _fontsLoaded = false;

/// Registra fontes reais (sem rede) para os testes medirem texto de verdade:
/// a Roboto do SDK do Flutter como família "Inter" (métricas parecidas; a
/// Inter é um pouco mais larga, por isso os testes também rodam com texto
/// ampliado) e os ícones do Material.
Future<void> loadAppFonts() async {
  AppTypography.useGoogleFonts = false;
  if (_fontsLoaded) return;
  final String dir = _materialFontsDir();

  Future<ByteData> read(String name) async => ByteData.sublistView(
    Uint8List.fromList(await File('$dir/$name').readAsBytes()),
  );

  final FontLoader inter = FontLoader(AppTypography.fontFamily)
    ..addFont(read('roboto-regular.ttf'))
    ..addFont(read('roboto-medium.ttf'))
    ..addFont(read('roboto-bold.ttf'));
  await inter.load();
  final FontLoader icons = FontLoader('MaterialIcons')
    ..addFont(read('materialicons-regular.otf'));
  await icons.load();
  _fontsLoaded = true;
}

/// Monta o app real (tema, moldura, overlay de alertas, gesto escondido) já
/// na [location], com tamanho de tela e escala de texto definidos.
Future<ProviderContainer> pumpAppAt(
  WidgetTester tester,
  String location, {
  Size size = kSmallPhone,
  double textScale = 1.0,
  bool settle = true,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  addTearDown(tester.view.reset);
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

  final ProviderContainer container = ProviderContainer();
  addTearDown(container.dispose);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: BreatheApp(router: createAppRouter(initialLocation: location)),
    ),
  );
  if (settle) {
    await tester.pumpAndSettle();
  } else {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
  }
  return container;
}

/// Rola todas as áreas roláveis até o fim, para montar e medir o conteúdo
/// que só aparece embaixo (listas preguiçosas).
Future<void> scrollToEnd(WidgetTester tester, {bool settle = true}) async {
  for (int i = 0; i < 12; i++) {
    final Finder scrollables = find.byWidgetPredicate(
      (Widget w) => w is Scrollable && w.axisDirection == AxisDirection.down,
    );
    if (scrollables.evaluate().isEmpty) return;
    await tester.drag(
      scrollables.first,
      const Offset(0, -400),
      warnIfMissed: false,
    );
    if (settle) {
      await tester.pumpAndSettle();
    } else {
      await tester.pump(const Duration(milliseconds: 300));
    }
  }
}

/// Desmonta a árvore (cancela timers e animações infinitas das telas).
Future<void> unmountApp(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump(const Duration(seconds: 1));
}

/// Pasta das fontes do Material no SDK: usa FLUTTER_ROOT ou sobe a partir do
/// executável de teste (que fica dentro de bin/cache/artifacts).
String _materialFontsDir() {
  const String rel = 'bin/cache/artifacts/material_fonts';
  final String? root = Platform.environment['FLUTTER_ROOT'];
  if (root != null && Directory('$root/$rel').existsSync()) return '$root/$rel';
  Directory d = File(Platform.resolvedExecutable).parent;
  while (d.parent.path != d.path) {
    if (Directory('${d.path}/$rel').existsSync()) return '${d.path}/$rel';
    d = d.parent;
  }
  throw StateError('Fontes do Material não encontradas no SDK do Flutter.');
}
