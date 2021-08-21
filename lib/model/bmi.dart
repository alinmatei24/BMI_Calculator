import 'DatabaseClient.dart';
import 'User.dart';

class Bmi {
  int id;
  DateTime calculationDate;
  double userWeight;
  double bmi;

  Bmi._(
      {required this.id,
      required this.calculationDate,
      required this.userWeight,
      required this.bmi});

  static Future<List<Bmi>> getUserBmiList(User user) async {
    DatabaseClient databaseClient = await DatabaseClient.getDatabaseClient();
    try {
      List<Map> databaseResults = await databaseClient.getDatabase().rawQuery(
          'select id, calculation_date, user_weight, bmi from user_bmi where user_id = ?',
          [user.name]);
      List<Bmi> userBmiList = [];
      databaseResults.forEach((result) {
        Bmi userBmi = new Bmi._(
            id: result["bmi"],
            calculationDate: new DateTime.fromMillisecondsSinceEpoch(
                result["calculation_date"]),
            userWeight: result["user_weight"],
            bmi: result["bmi"]);
        userBmiList.add(userBmi);
      });
      return userBmiList;
    } catch (e) {
      throw Exception("Error ocured during getUserBmiList: " + e.toString());
    }
  }

  Future<bool> deleteUserBmifromDatabase() async {
    DatabaseClient databaseClient = await DatabaseClient.getDatabaseClient();
    try {
      await databaseClient
          .getDatabase()
          .rawUpdate('delete from user_bmi where id=?', [this.id]);
      return true;
    } catch (e) {
      throw Exception(
          "Exception thrown while deleting user bmi: " + e.toString());
    }
  }
}
