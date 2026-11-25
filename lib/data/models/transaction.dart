/// Tipo de movimentação financeira.
enum TransactionType { income, expense }

/// Movimentação financeira (ganho ou gasto) do trabalhador.
class Transaction {
  const Transaction({
    required this.id,
    required this.type,
    required this.category,
    required this.amount,
    required this.date,
    required this.description,
  });

  final String id;
  final TransactionType type;

  /// Categoria (ex.: "Combustível", "Alimentação", "Corridas").
  final String category;

  /// Valor sempre positivo; o sinal é dado por [type].
  final double amount;

  final DateTime date;
  final String description;

  bool get isIncome => type == TransactionType.income;
  bool get isExpense => type == TransactionType.expense;

  Transaction copyWith({
    String? id,
    TransactionType? type,
    String? category,
    double? amount,
    DateTime? date,
    String? description,
  }) {
    return Transaction(
      id: id ?? this.id,
      type: type ?? this.type,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      description: description ?? this.description,
    );
  }
}
