import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/app_spacing.dart';
import 'breathe_header.dart';

/// Scaffold padrão das telas: [BreatheHeader] no topo e o [body] abaixo.
///
/// O ícone de Ajuda do cabeçalho leva a `/ajuda` por padrão (pode ser trocado
/// via [onHelp] ou escondido com [showHelp] = false, como na própria tela de
/// ajuda). Com [scrollable], o corpo vira rolável com padding padrão.
class BreatheScaffold extends StatelessWidget {
  const BreatheScaffold({
    super.key,
    required this.title,
    required this.body,
    this.subtitle,
    this.action,
    this.onHelp,
    this.showHelp = true,
    this.scrollable = false,
    this.floatingActionButton,
  });

  final String title;
  final Widget body;
  final String? subtitle;
  final Widget? action;
  final VoidCallback? onHelp;
  final bool showHelp;
  final bool scrollable;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    final VoidCallback? effectiveOnHelp =
        showHelp ? (onHelp ?? () => context.push('/ajuda')) : null;

    return Scaffold(
      floatingActionButton: floatingActionButton,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          BreatheHeader(
            title: title,
            subtitle: subtitle,
            action: action,
            onHelp: effectiveOnHelp,
            showHelp: showHelp,
          ),
          Expanded(
            child: scrollable
                ? SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: body,
                  )
                : body,
          ),
        ],
      ),
    );
  }
}
