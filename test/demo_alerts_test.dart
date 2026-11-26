import 'package:breathe_drivers_club/app/health_limits.dart';
import 'package:breathe_drivers_club/core/alerts/alerts_providers.dart';
import 'package:breathe_drivers_club/core/alerts/app_alerts_overlay.dart';
import 'package:breathe_drivers_club/core/widgets/widgets.dart';
import 'package:breathe_drivers_club/data/models/models.dart';
import 'package:breathe_drivers_club/data/providers/providers.dart';
import 'package:breathe_drivers_club/features/demo/screens/screens_catalog_screen.dart';
import 'package:breathe_drivers_club/features/demo/widgets/demo_sheet.dart';
import 'package:breathe_drivers_club/features/home/screens/home_screen.dart';
import 'package:breathe_drivers_club/features/more/screens/more_screen.dart';
import 'package:breathe_drivers_club/features/more/screens/privacy_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

ProviderContainer makeContainer() {
  final ProviderContainer c = ProviderContainer();
  addTearDown(c.dispose);
  return c;
}

/// Monta o app como o `app.dart` (gesto escondido + overlay de alertas), com
/// telas reais onde importa e marcadores simples no resto. Usa o tema padrão
/// (sem google_fonts).
Future<ProviderContainer> pumpApp(WidgetTester tester, String location) async {
  tester.view.physicalSize = const Size(400, 860);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  Widget marker(String text) => Scaffold(body: Center(child: Text(text)));
  final GoRouter router = GoRouter(
    initialLocation: location,
    routes: <RouteBase>[
      GoRoute(path: '/acesso', builder: (_, _) => marker('Tela de acesso')),
      GoRoute(
        path: '/inicio',
        builder: (_, _) => const HomeScreen(),
        routes: <RouteBase>[
          GoRoute(path: 'pausa', builder: (_, _) => marker('Pausa guiada')),
        ],
      ),
      GoRoute(path: '/mais', builder: (_, _) => const MoreScreen()),
      GoRoute(path: '/privacidade', builder: (_, _) => const PrivacyScreen()),
      GoRoute(path: '/telas', builder: (_, _) => const ScreensCatalogScreen()),
      GoRoute(path: '/outra', builder: (_, _) => marker('Outra tela')),
    ],
  );

  final ProviderContainer container = makeContainer();
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(
        routerConfig: router,
        builder: (BuildContext context, Widget? child) => SecretGestureScope(
          onTrigger: showDemoSheet,
          child: AppAlertsOverlay(router: router, child: child!),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return container;
}

const String kJourneyText = 'Que tal encerrar ou fazer uma pausa longa?';

void main() {
  group('providers dos alertas', () {
    test('jornada longa: aparece no limite e respeita pausa e adiamento', () {
      final ProviderContainer c = makeContainer();
      expect(c.read(longJourneyDueProvider), isFalse);

      c
          .read(planProvider.notifier)
          .setOnlineHours(HealthLimits.longJourneyHours);
      expect(c.read(longJourneyDueProvider), isTrue);

      c.read(longJourneyAlertProvider.notifier).snooze();
      expect(c.read(longJourneyDueProvider), isFalse);

      c.read(longJourneyAlertProvider.notifier).rearm();
      expect(c.read(longJourneyDueProvider), isTrue);

      c.read(longJourneyAlertProvider.notifier).acknowledge();
      expect(c.read(longJourneyDueProvider), isFalse);
    });

    test('horas online nunca ficam negativas', () {
      final ProviderContainer c = makeContainer();
      c.read(planProvider.notifier).setOnlineHours(-3);
      expect(c.read(planProvider).workDay.onlineHours, 0);
    });

    test('reconhecimento credita os pontos', () {
      final ProviderContainer c = makeContainer();
      final int before = c.read(profileProvider).profile.points;
      c
          .read(recognitionProvider.notifier)
          .celebrate(points: 20, message: 'teste');
      expect(c.read(profileProvider).profile.points, before + 20);
      expect(c.read(recognitionProvider)?.points, 20);
    });

    test('selo de destaque soma metas, pausas e questionário', () {
      final ProviderContainer c = makeContainer();
      final int before = c.read(highlightProvider).value;
      c.read(planProvider.notifier).registerBreak();
      expect(c.read(highlightProvider).value, before + 1);
    });
  });

  group('overlay de alertas', () {
    testWidgets('alerta de jornada só aparece no Início; pausa navega', (
      WidgetTester tester,
    ) async {
      final ProviderContainer c = await pumpApp(tester, '/outra');
      c
          .read(planProvider.notifier)
          .setOnlineHours(HealthLimits.longJourneyHours);
      await tester.pumpAndSettle();
      expect(find.text(kJourneyText), findsNothing);

      GoRouter.of(tester.element(find.text('Outra tela'))).go('/inicio');
      await tester.pumpAndSettle();
      expect(find.text(kJourneyText), findsOneWidget);
      expect(find.text('Você está há 10h online.'), findsOneWidget);

      await tester.tap(find.text('Fazer pausa agora'));
      await tester.pumpAndSettle();
      expect(find.text('Pausa guiada'), findsOneWidget);
      expect(c.read(longJourneyAlertProvider).acknowledged, isTrue);
    });

    testWidgets('lembrar em 30 min fecha o alerta e ele volta depois', (
      tester,
    ) async {
      final ProviderContainer c = await pumpApp(tester, '/inicio');
      c
          .read(planProvider.notifier)
          .setOnlineHours(HealthLimits.longJourneyHours);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Lembrar em 30 min'));
      await tester.pumpAndSettle();
      expect(find.text(kJourneyText), findsNothing);

      // Depois de 30 minutos, o alerta volta.
      await tester.pump(LongJourneyAlertNotifier.snoozeDuration);
      await tester.pumpAndSettle();
      expect(find.text(kJourneyText), findsOneWidget);
    });

    testWidgets('banner de pausa aparece, fecha e some sozinho', (
      tester,
    ) async {
      final ProviderContainer c = await pumpApp(tester, '/outra');
      c.read(breakReminderProvider.notifier).show();
      await tester.pumpAndSettle();
      expect(find.textContaining('Já são 2h sem pausa'), findsOneWidget);

      await tester.tap(find.bySemanticsLabel('Fechar lembrete'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Já são 2h sem pausa'), findsNothing);

      c.read(breakReminderProvider.notifier).show();
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 11));
      await tester.pumpAndSettle();
      expect(c.read(breakReminderProvider), isFalse);
    });

    testWidgets('toast de reconhecimento some sozinho', (tester) async {
      final ProviderContainer c = await pumpApp(tester, '/outra');
      c
          .read(recognitionProvider.notifier)
          .celebrate(points: 20, message: 'você cuidou de você hoje');
      await tester.pump();
      expect(find.textContaining('você cuidou de você hoje'), findsOneWidget);
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();
      expect(c.read(recognitionProvider), isNull);
    });
  });

  group('modo apresentação', () {
    testWidgets('toque longo no logo abre o menu', (tester) async {
      await pumpApp(tester, '/mais');
      await tester.longPress(find.byType(BreatheLogo).first);
      await tester.pumpAndSettle();
      expect(find.text('Modo apresentação'), findsOneWidget);
    });

    testWidgets('5 toques no avatar abrem o menu; 1 toque abre Mais', (
      tester,
    ) async {
      await pumpApp(tester, '/inicio');
      final Finder avatar = find.byTooltip('Perfil e mais opções');
      for (int i = 0; i < 5; i++) {
        await tester.tap(avatar);
        await tester.pump(const Duration(milliseconds: 100));
      }
      await tester.pumpAndSettle();
      expect(find.text('Modo apresentação'), findsOneWidget);

      Navigator.of(tester.element(find.text('Modo apresentação'))).pop();
      await tester.pumpAndSettle();
      // Toque simples: espera a janela dos toques rápidos e abre Mais.
      await tester.tap(avatar);
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();
      expect(
        find.text('Perfil, privacidade e outros recursos'),
        findsOneWidget,
      );
    });

    testWidgets('trocar persona e resetar pelo menu', (tester) async {
      final ProviderContainer c = await pumpApp(tester, '/mais');
      await tester.longPress(find.byType(BreatheLogo).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Trocar persona'));
      await tester.pumpAndSettle();
      expect(c.read(personaProvider), Persona.joana);
      expect(find.text('Joana Lima'), findsOneWidget);

      await tester.longPress(find.byType(BreatheLogo).first);
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text('Resetar dados'),
        100,
        scrollable: find.byType(Scrollable).last,
      );
      await tester.tap(find.text('Resetar dados'));
      await tester.pumpAndSettle();
      expect(c.read(personaProvider), Persona.carlos);
    });

    testWidgets('catálogo: estado especial dispara o alerta de jornada', (
      tester,
    ) async {
      await pumpApp(tester, '/telas');
      await tester.scrollUntilVisible(
        find.text('Alerta de jornada longa'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Alerta de jornada longa'));
      await tester.pumpAndSettle();
      expect(find.text(kJourneyText), findsOneWidget);
    });
  });

  group('Mais e Privacidade', () {
    testWidgets('Mais mostra o perfil e Sair volta ao acesso', (tester) async {
      await pumpApp(tester, '/mais');
      expect(find.text('Carlos Souza'), findsOneWidget);
      expect(find.textContaining('Brasília'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('Sair'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Sair'));
      await tester.pumpAndSettle();
      expect(find.text('Tela de acesso'), findsOneWidget);
    });

    testWidgets('interruptor da Privacidade grava no mesmo provider', (
      tester,
    ) async {
      final ProviderContainer c = await pumpApp(tester, '/privacidade');
      final bool before = c.read(profileProvider).consent.shareUsage;
      await tester.scrollUntilVisible(
        find.text('Uso do app'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Uso do app'));
      await tester.pumpAndSettle();
      expect(c.read(profileProvider).consent.shareUsage, !before);
    });

    testWidgets('baixar meus dados pede confirmação', (tester) async {
      await pumpApp(tester, '/privacidade');
      await tester.scrollUntilVisible(
        find.text('Baixar meus dados'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Baixar meus dados'));
      await tester.pumpAndSettle();
      expect(find.text('Baixar meus dados?'), findsOneWidget);
      await tester.tap(find.text('Pedir arquivo'));
      await tester.pumpAndSettle();
      expect(find.text('Pedido registrado'), findsOneWidget);
    });
  });
}
