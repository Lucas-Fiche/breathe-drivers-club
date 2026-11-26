import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/utils/navigation.dart';
import '../../../core/widgets/widgets.dart';
import '../widgets/about_sheet.dart';
import '../widgets/profile_card.dart';

/// Tela Mais (`/mais`): perfil e os recursos que não cabem na barra de abas.
class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BreatheScaffold(
      title: 'Mais',
      subtitle: 'Perfil, privacidade e outros recursos',
      onBack: () => popOrGo(context),
      showProfile: false, // já é a tela do perfil
      scrollable: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const ProfileCard(),
          const SizedBox(height: AppSpacing.lg),
          BreatheCard(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
            child: Column(
              children: <Widget>[
                _MenuItem(
                  icon: Icons.groups_outlined,
                  title: 'Comunidade',
                  subtitle: 'Troque experiências',
                  onTap: () => context.push('/comunidade'),
                ),
                const _MenuDivider(),
                _MenuItem(
                  icon: Icons.assignment_outlined,
                  title: 'Questionário semestral',
                  subtitle: 'Como tem sido o seu trabalho',
                  onTap: () => context.push('/questionario'),
                ),
                const _MenuDivider(),
                _MenuItem(
                  icon: Icons.lock_outline_rounded,
                  title: 'Privacidade e dados',
                  subtitle: 'O que você compartilha',
                  onTap: () => context.push('/privacidade'),
                ),
                const _MenuDivider(),
                _MenuItem(
                  icon: Icons.favorite_border_rounded,
                  title: 'Ajuda',
                  subtitle: 'Acolhimento gratuito e sigiloso',
                  onTap: () => context.push('/ajuda'),
                ),
                const _MenuDivider(),
                _MenuItem(
                  icon: Icons.info_outline_rounded,
                  title: 'Sobre o Breathe',
                  subtitle: 'Para que serve o app',
                  onTap: () => showAboutBreatheSheet(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          BreatheCard(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
            child: _MenuItem(
              icon: Icons.logout_rounded,
              title: 'Sair',
              onTap: () => context.go('/acesso'),
              showChevron: false,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.showChevron = true,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return ListTile(
      onTap: onTap,
      minVerticalPadding: AppSpacing.md,
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: textTheme.titleMedium),
      subtitle: subtitle == null
          ? null
          : Text(subtitle!, style: textTheme.bodyMedium),
      trailing: showChevron
          ? const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textSecondary,
            )
          : null,
    );
  }
}

class _MenuDivider extends StatelessWidget {
  const _MenuDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      indent: AppSpacing.lg,
      endIndent: AppSpacing.lg,
    );
  }
}
