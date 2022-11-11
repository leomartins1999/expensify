import 'package:expensify/dtos/expense.dart';
import 'package:expensify/pages/home/update_expense_dialog.dart';
import 'package:expensify/repositories/expense_repository.dart';
import 'package:flutter/material.dart';

import 'create_expense_dialog.dart';
import 'expense_list.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ExpenseRepository _repository = ExpenseRepository();
  late List<Expense> _expenses = [];

  @override
  void initState() {
    super.initState();

    updateExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("expensify"),
      ),
      body: buildExpenseList(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddExpenseMenu(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildExpenseList(BuildContext ctx) {
    return ExpenseList(
      _expenses,
      (e) => showUpdateExpenseMenu(ctx, e),
    );
  }

  void showUpdateExpenseMenu(BuildContext ctx, Expense e) async {
    final UpdateExpenseDialogResult? result = await showDialog(
      context: context,
      builder: (context) => UpdateExpenseDialog(e),
    );

    if (result == null) return;

    switch (result.type) {
      case UpdateExpenseDialogResultType.delete:
        await deleteExpense(e);
        break;
      case UpdateExpenseDialogResultType.update:
        await updateExpense(result.updatedExpense!);
        break;
    }
  }

  Future<void> deleteExpense(Expense e) async {
    await _repository.deleteExpense(e.id);

    showSnackbar("Deleted ${e.title} expense!");

    await updateExpenses();
  }

  Future<void> updateExpense(Expense e) async {
    await _repository.updateExpense(e);

    showSnackbar("Updated ${e.title} expense!");

    await updateExpenses();
  }

  void showAddExpenseMenu(BuildContext ctx) async {
    final Expense? newExpense = await showDialog(
      context: ctx,
      builder: (context) => const CreateExpenseDialog(),
    );

    if (newExpense == null) return;

    await _repository.saveExpense(newExpense);

    showSnackbar("Added ${newExpense.title} expense!");

    await updateExpenses();
  }

  Future<void> updateExpenses() async {
    final newExpenses = await _repository.getExpenses();

    setState(() {
      _expenses = newExpenses;
    });
  }

  void showSnackbar(String text) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
}
