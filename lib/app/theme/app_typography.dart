import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Tipografia do app, baseada na fonte Inter (google_fonts).
///
/// Escala (CLAUDE.md): título de tela 22–24 semibold; título de card 16–17
/// semibold; corpo 14–15; números de destaque 32–40 bold em [AppColors.primary].
abstract final class AppTypography {
  /// Família usada quando [useGoogleFonts] é falso.
  static const String fontFamily = 'Inter';

  /// No app, a Inter vem do google_fonts. Nos testes, fica falso: a família
  /// 'Inter' é registrada à mão (sem rede), com as mesmas medidas do tema.
  static bool useGoogleFonts = true;

  static TextStyle _inter({
    required double fontSize,
    required FontWeight fontWeight,
    required Color color,
    double? height,
    double? letterSpacing,
  }) {
    if (useGoogleFonts) {
      return GoogleFonts.inter(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        height: height,
        letterSpacing: letterSpacing,
      );
    }
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static const FontWeight _regular = FontWeight.w400;
  static const FontWeight _medium = FontWeight.w500;
  static const FontWeight _semibold = FontWeight.w600;
  static const FontWeight _bold = FontWeight.w700;

  /// Monta o [TextTheme] do app sobre a fonte Inter, mantendo as cores de
  /// texto padrão. Em superfícies escuras (cabeçalho) as cores são
  /// sobrescritas localmente via `copyWith(color: ...)`.
  static TextTheme textTheme() {
    final TextTheme base = useGoogleFonts
        ? GoogleFonts.interTextTheme()
        : ThemeData.light().textTheme.apply(fontFamily: fontFamily);
    return base.copyWith(
      // Números de destaque (ex.: "R$ 120", "10 corridas").
      displaySmall: _inter(
        fontSize: 40,
        fontWeight: _bold,
        color: AppColors.primary,
        height: 1.1,
      ),
      headlineMedium: _inter(
        fontSize: 32,
        fontWeight: _bold,
        color: AppColors.primary,
        height: 1.1,
      ),
      // Título de tela (dentro do cabeçalho).
      titleLarge: _inter(
        fontSize: 23,
        fontWeight: _semibold,
        color: AppColors.textPrimary,
        height: 1.2,
      ),
      // Título de card.
      titleMedium: _inter(
        fontSize: 17,
        fontWeight: _semibold,
        color: AppColors.textPrimary,
        height: 1.25,
      ),
      // Marca "BREATHE DRIVERS CLUB" (caixa alta, espaçada) e rótulos pequenos.
      titleSmall: _inter(
        fontSize: 13,
        fontWeight: _semibold,
        color: AppColors.textPrimary,
        letterSpacing: 1.2,
        height: 1.2,
      ),
      // Corpo.
      bodyLarge: _inter(
        fontSize: 15,
        fontWeight: _regular,
        color: AppColors.textPrimary,
        height: 1.4,
      ),
      bodyMedium: _inter(
        fontSize: 14,
        fontWeight: _regular,
        color: AppColors.textSecondary,
        height: 1.4,
      ),
      bodySmall: _inter(
        fontSize: 12.5,
        fontWeight: _regular,
        color: AppColors.textSecondary,
        height: 1.3,
      ),
      // Texto de botões e chips.
      labelLarge: _inter(
        fontSize: 15,
        fontWeight: _semibold,
        color: AppColors.textPrimary,
        height: 1.1,
      ),
      labelMedium: _inter(
        fontSize: 13,
        fontWeight: _medium,
        color: AppColors.textSecondary,
        height: 1.1,
      ),
    );
  }
}
