import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../Models/Musee.dart';
import '../Models/Pays.dart';

class DatabaseProvider {
  static final DatabaseProvider databaseProvider = DatabaseProvider._();
  DatabaseProvider._();
  static Database? _database;

  factory DatabaseProvider() {
    return DatabaseProvider._();
  }

  Future<Database> get database async {
    //   Directory path = await getApplicationDocumentsDirectory();
    String path = await getDatabasesPath();
    String dbPath = join(path, 'Musee_Database.db');

    _database = await openDatabase(dbPath, version: 1, onCreate: _create);
    return _database!;
  }

  Future _create(Database db, int version) async {
    await db.execute("""
            CREATE TABLE PAYS (
              codePays TEXT PRIMARY KEY, 
              nbhabitant INTEGER NOT NULL
            )""");

    await db.execute("""
            CREATE TABLE MUSEE (
              numMus INTEGER PRIMARY KEY AUTOINCREMENT,
              nomMus TEXT NOT NULL,
              nblivres INTEGER NOT NULL,
              codePays TEXT NOT NULL,
              FOREIGN KEY (codePays) REFERENCES PAYS (codePays)
            )""");

    await db.execute("""
            CREATE TABLE OUVRAGE (
              isbn TEXT PRIMARY KEY,
              nbPage INTEGER NOT NULL,
              titre TEXT NOT NULL,
              codePays TEXT NOT NULL,
              FOREIGN KEY (codePays) REFERENCES PAYS (codePays)
            )""");

    await db.execute("""
            CREATE TABLE BIBLIOTHEQUE (
              dateAchat TEXT NOT NULL,
              numMus INTEGER NOT NULL,
              isbn TEXT NOT NULL,
              FOREIGN KEY (numMus) REFERENCES MUSEE (numMus),
              FOREIGN KEY (isbn) REFERENCES PAYS (isbn)
              CONSTRAINT pk_numMus_isbn PRIMARY KEY(numMus, isbn)
            )""");

    await db.execute("""
            CREATE TABLE MOMENT (
              jour TEXT PRIMARY KEY
            )""");

    await db.execute("""
            CREATE TABLE VISITER (
              jour TEXT NOT NULL,
              numMus INTEGER NOT NULL,
              nbvisiteurs INTEGER NOT NULL,
              FOREIGN KEY (numMus) REFERENCES MUSEE (numMus),
              FOREIGN KEY (jour) REFERENCES MOMENT (jour)
              CONSTRAINT pk_numMus_jour PRIMARY KEY(numMus, jour)
            )""");

    await db.execute("""INSERT INTO MOMENT (jour) values ('Lundi')""");
    await db.execute("""INSERT INTO MOMENT (jour) values ('Mardi')""");
    await db.execute("""INSERT INTO MOMENT (jour) values ('Mercredi')""");
    await db.execute("""INSERT INTO MOMENT (jour) values ('Jeudi')""");
    await db.execute("""INSERT INTO MOMENT (jour) values ('Vendredi')""");
    await db.execute("""INSERT INTO MOMENT (jour) values ('Samedi')""");
    await db.execute("""INSERT INTO MOMENT (jour) values ('Dimanche')""");

    List<Pays> countries = [
      Pays(codePays: "bj", nbhabitant: 12123200),
      Pays(codePays: "cn", nbhabitant: 1439323),
      Pays(codePays: "ke", nbhabitant: 71296),
      Pays(codePays: "tg", nbhabitant: 8278724),
      Pays(codePays: "us", nbhabitant: 331002650),
    ];

    List<Musee> museums = [
      Musee(
          numMus: 1, nomMus: "Musée Da Silva", nblivres: 3560, codePays: "tg"),
      Musee(
          numMus: 2,
          nomMus: "United State of America Museum",
          nblivres: 36000,
          codePays: "us"),
      Musee(
          numMus: 3, nomMus: "Musée de Ouidah", nblivres: 4280, codePays: "bj"),
    ];

    // ---- Insertions -----
    // Pays
    for (var c in countries) {
      await db.insert("PAYS", c.toJson());
    }

    // Museums
    for (var m in museums) {
      db.insert("MUSEE", m.toJson());
    }
  }

  Future close() async {
    final db = await databaseProvider.database;
    db.close();
  }
}
