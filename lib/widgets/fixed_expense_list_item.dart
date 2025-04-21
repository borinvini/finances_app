import 'package:flutter/material.dart';
import '../models/fixed_expense.dart';

class FixedExpenseListItem extends StatelessWidget {
  final FixedExpense fixedExpense;
  final Function(bool?)? onPaidChanged;

  const FixedExpenseListItem({
    super.key,
    required this.fixedExpense,
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
                value: fixedExpense.paid,
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
                color: fixedExpense.iconBackgroundColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                fixedExpense.icon,
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
                    fixedExpense.bill,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: fixedExpense.paid ? Colors.grey : Colors.white,
                      fontSize: 13,
                      decoration: fixedExpense.paid ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  Text(
                    'Vencimento dia ${fixedExpense.dueDay}',
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
              '€ ${fixedExpense.amount.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: fixedExpense.paid ? Colors.grey : Colors.white,
                fontSize: 13,
                decoration: fixedExpense.paid ? TextDecoration.lineThrough : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}