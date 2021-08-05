import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:proiect_bmi/main.dart';
import 'package:proiect_bmi/Welcome.dart';
import 'User.dart';
import 'database.dart';

void main() {
  runApp(MaterialApp(
    home: StartApp(), //home page
  ));
}

class StartApp extends StatefulWidget {
  @override
  _StartAppState createState() => _StartAppState();
}

class _StartAppState extends State<StartApp> {
  Future getUser() async {
    try {
      DBClient db = DBClient();
      await db.createDatabase();
      User connectedUser = await db.selectUser();
      Navigator.pushAndRemoveUntil<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => Home(connectedUser),
          ),
          (route) => false);
    } catch (e) {
      Navigator.pushAndRemoveUntil<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => Welcome(),
          ),
          (route) => false);
    }
  }

  @override
  void initState() {
    super.initState();
    getUser();
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
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.orange,
          ),
        ));
  }
}
