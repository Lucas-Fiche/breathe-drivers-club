import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/assistant/screens/assistant_screen.dart';
import '../features/benefits/screens/benefits_screen.dart';
import '../features/community/screens/community_screen.dart';
import '../features/demo/screens/components_gallery_screen.dart';
import '../features/demo/screens/screens_catalog_screen.dart';
import '../features/finance/screens/finance_screen.dart';
import '../features/help/screens/connecting_screen.dart';
import '../features/help/screens/help_screen.dart';
import '../features/home/screens/break_screen.dart';
import '../features/home/screens/home_screen.dart';
import '../features/more/screens/more_screen.dart';
import '../features/more/screens/privacy_screen.dart';
import '../features/onboarding/screens/access_screen.dart';
import '../features/onboarding/screens/consent_screen.dart';
import '../features/onboarding/screens/initial_profile_screen.dart';
import '../features/plan/screens/plan_screen.dart';
import '../features/support_points/screens/support_points_screen.dart';
import '../features/survey/screens/survey_result_screen.dart';
import '../features/survey/screens/survey_screen.dart';
import 'scaffold_with_nav_bar.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

/// Configuração de rotas do app.
///
/// - As 5 abas ficam num [StatefulShellRoute.indexedStack] (estado preservado).
/// - Todas as demais rotas são de tela cheia (sem barra inferior).
/// - Rota inicial `/acesso`. Sem redirect/bloqueio: qualquer URL abre direto.
/// - Estratégia de URL padrão (com `#`), que funciona no GitHub Pages.
final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/acesso',
  routes: <RouteBase>[
    // Onboarding (tela cheia).
    GoRoute(
      path: '/acesso',
      builder: (BuildContext context, GoRouterState state) =>
          const AccessScreen(),
    ),
    GoRoute(
      path: '/consentimento',
      builder: (BuildContext context, GoRouterState state) =>
          const ConsentScreen(),
    ),
    GoRoute(
      path: '/perfil-inicial',
      builder: (BuildContext context, GoRouterState state) =>
          const InitialProfileScreen(),
    ),

    // Abas principais (com barra inferior + FAB do Assistente).
    StatefulShellRoute.indexedStack(
      builder: (
        BuildContext context,
        GoRouterState state,
        StatefulNavigationShell navigationShell,
      ) =>
          ScaffoldWithNavBar(navigationShell: navigationShell),
      branches: <StatefulShellBranch>[
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/inicio',
              builder: (BuildContext context, GoRouterState state) =>
                  const HomeScreen(),
              routes: <RouteBase>[
                // Pausa guiada: tela cheia (renderiza no navegador raiz).
                GoRoute(
                  path: 'pausa',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (BuildContext context, GoRouterState state) =>
                      const BreakScreen(),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/plano',
              builder: (BuildContext context, GoRouterState state) =>
                  const PlanScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/financas',
              builder: (BuildContext context, GoRouterState state) =>
                  const FinanceScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/apoio',
              builder: (BuildContext context, GoRouterState state) =>
                  const SupportPointsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/beneficios',
              builder: (BuildContext context, GoRouterState state) =>
                  BenefitsScreen(
                initialFilter: state.uri.queryParameters['filtro'],
              ),
            ),
          ],
        ),
      ],
    ),

    // Demais telas cheias.
    GoRoute(
      path: '/assistente',
      builder: (BuildContext context, GoRouterState state) =>
          const AssistantScreen(),
    ),
    GoRoute(
      path: '/comunidade',
      builder: (BuildContext context, GoRouterState state) =>
          const CommunityScreen(),
    ),
    GoRoute(
      path: '/questionario',
      builder: (BuildContext context, GoRouterState state) =>
          const SurveyScreen(),
      routes: <RouteBase>[
        GoRoute(
          path: 'resultado',
          builder: (BuildContext context, GoRouterState state) =>
              const SurveyResultScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/ajuda',
      builder: (BuildContext context, GoRouterState state) =>
          const HelpScreen(),
      routes: <RouteBase>[
        // Simulação do atendimento com psicólogo.
        GoRoute(
          path: 'psicologo',
          builder: (BuildContext context, GoRouterState state) =>
              const ConnectingScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/mais',
      builder: (BuildContext context, GoRouterState state) =>
          const MoreScreen(),
    ),
    GoRoute(
      path: '/privacidade',
      builder: (BuildContext context, GoRouterState state) =>
          const PrivacyScreen(),
    ),

    // Catálogo de telas (apresentação) e catálogo de componentes.
    GoRoute(
      path: '/telas',
      builder: (BuildContext context, GoRouterState state) =>
          const ScreensCatalogScreen(),
    ),
    // Mantida acessível só por URL (fora da navegação principal).
    GoRoute(
      path: '/componentes',
      builder: (BuildContext context, GoRouterState state) =>
          const ComponentsGalleryScreen(),
    ),
  ],
);
