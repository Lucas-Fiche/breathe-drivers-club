import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

/// Logo do Breathe: um volante desenhado em código (sem imagem).
///
/// Aro em [AppColors.mint], três raios e centro em [AppColors.coral].
/// Use [size] para controlar o diâmetro.
class BreatheLogo extends StatelessWidget {
  const BreatheLogo({
    super.key,
    this.size = 80,
    this.ringColor = AppColors.mint,
    this.hubColor = AppColors.coral,
  });

  final double size;
  final Color ringColor;
  final Color hubColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(
        painter: _SteeringWheelPainter(
          ringColor: ringColor,
          hubColor: hubColor,
        ),
      ),
    );
  }
}

class _SteeringWheelPainter extends CustomPainter {
  const _SteeringWheelPainter({
    required this.ringColor,
    required this.hubColor,
  });

  final Color ringColor;
  final Color hubColor;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = size.center(Offset.zero);
    final double radius = size.width / 2;
    final double strokeWidth = size.width * 0.11;
    final double hubRadius = size.width * 0.17;

    final Paint ringPaint = Paint()
      ..color = ringColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final Paint spokePaint = Paint()
      ..color = ringColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth * 0.9
      ..strokeCap = StrokeCap.round;

    // Aro.
    canvas.drawCircle(center, radius - strokeWidth / 2, ringPaint);

    // Três raios a 90°, 210° e 330° (um para cima, dois para baixo).
    final double spokeEnd = radius - strokeWidth;
    const List<double> angles = <double>[
      -math.pi / 2,
      math.pi / 6 * 5,
      math.pi / 6,
    ];
    for (final double angle in angles) {
      final Offset outer = center +
          Offset(math.cos(angle), math.sin(angle)) * spokeEnd;
      canvas.drawLine(center, outer, spokePaint);
    }

    // Centro coral por cima dos raios.
    final Paint hubPaint = Paint()..color = hubColor;
    canvas.drawCircle(center, hubRadius, hubPaint);
  }

  @override
  bool shouldRepaint(_SteeringWheelPainter oldDelegate) {
    return oldDelegate.ringColor != ringColor || oldDelegate.hubColor != hubColor;
  }
}
