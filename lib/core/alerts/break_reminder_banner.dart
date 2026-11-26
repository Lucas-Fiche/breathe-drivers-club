import 'dart:async';

import 'package:flutter/material.dart';

import '../../app/health_limits.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';

/// Banner de lembrete de pausa, no estilo de notificação, que desce do topo.
/// Some sozinho depois de [autoHide] ou ao tocar em fechar.
class BreakReminderBanner extends StatefulWidget {
  const BreakReminderBanner({
    super.key,
    required this.onPause,
    required this.onDismiss,
    this.autoHide = const Duration(seconds: 10),
  });

  final VoidCallback onPause;
  final VoidCallback onDismiss;
  final Duration autoHide;

  @override
  State<BreakReminderBanner> createState() => _BreakReminderBannerState();
}

class _BreakReminderBannerState extends State<BreakReminderBanner> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(widget.autoHide, widget.onDismiss);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final int hours = HealthLimits.breakReminderHours.round();
    return Semantics(
      liveRegion: true,
      container: true,
      child: Material(
        color: AppColors.surface,
        elevation: 6,
        shadowColor: AppColors.primaryDark.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.xs,
            AppSpacing.sm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: AppColors.coralSoft,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.local_cafe_outlined,
                      color: AppColors.coral,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.xs),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Hora de uma pausa',
                            style: textTheme.labelLarge,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            'Já são ${hours}h sem pausa. Uma parada de 5 '
                            'minutos ajuda a manter a atenção.',
                            style: textTheme.bodyMedium?.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Sem tooltip: este banner fica acima do Navigator, onde não
                  // há Overlay para o balão do tooltip.
                  IconButton(
                    onPressed: widget.onDismiss,
                    icon: const Icon(
                      Icons.close_rounded,
                      color: AppColors.textSecondary,
                      semanticLabel: 'Fechar lembrete',
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.sm),
                  child: TextButton.icon(
                    onPressed: widget.onPause,
                    icon: const Icon(Icons.air_rounded),
                    label: const Text('Pausar agora'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      minimumSize: const Size(0, 48),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
