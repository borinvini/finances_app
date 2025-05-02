// lib/database/schema.dart
class DatabaseSchema {
  // Nome das tabelas como constantes
  static const String expensesTable = 'expenses';
  static const String fixedExpensesTable = 'fixed_expenses';
  static const String incomesTable = 'incomes';
  static const String financeDataTable = 'finance_data';
  static const String categoriesTable = 'categories'; // Nova tabela
  
  // Versão do esquema
  static const int schemaVersion = 3; // Versão incrementada para a alteração do esquema
  
  // Declarações SQL para criar tabelas
  static const String createExpensesTable = '''
    CREATE TABLE $expensesTable(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      amount REAL NOT NULL,
      iconName TEXT NOT NULL,
      iconColorValue INTEGER NOT NULL,
      category TEXT NOT NULL,
      date TEXT NOT NULL
    )
  ''';
  
  static const String createFixedExpensesTable = '''
    CREATE TABLE $fixedExpensesTable(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      bill TEXT NOT NULL,
      amount REAL NOT NULL,
      iconName TEXT NOT NULL,
      iconColorValue INTEGER NOT NULL,
      date TEXT NOT NULL,
      dueDay INTEGER,
      paid INTEGER NOT NULL
    )
  ''';
  
  static const String createIncomesTable = '''
    CREATE TABLE $incomesTable(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      amount REAL NOT NULL,
      iconName TEXT NOT NULL,
      iconColorValue INTEGER NOT NULL,
      category TEXT NOT NULL,
      date TEXT NOT NULL,
      receiveDay INTEGER,
      received INTEGER NOT NULL
    )
  ''';
  
  static const String createFinanceDataTable = '''
    CREATE TABLE $financeDataTable(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      balance REAL NOT NULL,
      income REAL NOT NULL,
      expenses REAL NOT NULL,
      month TEXT NOT NULL
    )
  ''';
  
  // Nova tabela de categorias
  static const String createCategoriesTable = '''
    CREATE TABLE $categoriesTable(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      iconName TEXT NOT NULL,
      iconColorValue INTEGER NOT NULL
    )
  ''';
  
  // Lista de todos os scripts de criação para inicialização mais fácil do banco de dados
  static final List<String> createTableStatements = [
    createExpensesTable,
    createFixedExpensesTable,
    createIncomesTable,
    createFinanceDataTable,
    createCategoriesTable, // Adicionado à lista
  ];
  
  // Consultas SQL para recuperação de dados
  static const String getRecentExpensesQuery = '''
    SELECT * FROM $expensesTable
    ORDER BY date DESC
  ''';
  
  static const String getFixedExpensesQuery = '''
    SELECT * FROM $fixedExpensesTable
    ORDER BY dueDay ASC
  ''';
  
  static const String getFixedIncomesQuery = '''
    SELECT * FROM $incomesTable
    WHERE receiveDay > 0
    ORDER BY receiveDay ASC
  ''';
  
  static const String getCurrentMonthFinancesQuery = '''
    SELECT * FROM $financeDataTable
    WHERE month LIKE ?
    LIMIT 1
  ''';
  
  // Nova consulta para obter categorias
  static const String getCategoriesQuery = '''
    SELECT * FROM $categoriesTable
    ORDER BY name ASC
  ''';
  
  // Consulta para verificar se dados existem
  static const String countExpensesQuery = '''
    SELECT COUNT(*) FROM $expensesTable
  ''';
  
  static const String countFixedExpensesQuery = '''
    SELECT COUNT(*) FROM $fixedExpensesTable
  ''';
  
  static const String countCategoriesQuery = '''
    SELECT COUNT(*) FROM $categoriesTable
  ''';
}