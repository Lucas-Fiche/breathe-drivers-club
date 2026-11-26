import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/models.dart';
import '../../../data/providers/providers.dart';
import '../widgets/event_tile.dart';
import '../widgets/point_details_sheet.dart';
import '../widgets/support_map.dart';
import '../widgets/support_point_tile.dart';

/// Tela Pontos de apoio (`/apoio`): mapa ilustrado, alternância pontos/eventos e
/// as listas correspondentes.
class SupportPointsScreen extends ConsumerStatefulWidget {
  const SupportPointsScreen({super.key});

  @override
  ConsumerState<SupportPointsScreen> createState() =>
      _SupportPointsScreenState();
}

class _SupportPointsScreenState extends ConsumerState<SupportPointsScreen> {
  bool _showingEvents = false;
  String? _selectedEventId;

  @override
  Widget build(BuildContext context) {
    final SupportState state = ref.watch(supportProvider);

    return BreatheScaffold(
      title: 'Pontos de apoio',
      subtitle: 'Descanso, convivência e eventos perto de você',
      scrollable: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SupportMap(
            showingEvents: _showingEvents,
            selectedEventId: _selectedEventId,
            onSelectPoint: (String id) =>
                ref.read(supportProvider.notifier).startRoute(id),
            onSelectEvent: (String id) =>
                setState(() => _selectedEventId = id),
          ),
          const SizedBox(height: AppSpacing.lg),
          ChipGroup(
            options: const <String>['Pontos de apoio', 'Eventos'],
            selectedIndex: _showingEvents ? 1 : 0,
            onSelected: (int i) => setState(() => _showingEvents = i == 1),
          ),
          const SizedBox(height: AppSpacing.lg),
          if (_showingEvents)
            for (final Event e in state.events) ...<Widget>[
              EventTile(
                event: e,
                selected: e.id == _selectedEventId,
                onTap: () => setState(() => _selectedEventId = e.id),
              ),
              const SizedBox(height: AppSpacing.md),
            ]
          else
            for (final SupportPoint p in state.supportPoints) ...<Widget>[
              SupportPointTile(
                point: p,
                selected: p.id == state.activePointId,
                onTap: () {
                  ref.read(supportProvider.notifier).startRoute(p.id);
                  showPointDetailsSheet(context, p);
                },
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          const SizedBox(height: AppSpacing.sm),
        ],
      ),
    );
  }
}
