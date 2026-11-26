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
import 'page_transitions.dart';
import 'scaffold_with_nav_bar.dart';

/// Configuração de rotas do app.
///
/// - As 5 abas ficam num [StatefulShellRoute.indexedStack] (estado preservado).
/// - Todas as demais rotas são de tela cheia (sem barra inferior).
/// - Rota inicial `/acesso`. Sem redirect/bloqueio: qualquer URL abre direto.
/// - Estratégia de URL padrão (com `#`), que funciona no GitHub Pages.
final GoRouter appRouter = createAppRouter();

/// Cria o roteador. Uma função (e não só a instância global) para os testes
/// abrirem qualquer rota num roteador novo.
GoRouter createAppRouter({String initialLocation = '/acesso'}) {
  final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(
    debugLabel: 'root',
  );
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: initialLocation,
    routes: <RouteBase>[
      // Onboarding (tela cheia).
      GoRoute(
        path: '/acesso',
        pageBuilder: (BuildContext context, GoRouterState state) =>
            fadeSlidePage(state, const AccessScreen()),
      ),
      GoRoute(
        path: '/consentimento',
        pageBuilder: (BuildContext context, GoRouterState state) =>
            fadeSlidePage(state, const ConsentScreen()),
      ),
      GoRoute(
        path: '/perfil-inicial',
        pageBuilder: (BuildContext context, GoRouterState state) =>
            fadeSlidePage(state, const InitialProfileScreen()),
      ),

      // Abas principais (com barra inferior + FAB do Assistente).
      StatefulShellRoute.indexedStack(
        builder:
            (
              BuildContext context,
              GoRouterState state,
              StatefulNavigationShell navigationShell,
            ) => ScaffoldWithNavBar(navigationShell: navigationShell),
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
                    parentNavigatorKey: rootNavigatorKey,
                    pageBuilder: (BuildContext context, GoRouterState state) =>
                        fadeSlidePage(state, const BreakScreen()),
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
        pageBuilder: (BuildContext context, GoRouterState state) =>
            fadeSlidePage(state, const AssistantScreen()),
      ),
      GoRoute(
        path: '/comunidade',
        pageBuilder: (BuildContext context, GoRouterState state) =>
            fadeSlidePage(state, const CommunityScreen()),
      ),
      GoRoute(
        path: '/questionario',
        pageBuilder: (BuildContext context, GoRouterState state) =>
            fadeSlidePage(state, const SurveyScreen()),
        routes: <RouteBase>[
          GoRoute(
            path: 'resultado',
            pageBuilder: (BuildContext context, GoRouterState state) =>
                fadeSlidePage(state, const SurveyResultScreen()),
          ),
        ],
      ),
      GoRoute(
        path: '/ajuda',
        pageBuilder: (BuildContext context, GoRouterState state) =>
            fadeSlidePage(state, const HelpScreen()),
        routes: <RouteBase>[
          // Simulação do atendimento com psicólogo.
          GoRoute(
            path: 'psicologo',
            pageBuilder: (BuildContext context, GoRouterState state) =>
                fadeSlidePage(state, const ConnectingScreen()),
          ),
        ],
      ),
      GoRoute(
        path: '/mais',
        pageBuilder: (BuildContext context, GoRouterState state) =>
            fadeSlidePage(state, const MoreScreen()),
      ),
      GoRoute(
        path: '/privacidade',
        pageBuilder: (BuildContext context, GoRouterState state) =>
            fadeSlidePage(state, const PrivacyScreen()),
      ),

      // Catálogo de telas (apresentação) e catálogo de componentes.
      GoRoute(
        path: '/telas',
        pageBuilder: (BuildContext context, GoRouterState state) =>
            fadeSlidePage(state, const ScreensCatalogScreen()),
      ),
      // Mantida acessível só por URL (fora da navegação principal).
      GoRoute(
        path: '/componentes',
        pageBuilder: (BuildContext context, GoRouterState state) =>
            fadeSlidePage(state, const ComponentsGalleryScreen()),
      ),
    ],
  );
}
