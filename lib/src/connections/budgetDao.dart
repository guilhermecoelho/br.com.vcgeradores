import 'package:sqflite/sqflite.dart';
import 'package:vc_geradores/database/database.dart';
import '../models/budgetModel.dart';

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

  return List.generate(maps.length, (i) {
    return _populateBudgetModel(maps[i]);
  });
}

Future<BudgetModel?> getBudgetById(int id) async {
  final Database db = await database;

  final List<Map<String, dynamic>> maps =
      await db.query('Budget', where: 'id = ?', whereArgs: [id]);

  if (maps.isNotEmpty) {
    return _populateBudgetModel(maps.first);
  }

  return null;
}

Future<void> updateBudget(BudgetModel budget) async {
  final Database db = await database;

  await db.update('Budget', budget.toMap(),
      where: 'id = ?', whereArgs: [budget.id]);
}

Future<void> deleteBudget(BudgetModel budget) async {
  final Database db = await database;

  await db.delete('Budget', where: 'id = ?', whereArgs: [budget.id]);
}

BudgetModel _populateBudgetModel(Map<String, dynamic> map) {
  return BudgetModel(
      id: map['id'],
      budgetCode: map['budgetCode'],
      budgetTotalValue: map['budgetTotalValue'],
      budgetDate: map['budgetDate'],
      clientName: map['clientName'],
      clientCity: map['clientCity'],
      clientPhone: map['clientPhone'],
      clientEmail: map['clientEmail'],
      generatorKva: map['generatorKva'],
      generatorValue: map['generatorValue'],
      generatorOperatorValue: map['generatorOperatorValue'],
      generatorIsStandBy: map['generatorIsStandBy'],
      generatorObservation: map['generatorObservation'],
      generatorCableValue: map['generatorCableValue'],
      eventLocal: map['eventLocal'],
      eventAdditionalhour: map['eventAdditionalhour'],
      eventHoursUsed: map['eventHoursUsed'],
      eventDateStart: map['eventDateStart'],
      eventDateEnd: map['eventDateEnd'],
      paymentType: map['paymentType']);
}
