// lib/screens/fixed_budget_screen.dart
import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../widgets/compact_expense_list_item.dart';

class FixedBudgetScreen extends StatelessWidget {
  const FixedBudgetScreen({super.key});

  // Calcular o total do orçamento fixo
  double get totalAmount => 
      fixedBudgetItems.fold(0, (sum, expense) => sum + expense.amount);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabeçalho da tela
          const Padding(
            padding: EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 4.0),
            child: Text(
              'Orçamento Fixo - Abril 2025',
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
          
          // Lista completa do orçamento fixo
          ...fixedBudgetItems.map((expense) => CompactExpenseListItem(
            expense: expense,
            showDueDate: true,
          )).toList(),
          
          // Total do orçamento fixo
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
                    'Total Orçamento Fixo',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '€ ${totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
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
  }
}