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
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xFF1A1F2E),
        ),
        child: ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: expense.iconBackgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              expense.icon,
              color: Colors.white,
            ),
          ),
          title: Text(
            expense.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          subtitle: Text(
            showDueDate 
              ? 'Vencimento dia ${expense.dueDay}'
              : '${expense.category} • ${expense.date.day.toString().padLeft(2, '0')} Abr',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 12,
            ),
          ),
          trailing: Text(
            'R\$ ${expense.amount.toStringAsFixed(2)}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}