// lib/widgets/expense_section.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/finance_provider.dart';
import '../models/expense.dart';

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
        // Replace direct mapping with a method that handles dismissible wrapping
        ...expenses.map((expense) => _buildDismissibleExpenseItem(context, expense)),
        
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

  // New method to build a dismissible wrapper around each expense item
  Widget _buildDismissibleExpenseItem(BuildContext context, dynamic expense) {
    // Only regular expenses (not fixed expenses) can be deleted
    if (expense is Expense) {
      return Dismissible(
        // Use the expense ID as the key
        key: Key(expense.id.toString()),
        // Only allow right-to-left swipe (show delete on right side)
        direction: DismissDirection.endToStart,
        // Confirm dialog before deletion
        confirmDismiss: (direction) async {
          return await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: const Color(0xFF1A1F2E),
                title: const Text('Confirmar Exclusão', 
                  style: TextStyle(color: Colors.white)),
                content: const Text('Tem certeza que deseja excluir esta despesa?',
                  style: TextStyle(color: Colors.white70)),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('CANCELAR', 
                      style: TextStyle(color: Colors.blue)),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('EXCLUIR', 
                      style: TextStyle(color: Colors.red)),
                  ),
                ],
              );
            },
          );
        },
        // What happens on dismissal
        onDismissed: (direction) {
          // Create a copy of the expense for potential restoration
          final deletedExpense = expense;
          
          // Delete the expense from provider
          Provider.of<FinanceProvider>(context, listen: false)
              .deleteExpense(expense.id!);
          
          // Show a snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Despesa excluída'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
              action: SnackBarAction(
                label: 'DESFAZER',
                textColor: Colors.white,
                onPressed: () {
                  // Re-add the expense
                  Provider.of<FinanceProvider>(context, listen: false)
                      .addExpense(deletedExpense);
                },
              ),
            ),
          );
        },
        // Background shown when swiping (red with a trash icon)
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20.0),
          color: Colors.red,
          child: const Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
        // The actual expense item
        child: CompactExpenseListItem(
          expense: expense,
          showDueDate: showDueDate,
        ),
      );
    } else {
      // For FixedExpense items, don't wrap with Dismissible
      return CompactExpenseListItem(
        expense: expense,
        showDueDate: showDueDate,
      );
    }
  }
}