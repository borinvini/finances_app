import 'package:flutter/material.dart';
import '../models/finance_data.dart';
import 'package:intl/intl.dart';

// Lista de meses em português como fallback
const List<String> _monthNames = [
  '', 'Janeiro', 'Fevereiro', 'Março', 'Abril',
  'Maio', 'Junho', 'Julho', 'Agosto',
  'Setembro', 'Outubro', 'Novembro', 'Dezembro'
];

class SummaryCard extends StatelessWidget {
  // Método helper para obter nome do mês como fallback
  static String _getMonthName(int month) {
    if (month < 1 || month > 12) return '';
    return _monthNames[month];
  }
  final FinanceData financeData;

  const SummaryCard({
    super.key,
    required this.financeData,
  });

  @override
  Widget build(BuildContext context) {
    // Formatar o mês atual
    String monthName;
    try {
      final monthFormat = DateFormat.MMMM('pt_BR');
      monthName = monthFormat.format(financeData.month);
      // Capitalize a primeira letra
      monthName = monthName[0].toUpperCase() + monthName.substring(1);
    } catch (e) {
      // Fallback para nomes em inglês caso a formatação em português falhe
      monthName = _getMonthName(financeData.month.month);
    }
    
    return Card(
      margin: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
      color: const Color(0xFF1A1F2E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Saldo Atual - $monthName ${financeData.month.year}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '€ ${financeData.balance.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.arrow_upward,
                        color: Colors.green,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Receitas',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                          ),
                        ),
                        Text(
                          '€ ${financeData.income.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.arrow_downward,
                        color: Colors.red,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Despesas',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                          ),
                        ),
                        Text(
                          '€ ${financeData.expenses.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
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