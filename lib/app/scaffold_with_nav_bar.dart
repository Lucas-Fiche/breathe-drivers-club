import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'theme/app_colors.dart';
import 'theme/app_spacing.dart';

/// Shell das 5 abas principais: mantém o estado de cada aba (indexedStack),
/// a barra inferior customizada e o FAB do Assistente.
///
/// Enquanto a pessoa rola a tela, o FAB fica translúcido para não esconder o
/// conteúdo; ao parar de rolar, ele volta ao normal depois de um instante.
class ScaffoldWithNavBar extends StatefulWidget {
  const ScaffoldWithNavBar({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const List<_TabItem> _tabs = <_TabItem>[
    _TabItem(
      label: 'Início',
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
    ),
    _TabItem(
      label: 'Plano',
      icon: Icons.flag_outlined,
      activeIcon: Icons.flag_rounded,
    ),
    _TabItem(
      label: 'Finanças',
      icon: Icons.account_balance_wallet_outlined,
      activeIcon: Icons.account_balance_wallet_rounded,
    ),
    _TabItem(
      label: 'Apoio',
      icon: Icons.place_outlined,
      activeIcon: Icons.place_rounded,
    ),
    _TabItem(
      label: 'Benefícios',
      icon: Icons.loyalty_outlined,
      activeIcon: Icons.loyalty_rounded,
    ),
  ];

  @override
  State<ScaffoldWithNavBar> createState() => _ScaffoldWithNavBarState();
}

class _ScaffoldWithNavBarState extends State<ScaffoldWithNavBar> {
  /// Tempo parado (sem rolar) até o FAB voltar a ficar opaco.
  static const Duration _restoreDelay = Duration(milliseconds: 900);

  bool _scrolling = false;
  Timer? _restoreTimer;

  @override
  void dispose() {
    _restoreTimer?.cancel();
    super.dispose();
  }

  void _onTap(int index) {
    // Tocar na aba atual volta à raiz dela (initialLocation: true).
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
    _setScrolling(false);
  }

  void _setScrolling(bool value) {
    _restoreTimer?.cancel();
    if (_scrolling != value) setState(() => _scrolling = value);
  }

  bool _onScroll(ScrollNotification notification) {
    // Só a rolagem vertical do conteúdo (ignora carrosséis horizontais).
    if (notification.metrics.axis != Axis.vertical) return false;
    if (notification is ScrollUpdateNotification &&
        (notification.scrollDelta ?? 0) != 0) {
      _setScrolling(true);
    } else if (notification is ScrollEndNotification) {
      _restoreTimer?.cancel();
      _restoreTimer = Timer(_restoreDelay, () {
        if (mounted) _setScrolling(false);
      });
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: _onScroll,
        child: widget.navigationShell,
      ),
      floatingActionButton: _AssistantFab(faded: _scrolling),
      bottomNavigationBar: _NavBar(
        tabs: ScaffoldWithNavBar._tabs,
        currentIndex: widget.navigationShell.currentIndex,
        onTap: _onTap,
      ),
    );
  }
}

class _TabItem {
  const _TabItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });

  final String label;
  final IconData icon;
  final IconData activeIcon;
}

class _NavBar extends StatelessWidget {
  const _NavBar({
    required this.tabs,
    required this.currentIndex,
    required this.onTap,
  });

  final List<_TabItem> tabs;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        // Altura mínima de 66; cresce com o texto ampliado (acessibilidade).
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 66),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                for (int i = 0; i < tabs.length; i++)
                  Expanded(
                    child: _NavItem(
                      item: tabs[i],
                      selected: i == currentIndex,
                      onTap: () => onTap(i),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final _TabItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Color color = selected ? AppColors.primary : AppColors.textSecondary;

    return Semantics(
      button: true,
      selected: selected,
      label: item.label,
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // Traço coral acima do item ativo.
            Container(
              height: 3,
              margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              decoration: BoxDecoration(
                color: selected ? AppColors.coral : AppColors.transparent,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(3),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Icon(
              selected ? item.activeIcon : item.icon,
              color: color,
              size: 24,
            ),
            const SizedBox(height: AppSpacing.xxs),
            // Com texto ampliado, o rótulo encolhe para caber na largura da
            // aba em vez de quebrar ou estourar.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  item.label,
                  maxLines: 1,
                  style: textTheme.labelMedium?.copyWith(
                    color: color,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    );
  }
}

/// FAB do Assistente: balão de conversa, fundo primaryDark, ícone mint.
/// Com [faded], fica translúcido (durante a rolagem), mas continua tocável.
class _AssistantFab extends StatelessWidget {
  const _AssistantFab({required this.faded});

  final bool faded;

  /// Opacidade enquanto a pessoa rola a tela.
  static const double _fadedOpacity = 0.25;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: faded ? _fadedOpacity : 1,
      duration: const Duration(milliseconds: 200),
      child: FloatingActionButton(
        onPressed: () => context.push('/assistente'),
        backgroundColor: AppColors.primaryDark,
        foregroundColor: AppColors.mint,
        elevation: 2,
        shape: const CircleBorder(),
        tooltip: 'Assistente',
        child: const Icon(Icons.chat_bubble_outline_rounded),
      ),
    );
  }
}
