import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proiect_bmi/utils.dart';
import 'model/bmi.dart';
import 'database.dart';
import 'model/user.dart';

Future<List<BMI>> getHistoryList() async {
  List<BMI> history = [];
  try {
    DBClient db = DBClient();
    await db.createDatabase();
    history = await db.getHistory();
    return history;
  } catch (e) {
    throw Exception("can't get history");
  }
}

void displayHistory(List<BMI> list) {
  for (int i = 0; i < list.length; i++) {
    print("Date:" + list[i].calcDate.toString() + " ");
    print("Weight:" + list[i].weight.toString() + " ");
    print("Result:" + list[i].result.toString() + " ");
  }
}
  List<BMI> testList(){
    List<BMI> history =[];
    history.add(new BMI(calcDate: DateTime.now(), weight: 81, result: 24));
    history.add(new BMI(calcDate: DateTime.now(), weight: 82, result: 25));
    history.add(new BMI(calcDate: DateTime.now(), weight: 83, result: 26));
    history.add(new BMI(calcDate: DateTime.now(), weight: 84, result: 27));
    history.add(new BMI(calcDate: DateTime.now(), weight: 85, result: 28));
    history.add(new BMI(calcDate: DateTime.now(), weight: 86, result: 29));
    history.add(new BMI(calcDate: DateTime.now(), weight: 87, result: 30));
    history.add(new BMI(calcDate: DateTime.now(), weight: 88, result: 31));
    return history;
  }
class History extends StatefulWidget {
  History(this.user);
  final User user;
  @override
  _History createState() => _History();
}

class _History extends State<History> {
  List<BMI> list=[];
  Future<void> getHistory() async{
    list =await getHistoryList();
    setState(() {

    });
  }

  @override
  void initState() {
    getHistory();
    super.initState();
  }


  Future<void> onPressDelete(BMI bmi) async {
    print('Date:'+ bmi.calcDate.toString() + ' ' + 'Weight:' + bmi.weight.toString() + ' Result:' + bmi.result.toString());
    try{
    DBClient db = DBClient();
    await db.createDatabase();
    await db.deleteBMI(bmi.calcDate, bmi.weight, bmi.result);
    getHistory();
    } catch (e) {
      showToast("An error occurred during data deletion. Please try again.",
          Colors.red.shade300, Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'BMI Calculator',
            style: TextStyle(
              fontSize: 32,
            ),
          ),
          centerTitle: true,
        ),
        body: Container(
          child: new ListView.builder(
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) =>buildCard(context, index)
          ),
        ),
    );
  }
  
  Widget buildCard(BuildContext context, int index){
    final ind = list[index];
    return new  Container(
      child: Card(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: <Widget>[
                    Text('Date:${DateFormat('dd/MM/yyyy').format(ind.calcDate)}'),
                    Text('Weight:${ind.weight}'),
                  ],
                ),
                Text('Result:${ind.result.toStringAsFixed(1)}'),
                IconButton(onPressed: ()=>onPressDelete(ind), icon:Icon(Icons.delete), ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  
}
