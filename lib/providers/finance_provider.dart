import 'package:flutter/material.dart';

import '../services/database_helper.dart';
import '../models/expense.dart';
import '../models/fixed_expense.dart';
import '../models/finance_data.dart';
import '../models/category.dart';

class FinanceProvider with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  
  // Dados de estado
  FinanceData? _currentFinanceData;
  List<Expense> _recentExpenses = [];
  List<FixedExpense> _fixedExpenses = [];
  List<Income> _fixedIncomes = [];
  List<Category> _categories = [];
  DateTime _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month); // Novo
  
  // Getters
  FinanceData get currentFinanceData => _currentFinanceData ?? getCurrentFinances();
  List<Expense> get recentExpenses => _recentExpenses;
  List<FixedExpense> get fixedExpenses => _fixedExpenses;
  List<Income> get fixedIncomes => _fixedIncomes;
  List<Category> get categories => _categories;
  DateTime get selectedMonth => _selectedMonth; // Novo getter
  
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
    
    // Carregar dados financeiros do mês selecionado
    final financeData = await _dbHelper.getFinancesForMonth(_selectedMonth);
    if (financeData != null) {
      _currentFinanceData = financeData;
    } else {
      // Criar dados vazios para o mês selecionado se não existirem
      _currentFinanceData = FinanceData(
        balance: 0.0,
        income: 0.0,
        expenses: 0.0,
        month: _selectedMonth,
      );
    }
    
    // Carregar despesas do mês selecionado
    _recentExpenses = await _dbHelper.getExpensesForMonth(_selectedMonth);
    
    // Carregar despesas fixas (estas são sempre as mesmas, independente do mês)
    _fixedExpenses = await _dbHelper.getFixedExpenses();
    
    // Carregar receitas fixas (estas são sempre as mesmas, independente do mês)
    _fixedIncomes = await _dbHelper.getFixedIncomes();
    
    // Recalcular os totais para o mês selecionado
    await _updateFinanceSummaryForMonth(_selectedMonth);
    
    notifyListeners();
  }
  
  // Novo método para mudar o mês selecionado
  Future<void> changeSelectedMonth(DateTime newMonth) async {
    _selectedMonth = DateTime(newMonth.year, newMonth.month);
    await loadAllData();
  }
  
  // Adicionar uma nova despesa
  Future<void> addExpense(Expense expense) async {
    await _dbHelper.insertExpense(expense);
    
    // Recarregar despesas do mês selecionado se a despesa for do mês atual
    if (expense.date.year == _selectedMonth.year && expense.date.month == _selectedMonth.month) {
      _recentExpenses = await _dbHelper.getExpensesForMonth(_selectedMonth);
      await _updateFinanceSummaryForMonth(_selectedMonth);
      notifyListeners();
    }
  }
  
  // Atualizar uma despesa
  Future<void> updateExpense(Expense expense) async {
    await _dbHelper.updateExpense(expense);
    
    // Recarregar despesas do mês selecionado
    _recentExpenses = await _dbHelper.getExpensesForMonth(_selectedMonth);
    await _updateFinanceSummaryForMonth(_selectedMonth);
    
    notifyListeners();
  }
  
  // Excluir uma despesa
  Future<void> deleteExpense(int id) async {
    await _dbHelper.deleteExpense(id);
    
    // Recarregar despesas do mês selecionado
    _recentExpenses = await _dbHelper.getExpensesForMonth(_selectedMonth);
    await _updateFinanceSummaryForMonth(_selectedMonth);
    
    notifyListeners();
  }
  
  // Adicionar uma nova despesa fixa
  Future<void> addFixedExpense(FixedExpense fixedExpense) async {
    await _dbHelper.insertFixedExpense(fixedExpense);
    
    // Recarregar despesas fixas
    _fixedExpenses = await _dbHelper.getFixedExpenses();
    
    // Atualizar totais para o mês selecionado
    await _updateFinanceSummaryForMonth(_selectedMonth);
    
    notifyListeners();
  }
  
  // Atualizar uma despesa fixa
  Future<void> updateFixedExpense(FixedExpense fixedExpense) async {
    await _dbHelper.updateFixedExpense(fixedExpense);
    
    // Recarregar despesas fixas
    _fixedExpenses = await _dbHelper.getFixedExpenses();
    
    // Atualizar totais para o mês selecionado
    await _updateFinanceSummaryForMonth(_selectedMonth);
    
    notifyListeners();
  }
  
  // Excluir uma despesa fixa
  Future<void> deleteFixedExpense(int id) async {
    await _dbHelper.deleteFixedExpense(id);
    
    // Recarregar despesas fixas
    _fixedExpenses = await _dbHelper.getFixedExpenses();
    
    // Atualizar totais para o mês selecionado
    await _updateFinanceSummaryForMonth(_selectedMonth);
    
    notifyListeners();
  }
  
  // Adicionar uma nova receita
  Future<void> addIncome(Income income) async {
    await _dbHelper.insertIncome(income);
    
    // Recarregar receitas fixas
    _fixedIncomes = await _dbHelper.getFixedIncomes();
    
    // Atualizar totais para o mês selecionado
    await _updateFinanceSummaryForMonth(_selectedMonth);
    
    notifyListeners();
  }
  
  // Atualizar uma receita
  Future<void> updateIncome(Income income) async {
    await _dbHelper.updateIncome(income);
    
    // Recarregar receitas fixas
    _fixedIncomes = await _dbHelper.getFixedIncomes();
    
    // Atualizar totais para o mês selecionado
    await _updateFinanceSummaryForMonth(_selectedMonth);
    
    notifyListeners();
  }
  
  // Excluir uma receita
  Future<void> deleteIncome(int id) async {
    await _dbHelper.deleteIncome(id);
    
    // Recarregar receitas fixas
    _fixedIncomes = await _dbHelper.getFixedIncomes();
    
    // Atualizar totais para o mês selecionado
    await _updateFinanceSummaryForMonth(_selectedMonth);
    
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
  
  // Método para obter uma categoria por nome
  Future<Category?> getCategoryByName(String name) async {
    return await _dbHelper.getCategoryByName(name);
  }
  
  // Atualizar dados de resumo financeiro para um mês específico
  Future<void> _updateFinanceSummaryForMonth(DateTime month) async {
    // Obter despesas regulares do mês específico
    final monthExpenses = await _dbHelper.getExpensesForMonth(month);
    final totalRegularExpenses = monthExpenses.fold(0.0, (sum, expense) => sum + expense.amount);
    
    // Despesas fixas são sempre consideradas (assumindo que se aplicam a todos os meses)
    final totalFixedExpenses = _fixedExpenses.fold(0.0, (sum, expense) => sum + expense.amount);
    final totalExpenses = totalRegularExpenses + totalFixedExpenses;
    
    // Receitas fixas são sempre consideradas (assumindo que se aplicam a todos os meses)
    final totalIncome = _fixedIncomes.fold(0.0, (sum, income) => sum + income.amount);
    final balance = totalIncome - totalExpenses;
    
    // Criar ou atualizar dados financeiros para o mês específico
    if (_currentFinanceData != null && _currentFinanceData!.id != null) {
      // Atualizar registro existente
      final updatedData = _currentFinanceData!.copyWith(
        balance: balance,
        income: totalIncome,
        expenses: totalExpenses,
      );
      
      await _dbHelper.updateFinanceData(updatedData);
      _currentFinanceData = updatedData;
    } else {
      // Verificar se já existe um registro para este mês
      final existingData = await _dbHelper.getFinancesForMonth(month);
      if (existingData != null) {
        // Atualizar registro existente
        final updatedData = existingData.copyWith(
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

  // Add a new category
  Future<void> addCategory(Category category) async {
    final id = await _dbHelper.insertCategory(category);
    
    // Add the category to the local list with the generated ID
    final newCategory = Category(
      id: id,
      name: category.name,
      icon: category.icon,
      iconBackgroundColor: category.iconBackgroundColor,
    );
    
    _categories.add(newCategory);
    // Sort categories by name
    _categories.sort((a, b) => a.name.compareTo(b.name));
    
    notifyListeners();
  }

  // Update an existing category
  Future<void> updateCategory(Category category) async {
    await _dbHelper.updateCategory(category);
    
    // Update the category in the local list
    final index = _categories.indexWhere((c) => c.id == category.id);
    if (index != -1) {
      _categories[index] = category;
      // Sort categories by name
      _categories.sort((a, b) => a.name.compareTo(b.name));
    }
    
    notifyListeners();
  }

  // Delete a category
  Future<void> deleteCategory(int id) async {
    await _dbHelper.deleteCategory(id);
    
    // Remove the category from the local list
    _categories.removeWhere((c) => c.id == id);
    
    notifyListeners();
  }

  // Check if a category can be deleted (not used by any expense)
  Future<bool> canDeleteCategory(int categoryId) async {
    // Get the category name
    final category = _categories.firstWhere((c) => c.id == categoryId);
    
    // Check if any expense uses this category
    final expenses = await _dbHelper.getExpensesWithCategory(category.name);
    // We also need to check incomes
    final incomes = await _dbHelper.getIncomesWithCategory(category.name);
    
    // If there are no expenses or incomes using this category, it can be deleted
    return expenses.isEmpty && incomes.isEmpty;
  }
}