import 'package:flutter/material.dart';

// Import the updated component
import 'compact_expense_list_item.dart';

class ExpenseSection extends StatelessWidget {
  final String title;
  final List<dynamic> expenses; // Can contain Expense or FixedExpense objects
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
          padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
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
                      fontSize: 13,
                      color: Colors.blue,
                    ),
                  ),
                ),
            ],
          ),
        ),
        // Use CompactExpenseListItem for any expense type
        ...expenses.map((expense) => CompactExpenseListItem(
              expense: expense,
              showDueDate: showDueDate,
            )),
        if (showTotal)
          Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Orçamento Fixo',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '€ ${totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 14,
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