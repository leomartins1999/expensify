import 'package:expensify/dtos/expense.dart';
import 'package:flutter/material.dart';

class CreateExpenseDialog extends StatelessWidget {
  CreateExpenseDialog({super.key});

  final titleController = TextEditingController();
  final costController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add new expense"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            decoration: const InputDecoration(
              labelText: "Title",
            ),
            keyboardType: TextInputType.name,
            controller: titleController,
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: "Cost",
            ),
            keyboardType: TextInputType.number,
            controller: costController,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            final expense = Expense(
              titleController.text,
              double.parse(costController.text),
            );

            return Navigator.of(context).pop(expense);
          },
          child: const Text("Add"),
        ),
      ],
    );
  }
}
