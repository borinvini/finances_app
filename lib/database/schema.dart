// lib/database/schema.dart
class DatabaseSchema {
  // Table names as constants
  static const String expensesTable = 'expenses';
  static const String incomesTable = 'incomes';
  static const String financeDataTable = 'finance_data';
  
  // Schema version
  static const int schemaVersion = 1;
  
  // Create tables SQL statements
  static const String createExpensesTable = '''
    CREATE TABLE $expensesTable(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      amount REAL NOT NULL,
      iconName TEXT NOT NULL,
      iconColorValue INTEGER NOT NULL,
      category TEXT NOT NULL,
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
  
  // List of all creation scripts for easier database initialization
  static final List<String> createTableStatements = [
    createExpensesTable,
    createIncomesTable,
    createFinanceDataTable,
  ];
  
  // SQL queries for data retrieval
  static const String getRecentExpensesQuery = '''
    SELECT * FROM $expensesTable
    ORDER BY date DESC
  ''';
  
  static const String getFixedExpensesQuery = '''
    SELECT * FROM $expensesTable
    WHERE dueDay > 0
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
  
  // Query to check if data exists
  static const String countExpensesQuery = '''
    SELECT COUNT(*) FROM $expensesTable
  ''';
}