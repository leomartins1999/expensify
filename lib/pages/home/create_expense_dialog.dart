import 'package:expensify/dtos/expense.dart';
import 'package:expensify/utils/date_formatting.dart';
import 'package:flutter/material.dart';

class CreateExpenseDialog extends StatefulWidget {
  const CreateExpenseDialog({super.key});

  @override
  State<StatefulWidget> createState() => _CreateExpenseDialogState();
}

class _CreateExpenseDialogState extends State<CreateExpenseDialog> {
  String? title;
  double? value;

  DateTime date = DateTime.now();
  TextEditingController dateTextController = TextEditingController(
    text: DateTime.now().format(),
  );

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add new expense"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [buildTitleForm(), buildCostForm(), buildDateForm()],
      ),
      actions: [buildAddButton()],
    );
  }

  Widget buildTitleForm() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Title",
      ),
      keyboardType: TextInputType.name,
      onChanged: (v) => setState(() {
        title = v;
      }),
    );
  }

  Widget buildCostForm() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Cost",
      ),
      keyboardType: TextInputType.number,
      onChanged: (v) => setState(() {
        value = double.parse(v);
      }),
    );
  }

  Widget buildDateForm() {
    return TextFormField(
      controller: dateTextController,
      decoration: const InputDecoration(
        labelText: "Date",
        icon: Icon(Icons.calendar_today),
      ),
      readOnly: true,
      onTap: () async {
        final newDate = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );

        if (newDate == null) return;

        setState(() {
          dateTextController.text = newDate.format();
          date = newDate;
        });
      },
    );
  }

  Widget buildAddButton() {
    onClick() {
      final expense = Expense(title!, value!, date);
      return Navigator.of(context).pop(expense);
    }

    return TextButton(
      onPressed: isAddEnabled() ? onClick : null,
      child: const Text("Add"),
    );
  }

  bool isAddEnabled() => title != null && value != null;
}
