import 'package:expensify/dtos/expense.dart';
import 'package:expensify/utils/date_formatting.dart';
import 'package:flutter/material.dart';

class ExpenseList extends StatelessWidget {
  final List<Expense> _expenses;

  const ExpenseList(this._expenses, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: _expenses
          .map((e) => ListTile(
                title: Text(e.title),
                subtitle: Text(e.date.format()),
                trailing: Text("${e.value.toStringAsFixed(2)} €"),
              ))
          .toList(),
    );
  }
}
