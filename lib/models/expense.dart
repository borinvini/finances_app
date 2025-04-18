import 'package:flutter/material.dart';

class Expense {
  final String name;
  final double amount;
  final IconData icon;
  final Color iconBackgroundColor;
  final String category;
  final DateTime date;
  final int dueDay;

  Expense({
    required this.name,
    required this.amount,
    required this.icon,
    required this.iconBackgroundColor,
    required this.category,
    required this.date,
    this.dueDay = 0,
  });
}

List<Expense> fixedBudgetItems = [
  Expense(
    name: 'Aluguel',
    amount: 1200.00,
    icon: Icons.home,
    iconBackgroundColor: Colors.blue.shade700,
    category: 'Moradia',
    date: DateTime(2025, 4, 10),
    dueDay: 10,
  ),
  Expense(
    name: 'Energia',
    amount: 245.00,
    icon: Icons.bolt,
    iconBackgroundColor: Colors.amber.shade700,
    category: 'Serviços',
    date: DateTime(2025, 4, 15),
    dueDay: 15,
  ),
  Expense(
    name: 'Internet',
    amount: 120.00,
    icon: Icons.wifi,
    iconBackgroundColor: Colors.blue.shade500,
    category: 'Serviços',
    date: DateTime(2025, 4, 20),
    dueDay: 20,
  ),
  Expense(
    name: 'Água',
    amount: 85.00,
    icon: Icons.water_drop,
    iconBackgroundColor: Colors.blue.shade300,
    category: 'Serviços',
    date: DateTime(2025, 4, 15),
    dueDay: 15,
  ),
];

List<Expense> recentExpenses = [
  Expense(
    name: 'Supermercado Extra',
    amount: 320.45,
    icon: Icons.shopping_cart,
    iconBackgroundColor: Colors.red.shade700,
    category: 'Alimentação',
    date: DateTime(2025, 4, 18),
  ),
  Expense(
    name: 'Netflix',
    amount: 39.90,
    icon: Icons.movie,
    iconBackgroundColor: Colors.red.shade700,
    category: 'Entretenimento',
    date: DateTime(2025, 4, 15),
  ),
  Expense(
    name: 'Farmácia',
    amount: 67.50,
    icon: Icons.medication,
    iconBackgroundColor: Colors.red.shade700,
    category: 'Saúde',
    date: DateTime(2025, 4, 8),
  ),
];