import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseClient {
  late Database _db;

  static Future<DatabaseClient> getDatabaseClient() async {
    DatabaseClient databaseClient = DatabaseClient();
    await databaseClient.createOrGetDatabase();
    return databaseClient;
  }

  Future createOrGetDatabase() async {
    Directory path = await getApplicationDocumentsDirectory();
    String dbPath = join(path.path, "database.db");
    _db =
        await openDatabase(dbPath, version: 1, onCreate: this._createDatabase);
  }

  Future _createDatabase(Database db, int version) async {
    await _createTables(db);
    await _initClassificationTable(db);
  }

  Database getDatabase() {
    return this._db;
  }

  Future _createTables(Database db) async {
    await db.execute(
        'create table users(id INTEGER PRIMARY KEY AUTOINCREMENT, name text unique_key, height real, birthday date, gender text, preffered_unit_system text, default_user text)');
    await db.execute(
        'create table user_bmi(id INTEGER PRIMARY KEY AUTOINCREMENT, user_id integer, calculation_date date, user_weight real, bmi real)');
    await db.execute(
        'create table bmi_classifications(id INTEGER PRIMARY KEY AUTOINCREMENT, from_bmi real, to_bmi real, classification text, color text)');
  }

  Future _initClassificationTable(Database db) async {
    await db.rawInsert(
        'insert into bmi_classifications(from_bmi, to_bmi, classification, color) values(?, ?, ?, ?)',
        [null, 18.5, 'Underweight', '0xFFFFC107']);
    await db.rawInsert(
        'insert into bmi_classifications(from_bmi, to_bmi, classification, color) values(?, ?, ?, ?)',
        [18.6, 24.9, 'Normal weight', '0xFF4CAF50']);
    await db.rawInsert(
        'insert into bmi_classifications(from_bmi, to_bmi, classification, color) values(?, ?, ?, ?)',
        [25, 29.9, 'Overweight', '0xFFFFC107']);
    await db.rawInsert(
        'insert into bmi_classifications(from_bmi, to_bmi, classification, color) values(?, ?, ?, ?)',
        [30, 34.9, 'Class I Obese', '0xFFFF8F00']);
    await db.rawInsert(
        'insert into bmi_classifications(from_bmi, to_bmi, classification, color) values(?, ?, ?, ?)',
        [35, 39.9, 'Class II Obese', '0xFFFF6F00']);
    await db.rawInsert(
        'insert into bmi_classifications(from_bmi, to_bmi, classification, color) values(?, ?, ?, ?)',
        [40, null, 'Class III Obese', '0xFFF44336']);
  }
}
