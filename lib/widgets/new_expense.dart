import 'package:expense_tracker_app/models/expense.dart';
import 'package:flutter/material.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.addNewExpense});

  final Function(Expense) addNewExpense;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.food;

  @override
  void dispose() {
    //Se ejecuta al finalizar la app y se necesita para cerrar automaticamente el TextController para que no consuma memoria
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      firstDate: firstDate,
      lastDate: now,
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _submitNewExpense() {
    //Controla que todos los valores sean validos
    final bool isTitleValid = _titleController.text.trim().isNotEmpty;
    final double? parsedAmount = double.tryParse(_amountController.text);
    final bool isAmountValid =
        (_amountController.text.isNotEmpty) &&
        (parsedAmount != null) &&
        (parsedAmount > 0);
    final bool isDateValid = _selectedDate != null;

    if (isTitleValid && isAmountValid && isDateValid) {
      //Si es valido, agrega el expense a la lista
      Expense newExpense = Expense(title: _titleController.text, amount: parsedAmount, date: _selectedDate!, category: _selectedCategory);
      widget.addNewExpense(newExpense);
      Navigator.pop(context);
    } else {
      //Si no es valido, muestra un dialog 
      showDialog(
        context: context,
        builder:
            (ctx) => AlertDialog(
              title: Text("Input error"),
              content: Text(
                "Please make sure a valid title, amount, date and category was entered",
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                  },
                  child: Text("Ok"),
                ),
              ],
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16,48,16,16),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            maxLength: 50,
            decoration: const InputDecoration(label: Text("Title...")),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    prefixText: "\$ ",
                    label: Text("Amount..."),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      _selectedDate == null
                          ? "No selected date"
                          : formatter.format(_selectedDate!),
                    ),
                    IconButton(
                      onPressed: _presentDatePicker,
                      icon: Icon(Icons.calendar_month),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              DropdownButton(
                value: _selectedCategory,
                items:
                    Category.values
                        .map(
                          (data) => DropdownMenuItem(
                            value: data,
                            child: Text(data.name.toUpperCase()),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    _selectedCategory = value;
                  });
                },
              ),
              Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: _submitNewExpense,
                child: const Text("Save expense"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
