import 'dart:async';

import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';

/// Toast de reconhecimento: pílula escura com estrela coral que aparece com
/// um "pulo" suave e some sozinha depois de [duration].
class RecognitionToast extends StatefulWidget {
  const RecognitionToast({
    super.key,
    required this.points,
    required this.message,
    required this.onDone,
    this.duration = const Duration(milliseconds: 3200),
  });

  final int points;
  final String message;
  final VoidCallback onDone;
  final Duration duration;

  @override
  State<RecognitionToast> createState() => _RecognitionToastState();
}

class _RecognitionToastState extends State<RecognitionToast>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 450),
  )..forward();

  late final Animation<double> _scale = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOutBack,
  );

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(widget.duration, () async {
      if (!mounted) return;
      await _controller.reverse();
      widget.onDone();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Semantics(
      liveRegion: true,
      label: '+${widget.points} pontos. ${widget.message}',
      excludeSemantics: true,
      child: FadeTransition(
        opacity: _controller,
        child: ScaleTransition(
          scale: _scale,
          child: Material(
            color: AppColors.primaryDark,
            elevation: 6,
            shape: const StadiumBorder(),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xl,
                vertical: AppSpacing.md,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Icon(Icons.stars_rounded, color: AppColors.coral),
                  const SizedBox(width: AppSpacing.sm),
                  Flexible(
                    child: Text.rich(
                      TextSpan(
                        children: <InlineSpan>[
                          TextSpan(
                            text: '+${widget.points} pontos',
                            style: const TextStyle(color: AppColors.mint),
                          ),
                          TextSpan(text: ' — ${widget.message}'),
                        ],
                      ),
                      style: textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
