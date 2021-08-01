import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:proiect_bmi/Welcome.dart';

void main() {

  if(1==2) {//to check if is first time opening app(probavly a check if is something in teh database or cache memory, idk :)))
    runApp(MaterialApp(
      home: Home(),//home page
    ));
  }else{
    runApp(MaterialApp(
      home: Welcome(),//welcome page
    ));
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DateTime selectedDate = DateTime.now();

  String selectedSex='Male';

  int _value = 1;

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
    );

  }
}
