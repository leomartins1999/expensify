class Expense {
  final int id;
  final String title;
  final double value;
  final DateTime date;

  const Expense(this.title, this.value, this.date, {this.id = -1});
}
