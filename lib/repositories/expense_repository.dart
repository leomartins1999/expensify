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

    return entries
        .map((e) => Expense(
              e["title"],
              e["value"],
              DateTime.parse(e["date"]),
            ))
        .toList();
  }

  Future<void> saveExpense(Expense e) async {
    final db = await database;

    final map = {"title": e.title, "value": e.value, "date": e.date.toString()};

    await db.insert("expenses", map);
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
