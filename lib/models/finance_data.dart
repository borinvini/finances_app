class FinanceData {
  final int? id; // ID for database (nullable for new records)
  final double balance;
  final double income;
  final double expenses;
  final DateTime month;

  FinanceData({
    this.id,
    required this.balance,
    required this.income,
    required this.expenses,
    required this.month,
  });

  // Convert FinanceData object to a Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'balance': balance,
      'income': income,
      'expenses': expenses,
      'month': month.toIso8601String(),
    };
  }

  // Create a FinanceData object from a SQLite map
  factory FinanceData.fromMap(Map<String, dynamic> map) {
    return FinanceData(
      id: map['id'],
      balance: map['balance'],
      income: map['income'],
      expenses: map['expenses'],
      month: DateTime.parse(map['month']),
    );
  }
  
  // Copy a FinanceData with some fields changed
  FinanceData copyWith({
    int? id,
    double? balance,
    double? income,
    double? expenses,
    DateTime? month,
  }) {
    return FinanceData(
      id: id ?? this.id,
      balance: balance ?? this.balance,
      income: income ?? this.income,
      expenses: expenses ?? this.expenses,
      month: month ?? this.month,
    );
  }
}

// Helper function to get current month's finances
FinanceData getCurrentFinances() {
  return FinanceData(
    balance: 1650.00,
    income: 4500.00,
    expenses: 2850.00,
    month: DateTime(DateTime.now().year, DateTime.now().month),
  );
}