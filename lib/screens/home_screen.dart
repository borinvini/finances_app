// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../models/finance_data.dart';
import '../widgets/summary_card.dart';
import '../widgets/expense_section.dart';
import 'base_expenses_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  
  // Total das despesas base
  double get totalBaseExpenses => 
      baseExpenses.fold(0, (sum, expense) => sum + expense.amount);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 56,
        title: const Text(
          'Minhas Finanças',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today, color: Colors.white, size: 20),
            onPressed: () {},
            padding: const EdgeInsets.symmetric(horizontal: 12),
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white, size: 20),
            onPressed: () {},
            padding: const EdgeInsets.symmetric(horizontal: 12),
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.blue,
        mini: true,
        child: const Icon(Icons.add, size: 20),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF0A0E1A),
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedFontSize: 12,
        unselectedFontSize: 12,
        iconSize: 20,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Despesas Base',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flag),
            label: 'Despesas no Brasil',
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return _buildHomeTab();
      case 1:
        return const BaseExpensesScreen();
      case 2:
        // Placeholder for "Despesas no Brasil" tab
        return const Center(
          child: Text(
            'Despesas no Brasil',
            style: TextStyle(color: Colors.white),
          ),
        );
      default:
        return _buildHomeTab();
    }
  }

  Widget _buildHomeTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
            child: Text(
              'Abril 2025',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          SummaryCard(financeData: currentFinances),
          const SizedBox(height: 12),
          
          // Apenas o total das despesas base, sem listar os itens
          Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Despesas Base',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentIndex = 1; // Navegar para a aba Despesas Base
                    });
                  },
                  child: const Text(
                    'Ver Detalhes',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Card para mostrar apenas o total
          Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 12.0),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color(0xFF1A1F2E),
              ),
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Despesas Base',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '€ ${totalBaseExpenses.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 4),
          
          // Manter a seção de Despesas Recentes como está
          ExpenseSection(
            title: 'Despesas Recentes',
            expenses: recentExpenses,
            actionText: 'Ver Todas',
            onActionTap: () {},
          ),
          
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}