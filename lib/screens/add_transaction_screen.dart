// lib/screens/add_transaction_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/finance_provider.dart';
import '../models/expense.dart';
import '../models/fixed_expense.dart';
import '../models/category.dart'; // Nova importação

// Definir tipo de transação enum fora da classe para evitar problemas de escopo
enum TransactionType { regularExpense, fixedExpense, income }

// Adicionar este enum para a tela de origem
enum SourceScreen { home, budget }

class AddTransactionScreen extends StatefulWidget {
  final SourceScreen sourceScreen;

  const AddTransactionScreen({
    super.key,
    required this.sourceScreen,
  });

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Campos do formulário
  late TransactionType _transactionType;
  String _name = '';
  String _bill = '';
  double _amount = 0.0;
  String _category = 'Outros';
  DateTime _date = DateTime.now();
  int _recurringDay = 0;
  
  // Estes não são mais selecionados pelo usuário
  IconData _selectedIcon = Icons.attach_money;
  Color _selectedColor = Colors.blue;
  
  // Categorias disponíveis - serão carregadas do banco de dados 
  List<String> _expenseCategories = [];
  
  final List<String> _incomeCategories = [
    'Salário', 'Freelance', 'Investimentos', 'Vendas', 'Outros'
  ];

  @override
  void initState() {
    super.initState();
    // Definir tipo de transação padrão com base na tela de origem
    if (widget.sourceScreen == SourceScreen.home) {
      _transactionType = TransactionType.regularExpense;
    } else {
      _transactionType = TransactionType.fixedExpense;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Carregar as categorias do provider
    _loadCategories();
  }

  // Carregar as categorias do banco de dados
  void _loadCategories() async {
    final provider = Provider.of<FinanceProvider>(context, listen: false);
    
    // Verificar se as categorias já foram carregadas
    if (provider.categories.isEmpty) {
      await provider.loadAllData();
    }
    
    // Extrair os nomes das categorias
    setState(() {
      _expenseCategories = provider.categories.map((c) => c.name).toList();
      
      // Definir categoria padrão
      if (_expenseCategories.isNotEmpty) {
        _category = _transactionType == TransactionType.income
            ? _incomeCategories[0]
            : _expenseCategories[0];
      }
    });
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      final provider = Provider.of<FinanceProvider>(context, listen: false);
      
      switch (_transactionType) {
        case TransactionType.regularExpense:
          // Obter a categoria para acessar o ícone e cor
          final categoryObj = await provider.getCategoryByName(_category);
          
          final expense = Expense(
            name: _name,
            amount: _amount,
            // Usar ícone e cor da categoria, se disponível
            icon: categoryObj?.icon ?? Icons.attach_money,
            iconBackgroundColor: categoryObj?.iconBackgroundColor ?? Colors.blue,
            category: _category,
            date: _date,
          );
          provider.addExpense(expense);
          break;
        
        case TransactionType.fixedExpense:
          // Para despesas fixas, usamos ícones padrão, mas no futuro poderíamos
          // igualmente associá-las a categorias
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
      
      // Retornar à tela anterior
      Navigator.pop(context);
    }
  }

  // Atualiza o ícone e a cor com base na categoria selecionada
  void _updateIconAndColorFromCategory(String categoryName) async {
    final provider = Provider.of<FinanceProvider>(context, listen: false);
    final categoryObj = await provider.getCategoryByName(categoryName);
    
    if (categoryObj != null) {
      setState(() {
        _selectedIcon = categoryObj.icon;
        _selectedColor = categoryObj.iconBackgroundColor;
      });
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
              // Seletor de tipo de transação - mostrar apenas se estiver na tela de orçamento
              if (widget.sourceScreen == SourceScreen.budget)
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
                            // Mostrar apenas opções de despesa fixa e receita para tela de orçamento
                            Expanded(
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    _transactionType = TransactionType.fixedExpense;
                                    _recurringDay = _date.day; // Padrão para o dia atual
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
              
              // Campo de nome para despesas regulares e receita
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
              
              // Campo de conta para despesas fixas
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
              
              // Campo de valor
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
              
              // Dropdown de categoria para despesas regulares e receita
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
                        if (value != null) {
                          setState(() {
                            _category = value;
                          });
                          
                          // Atualizar o ícone e a cor com base na categoria
                          if (_transactionType == TransactionType.regularExpense) {
                            _updateIconAndColorFromCategory(value);
                          }
                        }
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
              
              // Seletor de data
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
                      // Atualizar dia recorrente se esta for uma despesa fixa ou receita
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
              
              // Dia de vencimento para despesa fixa (sempre mostrar, pois é obrigatório)
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
              
              // Transação recorrente para receita
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
              
              // Remover seletor de ícone e cor para despesas regulares
              // Mostrar somente para receitas e despesas fixas onde não temos categorias
              if (_transactionType != TransactionType.regularExpense)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ícone e Cor',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    
                    // Grade de ícones
                    Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1F2E),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Consumer<FinanceProvider>(
                        builder: (context, provider, _) {
                          // Extrair os ícones de todas as categorias
                          List<IconData> availableIcons = provider.categories
                            .map((c) => c.icon)
                            .toSet() // Remover duplicatas
                            .toList();
                          
                          // Adicionar alguns ícones padrão
                          availableIcons.addAll([
                            Icons.account_balance_wallet, 
                            Icons.work,
                            Icons.attach_money,
                          ]);
                          
                          return GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 7,
                              childAspectRatio: 1.0,
                            ),
                            itemCount: availableIcons.length,
                            itemBuilder: (context, index) {
                              return IconButton(
                                icon: Icon(
                                  availableIcons[index],
                                  color: _selectedIcon == availableIcons[index]
                                      ? _selectedColor
                                      : Colors.white70,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _selectedIcon = availableIcons[index];
                                  });
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Grade de cores
                    Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1F2E),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Consumer<FinanceProvider>(
                        builder: (context, provider, _) {
                          // Extrair as cores de todas as categorias
                          List<Color> availableColors = provider.categories
                            .map((c) => c.iconBackgroundColor)
                            .toSet() // Remover duplicatas
                            .toList();
                          
                          // Adicionar algumas cores padrão
                          availableColors.addAll([
                            Colors.blue,
                            Colors.red,
                            Colors.green,
                            Colors.orange,
                            Colors.purple,
                          ]);
                          
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: availableColors.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedColor = availableColors[index];
                                    });
                                  },
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: availableColors[index],
                                      shape: BoxShape.circle,
                                      border: _selectedColor == availableColors[index]
                                          ? Border.all(color: Colors.white, width: 2)
                                          : null,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Visualização
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
                  ],
                ),
              
              // Botão de envio
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