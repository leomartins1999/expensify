import 'package:expensify/dtos/expense.dart';
import 'package:flutter/material.dart';

class CreateExpenseDialog extends StatefulWidget {
  const CreateExpenseDialog({super.key});

  @override
  State<StatefulWidget> createState() => _CreateExpenseDialogState();
}

class _CreateExpenseDialogState extends State<CreateExpenseDialog> {
  String? title;
  double? value;

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
            onChanged: (v) => setState(() {
              title = v;
            }),
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: "Cost",
            ),
            keyboardType: TextInputType.number,
            onChanged: (v) => setState(() {
              value = double.parse(v);
            }),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: !isAddEnabled()
              ? null
              : () {
                  final expense = Expense(title!, value!);

                  return Navigator.of(context).pop(expense);
                },
          child: const Text("Add"),
        ),
      ],
    );
  }

  bool isAddEnabled() => title != null && value != null;
}
