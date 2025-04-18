// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../models/finance_data.dart';
import '../widgets/summary_card.dart';
import '../widgets/expense_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 56, // Slightly shorter app bar
        title: const Text(
          'Minhas Finanças',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18, // Smaller font
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today, color: Colors.white, size: 20), // Smaller icon
            onPressed: () {},
            padding: const EdgeInsets.symmetric(horizontal: 12), // Smaller padding
          ),
          // Adicionado botão de configurações
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white, size: 20), // Smaller icon
            onPressed: () {},
            padding: const EdgeInsets.symmetric(horizontal: 12), // Smaller padding
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0), // Reduced padding
              child: Text(
                'Abril 2025',
                style: TextStyle(
                  fontSize: 18, // Smaller font
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SummaryCard(financeData: currentFinances),
            const SizedBox(height: 4), // Add small spacing between sections
            ExpenseSection(
              title: 'Despesas Base',
              expenses: baseExpenses,
              showDueDate: true,
              showTotal: true,
            ),
            const SizedBox(height: 4), // Add small spacing between sections
            ExpenseSection(
              title: 'Despesas Recentes',
              expenses: recentExpenses,
              actionText: 'Ver Todas',
              onActionTap: () {},
            ),
            const SizedBox(height: 60), // Reduced space for FAB
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.blue,
        mini: true, // Use smaller FAB
        child: const Icon(Icons.add, size: 20), // Smaller icon
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF0A0E1A),
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        selectedFontSize: 12, // Smaller font
        unselectedFontSize: 12, // Smaller font
        iconSize: 20, // Smaller icons
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Despesas Base',
          ),
          // Configurações substituído por Despesas no Brasil
          BottomNavigationBarItem(
            icon: Icon(Icons.public),
            label: 'Despesas no Brasil',
          ),
        ],
      ),
    );
  }
}