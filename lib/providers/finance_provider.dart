import 'package:flutter/material.dart';

import '../services/database_helper.dart';
import '../models/expense.dart';
import '../models/fixed_expense.dart';
import '../models/finance_data.dart';
import '../models/category.dart'; // Nova importação

class FinanceProvider with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  
  // Dados de estado
  FinanceData? _currentFinanceData;
  List<Expense> _recentExpenses = [];
  List<FixedExpense> _fixedExpenses = [];
  List<Income> _fixedIncomes = [];
  List<Category> _categories = []; // Nova lista para categorias
  
  // Getters
  FinanceData get currentFinanceData => _currentFinanceData ?? getCurrentFinances();
  List<Expense> get recentExpenses => _recentExpenses;
  List<FixedExpense> get fixedExpenses => _fixedExpenses;
  List<Income> get fixedIncomes => _fixedIncomes;
  List<Category> get categories => _categories; // Novo getter
  
  // Cálculo do orçamento fixo total
  double get totalFixedBudget => _fixedExpenses.fold(0, (sum, expense) => sum + expense.amount);
  
  // Cálculo da receita total
  double get totalIncome => _fixedIncomes.fold(0, (sum, income) => sum + income.amount);
  
  // Cálculo do saldo
  double get fixedBudgetBalance => totalIncome - totalFixedBudget;
  
  // Carregar todos os dados do banco de dados
  Future<void> loadAllData() async {
    // Inicializar banco de dados com dados de exemplo, se necessário
    await _dbHelper.insertSampleData();
    
    // Carregar categorias
    _categories = await _dbHelper.getCategories();
    
    // Carregar dados financeiros do mês atual
    final financeData = await _dbHelper.getCurrentMonthFinances();
    if (financeData != null) {
      _currentFinanceData = financeData;
    }
    
    // Carregar despesas recentes
    _recentExpenses = await _dbHelper.getRecentExpenses();
    
    // Carregar despesas fixas
    _fixedExpenses = await _dbHelper.getFixedExpenses();
    
    // Carregar receitas fixas
    _fixedIncomes = await _dbHelper.getFixedIncomes();
    
    notifyListeners();
  }
  
  // Adicionar uma nova despesa
  Future<void> addExpense(Expense expense) async {
    await _dbHelper.insertExpense(expense);
    
    // Recarregar despesas recentes
    _recentExpenses = await _dbHelper.getRecentExpenses();
    
    // Atualizar totais nos dados financeiros
    await _updateFinanceSummary();
    
    notifyListeners();
  }
  
  // Atualizar uma despesa
  Future<void> updateExpense(Expense expense) async {
    await _dbHelper.updateExpense(expense);
    
    // Recarregar despesas
    _recentExpenses = await _dbHelper.getRecentExpenses();
    
    // Atualizar totais nos dados financeiros
    await _updateFinanceSummary();
    
    notifyListeners();
  }
  
  // Excluir uma despesa
  Future<void> deleteExpense(int id) async {
    await _dbHelper.deleteExpense(id);
    
    // Recarregar despesas
    _recentExpenses = await _dbHelper.getRecentExpenses();
    
    // Atualizar totais nos dados financeiros
    await _updateFinanceSummary();
    
    notifyListeners();
  }
  
  // Adicionar uma nova despesa fixa
  Future<void> addFixedExpense(FixedExpense fixedExpense) async {
    await _dbHelper.insertFixedExpense(fixedExpense);
    
    // Recarregar despesas fixas
    _fixedExpenses = await _dbHelper.getFixedExpenses();
    
    // Atualizar totais nos dados financeiros
    await _updateFinanceSummary();
    
    notifyListeners();
  }
  
  // Atualizar uma despesa fixa
  Future<void> updateFixedExpense(FixedExpense fixedExpense) async {
    await _dbHelper.updateFixedExpense(fixedExpense);
    
    // Recarregar despesas fixas
    _fixedExpenses = await _dbHelper.getFixedExpenses();
    
    // Atualizar totais nos dados financeiros
    await _updateFinanceSummary();
    
    notifyListeners();
  }
  
  // Excluir uma despesa fixa
  Future<void> deleteFixedExpense(int id) async {
    await _dbHelper.deleteFixedExpense(id);
    
    // Recarregar despesas fixas
    _fixedExpenses = await _dbHelper.getFixedExpenses();
    
    // Atualizar totais nos dados financeiros
    await _updateFinanceSummary();
    
    notifyListeners();
  }
  
  // Adicionar uma nova receita
  Future<void> addIncome(Income income) async {
    await _dbHelper.insertIncome(income);
    
    // Recarregar receitas fixas
    _fixedIncomes = await _dbHelper.getFixedIncomes();
    
    // Atualizar totais nos dados financeiros
    await _updateFinanceSummary();
    
    notifyListeners();
  }
  
  // Atualizar uma receita
  Future<void> updateIncome(Income income) async {
    await _dbHelper.updateIncome(income);
    
    // Recarregar receitas fixas
    _fixedIncomes = await _dbHelper.getFixedIncomes();
    
    // Atualizar totais nos dados financeiros
    await _updateFinanceSummary();
    
    notifyListeners();
  }
  
  // Excluir uma receita
  Future<void> deleteIncome(int id) async {
    await _dbHelper.deleteIncome(id);
    
    // Recarregar receitas fixas
    _fixedIncomes = await _dbHelper.getFixedIncomes();
    
    // Atualizar totais nos dados financeiros
    await _updateFinanceSummary();
    
    notifyListeners();
  }
  
  // Alternar status de pago da despesa fixa
  Future<void> toggleExpensePaid(FixedExpense fixedExpense) async {
    FixedExpense updatedExpense = fixedExpense.copyWith(paid: !fixedExpense.paid);
    await updateFixedExpense(updatedExpense);
  }
  
  // Alternar status de recebido da receita
  Future<void> toggleIncomeReceived(Income income) async {
    Income updatedIncome = income.copyWith(received: !income.received);
    await updateIncome(updatedIncome);
  }
  
  // Novo método para obter uma categoria por nome
  Future<Category?> getCategoryByName(String name) async {
    return await _dbHelper.getCategoryByName(name);
  }
  
  // Atualizar dados de resumo financeiro
  Future<void> _updateFinanceSummary() async {
    // Obter todas as despesas e receitas
    final allExpenses = await _dbHelper.getExpenses();
    final allFixedExpenses = await _dbHelper.getFixedExpenses();
    final allIncomes = await _dbHelper.getIncomes();
    
    // Calcular totais
    final totalRegularExpenses = allExpenses.fold(0.0, (sum, expense) => sum + expense.amount);
    final totalFixedExpenses = allFixedExpenses.fold(0.0, (sum, expense) => sum + expense.amount);
    final totalExpenses = totalRegularExpenses + totalFixedExpenses;
    
    final totalIncome = allIncomes.fold(0.0, (sum, income) => sum + income.amount);
    final balance = totalIncome - totalExpenses;
    
    // Criar ou atualizar dados financeiros para o mês atual
    final now = DateTime.now();
    final month = DateTime(now.year, now.month);
    
    if (_currentFinanceData != null) {
      // Atualizar registro existente
      final updatedData = _currentFinanceData!.copyWith(
        balance: balance,
        income: totalIncome,
        expenses: totalExpenses,
      );
      
      await _dbHelper.updateFinanceData(updatedData);
      _currentFinanceData = updatedData;
    } else {
      // Criar novo registro
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
  
  // Resetar banco de dados e recarregar dados
  Future<void> resetDatabaseAndReload() async {
    await _dbHelper.resetDatabase();
    await loadAllData();
    notifyListeners();
  }
  
  // Este método é para "desfazer" uma operação de exclusão
  Future<void> undeleteExpense(Expense expense) async {
    // Readicionar a despesa ao banco de dados
    await addExpense(expense);
  }
}