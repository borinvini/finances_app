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
  
  // UPDATED: Complete icon mapping to match CategoryFormScreen icons
  static String iconToString(IconData icon) {
    // Original icons
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
    
    // Additional icons from CategoryFormScreen
    if (icon == Icons.school) return 'school';
    if (icon == Icons.local_hospital) return 'local_hospital';
    if (icon == Icons.sports_soccer) return 'sports_soccer';
    if (icon == Icons.attach_money) return 'attach_money';
    if (icon == Icons.credit_card) return 'credit_card';
    if (icon == Icons.local_atm) return 'local_atm';
    if (icon == Icons.fitness_center) return 'fitness_center';
    if (icon == Icons.flight_takeoff) return 'flight_takeoff';
    if (icon == Icons.laptop_mac) return 'laptop_mac';
    if (icon == Icons.restaurant) return 'restaurant';
    if (icon == Icons.build) return 'build';
    if (icon == Icons.category) return 'category';
    if (icon == Icons.celebration) return 'celebration';
    if (icon == Icons.child_care) return 'child_care';
    if (icon == Icons.pets) return 'pets';
    if (icon == Icons.book) return 'book';
    if (icon == Icons.coffee) return 'coffee';
    if (icon == Icons.local_bar) return 'local_bar';
    if (icon == Icons.train) return 'train';
    if (icon == Icons.apartment) return 'apartment';
    
    // Additional icons that might be used
    if (icon == Icons.handyman) return 'handyman';
    if (icon == Icons.devices_other) return 'devices_other';
    if (icon == Icons.checkroom) return 'checkroom';
    if (icon == Icons.sports_esports) return 'sports_esports';
    if (icon == Icons.restaurant_menu) return 'restaurant_menu';
    if (icon == Icons.commute) return 'commute';
    if (icon == Icons.house) return 'house';
    
    return 'category'; // Default to category icon instead of attach_money
  }
  
  static IconData stringToIcon(String iconName) {
    switch(iconName) {
      // Original icons
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
      
      // Additional icons from CategoryFormScreen
      case 'school': return Icons.school;
      case 'local_hospital': return Icons.local_hospital;
      case 'sports_soccer': return Icons.sports_soccer;
      case 'attach_money': return Icons.attach_money;
      case 'credit_card': return Icons.credit_card;
      case 'local_atm': return Icons.local_atm;
      case 'fitness_center': return Icons.fitness_center;
      case 'flight_takeoff': return Icons.flight_takeoff;
      case 'laptop_mac': return Icons.laptop_mac;
      case 'restaurant': return Icons.restaurant;
      case 'build': return Icons.build;
      case 'category': return Icons.category;
      case 'celebration': return Icons.celebration;
      case 'child_care': return Icons.child_care;
      case 'pets': return Icons.pets;
      case 'book': return Icons.book;
      case 'coffee': return Icons.coffee;
      case 'local_bar': return Icons.local_bar;
      case 'train': return Icons.train;
      case 'apartment': return Icons.apartment;
      
      // Additional icons that might be used
      case 'handyman': return Icons.handyman;
      case 'devices_other': return Icons.devices_other;
      case 'checkroom': return Icons.checkroom;
      case 'sports_esports': return Icons.sports_esports;
      case 'restaurant_menu': return Icons.restaurant_menu;
      case 'commute': return Icons.commute;
      case 'house': return Icons.house;
      
      default: return Icons.category; // Default to category icon
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