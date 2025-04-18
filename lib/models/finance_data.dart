class FinanceData {
  final double balance;
  final double income;
  final double expenses;
  final DateTime month;

  FinanceData({
    required this.balance,
    required this.income,
    required this.expenses,
    required this.month,
  });
}

FinanceData currentFinances = FinanceData(
  balance: 1650.00,
  income: 4500.00,
  expenses: 2850.00,
  month: DateTime(2025, 4),
);