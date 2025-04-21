// lib/screens/add_transaction_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/finance_provider.dart';
import '../models/expense.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Form fields
  bool _isExpense = true; // true = expense, false = income
  String _name = '';
  double _amount = 0.0;
  String _category = 'Outros';
  DateTime _date = DateTime.now();
  int _recurringDay = 0;
  IconData _selectedIcon = Icons.attach_money;
  Color _selectedColor = Colors.blue;
  
  // Available categories
  final List<String> _expenseCategories = [
    'Moradia', 'Alimentação', 'Transporte', 'Saúde', 
    'Educação', 'Lazer', 'Serviços', 'Outros'
  ];
  
  final List<String> _incomeCategories = [
    'Salário', 'Freelance', 'Investimentos', 'Vendas', 'Outros'
  ];
  
  // Available icons
  final List<IconData> _availableIcons = [
    Icons.home, Icons.shopping_cart, Icons.fastfood, 
    Icons.directions_car, Icons.health_and_safety, 
    Icons.school, Icons.movie, Icons.wifi, 
    Icons.water_drop, Icons.bolt, Icons.phone_android,
    Icons.work, Icons.account_balance_wallet, 
    Icons.attach_money, Icons.medication
  ];
  
  // Available colors
  final List<Color> _availableColors = [
    Colors.blue, Colors.red, Colors.green, 
    Colors.amber, Colors.purple, Colors.teal,
    Colors.orange, Colors.pink, Colors.indigo,
  ];

  @override
  void initState() {
    super.initState();
    // Set default category
    _category = _isExpense ? _expenseCategories[0] : _incomeCategories[0];
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      final provider = Provider.of<FinanceProvider>(context, listen: false);
      
      if (_isExpense) {
        final expense = Expense(
          name: _name,
          amount: _amount,
          icon: _selectedIcon,
          iconBackgroundColor: _selectedColor,
          category: _category,
          date: _date,
          dueDay: _recurringDay,
        );
        
        provider.addExpense(expense);
      } else {
        final income = Income(
          name: _name,
          amount: _amount,
          icon: _selectedIcon,
          iconBackgroundColor: _selectedColor,
          category: _category,
          date: _date,
          receiveDay: _recurringDay,
        );
        
        provider.addIncome(income);
      }
      
      // Return to previous screen
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isExpense ? 'Nova Despesa' : 'Nova Receita',
          style: const TextStyle(fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Switch between expense and income
              Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              _isExpense = true;
                              _category = _expenseCategories[0];
                            });
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: _isExpense 
                                ? Colors.red.withOpacity(0.2) 
                                : Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Despesa',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              _isExpense = false;
                              _category = _incomeCategories[0];
                            });
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: !_isExpense 
                                ? Colors.green.withOpacity(0.2) 
                                : Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Receita',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Name field
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um nome';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              const SizedBox(height: 16),
              
              // Amount field
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Valor (€)',
                  border: const OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.euro,
                    color: _isExpense ? Colors.red : Colors.green,
                  ),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um valor';
                  }
                  try {
                    final amount = double.parse(value.replaceAll(',', '.'));
                    if (amount <= 0) {
                      return 'O valor deve ser maior que zero';
                    }
                  } catch (e) {
                    return 'Por favor, insira um valor válido';
                  }
                  return null;
                },
                onSaved: (value) {
                  _amount = double.parse(value!.replaceAll(',', '.'));
                },
              ),
              const SizedBox(height: 16),
              
              // Category dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Categoria',
                  border: OutlineInputBorder(),
                ),
                value: _category,
                items: (_isExpense ? _expenseCategories : _incomeCategories)
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _category = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, selecione uma categoria';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Date picker
              InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _date,
                    firstDate: DateTime(2024),
                    lastDate: DateTime(2026),
                  );
                  if (picked != null) {
                    setState(() {
                      _date = picked;
                    });
                  }
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Data',
                    border: OutlineInputBorder(),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(DateFormat('dd/MM/yyyy').format(_date)),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Recurring transaction
              SwitchListTile(
                title: Text(
                  _isExpense ? 'Despesa Recorrente?' : 'Receita Recorrente?',
                  style: const TextStyle(fontSize: 16),
                ),
                value: _recurringDay > 0,
                onChanged: (value) {
                  setState(() {
                    _recurringDay = value ? _date.day : 0;
                  });
                },
                subtitle: Text(_recurringDay > 0 
                  ? 'Repetir todo dia ${_recurringDay.toString().padLeft(2, '0')} do mês'
                  : 'Transação única'
                ),
              ),
              const SizedBox(height: 16),
              
              // Icon and color pickers
              const Text(
                'Ícone e Cor',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              
              // Icon grid
              Container(
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1F2E),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: _availableIcons.length,
                  itemBuilder: (context, index) {
                    return IconButton(
                      icon: Icon(
                        _availableIcons[index],
                        color: _selectedIcon == _availableIcons[index]
                            ? _selectedColor
                            : Colors.white70,
                      ),
                      onPressed: () {
                        setState(() {
                          _selectedIcon = _availableIcons[index];
                        });
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              
              // Color grid
              Container(
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1F2E),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _availableColors.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedColor = _availableColors[index];
                          });
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: _availableColors[index],
                            shape: BoxShape.circle,
                            border: _selectedColor == _availableColors[index]
                                ? Border.all(color: Colors.white, width: 2)
                                : null,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              
              // Preview
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: _selectedColor.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _selectedIcon,
                    color: _selectedColor,
                    size: 40,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Submit button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: _isExpense ? Colors.red : Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    _isExpense ? 'Adicionar Despesa' : 'Adicionar Receita',
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
}