// lib/models/fixed_expense.dart
import 'package:flutter/material.dart';

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
      'iconName': iconToString(icon),
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
      icon: stringToIcon(map['iconName']),
      iconBackgroundColor: Color(map['iconColorValue']),
      date: DateTime.parse(map['date']),
      dueDay: map['dueDay'],
      paid: map['paid'] == 1,
    );
  }
  
  // Helper methods to convert IconData to/from string - reusing from Expense model
  static String iconToString(IconData icon) {
    // This is a simple mapping - expand for more icons as needed
    if (icon == Icons.home) return 'home';
    if (icon == Icons.bolt) return 'bolt';
    if (icon == Icons.wifi) return 'wifi';
    if (icon == Icons.water_drop) return 'water_drop';
    if (icon == Icons.shopping_cart) return 'shopping_cart';
    if (icon == Icons.movie) return 'movie';
    if (icon == Icons.medication) return 'medication';
    if (icon == Icons.fastfood) return 'fastfood';
    if (icon == Icons.directions_car) return 'directions_car';
    if (icon == Icons.phone_android) return 'phone_android';
    
    return 'attach_money'; // Default icon
  }
  
  static IconData stringToIcon(String iconName) {
    switch(iconName) {
      case 'home': return Icons.home;
      case 'bolt': return Icons.bolt;
      case 'wifi': return Icons.wifi;
      case 'water_drop': return Icons.water_drop;
      case 'shopping_cart': return Icons.shopping_cart;
      case 'movie': return Icons.movie;
      case 'medication': return Icons.medication;
      case 'fastfood': return Icons.fastfood;
      case 'directions_car': return Icons.directions_car;
      case 'phone_android': return Icons.phone_android;
      default: return Icons.attach_money;
    }
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