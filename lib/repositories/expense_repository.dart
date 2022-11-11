import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../dtos/expense.dart';

class ExpenseRepository {
  static final ExpenseRepository _instance = ExpenseRepository._internal();

  Database? _database;
  Future<Database> get database async => _database ??= await buildDatabase();

  factory ExpenseRepository() => _instance;

  ExpenseRepository._internal();

  Future<List<Expense>> getExpenses() async {
    final db = await database;

    final List<Map<String, dynamic>> entries = await db.query(
      "expenses",
      orderBy: "date DESC",
    );

    return entries.map((e) => e.toExpense()).toList();
  }

  Future<void> saveExpense(Expense e) async {
    final db = await database;

    await db.insert("expenses", e.toMap());
  }

  Future<void> updateExpense(Expense e) async {
    final db = await database;

    await db.update("expenses", e.toMap(), where: "id = ?", whereArgs: [e.id]);
  }

  Future<void> deleteExpense(int expenseId) async {
    final db = await database;

    await db.delete("expenses", where: "id = ?", whereArgs: [expenseId]);
  }

  static Future<Database> buildDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), "expenses.db"),
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS expenses(
            id INTEGER PRIMARY KEY,
            title TEXT NOT NULL,
            value DOUBLE NOT NULL
          );
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        for (int i = oldVersion + 1; i <= newVersion; i++) {
          await db.execute(migrations[i]!);
        }
      },
    );
  }

  static Map<int, String> migrations = {
    2: '''
    ALTER TABLE expenses
      ADD date TEXT NOT NULL DEFAULT '2021-11-09 00:00:00';
    '''
  };
}

extension MapExtensions on Expense {
  Map<String, dynamic> toMap() =>
      {"title": title, "value": value, "date": date.toString()};
}

extension ExpenseExtensions on Map<String, dynamic> {
  Expense toExpense() => Expense(
        this["title"],
        this["value"],
        DateTime.parse(this["date"]),
        id: this["id"],
      );
}
