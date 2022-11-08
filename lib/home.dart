import 'package:expensify/create_expense_dialog.dart';
import 'package:expensify/expense.dart';
import 'package:flutter/material.dart';

import 'expense_list.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Expense> _expenses = getExpenses();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("expensify"),
      ),
      body: ExpenseList(_expenses),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddExpenseMenu(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void showAddExpenseMenu(BuildContext ctx) async {
    final newExpense = await showDialog(
      context: ctx,
      builder: (context) => CreateExpenseDialog(),
    );

    if (newExpense == null) return;

    setState(() {
      _expenses = [..._expenses, newExpense];
    });
  }

  static List<Expense> getExpenses() {
    return [
      const Expense("Groceries", 15.99),
      const Expense("Telecom", 34.99),
    ];
  }
}
