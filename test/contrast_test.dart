// Contraste (WCAG 2.1) dos pares de cor de texto usados no app.
//
// Texto normal precisa de 4,5:1; texto grande (≥ 18,7 px negrito ou ≥ 24 px)
// e ícones que carregam informação precisam de 3:1. Textos em coral sobre
// fundo claro NÃO passam (2,6:1) e por isso o app usa coral só como fundo de
// botão (com texto escuro) e em ícones ao lado de um texto.

import 'package:breathe_drivers_club/app/theme/app_colors.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';

double contrast(Color a, Color b) {
  final double la = a.computeLuminance();
  final double lb = b.computeLuminance();
  final double hi = la > lb ? la : lb;
  final double lo = la > lb ? lb : la;
  return (hi + 0.05) / (lo + 0.05);
}

const Color _white = Color(0xFFFFFFFF);

/// (texto, fundo, onde aparece)
const List<(Color, Color, String)> _normalText = <(Color, Color, String)>[
  (
    AppColors.textPrimary,
    AppColors.coral,
    'botão principal (CTA) e selo "novo"',
  ),
  (AppColors.textPrimary, AppColors.mint, 'cards de dica'),
  (AppColors.primary, AppColors.mint, 'etiquetas e destaques sobre mint'),
  (AppColors.textSecondary, AppColors.mint, 'texto de apoio sobre mint'),
  (
    AppColors.textPrimary,
    AppColors.coralSoft,
    'cards de alerta, pausa e ajuda',
  ),
  (AppColors.textSecondary, AppColors.coralSoft, 'apoio sobre coralSoft'),
  (
    AppColors.primaryDark,
    AppColors.coralSoft,
    'data dos eventos, selo destaque',
  ),
  (AppColors.primary, AppColors.coralSoft, 'links sobre coralSoft'),
  (_white, AppColors.primary, 'chip selecionado, balão do usuário'),
  (_white, AppColors.primaryDark, 'cabeçalho'),
  (AppColors.mintTrack, AppColors.primaryDark, 'subtítulo do cabeçalho'),
  (AppColors.coral, AppColors.primaryDark, 'contagem da pausa guiada'),
  (AppColors.textSecondary, AppColors.background, 'texto de apoio'),
  (AppColors.textSecondary, AppColors.surface, 'texto de apoio em cards'),
  (AppColors.primary, AppColors.surface, 'links, números, aba ativa'),
  (AppColors.primary, AppColors.background, 'números de destaque'),
  (AppColors.textPrimary, AppColors.background, 'texto'),
];

void main() {
  group('contraste de texto ≥ 4,5:1', () {
    for (final (Color fg, Color bg, String where) in _normalText) {
      test(where, () {
        expect(contrast(fg, bg), greaterThanOrEqualTo(4.5));
      });
    }
  });

  test('coral sobre fundo claro não serve para texto (documenta a regra)', () {
    expect(contrast(AppColors.coral, AppColors.surface), lessThan(3));
    expect(contrast(_white, AppColors.coral), lessThan(3));
  });
}
