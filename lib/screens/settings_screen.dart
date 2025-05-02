// lib/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/finance_provider.dart';
import 'category_list_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Configurações do Aplicativo',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          // Categories section
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'Categorias',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
          
          // Manage categories option
          ListTile(
            title: const Text('Gerenciar Categorias'),
            subtitle: const Text('Adicionar, editar ou remover categorias'),
            leading: const Icon(Icons.category, color: Colors.blue),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CategoryListScreen()),
              );
            },
          ),
          
          const Divider(),
          
          // Database section
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'Banco de Dados',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
          
          // Reset database option
          ListTile(
            title: const Text('Limpar Banco de Dados'),
            subtitle: const Text('Apaga todos os dados e restaura os exemplos'),
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            onTap: () {
              // Show confirmation dialog
              _showResetConfirmationDialog(context);
            },
          ),
          
          const Divider(),
          
          // App information section
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'Informações do Aplicativo',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
          
          ListTile(
            title: const Text('Versão do Aplicativo'),
            subtitle: const Text('1.0.0'),
            leading: const Icon(Icons.info_outline),
          ),
        ],
      ),
    );
  }
  
  // Show confirmation dialog before resetting
  void _showResetConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpar Banco de Dados'),
        content: const Text(
          'Tem certeza que deseja limpar todos os dados? '
          'Esta ação não pode ser desfeita!'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('CANCELAR'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetDatabase(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('LIMPAR DADOS'),
          ),
        ],
      ),
    );
  }
  
  // Reset the database and show a confirmation message
  void _resetDatabase(BuildContext context) async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    
    // Reset database
    await Provider.of<FinanceProvider>(context, listen: false)
        .resetDatabaseAndReload();
    
    // Remove loading indicator
    if (context.mounted) Navigator.of(context).pop();
    
    // Show success message
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Banco de dados resetado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}