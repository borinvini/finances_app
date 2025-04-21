import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../models/fixed_expense.dart';

class ExpenseListItem extends StatelessWidget {
  final dynamic expense; // Can be either Expense or FixedExpense
  final bool showDueDate;

  const ExpenseListItem({
    super.key,
    required this.expense,
    this.showDueDate = false,
  });

  // Check if expense is a FixedExpense
  bool get isFixedExpense => expense is FixedExpense;

  @override
  Widget build(BuildContext context) {
    final String title = isFixedExpense ? (expense as FixedExpense).bill : (expense as Expense).name;
    final IconData icon = expense.icon;
    final Color iconBgColor = expense.iconBackgroundColor;
    final double amount = expense.amount;
    
    // Properties only available for FixedExpense
    final int dueDay = isFixedExpense ? (expense as FixedExpense).dueDay : 0;
    
    // For regular expenses, we show the category
    final String category = isFixedExpense ? '' : (expense as Expense).category;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0), // Reduced padding
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), // Smaller radius
          color: const Color(0xFF1A1F2E),
        ),
        child: ListTile(
          dense: true, // Make ListTile more compact
          contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0), // Reduced padding
          leading: Container(
            width: 36, // Smaller icon
            height: 36, // Smaller icon
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(6), // Smaller radius
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 20, // Smaller icon
            ),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 14, // Smaller font
            ),
          ),
          subtitle: Text(
            showDueDate && isFixedExpense
              ? 'Vencimento dia $dueDay'
              : category.isNotEmpty 
                ? '$category • ${expense.date.day.toString().padLeft(2, '0')} Abr'
                : '${expense.date.day.toString().padLeft(2, '0')} Abr',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 11, // Smaller font
            ),
          ),
          trailing: Text(
            '€ ${amount.toStringAsFixed(2)}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 14, // Smaller font
            ),
          ),
        ),
      ),
    );
  }
}