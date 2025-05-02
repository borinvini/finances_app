// lib/models/category.dart
import 'package:flutter/material.dart';
import 'expense.dart';

class Category {
  final int? id; // ID para o banco de dados (nullable para novos registros)
  final String name;
  final IconData icon;
  final Color iconBackgroundColor;

  Category({
    this.id,
    required this.name,
    required this.icon,
    required this.iconBackgroundColor,
  });

  // Converter objeto Category para um Map para o SQLite
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'iconName': iconToString(icon),
      'iconColorValue': iconBackgroundColor.value,
    };
  }

  // Criar um objeto Category a partir de um Map do SQLite
  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
      icon: stringToIcon(map['iconName']),
      iconBackgroundColor: Color(map['iconColorValue']),
    );
  }

  // Reutilizar os métodos de conversão de ícones existentes
  static String iconToString(IconData icon) => Expense.iconToString(icon);
  static IconData stringToIcon(String iconName) => Expense.stringToIcon(iconName);
}