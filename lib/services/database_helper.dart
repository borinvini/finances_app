// lib/services/database_helper.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/expense.dart';
import '../models/finance_data.dart';
import '../database/schema.dart'; // Import the schema

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  // Singleton pattern
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Get a location for the database
    String path = join(await getDatabasesPath(), 'finances.db');
    
    // Open/create the database
    return await openDatabase(
      path,
      version: DatabaseSchema.schemaVersion,
      onCreate: _createDb,
    );
  }

  Future<void> _createDb(Database db, int version) async {
    // Create all tables from the schema
    for (String createStatement in DatabaseSchema.createTableStatements) {
      await db.execute(createStatement);
    }
  }

  // EXPENSE CRUD OPERATIONS
  Future<int> insertExpense(Expense expense) async {
    final db = await database;
    return await db.insert(
      DatabaseSchema.expensesTable,
      expense.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  
  Future<List<Expense>> getExpenses() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(DatabaseSchema.expensesTable);
    
    return List.generate(maps.length, (i) {
      return Expense.fromMap(maps[i]);
    });
  }
  
  Future<List<Expense>> getRecentExpenses({int limit = 5}) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '${DatabaseSchema.getRecentExpensesQuery} LIMIT $limit'
    );
    
    return List.generate(maps.length, (i) {
      return Expense.fromMap(maps[i]);
    });
  }
  
  Future<List<Expense>> getFixedExpenses() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      DatabaseSchema.getFixedExpensesQuery
    );
    
    return List.generate(maps.length, (i) {
      return Expense.fromMap(maps[i]);
    });
  }
  
  Future<int> updateExpense(Expense expense) async {
    final db = await database;
    return await db.update(
      DatabaseSchema.expensesTable,
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }
  
  Future<int> deleteExpense(int id) async {
    final db = await database;
    return await db.delete(
      DatabaseSchema.expensesTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  
  // INCOME CRUD OPERATIONS
  Future<int> insertIncome(Income income) async {
    final db = await database;
    return await db.insert(
      DatabaseSchema.incomesTable,
      income.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  
  Future<List<Income>> getIncomes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(DatabaseSchema.incomesTable);
    
    return List.generate(maps.length, (i) {
      return Income.fromMap(maps[i]);
    });
  }
  
  Future<List<Income>> getFixedIncomes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      DatabaseSchema.getFixedIncomesQuery
    );
    
    return List.generate(maps.length, (i) {
      return Income.fromMap(maps[i]);
    });
  }
  
  Future<int> updateIncome(Income income) async {
    final db = await database;
    return await db.update(
      DatabaseSchema.incomesTable,
      income.toMap(),
      where: 'id = ?',
      whereArgs: [income.id],
    );
  }
  
  Future<int> deleteIncome(int id) async {
    final db = await database;
    return await db.delete(
      DatabaseSchema.incomesTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  
  // FINANCE DATA OPERATIONS
  Future<int> insertFinanceData(FinanceData financeData) async {
    final db = await database;
    return await db.insert(
      DatabaseSchema.financeDataTable,
      financeData.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  
  Future<FinanceData?> getCurrentMonthFinances() async {
    final db = await database;
    final now = DateTime.now();
    final monthStr = '${now.year}-${now.month.toString().padLeft(2, '0')}';
    
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      DatabaseSchema.getCurrentMonthFinancesQuery,
      ['$monthStr%']
    );
    
    if (maps.isNotEmpty) {
      return FinanceData.fromMap(maps.first);
    }
    
    return null; // No data for current month
  }
  
  Future<int> updateFinanceData(FinanceData financeData) async {
    final db = await database;
    return await db.update(
      DatabaseSchema.financeDataTable,
      financeData.toMap(),
      where: 'id = ?',
      whereArgs: [financeData.id],
    );
  }
  
  // Insert sample data
  Future<void> insertSampleData() async {
    final db = await database;
    
    // Check if data already exists
    final expenseCount = Sqflite.firstIntValue(
      await db.rawQuery(DatabaseSchema.countExpensesQuery)
    );
    
    if (expenseCount == 0) {
      // Sample expense data
      for (var expense in getSampleExpenses()) {
        await insertExpense(expense);
      }
      
      // Sample income data
      for (var income in getSampleIncomes()) {
        await insertIncome(income);
      }
      
      // Current month finance data
      await insertFinanceData(getCurrentFinances());
    }
  }
  
  // Helper method to provide sample expense data
  List<Expense> getSampleExpenses() {
    return [
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
        paid: true,
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
  }
  
  // Helper method to provide sample income data
  List<Income> getSampleIncomes() {
    return [
      Income(
        name: 'Salário',
        amount: 4000.00,
        icon: Icons.account_balance_wallet,
        iconBackgroundColor: Colors.green.shade700,
        category: 'Trabalho',
        date: DateTime(2025, 4, 5),
        receiveDay: 5,
        received: true,
      ),
      Income(
        name: 'Freelance',
        amount: 500.00,
        icon: Icons.work,
        iconBackgroundColor: Colors.green.shade500,
        category: 'Trabalho Extra',
        date: DateTime(2025, 4, 20),
        receiveDay: 20,
      ),
    ];
  }
}