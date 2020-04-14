import 'package:sqflite/sqflite.dart';
import 'package:vc_geradores/database/database.dart';

import '../../src/models/budgetModel.dart';


Future<void> insertBudget(BudgetModel budget) async {
  
  final Database db = await database;

  await db.insert(
    'Budget',
    budget.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<List<BudgetModel>> listBudget() async {
  final Database db = await database;

  final List<Map<String, dynamic>> maps = await db.query('Budget');

  // var t = BudgetModel(clientName: 'client 1', id: 1);
  // var t2 = BudgetModel(clientName: 'client 2', id: 2);

  // insertBudget(t);
  // insertBudget(t2);

  return List.generate(maps.length, (i) {
    return BudgetModel(
      id: maps[i]['id'],
      clientName: maps[i]['clientName']);
  });
}

Future<void> updateBudget(BudgetModel budget) async {
  final Database db = await database;

  await db.update('Budget', budget.toMap(),
      where: 'id = ?', whereArgs: [budget.id]);
}


Future<void> deleteBudget(BudgetModel budget) async {
  final Database db = await database;

  await db.delete('Budget',
      where: 'id = ?', whereArgs: [budget.id]);
}