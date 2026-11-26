import 'package:flutter/material.dart';

/// Tokens de cor do Breathe Drivers Club.
///
/// Extraídos da tabela do CLAUDE.md (Design System). Nunca usar cores soltas
/// nas telas: sempre referenciar [AppColors] ou o `ColorScheme`/`TextTheme`.
abstract final class AppColors {
  /// Cabeçalho, tela de acesso, textos fortes.
  static const Color primaryDark = Color(0xFF0B3B3B);

  /// Barras de progresso, números de destaque, chip selecionado, aba ativa.
  static const Color primary = Color(0xFF127572);

  /// Cards de dica, botões +/−, item selecionado.
  static const Color mint = Color(0xFFE2F5EF);

  /// Trilho das barras de progresso.
  static const Color mintTrack = Color(0xFFCFF3E7);

  /// Botão principal (CTA), pins do mapa, indicador da aba ativa, logo.
  static const Color coral = Color(0xFFFE7A59);

  /// Cards de alerta/pausa/ajuda, card de pontos.
  static const Color coralSoft = Color(0xFFFFE9E1);

  /// Fundo das telas (bege claro).
  static const Color background = Color(0xFFFBF6F0);

  /// Fundo dos cards.
  static const Color surface = Color(0xFFFFFFFF);

  /// Botão desabilitado.
  static const Color disabled = Color(0xFFD8D4C8);

  /// Texto principal.
  static const Color textPrimary = Color(0xFF1A1A1A);

  /// Texto de apoio.
  static const Color textSecondary = Color(0xFF5F6368);

  /// Contorno de cards e pílulas.
  static const Color border = Color(0xFFECE6DE);

  /// Texto e ícones sobre fundos escuros (primaryDark, primary).
  static const Color onDark = Color(0xFFFFFFFF);

  /// Erros de formulário (pouco usado: o app evita vermelho alarmante).
  static const Color error = Color(0xFFC0392B);

  /// Base das sombras (sempre com transparência).
  static const Color shadow = Color(0xFF000000);

  /// Transparente (ex.: indicador de aba inativa).
  static const Color transparent = Color(0x00000000);

  // Mapa ilustrado dos pontos de apoio (só decoração do desenho).
  static const Color mapStreet = Color(0xFFFCFAF6);
  static const Color mapBlock = Color(0xFFEAE3D7);
  static const Color mapGreen = Color(0xFFC3E1C6);
  static const Color mapWater = Color(0xFFBFE1EC);

  /// Ponto "Você" no mapa.
  static const Color mapYou = Color(0xFF3B82F6);
}
