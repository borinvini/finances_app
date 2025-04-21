import 'package:flutter/material.dart';

class Expense {
  final int? id; // ID for database (nullable for new records)
  final String name;
  final double amount;
  final IconData icon;
  final Color iconBackgroundColor;
  final String category;
  final DateTime date;

  Expense({
    this.id,
    required this.name,
    required this.amount,
    required this.icon,
    required this.iconBackgroundColor,
    required this.category,
    required this.date,
  });

  // Convert Expense object to a Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'amount': amount,
      'iconName': iconToString(icon),
      'iconColorValue': iconBackgroundColor.value,
      'category': category,
      'date': date.toIso8601String(),
    };
  }

  // Create an Expense object from a SQLite map
  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      name: map['name'],
      amount: map['amount'],
      icon: stringToIcon(map['iconName']),
      iconBackgroundColor: Color(map['iconColorValue']),
      category: map['category'],
      date: DateTime.parse(map['date']),
    );
  }
  
  // Helper methods to convert IconData to/from string
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
  
  // Copy an expense with some fields changed
  Expense copyWith({
    int? id,
    String? name,
    double? amount,
    IconData? icon,
    Color? iconBackgroundColor,
    String? category,
    DateTime? date,
  }) {
    return Expense(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      icon: icon ?? this.icon,
      iconBackgroundColor: iconBackgroundColor ?? this.iconBackgroundColor,
      category: category ?? this.category,
      date: date ?? this.date,
    );
  }
}

// Keeping the Income class in the same file as it was originally
class Income {
  final int? id; // ID for database (nullable for new records)
  final String name;
  final double amount;
  final IconData icon;
  final Color iconBackgroundColor;
  final String category;
  final DateTime date;
  final int receiveDay;
  bool received;

  Income({
    this.id,
    required this.name,
    required this.amount,
    required this.icon,
    required this.iconBackgroundColor,
    required this.category,
    required this.date,
    this.receiveDay = 0,
    this.received = false,
  });

  // Convert Income object to a Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'amount': amount,
      'iconName': Expense.iconToString(icon), // Reuse icon conversion
      'iconColorValue': iconBackgroundColor.value,
      'category': category,
      'date': date.toIso8601String(),
      'receiveDay': receiveDay,
      'received': received ? 1 : 0,
    };
  }

  // Create an Income object from a SQLite map
  factory Income.fromMap(Map<String, dynamic> map) {
    return Income(
      id: map['id'],
      name: map['name'],
      amount: map['amount'],
      icon: Expense.stringToIcon(map['iconName']), // Reuse icon conversion
      iconBackgroundColor: Color(map['iconColorValue']),
      category: map['category'],
      date: DateTime.parse(map['date']),
      receiveDay: map['receiveDay'] ?? 0,
      received: map['received'] == 1,
    );
  }
  
  // Copy an income with some fields changed
  Income copyWith({
    int? id,
    String? name,
    double? amount,
    IconData? icon,
    Color? iconBackgroundColor,
    String? category,
    DateTime? date,
    int? receiveDay,
    bool? received,
  }) {
    return Income(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      icon: icon ?? this.icon,
      iconBackgroundColor: iconBackgroundColor ?? this.iconBackgroundColor,
      category: category ?? this.category,
      date: date ?? this.date,
      receiveDay: receiveDay ?? this.receiveDay,
      received: received ?? this.received,
    );
  }
}