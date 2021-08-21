import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:proiect_bmi/model/Bmi.dart';
import 'package:proiect_bmi/model/User.dart';

class UserBmiScreen extends StatefulWidget {
  UserBmiScreen(this.user);
  final User user;
  @override
  _UserBmiScreen createState() => _UserBmiScreen();
}

class _UserBmiScreen extends State<UserBmiScreen> {
  List<Bmi> bmiList = [];

  Future<void> getUserBmi() async {
    bmiList = await Bmi.getUserBmiList(widget.user);
  }

  Future<void> onPressDelete(Bmi bmi) async {
    try {
      await bmi.deleteUserBmifromDatabase();
      bmiList.remove(bmi);
      setState(() {});
    } catch (e) {
      Fluttertoast.showToast(
          msg: "An error occurred during data deletion. Please try again.");
    }
  }

  @override
  void initState() {
    getUserBmi();
    super.initState();
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
            itemCount: bmiList.length,
            itemBuilder: (BuildContext context, int index) =>
                buildCard(context, index)),
      ),
    );
  }

  Widget buildCard(BuildContext context, int index) {
    final bmi = bmiList[index];
    return new Container(
      child: Card(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: <Widget>[
                    Text(
                        'Date:${DateFormat('dd/MM/yyyy').format(bmi.calculationDate)}'),
                    Text('Weight:${bmi.userWeight}'),
                  ],
                ),
                Text('Result:${bmi.bmi.toStringAsFixed(1)}'),
                IconButton(
                  onPressed: () => onPressDelete(bmi),
                  icon: Icon(Icons.delete),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
