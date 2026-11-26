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
/// a Roboto de `test/fonts/` como família "Inter" (métricas parecidas; a
/// Inter é um pouco mais larga, por isso os testes também rodam com texto
/// ampliado).
///
/// As fontes ficam no repositório para funcionar igual em qualquer máquina,
/// inclusive no GitHub Actions. Os ícones não precisam de fonte: o tamanho do
/// ícone é o mesmo com ou sem ela, e é o tamanho que os testes medem.
Future<void> loadAppFonts() async {
  AppTypography.useGoogleFonts = false;
  if (_fontsLoaded) return;

  Future<ByteData> read(String name) async => ByteData.sublistView(
    Uint8List.fromList(await File('test/fonts/$name').readAsBytes()),
  );

  final FontLoader inter = FontLoader(AppTypography.fontFamily)
    ..addFont(read('roboto-regular.ttf'))
    ..addFont(read('roboto-medium.ttf'))
    ..addFont(read('roboto-bold.ttf'));
  await inter.load();
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
