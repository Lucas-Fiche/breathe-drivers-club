// Revisão de layout antes da apresentação.
//
// Abre CADA rota do app em dois tamanhos de celular (360×740 e 430×932) e as
// telas principais com texto ampliado (1,3×). Qualquer overflow ("RenderFlex
// overflowed") ou exceção durante o build/layout faz o teste falhar, porque o
// flutter_test trata erros do framework como falha.

import 'package:breathe_drivers_club/app/health_limits.dart';
import 'package:breathe_drivers_club/data/providers/providers.dart';
import 'package:breathe_drivers_club/features/benefits/widgets/how_to_earn_sheet.dart';
import 'package:breathe_drivers_club/features/community/widgets/comments_sheet.dart';
import 'package:breathe_drivers_club/features/community/widgets/publish_post_sheet.dart';
import 'package:breathe_drivers_club/features/demo/widgets/demo_sheet.dart';
import 'package:breathe_drivers_club/features/finance/widgets/all_transactions_sheet.dart';
import 'package:breathe_drivers_club/features/finance/widgets/register_transaction_sheet.dart';
import 'package:breathe_drivers_club/features/more/widgets/about_sheet.dart';
import 'package:breathe_drivers_club/features/plan/widgets/new_goal_sheet.dart';
import 'package:breathe_drivers_club/features/support_points/widgets/point_details_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/test_app.dart';

/// Uma rota a revisar. [settle] = false nas telas com animação infinita
/// (pausa guiada, conexão com o profissional, pino pulsando no mapa).
class _RouteCase {
  const _RouteCase(this.location, {this.settle = true});

  final String location;
  final bool settle;
}

const List<_RouteCase> _allRoutes = <_RouteCase>[
  _RouteCase('/acesso'),
  _RouteCase('/consentimento'),
  _RouteCase('/perfil-inicial'),
  _RouteCase('/inicio'),
  _RouteCase('/inicio/pausa', settle: false),
  _RouteCase('/plano'),
  _RouteCase('/financas'),
  _RouteCase('/beneficios'),
  _RouteCase('/beneficios?filtro=estudos'),
  _RouteCase('/apoio', settle: false),
  _RouteCase('/assistente'),
  _RouteCase('/comunidade'),
  _RouteCase('/questionario'),
  _RouteCase('/questionario/resultado'),
  _RouteCase('/ajuda'),
  _RouteCase('/ajuda/psicologo', settle: false),
  _RouteCase('/mais'),
  _RouteCase('/privacidade'),
  _RouteCase('/telas'),
  _RouteCase('/componentes'),
];

/// Telas principais revisadas com texto ampliado.
const List<_RouteCase> _mainRoutes = <_RouteCase>[
  _RouteCase('/acesso'),
  _RouteCase('/inicio'),
  _RouteCase('/plano'),
  _RouteCase('/financas'),
  _RouteCase('/beneficios'),
  _RouteCase('/apoio', settle: false),
  _RouteCase('/assistente'),
  _RouteCase('/comunidade'),
  _RouteCase('/questionario'),
  _RouteCase('/questionario/resultado'),
  _RouteCase('/ajuda'),
  _RouteCase('/mais'),
  _RouteCase('/privacidade'),
];

Future<void> _review(
  WidgetTester tester,
  _RouteCase route, {
  required Size size,
  double textScale = 1.0,
}) async {
  await pumpAppAt(
    tester,
    route.location,
    size: size,
    textScale: textScale,
    settle: route.settle,
  );
  await scrollToEnd(tester, settle: route.settle);
  await unmountApp(tester);
}

void main() {
  setUpAll(loadAppFonts);

  for (final Size size in <Size>[kSmallPhone, kLargePhone]) {
    final String label = '${size.width.toInt()}×${size.height.toInt()}';
    group('todas as rotas em $label', () {
      for (final _RouteCase route in _allRoutes) {
        testWidgets(route.location, (WidgetTester tester) async {
          await _review(tester, route, size: size);
        });
      }
    });
  }

  group('texto ampliado 1,3× em 360×740', () {
    for (final _RouteCase route in _mainRoutes) {
      testWidgets(route.location, (WidgetTester tester) async {
        await _review(tester, route, size: kSmallPhone, textScale: 1.3);
      });
    }
  });

  group('estados especiais', () {
    for (final Size size in <Size>[kSmallPhone, kLargePhone]) {
      final String label = '${size.width.toInt()}×${size.height.toInt()}';

      testWidgets('alerta de jornada longa em $label', (tester) async {
        final ProviderContainer c = await pumpAppAt(
          tester,
          '/inicio',
          size: size,
        );
        c
            .read(planProvider.notifier)
            .setOnlineHours(HealthLimits.longJourneyHours);
        await tester.pumpAndSettle();
        expect(find.text('Lembrar em 30 min'), findsOneWidget);
        await unmountApp(tester);
      });

      testWidgets('alerta de jornada com texto 1,3× em $label', (tester) async {
        final ProviderContainer c = await pumpAppAt(
          tester,
          '/inicio',
          size: size,
          textScale: 1.3,
        );
        c
            .read(planProvider.notifier)
            .setOnlineHours(HealthLimits.longJourneyHours);
        await tester.pumpAndSettle();
        await unmountApp(tester);
      });

      testWidgets('pergunta do questionário em $label', (tester) async {
        await pumpAppAt(tester, '/questionario', size: size, textScale: 1.3);
        await tester.scrollUntilVisible(
          find.text('Começar'),
          200,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.tap(find.text('Começar'));
        await tester.pumpAndSettle();
        await scrollToEnd(tester);
        await unmountApp(tester);
      });
    }
  });

  // Bottom sheets: abertos chamando a própria função de cada um, com dados
  // reais dos providers, por cima de uma tela qualquer.
  group('bottom sheets', () {
    final Map<String, void Function(BuildContext, ProviderContainer)> sheets =
        <String, void Function(BuildContext, ProviderContainer)>{
          'modo apresentação': (BuildContext c, _) => showDemoSheet(c),
          'como ganhar pontos': (BuildContext c, _) => showHowToEarnSheet(c),
          'nova publicação': (BuildContext c, _) => showPublishPostSheet(c),
          'comentários': (BuildContext c, ProviderContainer p) =>
              showCommentsSheet(c, p.read(communityProvider).posts[2]),
          'registrar movimentação': (BuildContext c, _) =>
              showRegisterTransactionSheet(c),
          'todas as movimentações': (BuildContext c, ProviderContainer p) =>
              showAllTransactionsSheet(c, p.read(financeProvider).transactions),
          'nova meta': (BuildContext c, _) => showNewGoalSheet(c),
          'detalhes do ponto de apoio': (BuildContext c, ProviderContainer p) =>
              showPointDetailsSheet(
                c,
                p.read(supportProvider).supportPoints.first,
              ),
          'sobre o Breathe': (BuildContext c, _) => showAboutBreatheSheet(c),
        };

    for (final MapEntry<String, void Function(BuildContext, ProviderContainer)>
        sheet
        in sheets.entries) {
      for (final double scale in <double>[1.0, 1.3]) {
        testWidgets('${sheet.key} em 360×740, texto $scale×', (tester) async {
          final ProviderContainer c = await pumpAppAt(
            tester,
            '/mais',
            textScale: scale,
          );
          sheet.value(tester.element(find.byType(Scaffold).first), c);
          await tester.pumpAndSettle();
          await scrollToEnd(tester);
          await unmountApp(tester);
        });
      }
    }

    testWidgets('horários para agendar conversa, texto 1.3×', (tester) async {
      await pumpAppAt(tester, '/ajuda', textScale: 1.3);
      await tester.tap(find.text('Escolher horário'));
      await tester.pumpAndSettle();
      expect(find.text('Confirmar horário'), findsOneWidget);
      await unmountApp(tester);
    });
  });

  // Acessibilidade: área de toque ≥ 48 px e rótulo em todo alvo tocável
  // (inclui botões só com ícone). A tela é bem alta (360×4000) para todo o
  // conteúdo aparecer sem rolar: rolando, itens cortados na borda viram
  // falsos positivos.
  group('acessibilidade (toque ≥ 48 e rótulos)', () {
    for (final _RouteCase route in _allRoutes) {
      if (route.location == '/componentes') continue; // catálogo interno
      testWidgets(route.location, (WidgetTester tester) async {
        final SemanticsHandle semantics = tester.ensureSemantics();
        await pumpAppAt(
          tester,
          route.location,
          size: const Size(360, 4000),
          settle: route.settle,
        );
        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
        semantics.dispose();
        await unmountApp(tester);
      });
    }
  });
}
