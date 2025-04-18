// This is an optional alternative implementation for the expense list item
// that uses a more compact custom row instead of ListTile for maximum density

import 'package:flutter/material.dart';
import '../models/expense.dart';

class CompactExpenseListItem extends StatelessWidget {
  final Expense expense;
  final bool showDueDate;

  const CompactExpenseListItem({
    super.key,
    required this.expense,
    this.showDueDate = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 3.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: const Color(0xFF1A1F2E),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
        child: Row(
          children: [
            // Leading icon
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: expense.iconBackgroundColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                expense.icon,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 8),
            // Title and subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    expense.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    showDueDate 
                      ? 'Vencimento dia ${expense.dueDay}'
                      : '${expense.category} • ${expense.date.day.toString().padLeft(2, '0')} Abr',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            // Trailing amount
            Text(
              'R\$ ${expense.amount.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Usage example:
// Replace all instances of ExpenseListItem with CompactExpenseListItem in expense_section.dart