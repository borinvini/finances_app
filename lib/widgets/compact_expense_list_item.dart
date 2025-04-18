import 'package:flutter/material.dart';
import '../models/expense.dart';

class CompactExpenseListItem extends StatelessWidget {
  final Expense expense;
  final bool showDueDate;
  final Function(bool?)? onPaidChanged; // New callback for paid status changes

  const CompactExpenseListItem({
    super.key,
    required this.expense,
    this.showDueDate = false,
    this.onPaidChanged,
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
            // Checkbox for paid status
            if (onPaidChanged != null)
              Checkbox(
                value: expense.paid,
                onChanged: onPaidChanged,
                activeColor: Colors.blue,
                checkColor: Colors.white,
                side: const BorderSide(color: Colors.grey, width: 1.5),
              ),
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
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: expense.paid ? Colors.grey : Colors.white,
                      fontSize: 13,
                      decoration: expense.paid ? TextDecoration.lineThrough : null,
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
              '€ ${expense.amount.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: expense.paid ? Colors.grey : Colors.white,
                fontSize: 13,
                decoration: expense.paid ? TextDecoration.lineThrough : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}