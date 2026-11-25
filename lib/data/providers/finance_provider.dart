import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/models.dart';
import '../repositories/repositories.dart';
import 'persona_provider.dart';
import 'repository_providers.dart';

/// Estado das finanças: transações e cofrinho.
class FinanceState {
  const FinanceState({
    required this.transactions,
    required this.piggyBank,
  });

  final List<Transaction> transactions;
  final PiggyBank piggyBank;

  /// Total de ganhos do período.
  double get income => transactions
      .where((Transaction t) => t.isIncome)
      .fold(0, (double sum, Transaction t) => sum + t.amount);

  /// Total de gastos do período.
  double get expenses => transactions
      .where((Transaction t) => t.isExpense)
      .fold(0, (double sum, Transaction t) => sum + t.amount);

  /// Quanto sobrou (ganhos − gastos).
  double get saved => income - expenses;

  /// Gastos somados por categoria.
  Map<String, double> get expensesByCategory {
    final Map<String, double> result = <String, double>{};
    for (final Transaction t in transactions.where((t) => t.isExpense)) {
      result[t.category] = (result[t.category] ?? 0) + t.amount;
    }
    return result;
  }

  FinanceState copyWith({
    List<Transaction>? transactions,
    PiggyBank? piggyBank,
  }) {
    return FinanceState(
      transactions: transactions ?? this.transactions,
      piggyBank: piggyBank ?? this.piggyBank,
    );
  }
}

class FinanceNotifier extends Notifier<FinanceState> {
  @override
  FinanceState build() {
    final Persona persona = ref.watch(personaProvider);
    final FinanceRepository repo = ref.read(financeRepositoryProvider);
    return FinanceState(
      transactions: repo.loadTransactions(persona),
      piggyBank: repo.loadPiggyBank(persona),
    );
  }

  /// Guarda um valor no cofrinho. Ignora valores não positivos.
  void addToPiggyBank(double amount) {
    if (amount <= 0) return;
    state = state.copyWith(
      piggyBank: state.piggyBank.copyWith(
        balance: state.piggyBank.balance + amount,
      ),
    );
  }

  /// Muda a meta do cofrinho (ignora valores não positivos).
  void setPiggyGoal(double goal) {
    if (goal <= 0) return;
    state = state.copyWith(piggyBank: state.piggyBank.copyWith(goal: goal));
  }

  /// Adiciona uma transação (mais recente primeiro).
  void addTransaction(Transaction transaction) {
    state = state.copyWith(
      transactions: <Transaction>[transaction, ...state.transactions],
    );
  }

  /// Registra uma nova movimentação (ganho ou gasto). Ignora valor não positivo.
  void registerTransaction({
    required TransactionType type,
    required String category,
    required double amount,
    String description = '',
  }) {
    if (amount <= 0) return;
    addTransaction(
      Transaction(
        id: 'tx-${DateTime.now().microsecondsSinceEpoch}',
        type: type,
        category: category,
        amount: amount,
        date: DateTime.now(),
        description: description.trim(),
      ),
    );
  }
}

final NotifierProvider<FinanceNotifier, FinanceState> financeProvider =
    NotifierProvider<FinanceNotifier, FinanceState>(FinanceNotifier.new);
