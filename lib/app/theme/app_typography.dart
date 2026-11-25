import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Tipografia do app, baseada na fonte Inter (google_fonts).
///
/// Escala (CLAUDE.md): título de tela 22–24 semibold; título de card 16–17
/// semibold; corpo 14–15; números de destaque 32–40 bold em [AppColors.primary].
abstract final class AppTypography {
  static const FontWeight _regular = FontWeight.w400;
  static const FontWeight _medium = FontWeight.w500;
  static const FontWeight _semibold = FontWeight.w600;
  static const FontWeight _bold = FontWeight.w700;

  /// Monta o [TextTheme] do app sobre a fonte Inter, mantendo as cores de
  /// texto padrão. Em superfícies escuras (cabeçalho) as cores são
  /// sobrescritas localmente via `copyWith(color: ...)`.
  static TextTheme textTheme() {
    final TextTheme base = GoogleFonts.interTextTheme();
    return base.copyWith(
      // Números de destaque (ex.: "R$ 120", "10 corridas").
      displaySmall: GoogleFonts.inter(
        fontSize: 40,
        fontWeight: _bold,
        color: AppColors.primary,
        height: 1.1,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: _bold,
        color: AppColors.primary,
        height: 1.1,
      ),
      // Título de tela (dentro do cabeçalho).
      titleLarge: GoogleFonts.inter(
        fontSize: 23,
        fontWeight: _semibold,
        color: AppColors.textPrimary,
        height: 1.2,
      ),
      // Título de card.
      titleMedium: GoogleFonts.inter(
        fontSize: 17,
        fontWeight: _semibold,
        color: AppColors.textPrimary,
        height: 1.25,
      ),
      // Marca "BREATHE DRIVERS CLUB" (caixa alta, espaçada) e rótulos pequenos.
      titleSmall: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: _semibold,
        color: AppColors.textPrimary,
        letterSpacing: 1.2,
        height: 1.2,
      ),
      // Corpo.
      bodyLarge: GoogleFonts.inter(
        fontSize: 15,
        fontWeight: _regular,
        color: AppColors.textPrimary,
        height: 1.4,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: _regular,
        color: AppColors.textSecondary,
        height: 1.4,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12.5,
        fontWeight: _regular,
        color: AppColors.textSecondary,
        height: 1.3,
      ),
      // Texto de botões e chips.
      labelLarge: GoogleFonts.inter(
        fontSize: 15,
        fontWeight: _semibold,
        color: AppColors.textPrimary,
        height: 1.1,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: _medium,
        color: AppColors.textSecondary,
        height: 1.1,
      ),
    );
  }
}
