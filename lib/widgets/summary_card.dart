import 'package:flutter/material.dart';
import '../models/finance_data.dart';

class SummaryCard extends StatelessWidget {
  final FinanceData financeData;

  const SummaryCard({
    super.key,
    required this.financeData,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0), // Reduced margin
      color: const Color(0xFF1A1F2E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Smaller radius
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0), // Reduced padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Saldo Atual',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13, // Smaller font
              ),
            ),
            const SizedBox(height: 2), // Reduced spacing
            Text(
              'R\$ ${financeData.balance.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20, // Smaller font
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12), // Reduced spacing
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 28, // Smaller container
                      height: 28, // Smaller container
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6), // Smaller radius
                      ),
                      child: const Icon(
                        Icons.arrow_upward,
                        color: Colors.green,
                        size: 18, // Smaller icon
                      ),
                    ),
                    const SizedBox(width: 6), // Reduced spacing
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Receitas',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 11, // Smaller font
                          ),
                        ),
                        Text(
                          'R\$ ${financeData.income.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13, // Smaller font
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      width: 28, // Smaller container
                      height: 28, // Smaller container
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6), // Smaller radius
                      ),
                      child: const Icon(
                        Icons.arrow_downward,
                        color: Colors.red,
                        size: 18, // Smaller icon
                      ),
                    ),
                    const SizedBox(width: 6), // Reduced spacing
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Despesas',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 11, // Smaller font
                          ),
                        ),
                        Text(
                          'R\$ ${financeData.expenses.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13, // Smaller font
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}