import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/app_colors.dart';
import '../../data/providers/providers.dart';
import '../utils/formatters.dart';
import 'secret_gesture.dart';

/// Avatar com as iniciais da pessoa ativa, no canto do cabeçalho de todas as
/// telas. Um toque abre `/mais` (perfil e outros recursos); 5 toques rápidos
/// abrem o modo apresentação (gesto escondido).
class ProfileAvatarButton extends ConsumerWidget {
  const ProfileAvatarButton({super.key});

  /// Área de toque ≥ 48 px.
  static const double size = 48;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String name = ref.watch(profileProvider).profile.name;
    return Tooltip(
      message: 'Perfil e mais opções',
      child: SecretTapDetector(
        onTap: () => context.push('/mais'),
        child: Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: AppColors.mint,
            shape: BoxShape.circle,
          ),
          child: Text(
            initialsOf(name),
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
