// Atalhos do Início com a mesma altura e FAB do Assistente que fica
// translúcido durante a rolagem.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/test_app.dart';

void main() {
  testWidgets('os três atalhos do Início têm a mesma altura', (tester) async {
    await pumpAppAt(tester, '/inicio');
    final Finder shortcuts = find.byType(InkWell);
    double heightOf(String label) => tester
        .getSize(find.ancestor(of: find.text(label), matching: shortcuts).first)
        .height;

    await tester.scrollUntilVisible(find.text('Pontos de apoio'), 200);
    final double community = heightOf('Comunidade');
    expect(heightOf('Questionário'), community);
    expect(heightOf('Pontos de apoio'), community);
    await unmountApp(tester);
  });

  testWidgets('FAB do Assistente fica translúcido ao rolar e depois volta', (
    tester,
  ) async {
    await pumpAppAt(tester, '/inicio');
    double fabOpacity() => tester
        .widget<AnimatedOpacity>(
          find.ancestor(
            of: find.byType(FloatingActionButton),
            matching: find.byType(AnimatedOpacity),
          ),
        )
        .opacity;

    expect(fabOpacity(), 1);

    final TestGesture gesture = await tester.startGesture(
      tester.getCenter(find.byType(SingleChildScrollView)),
    );
    await gesture.moveBy(const Offset(0, -150));
    await tester.pump();
    expect(fabOpacity(), lessThan(1));

    await gesture.up();
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    expect(fabOpacity(), 1);
    await unmountApp(tester);
  });
}
