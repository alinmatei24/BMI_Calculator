import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:proiect_bmi/home.dart';
import 'package:proiect_bmi/welcome.dart';
import 'model/user.dart';
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
      User connectedUser = await db.getDefaultUser();
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
    getUser();
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
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.orange,
          ),
        ));
  }
}
