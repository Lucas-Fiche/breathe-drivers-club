import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/models.dart';
import '../../../data/providers/providers.dart';

/// Seção "Programas de estudo": cards maiores com inscrição simulada.
class StudyProgramsSection extends ConsumerWidget {
  const StudyProgramsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final List<StudyProgram> programs =
        ref.watch(benefitsProvider).studyPrograms;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Text('Programas de estudo', style: textTheme.titleMedium),
        ),
        for (final StudyProgram p in programs) ...<Widget>[
          _ProgramCard(program: p),
          const SizedBox(height: AppSpacing.md),
        ],
      ],
    );
  }
}

class _ProgramCard extends StatelessWidget {
  const _ProgramCard({required this.program});

  final StudyProgram program;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return BreatheCard(
      color: AppColors.mint,
      borderColor: AppColors.mint,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const Icon(Icons.school_outlined, color: AppColors.primary),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: Text(program.title, style: textTheme.titleMedium)),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            program.description,
            style: textTheme.bodyMedium?.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Parceria: ${program.provider}',
            style: textTheme.bodySmall,
          ),
          const SizedBox(height: AppSpacing.lg),
          PrimaryButton(
            label: 'Quero participar',
            onPressed: () => _enroll(context),
          ),
        ],
      ),
    );
  }

  Future<void> _enroll(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Inscrição enviada! 🎉'),
        content: Text(
          'Recebemos seu interesse em "${program.title}". A equipe de '
          '${program.provider} vai entrar em contato com os próximos passos.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Entendi'),
          ),
        ],
      ),
    );
  }
}
