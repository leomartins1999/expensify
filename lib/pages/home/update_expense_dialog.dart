import 'package:expensify/dtos/expense.dart';
import 'package:expensify/utils/date_formatting.dart';
import 'package:flutter/material.dart';

class UpdateExpenseDialog extends StatefulWidget {
  final Expense expense;

  const UpdateExpenseDialog(this.expense, {super.key});

  @override
  State<StatefulWidget> createState() => _UpdateExpenseDialogState();
}

class _UpdateExpenseDialogState extends State<UpdateExpenseDialog> {
  String title = "";
  double value = 0;

  DateTime date = DateTime.now();
  TextEditingController dateTextController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final expense = widget.expense;

    title = expense.title;
    value = expense.value;
    date = expense.date;

    dateTextController = TextEditingController(text: date.format());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Update expense"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [buildTitleForm(), buildCostForm(), buildDateForm()],
      ),
      actions: [
        Row(
          children: [buildDeleteButton(), const Spacer(), buildUpdateButton()],
        )
      ],
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
      initialValue: title,
    );
  }

  Widget buildCostForm() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Cost",
      ),
      keyboardType: TextInputType.number,
      onChanged: (v) => setState(() {
        value = (v == "") ? -1 : double.parse(v);
      }),
      initialValue: value.toStringAsFixed(2),
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

  Widget buildUpdateButton() {
    onClick() {
      final updatedExpense = Expense(title, value, date, id: widget.expense.id);

      Navigator.of(context).pop(UpdateExpenseDialogResult(
        UpdateExpenseDialogResultType.update,
        updatedExpense: updatedExpense,
      ));
    }

    return TextButton(
      onPressed: isAddEnabled() ? onClick : null,
      child: const Text("Update"),
    );
  }

  Widget buildDeleteButton() {
    onClick() {
      Navigator.of(context)
          .pop(UpdateExpenseDialogResult(UpdateExpenseDialogResultType.delete));
    }

    return TextButton(
      onPressed: onClick,
      child: const Text(
        "Delete",
        style: TextStyle(color: Colors.red),
      ),
    );
  }

  bool isAddEnabled() => title != "" && value != -1;
}

class UpdateExpenseDialogResult {
  final UpdateExpenseDialogResultType type;
  final Expense? updatedExpense;

  UpdateExpenseDialogResult(this.type, {this.updatedExpense});
}

enum UpdateExpenseDialogResultType { update, delete }
