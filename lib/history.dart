import 'model/bmi.dart';
import 'database.dart';

Future<void> getHistoryList() async {
  List<BMI> history = [];
  try {
    DBClient db = DBClient();
    await db.createDatabase();
    history = await db.getHistory();
    displayHistory(history);
  } catch (e) {
    print("Error updating user: " + e.toString());
  }
}

void displayHistory(List<BMI> list) {
  for (int i = 0; i < list.length; i++) {
    print("Date:" + list[i].calcDate.toString() + " ");
    print("Weight:" + list[i].weight.toString() + " ");
    print("Result:" + list[i].result.toString() + " ");
  }
}
