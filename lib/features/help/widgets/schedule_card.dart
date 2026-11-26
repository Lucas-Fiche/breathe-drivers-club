import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../providers.dart';
import 'help_cards.dart';

/// Card "Agendar conversa". Sem agendamento, abre a escolha de horário; com
/// agendamento, mostra a confirmação e permite trocar ou cancelar.
class ScheduleCard extends ConsumerWidget {
  const ScheduleCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final HelpSlot? scheduled = ref.watch(scheduledHelpProvider);

    return BreatheCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const HelpIconBadge(icon: Icons.event_available_rounded),
          const SizedBox(height: AppSpacing.md),
          Text('Agendar conversa', style: textTheme.titleMedium),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Prefere outro momento? Escolha um horário com calma.',
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.lg),
          if (scheduled == null)
            SecondaryButton(
              label: 'Escolher horário',
              icon: Icons.schedule_rounded,
              onPressed: () => _openSlots(context),
            )
          else ...<Widget>[
            _Confirmation(slot: scheduled),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: <Widget>[
                Expanded(
                  child: SecondaryButton(
                    label: 'Trocar',
                    onPressed: () => _openSlots(context),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: SecondaryButton(
                    label: 'Cancelar',
                    onPressed: () =>
                        ref.read(scheduledHelpProvider.notifier).cancel(),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _openSlots(BuildContext context) async {
    final HelpSlot? slot = await showModalBottomSheet<HelpSlot>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.header),
        ),
      ),
      builder: (BuildContext context) => const _SlotsSheet(),
    );
    if (slot == null || !context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Conversa agendada: ${slot.label}.'),
        ),
      );
  }
}

/// Confirmação do horário agendado (mint, com ícone de check).
class _Confirmation extends StatelessWidget {
  const _Confirmation({required this.slot});

  final HelpSlot slot;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.mint,
        borderRadius: BorderRadius.circular(AppRadius.button),
      ),
      child: Row(
        children: <Widget>[
          const Icon(Icons.check_circle_rounded, color: AppColors.primary),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Conversa agendada', style: textTheme.labelLarge),
                Text(
                  '${slot.label}. Você vai receber um lembrete.',
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Bottom sheet com os 3 horários fictícios e o botão de confirmar.
class _SlotsSheet extends ConsumerStatefulWidget {
  const _SlotsSheet();

  @override
  ConsumerState<_SlotsSheet> createState() => _SlotsSheetState();
}

class _SlotsSheetState extends ConsumerState<_SlotsSheet> {
  late String? _selectedId = ref.read(scheduledHelpProvider)?.id;

  void _confirm() {
    final HelpSlot slot = kHelpSlots.firstWhere(
      (HelpSlot s) => s.id == _selectedId,
    );
    ref.read(scheduledHelpProvider.notifier).schedule(slot);
    Navigator.of(context).pop(slot);
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text('Escolha um horário', style: textTheme.titleLarge),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Conversa de 30 minutos, por chat ou ligação.',
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            for (final HelpSlot s in kHelpSlots) ...<Widget>[
              _SlotTile(
                slot: s,
                selected: s.id == _selectedId,
                onTap: () => setState(() => _selectedId = s.id),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
            const SizedBox(height: AppSpacing.md),
            PrimaryButton(
              label: 'Confirmar horário',
              onPressed: _selectedId == null ? null : _confirm,
            ),
          ],
        ),
      ),
    );
  }
}

class _SlotTile extends StatelessWidget {
  const _SlotTile({
    required this.slot,
    required this.selected,
    required this.onTap,
  });

  final HelpSlot slot;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Semantics(
      selected: selected,
      button: true,
      child: BreatheCard(
        color: selected ? AppColors.mint : AppColors.surface,
        borderColor: selected ? AppColors.primary : AppColors.border,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        onTap: onTap,
        child: Row(
          children: <Widget>[
            Icon(
              selected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: selected ? AppColors.primary : AppColors.textSecondary,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: Text(slot.day, style: textTheme.bodyLarge)),
            Text(slot.time, style: textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}
