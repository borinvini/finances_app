// lib/database/migration_helper.dart
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
}