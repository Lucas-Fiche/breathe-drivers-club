import 'package:breathe_drivers_club/data/models/models.dart';
import 'package:breathe_drivers_club/data/providers/providers.dart';
import 'package:breathe_drivers_club/features/survey/screens/survey_result_screen.dart';
import 'package:breathe_drivers_club/features/survey/screens/survey_screen.dart';
import 'package:breathe_drivers_club/features/survey/survey_feedback.dart';
import 'package:breathe_drivers_club/features/survey/survey_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

ProviderContainer makeContainer() {
  final ProviderContainer c = ProviderContainer();
  addTearDown(c.dispose);
  return c;
}

/// Responde todos os itens de uma dimensão com o mesmo índice.
void answerDimension(ProviderContainer c, SurveyDimension d, int option) {
  for (final SurveyQuestion q in c.read(surveyProvider).questions) {
    if (q.dimension == d) c.read(surveyProvider.notifier).answer(q.id, option);
  }
}

List<String> routesFor(Map<SurveyDimension, double> scores) =>
    suggestionsFor(scores).map((SurveySuggestion s) => s.route).toList();

Future<void> pumpSurvey(WidgetTester tester, String location) async {
  tester.view.physicalSize = const Size(400, 860);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final GoRouter router = GoRouter(
    initialLocation: location,
    routes: <RouteBase>[
      GoRoute(
        path: '/inicio',
        builder: (_, _) => const Scaffold(body: Text('Início')),
      ),
      GoRoute(
        path: '/questionario',
        builder: (_, _) => const SurveyScreen(),
        routes: <RouteBase>[
          GoRoute(
            path: 'resultado',
            builder: (_, _) => const SurveyResultScreen(),
          ),
        ],
      ),
    ],
  );
  await tester.pumpWidget(
    ProviderScope(child: MaterialApp.router(routerConfig: router)),
  );
  await tester.pumpAndSettle();
}

Future<void> start(WidgetTester tester) async {
  await tester.scrollUntilVisible(
    find.text('Começar'),
    200,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.tap(find.text('Começar'));
  await tester.pumpAndSettle();
}

Future<void> answerCurrent(WidgetTester tester) async {
  await tester.tap(find.text('Concordo'));
  await tester.pump(SurveyScreen.advanceDelay);
  await tester.pumpAndSettle();
}

void main() {
  group('itens provisórios', () {
    test('4 dimensões com 2 a 3 itens cada e ids únicos', () {
      for (final SurveyDimension d in SurveyDimension.values) {
        final int n = kSurveyItems
            .where((SurveyQuestion q) => q.dimension == d)
            .length;
        expect(n, inInclusiveRange(2, 3), reason: d.name);
        expect(kDimensionInfo.containsKey(d), isTrue);
      }
      final Set<String> ids = kSurveyItems
          .map((SurveyQuestion q) => q.id)
          .toSet();
      expect(ids.length, kSurveyItems.length);
      expect(kSurveyScale.length, 5);
    });
  });

  group('pontuação por dimensão', () {
    test('sem respostas é nula', () {
      final ProviderContainer c = makeContainer();
      expect(c.read(surveyProvider).scoreFor(SurveyDimension.sono), isNull);
    });

    test('itens invertidos são espelhados', () {
      final ProviderContainer c = makeContainer();
      // Concordar totalmente com os dois itens do Sono: "durmo bem" vale 1 e
      // "acordo sem energia" (invertido) vale 0. Média 0,5.
      answerDimension(c, SurveyDimension.sono, 4);
      expect(c.read(surveyProvider).scoreFor(SurveyDimension.sono), 0.5);
    });

    test('vai de 0 a 1', () {
      final ProviderContainer c = makeContainer();
      answerDimension(c, SurveyDimension.suporte, 4);
      expect(c.read(surveyProvider).scoreFor(SurveyDimension.suporte), 1.0);
      answerDimension(c, SurveyDimension.suporte, 0);
      expect(c.read(surveyProvider).scoreFor(SurveyDimension.suporte), 0.0);
    });
  });

  group('sugestões', () {
    test('fadiga alta leva a pausas e pontos de apoio', () {
      expect(
        routesFor(<SurveyDimension, double>{
          SurveyDimension.bemEstar: 0.9,
          SurveyDimension.fadiga: 0.9,
          SurveyDimension.sono: 0.9,
          SurveyDimension.suporte: 0.9,
        }),
        <String>['/inicio/pausa', '/apoio'],
      );
    });

    test('suporte baixo leva a benefícios e assistente', () {
      expect(
        routesFor(<SurveyDimension, double>{
          SurveyDimension.bemEstar: 0.9,
          SurveyDimension.fadiga: 0.1,
          SurveyDimension.sono: 0.9,
          SurveyDimension.suporte: 0.1,
        }),
        <String>['/beneficios', '/assistente'],
      );
    });

    test('no máximo 3, começando pela dimensão menos favorável', () {
      final List<String> routes = routesFor(<SurveyDimension, double>{
        SurveyDimension.bemEstar: 0.2,
        SurveyDimension.fadiga: 0.95,
        SurveyDimension.sono: 0.2,
        SurveyDimension.suporte: 0.2,
      });
      expect(routes.length, 3);
      expect(routes.first, '/inicio/pausa'); // fadiga é a pior
    });

    test('tudo bem: ainda há 2 sugestões', () {
      expect(
        routesFor(<SurveyDimension, double>{
          SurveyDimension.bemEstar: 1,
          SurveyDimension.fadiga: 0,
          SurveyDimension.sono: 1,
          SurveyDimension.suporte: 1,
        }).length,
        2,
      );
    });
  });

  group('telas', () {
    testWidgets('responder tudo leva à devolutiva com +50 pontos e, ao '
        'voltar, mostra já respondido', (WidgetTester tester) async {
      await pumpSurvey(tester, '/questionario');
      expect(find.textContaining('só médias de todos'), findsOneWidget);
      await start(tester);

      for (int i = 0; i < kSurveyItems.length; i++) {
        expect(find.text('${i + 1} de ${kSurveyItems.length}'), findsOneWidget);
        await answerCurrent(tester);
      }

      expect(find.text('Sua devolutiva'), findsOneWidget);
      expect(find.text('+50 pontos'), findsOneWidget);
      expect(find.text('Fadiga'), findsOneWidget);

      await tester.tap(find.byTooltip('Voltar'));
      await tester.pumpAndSettle();
      expect(find.text('Questionário já respondido'), findsOneWidget);
      expect(find.textContaining(kNextSurveyLabel), findsOneWidget);
    });

    testWidgets('voltar retorna à afirmação anterior', (tester) async {
      await pumpSurvey(tester, '/questionario');
      await start(tester);
      await answerCurrent(tester);
      expect(find.text('2 de ${kSurveyItems.length}'), findsOneWidget);

      await tester.tap(find.byTooltip('Voltar'));
      await tester.pumpAndSettle();
      expect(find.text('1 de ${kSurveyItems.length}'), findsOneWidget);
    });

    testWidgets('resultado aberto direto mostra exemplo', (tester) async {
      await pumpSurvey(tester, '/questionario/resultado');
      expect(find.text('Exemplo de devolutiva'), findsOneWidget);
      expect(find.text('+50 pontos'), findsNothing);
    });
  });
}
