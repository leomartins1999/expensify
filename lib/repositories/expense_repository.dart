import '../dtos/expense.dart';

class ExpenseRepository {
  static final ExpenseRepository _instance = ExpenseRepository._internal();

  final List<Expense> _expenses = [];

  factory ExpenseRepository() => _instance;

  ExpenseRepository._internal();

  List<Expense> getExpenses() => _expenses;

  void saveExpense(Expense expense) => _expenses.add(expense);
}
