/// Categoria de um benefício/parceria.
enum BenefitCategory { trabalho, saude, estudos, financas }

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
