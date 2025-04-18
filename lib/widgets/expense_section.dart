import 'package:flutter/material.dart';
import '../models/expense.dart';
import 'expense_list_item.dart';

class ExpenseSection extends StatelessWidget {
  final String title;
  final List<Expense> expenses;
  final bool showDueDate;
  final bool showTotal;
  final String? actionText;
  final VoidCallback? onActionTap;

  const ExpenseSection({
    super.key,
    required this.title,
    required this.expenses,
    this.showDueDate = false,
    this.showTotal = false,
    this.actionText,
    this.onActionTap,
  });

  double get totalAmount => expenses.fold(0, (sum, expense) => sum + expense.amount);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              if (actionText != null)
                GestureDetector(
                  onTap: onActionTap,
                  child: Text(
                    actionText!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.blue,
                    ),
                  ),
                ),
            ],
          ),
        ),
        ...expenses.map((expense) => ExpenseListItem(
              expense: expense,
              showDueDate: showDueDate,
            )),
        if (showTotal)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Despesas Base',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'R\$ ${totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}