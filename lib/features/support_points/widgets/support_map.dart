import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../data/models/models.dart';
import '../../../data/providers/providers.dart';

/// Posição fixa do "Você" no mapa ilustrado (fração 0–1).
const Offset _youFraction = Offset(0.20, 0.52);
const double _mapHeight = 240;

/// Mapa ILUSTRADO dos pontos de apoio e eventos (sem pacote de mapas).
///
/// Desenha cidade estilizada, pins/losangos e um ponto "Você" pulsante. Ao
/// selecionar um ponto, anima o desenho da rota em L.
class SupportMap extends ConsumerStatefulWidget {
  const SupportMap({
    super.key,
    required this.showingEvents,
    required this.onSelectPoint,
    required this.onSelectEvent,
    this.selectedEventId,
  });

  final bool showingEvents;
  final ValueChanged<String> onSelectPoint;
  final ValueChanged<String> onSelectEvent;
  final String? selectedEventId;

  @override
  ConsumerState<SupportMap> createState() => _SupportMapState();
}

class _SupportMapState extends ConsumerState<SupportMap>
    with TickerProviderStateMixin {
  late final AnimationController _route = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 650),
  );
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat();

  @override
  void initState() {
    super.initState();
    if (ref.read(supportProvider).activePointId != null) {
      _route.value = 1;
    }
  }

  @override
  void dispose() {
    _route.dispose();
    _pulse.dispose();
    super.dispose();
  }

  void _handleTap(Offset local, double width) {
    final SupportState state = ref.read(supportProvider);
    final double fx = local.dx / width;
    final double fy = local.dy / _mapHeight;

    double best = double.infinity;
    String? bestId;
    bool bestIsEvent = false;

    if (widget.showingEvents) {
      for (final Event e in state.events) {
        final Offset pos = _eventFraction(state.events.indexOf(e));
        final double d = _dist(fx, fy, pos.dx, pos.dy, width);
        if (d < best) {
          best = d;
          bestId = e.id;
          bestIsEvent = true;
        }
      }
    } else {
      for (final SupportPoint p in state.supportPoints) {
        final double d = _dist(fx, fy, p.mapX, p.mapY, width);
        if (d < best) {
          best = d;
          bestId = p.id;
        }
      }
    }

    if (bestId != null && best < 28) {
      if (bestIsEvent) {
        widget.onSelectEvent(bestId);
      } else {
        widget.onSelectPoint(bestId);
      }
    }
  }

  double _dist(double fx, double fy, double mx, double my, double width) {
    final double dx = (fx - mx) * width;
    final double dy = (fy - my) * _mapHeight;
    return math.sqrt(dx * dx + dy * dy);
  }

  @override
  Widget build(BuildContext context) {
    final SupportState state = ref.watch(supportProvider);

    // Reinicia a animação da rota quando o ponto ativo muda.
    ref.listen<String?>(
      supportProvider.select((SupportState s) => s.activePointId),
      (String? previous, String? next) {
        if (next != null && next != previous) {
          _route.forward(from: 0);
        }
      },
    );

    final SupportPoint? active = state.activePointId == null
        ? null
        : state.supportPoints
              .where((SupportPoint p) => p.id == state.activePointId)
              .cast<SupportPoint?>()
              .firstWhere((_) => true, orElse: () => null);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.card),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final double width = constraints.maxWidth;
              // O mapa é desenhado; para leitor de tela, a lista de pontos
              // logo abaixo é a forma de escolher um ponto.
              return Semantics(
                label:
                    'Mapa dos pontos de apoio perto de você. A lista '
                    'abaixo mostra os mesmos pontos.',
                child: GestureDetector(
                  onTapUp: (TapUpDetails d) =>
                      _handleTap(d.localPosition, width),
                  child: SizedBox(
                    height: _mapHeight,
                    width: width,
                    child: Stack(
                      children: <Widget>[
                        AnimatedBuilder(
                          animation: Listenable.merge(<Listenable>[
                            _route,
                            _pulse,
                          ]),
                          builder: (BuildContext context, _) {
                            return CustomPaint(
                              size: Size(width, _mapHeight),
                              painter: _MapPainter(
                                points: state.supportPoints,
                                events: state.events,
                                showingEvents: widget.showingEvents,
                                activePointId: widget.showingEvents
                                    ? null
                                    : state.activePointId,
                                selectedEventId: widget.showingEvents
                                    ? widget.selectedEventId
                                    : null,
                                routeProgress: _route.value,
                                pulse: _pulse.value,
                              ),
                            );
                          },
                        ),
                        if (!widget.showingEvents && active != null)
                          Positioned(
                            top: AppSpacing.sm,
                            left: AppSpacing.sm,
                            child: _RouteLabel(point: active),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        const _Legend(),
      ],
    );
  }
}

/// Distribui os eventos em posições fixas no mapa (não têm mapX/mapY próprios).
Offset _eventFraction(int index) {
  const List<Offset> spots = <Offset>[
    Offset(0.62, 0.28),
    Offset(0.80, 0.62),
    Offset(0.45, 0.78),
    Offset(0.34, 0.34),
  ];
  return spots[index % spots.length];
}

class _RouteLabel extends StatelessWidget {
  const _RouteLabel({required this.point});

  final SupportPoint point;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.circular(AppRadius.button),
      ),
      child: Text(
        'Rota: ${point.name} · ${point.minutes} min',
        style: textTheme.labelMedium?.copyWith(color: AppColors.onDark),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _LegendItem(color: AppColors.coral, label: 'Ponto de apoio'),
        _LegendItem(color: AppColors.primary, label: 'Evento', diamond: true),
        _LegendItem(color: AppColors.mapYou, label: 'Você'),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.color,
    required this.label,
    this.diamond = false,
  });

  final Color color;
  final String label;
  final bool diamond;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Transform.rotate(
          angle: diamond ? math.pi / 4 : 0,
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: diamond ? BoxShape.rectangle : BoxShape.circle,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _MapPainter extends CustomPainter {
  _MapPainter({
    required this.points,
    required this.events,
    required this.showingEvents,
    required this.activePointId,
    required this.selectedEventId,
    required this.routeProgress,
    required this.pulse,
  });

  final List<SupportPoint> points;
  final List<Event> events;
  final bool showingEvents;
  final String? activePointId;
  final String? selectedEventId;
  final double routeProgress;
  final double pulse;


  @override
  void paint(Canvas canvas, Size size) {
    _paintCity(canvas, size);
    if (!showingEvents) _paintRoute(canvas, size);
    _paintMarkers(canvas, size);
    _paintYou(canvas, size);
  }

  void _paintCity(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = AppColors.mapStreet);

    final Paint blockPaint = Paint()..color = AppColors.mapBlock;
    const int cols = 4;
    const int rows = 5;
    const double gap = 12;
    final double cw = size.width / cols;
    final double ch = size.height / rows;
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        final Rect rect = Rect.fromLTWH(
          c * cw + gap / 2,
          r * ch + gap / 2,
          cw - gap,
          ch - gap,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, const Radius.circular(8)),
          blockPaint,
        );
      }
    }

    // Área verde (praça).
    final Rect greenRect = Rect.fromLTWH(
      size.width * 0.40,
      size.height * 0.30,
      size.width * 0.28,
      size.height * 0.30,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(greenRect, const Radius.circular(14)),
      Paint()..color = AppColors.mapGreen,
    );

    // Água no canto superior direito.
    final Rect waterRect = Rect.fromLTWH(
      size.width * 0.80,
      -size.height * 0.15,
      size.width * 0.40,
      size.height * 0.42,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(waterRect, const Radius.circular(22)),
      Paint()..color = AppColors.mapWater,
    );
  }

  void _paintRoute(Canvas canvas, Size size) {
    if (activePointId == null) return;
    final SupportPoint? dest = points
        .where((SupportPoint p) => p.id == activePointId)
        .cast<SupportPoint?>()
        .firstWhere((_) => true, orElse: () => null);
    if (dest == null) return;

    final Offset you = Offset(
      _youFraction.dx * size.width,
      _youFraction.dy * size.height,
    );
    final Offset target = Offset(
      dest.mapX * size.width,
      dest.mapY * size.height,
    );

    final Path path = Path()
      ..moveTo(you.dx, you.dy)
      ..lineTo(target.dx, you.dy)
      ..lineTo(target.dx, target.dy);

    final Paint routePaint = Paint()
      ..color = AppColors.coral
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    for (final metric in path.computeMetrics()) {
      canvas.drawPath(
        metric.extractPath(0, metric.length * routeProgress.clamp(0.0, 1.0)),
        routePaint,
      );
    }
  }

  void _paintMarkers(Canvas canvas, Size size) {
    if (showingEvents) {
      for (int i = 0; i < events.length; i++) {
        final Offset pos = _eventFraction(i);
        _diamond(
          canvas,
          Offset(pos.dx * size.width, pos.dy * size.height),
          events[i].id == selectedEventId
              ? AppColors.primaryDark
              : AppColors.primary,
        );
      }
    } else {
      for (final SupportPoint p in points) {
        _pin(
          canvas,
          Offset(p.mapX * size.width, p.mapY * size.height),
          p.id == activePointId ? AppColors.primaryDark : AppColors.coral,
        );
      }
    }
  }

  void _pin(Canvas canvas, Offset center, Color color) {
    canvas.drawCircle(center, 11, Paint()..color = AppColors.onDark);
    canvas.drawCircle(center, 9, Paint()..color = color);
    canvas.drawCircle(
      center,
      3.5,
      Paint()..color = AppColors.onDark.withValues(alpha: 0.9),
    );
  }

  void _diamond(Canvas canvas, Offset center, Color color) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(math.pi / 4);
    final Rect outer = Rect.fromCenter(
      center: Offset.zero,
      width: 22,
      height: 22,
    );
    final Rect inner = Rect.fromCenter(
      center: Offset.zero,
      width: 18,
      height: 18,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(outer, const Radius.circular(4)),
      Paint()..color = AppColors.onDark,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(inner, const Radius.circular(3)),
      Paint()..color = color,
    );
    canvas.restore();
  }

  void _paintYou(Canvas canvas, Size size) {
    final Offset you = Offset(
      _youFraction.dx * size.width,
      _youFraction.dy * size.height,
    );
    canvas.drawCircle(
      you,
      9 + 11 * pulse,
      Paint()..color = AppColors.mapYou.withValues(alpha: (1 - pulse) * 0.35),
    );
    canvas.drawCircle(you, 9, Paint()..color = AppColors.onDark);
    canvas.drawCircle(you, 6.5, Paint()..color = AppColors.mapYou);
  }

  @override
  bool shouldRepaint(_MapPainter old) {
    return old.routeProgress != routeProgress ||
        old.pulse != pulse ||
        old.activePointId != activePointId ||
        old.selectedEventId != selectedEventId ||
        old.showingEvents != showingEvents;
  }
}
