import 'package:expense_tracker_app/models/expense.dart';
import 'package:expense_tracker_app/widgets/expenses_list/expense_item.dart';
import 'package:flutter/material.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList({
    super.key,
    required this.registeredExpenses,
    required this.removeExpense,
  });

  final List<Expense> registeredExpenses;
  final Function(Expense) removeExpense;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      // .builder es como el recyclerview
      itemCount: registeredExpenses.length,
      itemBuilder:
          (context, index) => Dismissible(
            background: Container(
              color: Theme.of(context).colorScheme.error,
              margin: EdgeInsets.symmetric(horizontal: Theme.of(context).cardTheme.margin!.horizontal),
            ),
            key: ValueKey(registeredExpenses[index]),
            onDismissed: (direction) {
              removeExpense(registeredExpenses[index]);
            },
            child: ExpenseItem(expense: registeredExpenses[index]),
          ),
    );
  }
}
