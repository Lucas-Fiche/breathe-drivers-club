/// Cofrinho: saldo guardado e meta de poupança.
class PiggyBank {
  const PiggyBank({
    this.balance = 0,
    required this.goal,
  });

  final double balance;
  final double goal;

  double get progress => goal == 0 ? 0 : (balance / goal).clamp(0, 1);

  PiggyBank copyWith({
    double? balance,
    double? goal,
  }) {
    return PiggyBank(
      balance: balance ?? this.balance,
      goal: goal ?? this.goal,
    );
  }
}
