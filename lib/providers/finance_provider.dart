import 'package:flutter/material.dart';

import '../services/database_helper.dart';
import '../models/expense.dart';
import '../models/finance_data.dart';

class FinanceProvider with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  
  // State data
  FinanceData? _currentFinanceData;
  List<Expense> _recentExpenses = [];
  List<Expense> _fixedExpenses = [];
  List<Income> _fixedIncomes = [];
  
  // Getters
  FinanceData get currentFinanceData => _currentFinanceData ?? getCurrentFinances();
  List<Expense> get recentExpenses => _recentExpenses;
  List<Expense> get fixedExpenses => _fixedExpenses;
  List<Income> get fixedIncomes => _fixedIncomes;
  
  // Total fixed budget calculation
  double get totalFixedBudget => _fixedExpenses.fold(0, (sum, expense) => sum + expense.amount);
  
  // Total income calculation
  double get totalIncome => _fixedIncomes.fold(0, (sum, income) => sum + income.amount);
  
  // Balance calculation
  double get fixedBudgetBalance => totalIncome - totalFixedBudget;
  
  // Load all data from database
  Future<void> loadAllData() async {
    // Initialize database with sample data if needed
    await _dbHelper.insertSampleData();
    
    // Load current month finance data
    final financeData = await _dbHelper.getCurrentMonthFinances();
    if (financeData != null) {
      _currentFinanceData = financeData;
    }
    
    // Load recent expenses
    _recentExpenses = await _dbHelper.getRecentExpenses();
    
    // Load fixed expenses (with due day)
    _fixedExpenses = await _dbHelper.getFixedExpenses();
    
    // Load fixed incomes
    _fixedIncomes = await _dbHelper.getFixedIncomes();
    
    notifyListeners();
  }
  
  // Add a new expense
  Future<void> addExpense(Expense expense) async {
    await _dbHelper.insertExpense(expense);
    
    // Reload data based on type
    if (expense.dueDay > 0) {
      _fixedExpenses = await _dbHelper.getFixedExpenses();
    }
    
    _recentExpenses = await _dbHelper.getRecentExpenses();
    
    // Update totals in finance data
    await _updateFinanceSummary();
    
    notifyListeners();
  }
  
  // Update an expense
  Future<void> updateExpense(Expense expense) async {
    await _dbHelper.updateExpense(expense);
    
    // Reload data based on type
    if (expense.dueDay > 0) {
      _fixedExpenses = await _dbHelper.getFixedExpenses();
    }
    
    _recentExpenses = await _dbHelper.getRecentExpenses();
    
    // Update totals in finance data
    await _updateFinanceSummary();
    
    notifyListeners();
  }
  
  // Delete an expense
  Future<void> deleteExpense(int id) async {
    await _dbHelper.deleteExpense(id);
    
    // Reload all expenses since we don't know the type
    _fixedExpenses = await _dbHelper.getFixedExpenses();
    _recentExpenses = await _dbHelper.getRecentExpenses();
    
    // Update totals in finance data
    await _updateFinanceSummary();
    
    notifyListeners();
  }
  
  // Add a new income
  Future<void> addIncome(Income income) async {
    await _dbHelper.insertIncome(income);
    
    // Reload fixed incomes
    _fixedIncomes = await _dbHelper.getFixedIncomes();
    
    // Update totals in finance data
    await _updateFinanceSummary();
    
    notifyListeners();
  }
  
  // Update an income
  Future<void> updateIncome(Income income) async {
    await _dbHelper.updateIncome(income);
    
    // Reload fixed incomes
    _fixedIncomes = await _dbHelper.getFixedIncomes();
    
    // Update totals in finance data
    await _updateFinanceSummary();
    
    notifyListeners();
  }
  
  // Delete an income
  Future<void> deleteIncome(int id) async {
    await _dbHelper.deleteIncome(id);
    
    // Reload fixed incomes
    _fixedIncomes = await _dbHelper.getFixedIncomes();
    
    // Update totals in finance data
    await _updateFinanceSummary();
    
    notifyListeners();
  }
  
  // Toggle expense paid status
  Future<void> toggleExpensePaid(Expense expense) async {
    Expense updatedExpense = expense.copyWith(paid: !expense.paid);
    await updateExpense(updatedExpense);
  }
  
  // Toggle income received status
  Future<void> toggleIncomeReceived(Income income) async {
    Income updatedIncome = income.copyWith(received: !income.received);
    await updateIncome(updatedIncome);
  }
  
  // Update finance summary data
  Future<void> _updateFinanceSummary() async {
    // Get all expenses and incomes
    final allExpenses = await _dbHelper.getExpenses();
    final allIncomes = await _dbHelper.getIncomes();
    
    // Calculate totals
    final totalExpenses = allExpenses.fold(0.0, (sum, expense) => sum + expense.amount);
    final totalIncome = allIncomes.fold(0.0, (sum, income) => sum + income.amount);
    final balance = totalIncome - totalExpenses;
    
    // Create or update finance data for current month
    final now = DateTime.now();
    final month = DateTime(now.year, now.month);
    
    if (_currentFinanceData != null) {
      // Update existing record
      final updatedData = _currentFinanceData!.copyWith(
        balance: balance,
        income: totalIncome,
        expenses: totalExpenses,
      );
      
      await _dbHelper.updateFinanceData(updatedData);
      _currentFinanceData = updatedData;
    } else {
      // Create new record
      final newData = FinanceData(
        balance: balance,
        income: totalIncome, 
        expenses: totalExpenses,
        month: month,
      );
      
      final id = await _dbHelper.insertFinanceData(newData);
      _currentFinanceData = newData.copyWith(id: id);
    }
  }
}