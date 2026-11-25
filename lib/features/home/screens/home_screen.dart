import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/widgets.dart';

/// Tela Início (`/inicio`) — placeholder da Fase 2.
///
/// O cabeçalho traz o avatar do motorista (leva a `/mais`), conforme a decisão
/// de navegação do CLAUDE.md.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BreatheScaffold(
      title: 'Bom dia, Carlos',
      subtitle: 'Vamos fazer um dia equilibrado',
      action: _ProfileAvatar(onTap: () => context.push('/mais')),
      body: const EmptyState(
        title: 'Em construção',
        message: 'A tela de início será montada em breve.',
        icon: Icons.wb_sunny_outlined,
      ),
    );
  }
}

/// Avatar com as iniciais do motorista, no canto do cabeçalho.
class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.mint,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: const SizedBox.square(
          dimension: 44,
          child: Center(
            child: Text(
              'CS',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
