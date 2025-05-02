// lib/database/migration_helper.dart
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'schema.dart';

class MigrationHelper {
  static Future<void> migrateV1ToV2(Database db) async {
    // Create the new fixed_expenses table
    await db.execute(DatabaseSchema.createFixedExpensesTable);
    
    // Get all fixed expenses from the old table
    List<Map<String, dynamic>> fixedExpenses = await db.query(
      DatabaseSchema.expensesTable,
      where: 'dueDay > 0'
    );
    
    // Insert fixed expenses into the new table
    for (var expense in fixedExpenses) {
      await db.insert(
        DatabaseSchema.fixedExpensesTable,
        {
          'bill': expense['name'],
          'amount': expense['amount'],
          'iconName': expense['iconName'],
          'iconColorValue': expense['iconColorValue'],
          'date': expense['date'],
          'dueDay': expense['dueDay'],
          'paid': expense['paid'] ?? 0,
        }
      );
    }
    
    // Create a temporary table with the new schema for regular expenses
    await db.execute('''
      CREATE TABLE expenses_temp(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        amount REAL NOT NULL,
        iconName TEXT NOT NULL,
        iconColorValue INTEGER NOT NULL,
        category TEXT NOT NULL,
        date TEXT NOT NULL
      )
    ''');
    
    // Copy regular expenses to the temporary table
    await db.execute('''
      INSERT INTO expenses_temp (name, amount, iconName, iconColorValue, category, date)
      SELECT name, amount, iconName, iconColorValue, category, date
      FROM ${DatabaseSchema.expensesTable}
      WHERE dueDay IS NULL OR dueDay <= 0
    ''');
    
    // Drop the old table
    await db.execute('DROP TABLE ${DatabaseSchema.expensesTable}');
    
    // Rename the temporary table to expenses
    await db.execute('ALTER TABLE expenses_temp RENAME TO ${DatabaseSchema.expensesTable}');
    
    print('Migration from V1 to V2 completed successfully');
  }

  static Future<void> migrateV2ToV3(Database db) async {
    // Criar a nova tabela de categorias
    await db.execute(DatabaseSchema.createCategoriesTable);
    
    // Inserir as categorias padrão com ícones e cores predefinidos
    await _insertDefaultCategories(db);
    
    print('Migration from V2 to V3 completed successfully');
  }
  
  // Método auxiliar para inserir categorias padrão
  static Future<void> _insertDefaultCategories(Database db) async {
    // Mapeamento das categorias para ícones e cores
    final categories = [
      {
        'name': 'Moradia',
        'iconName': 'home',
        'iconColorValue': Colors.blue.shade700.value
      },
      {
        'name': 'Alimentação',
        'iconName': 'fastfood',
        'iconColorValue': Colors.orange.shade700.value
      },
      {
        'name': 'Transporte',
        'iconName': 'directions_car',
        'iconColorValue': Colors.green.shade700.value
      },
      {
        'name': 'Saúde',
        'iconName': 'medication',
        'iconColorValue': Colors.red.shade700.value
      },
      {
        'name': 'Educação',
        'iconName': 'school',
        'iconColorValue': Colors.purple.shade700.value
      },
      {
        'name': 'Lazer',
        'iconName': 'movie',
        'iconColorValue': Colors.amber.shade700.value
      },
      {
        'name': 'Serviços',
        'iconName': 'build',
        'iconColorValue': Colors.grey.shade700.value
      },
      {
        'name': 'Outros',
        'iconName': 'attach_money',
        'iconColorValue': Colors.teal.shade700.value
      }
    ];
    
    // Inserir cada categoria
    for (var category in categories) {
      await db.insert(DatabaseSchema.categoriesTable, category);
    }
  }
}