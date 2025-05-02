// lib/screens/category_form_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/finance_provider.dart';
import '../models/category.dart';

class CategoryFormScreen extends StatefulWidget {
  final Category? category; // If null, creating a new category
  
  const CategoryFormScreen({
    super.key,
    this.category,
  });

  @override
  State<CategoryFormScreen> createState() => _CategoryFormScreenState();
}

class _CategoryFormScreenState extends State<CategoryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  IconData _selectedIcon = Icons.category;
  Color _selectedColor = Colors.blue;
  
  bool get _isEditing => widget.category != null;
  
  // Lista de ícones disponíveis para seleção
  final List<IconData> _availableIcons = [
    Icons.home,
    Icons.fastfood,
    Icons.directions_car,
    Icons.school,
    Icons.local_hospital,
    Icons.movie,
    Icons.shopping_cart,
    Icons.sports_soccer,
    Icons.attach_money,
    Icons.credit_card,
    Icons.local_atm,
    Icons.fitness_center,
    Icons.flight_takeoff,
    Icons.laptop_mac,
    Icons.restaurant,
    Icons.build,
    Icons.category,
    Icons.celebration,
    Icons.child_care,
    Icons.pets,
    Icons.wifi,
    Icons.phone_android,
    Icons.water_drop,
    Icons.bolt,
    Icons.medication,
    Icons.book,
    Icons.coffee,
    Icons.local_bar,
    Icons.train,
    Icons.apartment,
  ];
  
  // Lista de cores disponíveis para seleção
  final List<Color> _availableColors = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
  ];

  @override
  void initState() {
    super.initState();
    
    // Inicializar com os valores da categoria existente, se estiver editando
    if (_isEditing) {
      _name = widget.category!.name;
      _selectedIcon = widget.category!.icon;
      _selectedColor = widget.category!.iconBackgroundColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenTitle = _isEditing ? 'Editar Categoria' : 'Nova Categoria';
    
    return Scaffold(
      appBar: AppBar(
        title: Text(screenTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Campo para o nome da categoria
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(
                  labelText: 'Nome da Categoria',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um nome para a categoria';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              const SizedBox(height: 24),
              
              // Seletor de ícone
              const Text(
                'Selecione um ícone',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: const Color(0xFF1A1F2E),
                ),
                child: GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6,
                    childAspectRatio: 1,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: _availableIcons.length,
                  itemBuilder: (context, index) {
                    final icon = _availableIcons[index];
                    final isSelected = _selectedIcon == icon;
                    
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIcon = icon;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected ? _selectedColor.withOpacity(0.2) : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: isSelected 
                            ? Border.all(color: _selectedColor, width: 2) 
                            : null,
                        ),
                        child: Icon(
                          icon,
                          color: isSelected ? _selectedColor : Colors.white,
                          size: 28,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              
              // Seletor de cor
              const Text(
                'Selecione uma cor',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              
              Container(
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: const Color(0xFF1A1F2E),
                ),
                child: GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 8,
                    childAspectRatio: 1,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: _availableColors.length,
                  itemBuilder: (context, index) {
                    final color = _availableColors[index];
                    final isSelected = _selectedColor.value == color.value;
                    
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedColor = color;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: isSelected 
                            ? Border.all(color: Colors.white, width: 2) 
                            : null,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 32),
              
              // Visualização
              Center(
                child: Column(
                  children: [
                    const Text(
                      'Visualização',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: _selectedColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        _selectedIcon,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _name.isEmpty ? 'Nome da Categoria' : _name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              // Botão de salvar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveCategory,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    _isEditing ? 'ATUALIZAR CATEGORIA' : 'SALVAR CATEGORIA',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _saveCategory() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      final provider = Provider.of<FinanceProvider>(context, listen: false);
      
      if (_isEditing) {
        // Atualizar categoria existente
        final updatedCategory = Category(
          id: widget.category!.id,
          name: _name,
          icon: _selectedIcon,
          iconBackgroundColor: _selectedColor,
        );
        
        provider.updateCategory(updatedCategory);
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Categoria atualizada com sucesso'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        // Criar nova categoria
        final newCategory = Category(
          name: _name,
          icon: _selectedIcon,
          iconBackgroundColor: _selectedColor,
        );
        
        provider.addCategory(newCategory);
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Categoria adicionada com sucesso'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
      
      Navigator.of(context).pop();
    }
  }
}