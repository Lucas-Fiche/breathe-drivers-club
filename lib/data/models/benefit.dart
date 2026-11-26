/// Categoria de um benefício/parceria.
enum BenefitCategory { trabalho, saude, estudos, financas }

extension BenefitCategoryX on BenefitCategory {
  /// Rótulo em português para exibição.
  String get label {
    switch (this) {
      case BenefitCategory.trabalho:
        return 'Trabalho';
      case BenefitCategory.saude:
        return 'Saúde';
      case BenefitCategory.estudos:
        return 'Estudos';
      case BenefitCategory.financas:
        return 'Finanças';
    }
  }

  /// Chave usada em query parameters da rota (ex.: `?filtro=estudos`).
  String get slug => name;

  /// Converte um slug de rota numa categoria (nulo se não corresponder).
  static BenefitCategory? fromSlug(String? slug) {
    if (slug == null) return null;
    for (final BenefitCategory c in BenefitCategory.values) {
      if (c.name == slug) return c;
    }
    return null;
  }
}

/// Benefício oferecido por um parceiro fictício, resgatável com pontos.
class Benefit {
  const Benefit({
    required this.id,
    required this.partnerName,
    required this.category,
    required this.description,
    required this.pointsCost,
    required this.discount,
  });

  final String id;

  /// Nome do parceiro (ex.: "AutoViva Peças e Serviços").
  final String partnerName;

  final BenefitCategory category;
  final String description;

  /// Custo em pontos para resgatar.
  final int pointsCost;

  /// Texto do desconto já pronto (ex.: "15% de desconto em revisão").
  final String discount;

  Benefit copyWith({
    String? id,
    String? partnerName,
    BenefitCategory? category,
    String? description,
    int? pointsCost,
    String? discount,
  }) {
    return Benefit(
      id: id ?? this.id,
      partnerName: partnerName ?? this.partnerName,
      category: category ?? this.category,
      description: description ?? this.description,
      pointsCost: pointsCost ?? this.pointsCost,
      discount: discount ?? this.discount,
    );
  }
}
