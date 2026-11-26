import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../data/models/models.dart';
import '../../../data/providers/providers.dart';
import '../demo_actions.dart';

/// Abre o bottom sheet "Modo apresentação". Ligado ao gesto escondido
/// (toque longo no logo ou 5 toques no avatar) pelo `app.dart`.
Future<void> showDemoSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.background,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppRadius.header),
      ),
    ),
    builder: (BuildContext sheetContext) => _DemoSheet(hostContext: context),
  );
}

class _DemoSheet extends ConsumerWidget {
  const _DemoSheet({required this.hostContext});

  /// Contexto da tela que abriu o sheet (usado para navegar e mostrar
  /// mensagens depois que o sheet fecha).
  final BuildContext hostContext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Persona persona = ref.watch(personaProvider);
    final Persona other = persona == Persona.carlos
        ? Persona.joana
        : Persona.carlos;

    void run(void Function() action, {String? message}) {
      action();
      Navigator.of(context).pop();
      if (message != null && hostContext.mounted) {
        ScaffoldMessenger.of(hostContext)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text(message),
            ),
          );
      }
    }

    final String path = GoRouterState.of(hostContext).uri.path;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                const Icon(Icons.slideshow_rounded, color: AppColors.primary),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text('Modo apresentação', style: textTheme.titleLarge),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Atalhos para demonstrar o protótipo. Persona atual: '
              '${persona.displayName}.',
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            _DemoAction(
              icon: Icons.schedule_rounded,
              title: 'Simular 10h de jornada',
              subtitle: 'O alerta aparece no Início',
              onTap: () => run(
                () => simulateLongJourney(ref),
                message: path == '/inicio'
                    ? null
                    : 'Pronto. Volte ao Início para ver o alerta de jornada.',
              ),
            ),
            _DemoAction(
              icon: Icons.notifications_active_outlined,
              title: 'Disparar lembrete de pausa',
              subtitle: 'Banner no topo, em qualquer tela',
              onTap: () => run(() => triggerBreakReminder(ref)),
            ),
            _DemoAction(
              icon: Icons.stars_rounded,
              title: 'Mostrar reconhecimento',
              subtitle: '+$kDemoRecognitionPoints pontos por cuidar de si',
              onTap: () => run(() => showRecognition(ref)),
            ),
            _DemoAction(
              icon: Icons.switch_account_outlined,
              title: 'Trocar persona',
              subtitle: 'Ver o app como ${other.displayName}',
              onTap: () => run(
                () => togglePersona(ref),
                message:
                    'Agora você está vendo o app como '
                    '${other.displayName}.',
              ),
            ),
            _DemoAction(
              icon: Icons.grid_view_rounded,
              title: 'Abrir catálogo de telas',
              subtitle: 'Todas as telas e estados especiais',
              onTap: () => run(() => hostContext.go('/telas')),
            ),
            _DemoAction(
              icon: Icons.restart_alt_rounded,
              title: 'Resetar dados',
              subtitle: 'Volta tudo ao início, com Carlos',
              onTap: () => run(
                () => resetDemoData(ref),
                message: 'Dados fictícios restaurados.',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DemoAction extends StatelessWidget {
  const _DemoAction({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return ListTile(
      onTap: onTap,
      minVerticalPadding: AppSpacing.md,
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: AppColors.mint,
        child: Icon(icon, color: AppColors.primary),
      ),
      title: Text(title, style: textTheme.labelLarge),
      subtitle: Text(subtitle, style: textTheme.bodyMedium),
    );
  }
}
