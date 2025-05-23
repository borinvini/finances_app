// lib/models/fixed_expense.dart
import 'package:flutter/material.dart';
import 'expense.dart'; // Import to use the updated icon conversion methods

class FixedExpense {
  final int? id; // ID for database (nullable for new records)
  final String bill;
  final double amount;
  final IconData icon;
  final Color iconBackgroundColor;
  final DateTime date;
  final int dueDay;
  bool paid;

  FixedExpense({
    this.id,
    required this.bill,
    required this.amount,
    required this.icon,
    required this.iconBackgroundColor,
    required this.date,
    required this.dueDay,
    this.paid = false,
  });

  // Convert FixedExpense object to a Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'bill': bill,
      'amount': amount,
      'iconName': Expense.iconToString(icon), // Use the updated method from Expense
      'iconColorValue': iconBackgroundColor.value,
      'date': date.toIso8601String(),
      'dueDay': dueDay,
      'paid': paid ? 1 : 0,
    };
  }

  // Create a FixedExpense object from a SQLite map
  factory FixedExpense.fromMap(Map<String, dynamic> map) {
    return FixedExpense(
      id: map['id'],
      bill: map['bill'],
      amount: map['amount'],
      icon: Expense.stringToIcon(map['iconName']), // Use the updated method from Expense
      iconBackgroundColor: Color(map['iconColorValue']),
      date: DateTime.parse(map['date']),
      dueDay: map['dueDay'],
      paid: map['paid'] == 1,
    );
  }
  
  // Copy a fixed expense with some fields changed
  FixedExpense copyWith({
    int? id,
    String? bill,
    double? amount,
    IconData? icon,
    Color? iconBackgroundColor,
    DateTime? date,
    int? dueDay,
    bool? paid,
  }) {
    return FixedExpense(
      id: id ?? this.id,
      bill: bill ?? this.bill,
      amount: amount ?? this.amount,
      icon: icon ?? this.icon,
      iconBackgroundColor: iconBackgroundColor ?? this.iconBackgroundColor,
      date: date ?? this.date,
      dueDay: dueDay ?? this.dueDay,
      paid: paid ?? this.paid,
    );
  }
}