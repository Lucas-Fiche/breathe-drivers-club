import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';

/// Moldura de celular para a web.
///
/// Quando a largura disponível passa de 600 px (desktop/apresentação), centra
/// o app numa moldura ~400×860 com cantos arredondados e sombra, sobre um fundo
/// [AppColors.primaryDark], com a legenda "Protótipo · dados fictícios".
///
/// Em telas estreitas (celular), devolve o [child] ocupando a tela toda.
/// Pensado para envolver o app inteiro no `builder` do `MaterialApp.router`.
class DeviceFrame extends StatelessWidget {
  const DeviceFrame({super.key, required this.child});

  final Widget child;

  static const double _breakpoint = 600;
  static const double _frameWidth = 400;
  static const double _frameHeight = 860;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth <= _breakpoint) {
          return child;
        }

        final double height = constraints.maxHeight.isFinite
            ? constraints.maxHeight.clamp(0.0, _frameHeight)
            : _frameHeight;

        return ColoredBox(
          color: AppColors.primaryDark,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _Frame(width: _frameWidth, height: height, child: child),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Protótipo · dados fictícios',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Frame extends StatelessWidget {
  const _Frame({
    required this.width,
    required this.height,
    required this.child,
  });

  final double width;
  final double height;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = BorderRadius.circular(36);
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 40,
            spreadRadius: 4,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          removeBottom: true,
          child: child,
        ),
      ),
    );
  }
}
