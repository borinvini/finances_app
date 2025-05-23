import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../models/fixed_expense.dart';

class CompactExpenseListItem extends StatelessWidget {
  final dynamic expense; // Can be either Expense or FixedExpense
  final bool showDueDate;
  final Function(bool?)? onPaidChanged; // Callback for paid status changes

  const CompactExpenseListItem({
    super.key,
    required this.expense,
    this.showDueDate = false,
    this.onPaidChanged,
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
    final bool isPaid = isFixedExpense ? (expense as FixedExpense).paid : false;
    final int dueDay = isFixedExpense ? (expense as FixedExpense).dueDay : 0;
    
    // For regular expenses, we show the category
    final String category = isFixedExpense ? '' : (expense as Expense).category;
    
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
            // Checkbox for paid status (only for fixed expenses)
            if (isFixedExpense && onPaidChanged != null)
              Checkbox(
                value: isPaid,
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
                color: iconBgColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                icon,
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
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isFixedExpense && isPaid ? Colors.grey : Colors.white,
                      fontSize: 13,
                      decoration: isFixedExpense && isPaid ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  Text(
                    showDueDate && isFixedExpense
                      ? 'Vencimento dia $dueDay'
                      : category.isNotEmpty 
                        ? '$category • ${expense.date.day.toString().padLeft(2, '0')} Abr'
                        : '${expense.date.day.toString().padLeft(2, '0')} Abr',
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
              '€ ${amount.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isFixedExpense && isPaid ? Colors.grey : Colors.white,
                fontSize: 13,
                decoration: isFixedExpense && isPaid ? TextDecoration.lineThrough : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}