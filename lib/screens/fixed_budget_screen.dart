// lib/screens/fixed_budget_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/finance_provider.dart';
import '../widgets/compact_expense_list_item.dart';
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
              // Cabeçalho da tela
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
              
              // Descrição da seção
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
              
              // Seção de Receitas
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
              
              // Lista de receitas
              ...provider.fixedIncomes.map((income) => IncomeListItem(
                income: income,
                onReceivedChanged: (value) {
                  provider.toggleIncomeReceived(income);
                },
              )).toList(),
              
              // Total de receitas
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
              
              // Seção de Despesas
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
              
              // Lista de despesas com checkboxes para marcar como pagas
              ...provider.fixedExpenses.map((expense) => CompactExpenseListItem(
                expense: expense,
                showDueDate: true,
                onPaidChanged: (value) {
                  provider.toggleExpensePaid(expense);
                },
              )).toList(),
              
              // Total de despesas
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
              
              // Saldo (diferença entre receitas e despesas)
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
              
              // Espaço adicional na parte inferior
              const SizedBox(height: 80),
            ],
          ),
        );
      },
    );
  }
}