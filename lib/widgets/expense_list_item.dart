import 'package:flutter/material.dart';
import '../models/expense.dart';

class ExpenseListItem extends StatelessWidget {
  final Expense expense;
  final bool showDueDate;

  const ExpenseListItem({
    super.key,
    required this.expense,
    this.showDueDate = false,
  });

  @override
  Widget build(BuildContext context) {
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
              color: expense.iconBackgroundColor,
              borderRadius: BorderRadius.circular(6), // Smaller radius
            ),
            child: Icon(
              expense.icon,
              color: Colors.white,
              size: 20, // Smaller icon
            ),
          ),
          title: Text(
            expense.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 14, // Smaller font
            ),
          ),
          subtitle: Text(
            showDueDate 
              ? 'Vencimento dia ${expense.dueDay}'
              : '${expense.category} • ${expense.date.day.toString().padLeft(2, '0')} Abr',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 11, // Smaller font
            ),
          ),
          trailing: Text(
            '€ ${expense.amount.toStringAsFixed(2)}',
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