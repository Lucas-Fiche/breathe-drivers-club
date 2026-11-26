/// Espaçamentos e raios padronizados do app.
///
/// Nunca usar valores soltos de padding/margin/raio nas telas: usar [AppSpacing]
/// e [AppRadius].
abstract final class AppSpacing {
  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;

  /// Espaço extra no fim das telas roláveis para o último item poder subir
  /// acima do botão flutuante (FAB de 56 + margem).
  static const double fabClearance = 80;
}

/// Raios de borda padronizados.
abstract final class AppRadius {
  /// Botões e pílulas.
  static const double button = 14;

  /// Cards.
  static const double card = 20;

  /// Cantos inferiores do cabeçalho e molduras maiores.
  static const double header = 24;
}
