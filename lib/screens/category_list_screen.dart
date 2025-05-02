// lib/screens/category_list_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/finance_provider.dart';
import '../models/category.dart';
import 'category_form_screen.dart';

class CategoryListScreen extends StatelessWidget {
  const CategoryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Categorias'),
      ),
      body: Consumer<FinanceProvider>(
        builder: (context, provider, child) {
          final categories = provider.categories;
          
          if (categories.isEmpty) {
            return const Center(
              child: Text('Nenhuma categoria encontrada'),
            );
          }
          
          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return _buildCategoryItem(context, category, provider);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddCategory(context),
        child: const Icon(Icons.add),
        tooltip: 'Adicionar Categoria',
      ),
    );
  }
  
  Widget _buildCategoryItem(BuildContext context, Category category, FinanceProvider provider) {
    return Dismissible(
      key: Key(category.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      confirmDismiss: (direction) async {
        // Verificar se a categoria pode ser excluída
        final canDelete = await provider.canDeleteCategory(category.id!);
        
        if (!canDelete) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Esta categoria está em uso e não pode ser excluída'),
                backgroundColor: Colors.red,
              ),
            );
          }
          return false;
        }
        
        // Mostrar diálogo de confirmação
        return await showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              backgroundColor: const Color(0xFF1A1F2E),
              title: const Text('Confirmar Exclusão', 
                style: TextStyle(color: Colors.white)),
              content: Text(
                'Tem certeza que deseja excluir a categoria ${category.name}?',
                style: const TextStyle(color: Colors.white70),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: const Text('CANCELAR', 
                    style: TextStyle(color: Colors.blue)),
                ),
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                  child: const Text('EXCLUIR', 
                    style: TextStyle(color: Colors.red)),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) {
        // Excluir a categoria
        provider.deleteCategory(category.id!);
        
        // Mostrar snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Categoria ${category.name} excluída'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      },
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: category.iconBackgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            category.icon,
            color: Colors.white,
            size: 24,
          ),
        ),
        title: Text(
          category.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white, // Added this line to fix the text color issue
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.edit, color: Colors.blue),
          onPressed: () => _navigateToEditCategory(context, category),
        ),
        onTap: () => _navigateToEditCategory(context, category),
      ),
    );
  }
  
  void _navigateToAddCategory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CategoryFormScreen(),
      ),
    );
  }
  
  void _navigateToEditCategory(BuildContext context, Category category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryFormScreen(category: category),
      ),
    );
  }
}