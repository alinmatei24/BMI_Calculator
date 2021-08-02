import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'BMI.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBClient {
  late Database _db;

//create and give acces to the database
  Future createDatabase() async {
    Directory path = await getApplicationDocumentsDirectory();
    String dbPath = join(path.path, "database.db");

    _db = await openDatabase(dbPath, version: 1, onCreate: this._createTables);
  }

//create the database tables
  Future _createTables(Database db, int version) async {
    await db.execute(
        'create table user(name primary key, sex text, birthday date, height real)');

    await db.execute(
        'create table history(calc_date date, weight real, result real)');
  }

//register a user
  Future<void> insertUser(String name, String sex, DateTime birthday,
      double height, String heightType) async {
    await _db.rawInsert(
        'insert into user(name, sex, birthday, height) VALUES(?, ?, ?, ?)',
        [name, sex, birthday.millisecondsSinceEpoch, height]);
  }

  //register a calculation
  Future<void> registerBMI(DateTime date, double weight, double result) async {
    await _db.rawInsert(
        'insert into history(calc_date, weight, result) VALUES(?, ?, ?)',
        [date, weight, result]);
  }

  Future<List<BMI>> getHistory() async {
    try {
      List<Map> results = await _db.rawQuery('select * from history"');
      // ignore: non_constant_identifier_names
      List<BMI> BMIs = [];
      results.forEach((result) {
        BMI bmi = new BMI(
            calcDate: result["calc_date"],
            weight: result["weight"],
            result: result["result"]);
        BMIs.add(bmi);
      });
      return BMIs;
    } catch (e) {
      print(e);
      throw Exception("An error occured!");
    }
  }
}
