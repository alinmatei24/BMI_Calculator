import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'model/bmi.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'model/user.dart';

class DBClient {
  late Database _db;

//create and give access to the database
  Future createDatabase() async {
    Directory path = await getApplicationDocumentsDirectory();
    String dbPath = join(path.path, "database.db");

    _db = await openDatabase(dbPath, version: 1, onCreate: this._createTables);
  }

//create the database tables
  Future _createTables(Database db, int version) async {
    await db.execute(
        'create table user(name text primary_key, height real, birthday date, sex text, unit_system text)');

    await db.execute(
        'create table history(calc_date date, weight real, result real)');
  }

//register a user
  Future<void> insertUser(String name, String sex, DateTime birthday,
      double height, String unitSystem) async {
    await _db.rawInsert(
        'insert into user(name, height, birthday, sex, unit_system) VALUES(?, ?, ?, ?, ?)',
        [name, height, birthday.millisecondsSinceEpoch, sex, unitSystem]);
  }

  //register a calculation
  Future<void> registerBMI(DateTime date, double weight, double result) async {
    await _db.rawInsert(
        'insert into history(calc_date, weight, result) VALUES(?, ?, ?)',
        [date.millisecondsSinceEpoch, weight, result]);
  }

  Future<List<BMI>> getHistory() async {
    try {
      List<Map> results = await _db.rawQuery('select * from history');
      // ignore: non_constant_identifier_names
      List<BMI> BMIs = [];
      results.forEach((result) {
        BMI bmi = new BMI(
            calcDate:
                new DateTime.fromMillisecondsSinceEpoch(result["calc_date"]),
            weight: result["weight"],
            result: result["result"]);
        BMIs.add(bmi);
      });
      return BMIs;
    } catch (e) {
      print(e);
      throw Exception("An error occurred!");
    }
  }

  Future<User> getDefaultUser() async {
    try {
      List<Map> results = await _db.rawQuery('select * from user');
      List<User> users = [];
      results.forEach((result) {
        User user = new User(
            name: result["name"],
            height: result["height"],
            birthDay:
                new DateTime.fromMillisecondsSinceEpoch(result["birthday"]),
            gender: result["sex"],
            unitSystem: result["unit_system"]);
        users.add(user);
      });
      return users.first;
    } catch (e) {
      print(e);
      throw Exception("No user found");
    }
  }

  Future<bool> updateUser(String currentName, String name, String sex,
      DateTime birthday, double height, String unitSystem) async {
    try {
      await _db.rawUpdate(
          'update user set height = ? where name = ?', [height, currentName]);
      return true;
    } catch (e) {
      throw Exception("can't update user");
    }
  }
}
