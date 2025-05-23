// lib/services/database_helper.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/expense.dart';
import '../models/fixed_expense.dart';
import '../models/finance_data.dart';
import '../models/category.dart'; // Nova importação
import '../database/schema.dart';
import '../database/migration_helper.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  // Padrão Singleton
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Obter uma localização para o banco de dados
    String path = join(await getDatabasesPath(), 'finances.db');
    
    // Abrir/criar o banco de dados
    return await openDatabase(
      path,
      version: DatabaseSchema.schemaVersion,
      onCreate: _createDb,
      onUpgrade: _upgradeDb,
    );
  }

  Future<void> _createDb(Database db, int version) async {
    // Criar todas as tabelas a partir do esquema
    for (String createStatement in DatabaseSchema.createTableStatements) {
      await db.execute(createStatement);
    }
    
    // Inserir categorias padrão
    await _insertDefaultCategories(db);
  }
  
  // Lidar com atualizações do banco de dados
  Future<void> _upgradeDb(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await MigrationHelper.migrateV1ToV2(db);
    }
    
    if (oldVersion < 3) {
      await MigrationHelper.migrateV2ToV3(db);
    }
  }
  
  // Método auxiliar para inserir categorias padrão
  Future<void> _insertDefaultCategories(Database db) async {
    // Verificar se já existem categorias
    final categoryCount = Sqflite.firstIntValue(
      await db.rawQuery(DatabaseSchema.countCategoriesQuery)
    );
    
    if (categoryCount == 0) {
      // Mapeamento das categorias para ícones e cores
      final categories = [
        {
          'name': 'Casa',
          'iconName': 'house', // Melhor do que 'home', mais específico para moradia
          'iconColorValue': Colors.blue.shade700.value,
        },
        {
          'name': 'Alimentação/Higiene',
          'iconName': 'restaurant_menu', // Representa comida de forma mais clara
          'iconColorValue': Colors.orange.shade700.value,
        },
        {
          'name': 'Transporte',
          'iconName': 'commute', // Ícone que representa transporte urbano
          'iconColorValue': Colors.green.shade700.value,
        },
        {
          'name': 'Saúde',
          'iconName': 'local_hospital', // Mais reconhecível para saúde do que 'medication'
          'iconColorValue': Colors.red.shade700.value,
        },
        {
          'name': 'Roupas',
          'iconName': 'checkroom', // Ícone de cabide, ideal para roupas
          'iconColorValue': Colors.purple.shade700.value,
        },
        {
          'name': 'Lazer',
          'iconName': 'sports_esports', // Um pouco mais abrangente e moderno que 'movie'
          'iconColorValue': Colors.amber.shade700.value,
        },
        {
          'name': 'Serviços',
          'iconName': 'handyman', // Mais completo que 'build' para serviços em geral
          'iconColorValue': Colors.grey.shade700.value,
        },
        {
          'name': 'Eletrônicos',
          'iconName': 'devices_other', // Representa tecnologia/eletrônicos
          'iconColorValue': Colors.indigo.shade700.value,
        },
        {
          'name': 'Outros',
          'iconName': 'category', // Representa uma categoria genérica
          'iconColorValue': Colors.teal.shade700.value,
        },
      ];

      
      // Inserir cada categoria
      for (var category in categories) {
        await db.insert(DatabaseSchema.categoriesTable, category);
      }
    }
  }

  // OPERAÇÕES CRUD DE DESPESA
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
  
  // OPERAÇÕES CRUD DE DESPESA FIXA
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
  
  // OPERAÇÕES CRUD DE RECEITA
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
  
  // OPERAÇÕES CRUD DE CATEGORIA
  Future<int> insertCategory(Category category) async {
    final db = await database;
    return await db.insert(
      DatabaseSchema.categoriesTable,
      category.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  
  Future<List<Category>> getCategories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      DatabaseSchema.getCategoriesQuery
    );
    
    return List.generate(maps.length, (i) {
      return Category.fromMap(maps[i]);
    });
  }
  
  Future<Category?> getCategoryByName(String name) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseSchema.categoriesTable,
      where: 'name = ?',
      whereArgs: [name],
    );
    
    if (maps.isNotEmpty) {
      return Category.fromMap(maps.first);
    }
    
    return null;
  }
  
  Future<int> updateCategory(Category category) async {
    final db = await database;
    return await db.update(
      DatabaseSchema.categoriesTable,
      category.toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }
  
  Future<int> deleteCategory(int id) async {
    final db = await database;
    return await db.delete(
      DatabaseSchema.categoriesTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  
  // OPERAÇÕES DE DADOS FINANCEIROS
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
    
    return null; // Sem dados para o mês atual
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
  
  // Inserir dados de exemplo
  Future<void> insertSampleData() async {
    final db = await database;
    
    // Verificar se já existem dados
    final expenseCount = Sqflite.firstIntValue(
      await db.rawQuery(DatabaseSchema.countExpensesQuery)
    );
    
    final fixedExpenseCount = Sqflite.firstIntValue(
      await db.rawQuery(DatabaseSchema.countFixedExpensesQuery)
    );
    
    if (expenseCount == 0 && fixedExpenseCount == 0) {
      // Inserir categorias padrão (já feito no método _insertDefaultCategories)
      
      // Dados de despesa regular de exemplo
      for (var expense in getSampleExpenses()) {
        await insertExpense(expense);
      }
      
      // Dados de despesa fixa de exemplo
      for (var fixedExpense in getSampleFixedExpenses()) {
        await insertFixedExpense(fixedExpense);
      }
      
      // Dados de receita de exemplo
      for (var income in getSampleIncomes()) {
        await insertIncome(income);
      }
      
      // Dados financeiros do mês atual
      await insertFinanceData(getCurrentFinances());
    }
  }
  
  // Método auxiliar para fornecer dados de despesa de exemplo
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
  
  // Método auxiliar para fornecer dados de despesa fixa de exemplo
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
  
  // Método auxiliar para fornecer dados de receita de exemplo
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
  
  // NOVO MÉTODO: Resetar banco de dados
  Future<void> resetDatabase() async {
    // Fechar primeiro quaisquer conexões abertas com o banco de dados
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
    
    // Obter o caminho do banco de dados e excluir o arquivo
    String path = join(await getDatabasesPath(), 'finances.db');
    if (await databaseExists(path)) {
      await deleteDatabase(path);
      print('Banco de dados excluído com sucesso');
    }
    
    // Reinicializar o banco de dados com dados de exemplo
    _database = await _initDatabase();
    await insertSampleData();
  }

  // Get all expenses that use a specific category
  Future<List<Expense>> getExpensesWithCategory(String categoryName) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseSchema.expensesTable,
      where: 'category = ?',
      whereArgs: [categoryName],
    );
    
    return List.generate(maps.length, (i) {
      return Expense.fromMap(maps[i]);
    });
  }

  // Get all incomes that use a specific category
  Future<List<Income>> getIncomesWithCategory(String categoryName) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseSchema.incomesTable,
      where: 'category = ?',
      whereArgs: [categoryName],
    );
    
    return List.generate(maps.length, (i) {
      return Income.fromMap(maps[i]);
    });
  }


    // Novo método para obter despesas de um mês específico
  Future<List<Expense>> getExpensesForMonth(DateTime month) async {
    final db = await database;
    final startOfMonth = DateTime(month.year, month.month, 1);
    final endOfMonth = DateTime(month.year, month.month + 1, 0, 23, 59, 59);
    
    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseSchema.expensesTable,
      where: 'date >= ? AND date <= ?',
      whereArgs: [
        startOfMonth.toIso8601String(),
        endOfMonth.toIso8601String(),
      ],
      orderBy: 'date DESC',
    );
    
    return List.generate(maps.length, (i) {
      return Expense.fromMap(maps[i]);
    });
  }

  // Método para obter dados financeiros de um mês específico
  Future<FinanceData?> getFinancesForMonth(DateTime month) async {
    final db = await database;
    final monthStr = '${month.year}-${month.month.toString().padLeft(2, '0')}';
    
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      DatabaseSchema.getCurrentMonthFinancesQuery,
      ['$monthStr%']
    );
    
    if (maps.isNotEmpty) {
      return FinanceData.fromMap(maps.first);
    }
    
    return null; // Sem dados para o mês especificado
  }

}