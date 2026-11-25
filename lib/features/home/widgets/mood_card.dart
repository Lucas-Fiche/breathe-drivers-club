import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/models.dart';
import '../../../data/providers/providers.dart';

/// Card "Como você está hoje?": chips de humor. Ao tocar, registra e mostra uma
/// resposta curta e acolhedora; em Estressado/Sobrecarregado, oferece ajuda.
class MoodCard extends ConsumerStatefulWidget {
  const MoodCard({super.key});

  @override
  ConsumerState<MoodCard> createState() => _MoodCardState();
}

class _MoodCardState extends ConsumerState<MoodCard> {
  static const List<Mood> _moods = <Mood>[
    Mood.bem,
    Mood.cansado,
    Mood.estressado,
    Mood.sobrecarregado,
  ];
  static const List<String> _labels = <String>[
    'Bem',
    'Cansado',
    'Estressado',
    'Sobrecarregado',
  ];

  int? _selected;

  void _select(int index) {
    setState(() => _selected = index);
    ref.read(planProvider.notifier).registerMood(_moods[index]);
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return BreatheCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SectionTitle(title: 'Como você está hoje?'),
          const SizedBox(height: AppSpacing.lg),
          ChipGroup(
            options: _labels,
            selectedIndex: _selected ?? -1,
            onSelected: _select,
          ),
          const SizedBox(height: AppSpacing.md),
          if (_selected == null)
            Text(
              'Toque para registrar. É só para você.',
              style: textTheme.bodyMedium,
            )
          else
            _MoodResponse(mood: _moods[_selected!]),
        ],
      ),
    );
  }
}

class _MoodResponse extends StatelessWidget {
  const _MoodResponse({required this.mood});

  final Mood mood;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final bool offerHelp =
        mood == Mood.estressado || mood == Mood.sobrecarregado;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: offerHelp ? AppColors.coralSoft : AppColors.mint,
        borderRadius: BorderRadius.circular(AppRadius.button),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            _message(mood),
            style: textTheme.bodyMedium?.copyWith(color: AppColors.textPrimary),
          ),
          if (offerHelp) ...<Widget>[
            const SizedBox(height: AppSpacing.sm),
            GestureDetector(
              onTap: () => context.push('/ajuda'),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Icon(Icons.favorite_rounded,
                      size: 16, color: AppColors.coral),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    'Falar com alguém que pode ajudar',
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.coral,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _message(Mood mood) {
    switch (mood) {
      case Mood.bem:
        return 'Que bom! Aproveite o dia com leveza.';
      case Mood.cansado:
        return 'Cansaço é sinal de que você vem se dedicando. Que tal uma pausa?';
      case Mood.estressado:
        return 'Respira. Dias assim passam. Você não precisa segurar tudo sozinho.';
      case Mood.sobrecarregado:
        return 'Dar conta de tudo é pesado. Buscar apoio é cuidar de você.';
    }
  }
}
