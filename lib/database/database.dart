import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();
}

Database? _database;

int _version = 3;

Future<Database> get database async {
  if (_database != null) return _database!;

  // if _database is null we instantiate it
  _database = await initDB();
  return _database!;
}

initDB() async {
  Directory documentsDirectory = await getApplicationDocumentsDirectory();
  String path = join(documentsDirectory.path, "TestDB.db");
  return await openDatabase(path, version: _version, onOpen: (db) {},
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
        "generatorIsStandBy INTEGER,"
        "generatorOperatorValue TEXT,"
        "generatorTotalValue TEXT,"
        "generatorObservation TEXT,"
        "eventLocal TEXT,"
        "eventAdditionalhour TEXT,"
        "eventHoursUsed TEXT,"
        "eventDateStart TEXT,"
        "eventDateEnd TEXT,"
        "paymentType TEXT"
        ")");

    // await db.insert('Budget', {
    //   'budgetCode': 'ORC-001',
    //   'budgetDate': '01/03/2026',
    //   'budgetTotalValue': '2500,00',
    //   'clientName': 'João Silva',
    //   'clientCity': 'São Paulo',
    //   'clientPhone': '(11) 99999-0001',
    //   'clientEmail': 'joao.silva@email.com',
    //   'generatorKva': '75',
    //   'generatorValue': '2000,00',
    //   'generatorOperatorValue': '300,00',
    //   'generatorIsStandBy': 0,
    //   'generatorObservation': 'Gerador com tanque cheio',
    //   'eventLocal': 'Espaço Verde Eventos',
    //   'eventAdditionalhour': '150,00',
    //   'eventHoursUsed': '8',
    //   'eventDateStart': '15/03/2026',
    //   'eventDateEnd': '15/03/2026',
    //   'paymentType': 'PIX',
    // });

  }, onUpgrade: (Database db, int oldVersion, int newVersion) async {
    if (newVersion == 2) {
      await db.execute("ALTER TABLE Budget ADD COLUMN eventHoursUsed TEXT;");
      await db
          .execute("ALTER TABLE Budget ADD COLUMN generatorIsStandBy INTEGER;");
      await db.execute("UPDATE Budget SET generatorIsStandBy = 1 ");
    }
    if (newVersion == 3) {
      await db
          .execute("ALTER TABLE Budget ADD COLUMN generatorObservation TEXT;");
    }
  });
}
