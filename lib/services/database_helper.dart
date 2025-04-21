// lib/services/database_helper.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/expense.dart';
import '../models/fixed_expense.dart';
import '../models/finance_data.dart';
import '../database/schema.dart';

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
      onUpgrade: _upgradeDb,
    );
  }

  Future<void> _createDb(Database db, int version) async {
    // Create all tables from the schema
    for (String createStatement in DatabaseSchema.createTableStatements) {
      await db.execute(createStatement);
    }
  }
  
  // Handle database upgrades
  Future<void> _upgradeDb(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // We're upgrading from version 1 to 2 - need to handle the split of expenses table
      
      // First create the new fixed_expenses table
      await db.execute(DatabaseSchema.createFixedExpensesTable);
      
      // Copy fixed expenses from old table to new table
      List<Map<String, dynamic>> fixedExpenses = await db.query(
        DatabaseSchema.expensesTable,
        where: 'dueDay > 0'
      );
      
      for (var expenseMap in fixedExpenses) {
        // Convert from old expense schema to new fixed expense schema
        await db.insert(
          DatabaseSchema.fixedExpensesTable,
          {
            'bill': expenseMap['name'],
            'amount': expenseMap['amount'],
            'iconName': expenseMap['iconName'],
            'iconColorValue': expenseMap['iconColorValue'],
            'date': expenseMap['date'],
            'dueDay': expenseMap['dueDay'],
            'paid': expenseMap['paid'] ?? 0,
          }
        );
      }
      
      // Create a temporary table with new schema for regular expenses
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
      
      // Drop old table
      await db.execute('DROP TABLE ${DatabaseSchema.expensesTable}');
      
      // Rename temporary table to expenses
      await db.execute('ALTER TABLE expenses_temp RENAME TO ${DatabaseSchema.expensesTable}');
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
  
  // FIXED EXPENSE CRUD OPERATIONS
  Future<int> insertFixedExpense(FixedExpense fixedExpense) async {
    final db = await database;
    return await db.insert(
      DatabaseSchema.fixedExpensesTable,
      fixedExpense.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  
  Future<List<FixedExpense>> getFixedExpenses() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      DatabaseSchema.getFixedExpensesQuery
    );
    
    return List.generate(maps.length, (i) {
      return FixedExpense.fromMap(maps[i]);
    });
  }
  
  Future<int> updateFixedExpense(FixedExpense fixedExpense) async {
    final db = await database;
    return await db.update(
      DatabaseSchema.fixedExpensesTable,
      fixedExpense.toMap(),
      where: 'id = ?',
      whereArgs: [fixedExpense.id],
    );
  }
  
  Future<int> deleteFixedExpense(int id) async {
    final db = await database;
    return await db.delete(
      DatabaseSchema.fixedExpensesTable,
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
    
    final fixedExpenseCount = Sqflite.firstIntValue(
      await db.rawQuery(DatabaseSchema.countFixedExpensesQuery)
    );
    
    if (expenseCount == 0 && fixedExpenseCount == 0) {
      // Sample regular expense data
      for (var expense in getSampleExpenses()) {
        await insertExpense(expense);
      }
      
      // Sample fixed expense data
      for (var fixedExpense in getSampleFixedExpenses()) {
        await insertFixedExpense(fixedExpense);
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
        name: 'Supermercado Extra',
        amount: 320.45,
        icon: Icons.shopping_cart,
        iconBackgroundColor: Colors.red.shade700,
        category: 'Alimentação',
        date: DateTime(2025, 4, 18),
      ),
      Expense(
        name: 'Farmácia',
        amount: 67.50,
        icon: Icons.medication,
        iconBackgroundColor: Colors.red.shade700,
        category: 'Saúde',
        date: DateTime(2025, 4, 8),
      ),
      Expense(
        name: 'Restaurante',
        amount: 85.90,
        icon: Icons.fastfood,
        iconBackgroundColor: Colors.orange.shade700,
        category: 'Alimentação',
        date: DateTime(2025, 4, 10),
      ),
    ];
  }
  
  // Helper method to provide sample fixed expense data
  List<FixedExpense> getSampleFixedExpenses() {
    return [
      FixedExpense(
        bill: 'Aluguel',
        amount: 1200.00,
        icon: Icons.home,
        iconBackgroundColor: Colors.blue.shade700,
        date: DateTime(2025, 4, 10),
        dueDay: 10,
      ),
      FixedExpense(
        bill: 'Energia',
        amount: 245.00,
        icon: Icons.bolt,
        iconBackgroundColor: Colors.amber.shade700,
        date: DateTime(2025, 4, 15),
        dueDay: 15,
        paid: true,
      ),
      FixedExpense(
        bill: 'Internet',
        amount: 120.00,
        icon: Icons.wifi,
        iconBackgroundColor: Colors.blue.shade500,
        date: DateTime(2025, 4, 20),
        dueDay: 20,
      ),
      FixedExpense(
        bill: 'Água',
        amount: 85.00,
        icon: Icons.water_drop,
        iconBackgroundColor: Colors.blue.shade300,
        date: DateTime(2025, 4, 15),
        dueDay: 15,
      ),
      FixedExpense(
        bill: 'Netflix',
        amount: 39.90,
        icon: Icons.movie,
        iconBackgroundColor: Colors.red.shade700,
        date: DateTime(2025, 4, 15),
        dueDay: 15,
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