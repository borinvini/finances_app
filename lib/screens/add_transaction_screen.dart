// lib/screens/add_transaction_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/finance_provider.dart';
import '../models/expense.dart';
import '../models/fixed_expense.dart';

// Define transaction type enum outside the class to avoid scope issues
enum TransactionType { regularExpense, fixedExpense, income }

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Form fields
  TransactionType _transactionType = TransactionType.regularExpense;
  String _name = '';
  String _bill = '';
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
    _category = _transactionType == TransactionType.income ? _incomeCategories[0] : _expenseCategories[0];
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      final provider = Provider.of<FinanceProvider>(context, listen: false);
      
      switch (_transactionType) {
        case TransactionType.regularExpense:
          final expense = Expense(
            name: _name,
            amount: _amount,
            icon: _selectedIcon,
            iconBackgroundColor: _selectedColor,
            category: _category,
            date: _date,
          );
          provider.addExpense(expense);
          break;
        
        case TransactionType.fixedExpense:
          final fixedExpense = FixedExpense(
            bill: _bill,
            amount: _amount,
            icon: _selectedIcon,
            iconBackgroundColor: _selectedColor,
            date: _date,
            dueDay: _recurringDay > 0 ? _recurringDay : _date.day,
            paid: false,
          );
          provider.addFixedExpense(fixedExpense);
          break;
        
        case TransactionType.income:
          final income = Income(
            name: _name,
            amount: _amount,
            icon: _selectedIcon,
            iconBackgroundColor: _selectedColor,
            category: _category,
            date: _date,
            receiveDay: _recurringDay > 0 ? _recurringDay : 0,
            received: false,
          );
          provider.addIncome(income);
          break;
      }
      
      // Return to previous screen
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    String screenTitle;
    switch (_transactionType) {
      case TransactionType.regularExpense:
        screenTitle = 'Nova Despesa Regular';
        break;
      case TransactionType.fixedExpense:
        screenTitle = 'Nova Despesa Fixa';
        break;
      case TransactionType.income:
        screenTitle = 'Nova Receita';
        break;
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          screenTitle,
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
              // Transaction type selector
              Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const Text(
                        'Tipo de Transação',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  _transactionType = TransactionType.regularExpense;
                                  _category = _expenseCategories[0];
                                });
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: _transactionType == TransactionType.regularExpense 
                                    ? Colors.red.withOpacity(0.2) 
                                    : Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Despesa Regular',
                                style: TextStyle(color: Colors.white, fontSize: 13),
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  _transactionType = TransactionType.fixedExpense;
                                  _recurringDay = _date.day; // Default to current day
                                });
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: _transactionType == TransactionType.fixedExpense 
                                    ? Colors.amber.withOpacity(0.2) 
                                    : Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Despesa Fixa',
                                style: TextStyle(color: Colors.white, fontSize: 13),
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  _transactionType = TransactionType.income;
                                  _category = _incomeCategories[0];
                                });
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: _transactionType == TransactionType.income 
                                    ? Colors.green.withOpacity(0.2) 
                                    : Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Receita',
                                style: TextStyle(color: Colors.white, fontSize: 13),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              // Name field for regular expenses and income
              if (_transactionType != TransactionType.fixedExpense)
                Column(
                  children: [
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
                  ],
                ),
              
              // Bill field for fixed expenses
              if (_transactionType == TransactionType.fixedExpense)
                Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Conta',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira um nome para a conta';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _bill = value!;
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              
              // Amount field
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Valor (€)',
                  border: const OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.euro,
                    color: _transactionType == TransactionType.income 
                        ? Colors.green 
                        : (_transactionType == TransactionType.regularExpense 
                            ? Colors.red 
                            : Colors.amber),
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
              
              // Category dropdown for regular expenses and income
              if (_transactionType != TransactionType.fixedExpense)
                Column(
                  children: [
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Categoria',
                        border: OutlineInputBorder(),
                      ),
                      value: _category,
                      items: (_transactionType == TransactionType.income ? _incomeCategories : _expenseCategories)
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
                  ],
                ),
              
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
                      // Update recurring day if this is a fixed expense or income
                      if (_transactionType == TransactionType.fixedExpense ||
                          (_transactionType == TransactionType.income && _recurringDay > 0)) {
                        _recurringDay = picked.day;
                      }
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
              
              // Due day for fixed expense (always show as it's required)
              if (_transactionType == TransactionType.fixedExpense)
                Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Dia de Vencimento',
                        border: OutlineInputBorder(),
                        helperText: 'Dia do mês em que a conta vence',
                      ),
                      keyboardType: TextInputType.number,
                      initialValue: _recurringDay.toString(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira o dia de vencimento';
                        }
                        try {
                          final day = int.parse(value);
                          if (day < 1 || day > 31) {
                            return 'Dia deve estar entre 1 e 31';
                          }
                        } catch (e) {
                          return 'Por favor, insira um número válido';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _recurringDay = int.parse(value!);
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              
              // Recurring transaction for income
              if (_transactionType == TransactionType.income)
                Column(
                  children: [
                    SwitchListTile(
                      title: const Text(
                        'Receita Recorrente?',
                        style: TextStyle(fontSize: 16),
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
                  ],
                ),
              
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
                    backgroundColor: _transactionType == TransactionType.income 
                        ? Colors.green 
                        : (_transactionType == TransactionType.regularExpense 
                            ? Colors.red 
                            : Colors.amber),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    _transactionType == TransactionType.income 
                        ? 'Adicionar Receita' 
                        : (_transactionType == TransactionType.regularExpense 
                            ? 'Adicionar Despesa Regular' 
                            : 'Adicionar Despesa Fixa'),
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