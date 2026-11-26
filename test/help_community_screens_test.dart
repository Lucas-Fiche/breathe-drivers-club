import 'package:breathe_drivers_club/features/community/screens/community_screen.dart';
import 'package:breathe_drivers_club/features/help/screens/connecting_screen.dart';
import 'package:breathe_drivers_club/features/help/screens/help_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

/// Monta o app com um roteador mínimo. Usa o tema padrão do Material (sem
/// google_fonts, que tentaria baixar a fonte durante o teste).
Future<void> pumpAt(
  WidgetTester tester,
  String location, {
  bool settle = true,
}) async {
  tester.view.physicalSize = const Size(400, 860);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final GoRouter router = GoRouter(
    initialLocation: location,
    routes: <RouteBase>[
      GoRoute(
        path: '/inicio',
        builder: (_, _) => const Scaffold(body: Text('Início')),
        routes: <RouteBase>[
          GoRoute(
            path: 'pausa',
            builder: (_, _) => const Scaffold(body: Text('Pausa')),
          ),
        ],
      ),
      GoRoute(
        path: '/ajuda',
        builder: (_, _) => const HelpScreen(),
        routes: <RouteBase>[
          GoRoute(
            path: 'psicologo',
            builder: (_, _) => const ConnectingScreen(),
          ),
        ],
      ),
      GoRoute(path: '/comunidade', builder: (_, _) => const CommunityScreen()),
    ],
  );
  await tester.pumpWidget(
    ProviderScope(child: MaterialApp.router(routerConfig: router)),
  );
  if (settle) {
    await tester.pumpAndSettle();
  } else {
    await tester.pump();
  }
}

void main() {
  group('Ajuda', () {
    testWidgets('mostra canais, emergência e nota de sigilo', (tester) async {
      await pumpAt(tester, '/ajuda');
      expect(find.text('Falar com um psicólogo agora'), findsOneWidget);
      expect(find.text('Agendar conversa'), findsOneWidget);
      expect(find.text('Exercício rápido'), findsOneWidget);
      await tester.scrollUntilVisible(find.text('192'), 200);
      expect(find.text('188'), findsOneWidget);
      expect(
        find.text(
          'Seu pedido de ajuda é sigiloso. A empresa não sabe quem pediu.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('agendar: escolhe horário e mostra a confirmação', (
      tester,
    ) async {
      await pumpAt(tester, '/ajuda');
      await tester.tap(find.text('Escolher horário'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Amanhã'));
      await tester.pump();
      await tester.tap(find.text('Confirmar horário'));
      await tester.pumpAndSettle();
      expect(find.text('Conversa agendada'), findsOneWidget);
    });

    testWidgets('CVV mostra o número sem ligar', (tester) async {
      await pumpAt(tester, '/ajuda');
      await tester.scrollUntilVisible(find.text('188'), 200);
      await tester.tap(find.text('188'));
      await tester.pumpAndSettle();
      expect(find.text('Ligar para o CVV'), findsOneWidget);
    });

    testWidgets('atendimento: conecta e depois explica a versão real', (
      tester,
    ) async {
      await pumpAt(tester, '/ajuda/psicologo', settle: false);
      expect(find.text('Conectando você a um profissional…'), findsOneWidget);
      await tester.pump(ConnectingScreen.connectDelay);
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.text('5 min'), findsOneWidget);
    });
  });

  group('Comunidade', () {
    testWidgets('filtro mostra só a categoria escolhida', (tester) async {
      await pumpAt(tester, '/comunidade');
      expect(find.text('Marcos A.'), findsOneWidget); // Conquista
      await tester.tap(find.text('Pontos de apoio'));
      await tester.pumpAndSettle();
      expect(find.text('João P.'), findsOneWidget);
      expect(find.text('Marcos A.'), findsNothing);
    });

    testWidgets('regras de convivência recolhem', (tester) async {
      await pumpAt(tester, '/comunidade');
      expect(find.text('Respeito com todo mundo, sempre.'), findsOneWidget);
      await tester.tap(find.text('Regras de convivência'));
      await tester.pumpAndSettle();
      expect(find.text('Respeito com todo mundo, sempre.'), findsNothing);
    });

    testWidgets('publicar coloca o post no topo do feed', (tester) async {
      await pumpAt(tester, '/comunidade');
      await tester.tap(find.text('Publicar'));
      await tester.pumpAndSettle();
      expect(
        find.textContaining('Não compartilhe dados pessoais'),
        findsOneWidget,
      );
      await tester.enterText(find.byType(TextField), 'Hoje fiz 3 pausas!');
      await tester.pump();
      await tester.tap(find.widgetWithText(ElevatedButton, 'Publicar'));
      await tester.pumpAndSettle();
      expect(find.text('Hoje fiz 3 pausas!'), findsOneWidget);
      expect(find.text('Carlos Souza'), findsOneWidget);
    });

    testWidgets('denunciar confirma que a moderação vai analisar', (
      tester,
    ) async {
      await pumpAt(tester, '/comunidade');
      await tester.tap(find.byTooltip('Mais opções').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Denunciar'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(TextButton, 'Denunciar'));
      await tester.pumpAndSettle();
      expect(
        find.text('Obrigado. Nossa moderação vai analisar.'),
        findsOneWidget,
      );
    });
  });
}
