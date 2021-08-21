import 'DatabaseClient.dart';

class User {
  int id;
  String name;
  double height;
  DateTime birthday;
  String gender;
  String prefferedUnitSystem;

  User._(
      {required this.id,
      required this.name,
      required this.height,
      required this.birthday,
      required this.gender,
      required this.prefferedUnitSystem});

  static Future<User> createUser(String name, double height, DateTime birthday,
      String gender, String unitSystem, bool defaultUser) async {
    await _insertUser(name, height, birthday, gender, unitSystem, defaultUser);
    int id = await _getUserId(name);
    return new User._(
        id: id,
        name: name,
        height: height,
        birthday: birthday,
        gender: gender,
        prefferedUnitSystem: unitSystem);
  }

  static Future<void> _insertUser(String name, double height, DateTime birthday,
      String gender, String unitSystem, bool defaultUser) async {
    DatabaseClient databaseClient = await DatabaseClient.getDatabaseClient();
    await databaseClient.getDatabase().rawInsert(
        'insert into users(name, height, birthday, gender, preffered_unit_system, default_user) values(?, ?, ?, ?, ?, ?)',
        [
          name,
          height,
          birthday.millisecondsSinceEpoch,
          gender,
          unitSystem,
          defaultUser == true ? 'D' : 'N'
        ]);
  }

  static Future<int> _getUserId(String name) async {
    DatabaseClient databaseClient = await DatabaseClient.getDatabaseClient();
    try {
      List<Map> databaseResults = await databaseClient
          .getDatabase()
          .rawQuery('select id from users where name = ?', [name]);
      return databaseResults.first["id"];
    } catch (e) {
      throw Exception("Exception caught getting the user id: " + e.toString());
    }
  }

  Future<void> insertUserBmi(
      DateTime calculationDate, double userWeight, double bmi) async {
    DatabaseClient databaseClient = await DatabaseClient.getDatabaseClient();
    await databaseClient.getDatabase().rawInsert(
        'insert into user_bmi(user_id, calculation_date, user_weight, bmi) values(?, ?, ?, ?)',
        [this.id, calculationDate.millisecondsSinceEpoch, userWeight, bmi]);
  }

  static Future<User> getDefaultUser() async {
    DatabaseClient databaseClient = await DatabaseClient.getDatabaseClient();
    try {
      List<Map> databaseResults = await databaseClient.getDatabase().rawQuery(
          'select id, name, height, birthday, gender, preffered_unit_system from users where default_user = \'D\'');
      return new User._(
          id: databaseResults.first["id"],
          name: databaseResults.first["name"],
          height: databaseResults.first["height"],
          birthday: new DateTime.fromMillisecondsSinceEpoch(
              databaseResults.first["birthday"]),
          gender: databaseResults.first["gender"],
          prefferedUnitSystem: databaseResults.first["preffered_unit_system"]);
    } catch (e) {
      throw Exception(
          "Exception caught getting the default user: " + e.toString());
    }
  }

  Future updateUser(String newName, double height, DateTime birthday,
      String gender, String unitSystem) async {
    try {
      await _updateUserInDatabase(
          newName, gender, birthday, height, unitSystem);
      _updateUserObject(newName, gender, birthday, height, unitSystem);
    } catch (e) {
      throw Exception("Exception thrown while updating user: " + e.toString());
    }
  }

  Future _updateUserInDatabase(String newName, String gender, DateTime birthday,
      double height, String unitSystem) async {
    DatabaseClient databaseClient = await DatabaseClient.getDatabaseClient();
    try {
      await databaseClient.getDatabase().rawUpdate(
          'update users set name = ?, gender = ?, birthday = ?, height = ?, preffered_unit_system = ? where id = ?',
          [newName, gender, birthday, height, unitSystem, this.id]);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  void _updateUserObject(String newName, String gender, DateTime birthday,
      double height, String unitSystem) {
    this.name = newName;
    this.gender = gender;
    this.birthday = birthday;
    this.height = height;
    this.prefferedUnitSystem = prefferedUnitSystem;
  }
}
