import 'package:flutter/material.dart';
import '../models/expense.dart';

class IncomeListItem extends StatelessWidget {
  final Income income;
  final Function(bool?)? onReceivedChanged;

  const IncomeListItem({
    super.key,
    required this.income,
    this.onReceivedChanged,
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
            // Checkbox for received status
            if (onReceivedChanged != null)
              Checkbox(
                value: income.received,
                onChanged: onReceivedChanged,
                activeColor: Colors.green,
                checkColor: Colors.white,
                side: const BorderSide(color: Colors.grey, width: 1.5),
              ),
            
            // Leading icon
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: income.iconBackgroundColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                income.icon,
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
                    income.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: income.received ? Colors.grey[400] : Colors.white,
                      fontSize: 13,
                      decoration: income.received ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  Text(
                    'Recebimento dia ${income.receiveDay}',
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
              '€ ${income.amount.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green[income.received ? 300 : 500],
                fontSize: 13,
                decoration: income.received ? TextDecoration.lineThrough : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}