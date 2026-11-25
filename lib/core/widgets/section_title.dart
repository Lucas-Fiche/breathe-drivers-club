import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';

/// Título de seção dentro de uma tela (ex.: "Metas de vida").
///
/// [trailing] opcional à direita (ex.: um botão "+", um "Ver todos").
class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    required this.title,
    this.trailing,
  });

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            title,
            style: textTheme.titleMedium,
          ),
        ),
        if (trailing != null) ...<Widget>[
          const SizedBox(width: AppSpacing.sm),
          trailing!,
        ],
      ],
    );
  }
}
