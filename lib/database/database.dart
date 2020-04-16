import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();
}

Database _database;

Future<Database> get database async {
  if (_database != null) return _database;

  // if _database is null we instantiate it
  _database = await initDB();
  return _database;
}

initDB() async {
  Directory documentsDirectory = await getApplicationDocumentsDirectory();
  String path = join(documentsDirectory.path, "TestDB.db");
  return await openDatabase(path, version: 1, onOpen: (db) {},
      onCreate: (Database db, int version) async {
    await db.execute("CREATE TABLE Budget ("
        "id INTEGER PRIMARY KEY,"
        "budgetCode TEXT,"
        "budgetTotalValue TEXT,"
        "budgetDate TEXT,"
        "clientName TEXT,"
        "clientCity TEXT,"
        "clientPhone TEXT,"
        "clientEmail TEXT,"
        "generatorKva TEXT,"
        "generatorValue TEXT,"
        "generatorOperatorValue TEXT,"
        "generatorTotalValue TEXT,"
        "eventLocal TEXT,"
        "eventAdditionalhour TEXT,"
        "eventDateStart TEXT,"
        "eventDateEnd TEXT,"
        "paymentType TEXT"
        ")");
  });
}
