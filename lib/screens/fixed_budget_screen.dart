// lib/screens/fixed_budget_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/finance_provider.dart';
import '../widgets/fixed_expense_list_item.dart';
import '../widgets/income_list_item.dart';

class FixedBudgetScreen extends StatefulWidget {
  const FixedBudgetScreen({super.key});

  @override
  State<FixedBudgetScreen> createState() => _FixedBudgetScreenState();
}

class _FixedBudgetScreenState extends State<FixedBudgetScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<FinanceProvider>(
      builder: (context, provider, child) {
        final totalExpenses = provider.totalFixedBudget;
        final totalIncome = provider.totalIncome;
        final balance = provider.fixedBudgetBalance;
      
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Screen header
              const Padding(
                padding: EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 4.0),
                child: Text(
                  'Orçamento Fixo',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              
              // Section description
              Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 12.0),
                child: Text(
                  'Despesas e receitas fixas mensais que você gerencia.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[400],
                  ),
                ),
              ),
              
              // Income section
              const Padding(
                padding: EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 4.0),
                child: Text(
                  'Receitas',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              
              // Income list
              ...provider.fixedIncomes.map((income) => IncomeListItem(
                income: income,
                onReceivedChanged: (value) {
                  provider.toggleIncomeReceived(income);
                },
              )).toList(),
              
              // Total income
              Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 16.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.green.withOpacity(0.1),
                  ),
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total de Receitas',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '€ ${totalIncome.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Fixed expense section
              const Padding(
                padding: EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 4.0),
                child: Text(
                  'Despesas',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              
              // Fixed expense list with checkboxes
              ...provider.fixedExpenses.map((fixedExpense) => FixedExpenseListItem(
                fixedExpense: fixedExpense,
                onPaidChanged: (value) {
                  provider.toggleExpensePaid(fixedExpense);
                },
              )).toList(),
              
              // Total expenses
              Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 16.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.red.withOpacity(0.1),
                  ),
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total de Despesas',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '€ ${totalExpenses.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Balance (difference between income and expenses)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.blue.withOpacity(0.1),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Saldo do Orçamento Fixo',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '€ ${balance.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: balance >= 0 ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Extra space at the bottom
              const SizedBox(height: 80),
            ],
          ),
        );
      },
    );
  }
}