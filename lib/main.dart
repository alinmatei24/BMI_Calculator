import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:proiect_bmi/Welcome.dart';
import 'package:proiect_bmi/update.dart';

import 'User.dart';

void main() {
  if (1 == 0) {
    //to check if is first time opening app(probably a check if is something in teh database or cache memory, idk :)))
    runApp(MaterialApp(
      home: Update(), //home page
    ));
  } else {
    runApp(MaterialApp(
      home: Home(), //welcome page
    ));
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DateTime selectedDate = DateTime.now();

  final heightType = TextEditingController(text: 'Cm');
  final weightType = TextEditingController(text: 'Kg');
  String selectedSex = 'Male';
  String selectedMetricSystem = 'Metric';
  final bmi = TextEditingController(text: '0');
  final response = TextEditingController(text: '');
  final weightController = TextEditingController();
  final heightController = TextEditingController();
  final ageController = TextEditingController();
  final hintHeightController = AutofillHints;
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            //sex and metric system buttons
            children: [
              Text(
                'Sex:  ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              DropdownButton<String>(
                value: selectedSex,
                items: <String>['Male', 'Female'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: new Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedSex = newValue!;
                  });
                },
              ),
              Text(
                '  Metric System:    ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              new Flexible(
                  child: DropdownButton<String>(
                value: selectedMetricSystem,
                items: <String>['Metric', 'Imperial'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: new Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  updateHints();
                  setState(() {
                    selectedMetricSystem = newValue!;
                  });
                },
              ))
            ],
          ),
          Row(
            //weight,height and age textFields
            children: [
              Text(
                'Weight:   ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              new Flexible(
                child: TextField(
                  controller: weightController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: weightType.text,
                    fillColor: Colors.black,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
              ),
              new Flexible(
                child: Text(
                  'Height:   ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              new Flexible(
                child: TextField(
                  controller: heightController,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: heightType.text,
                    fillColor: Colors.black,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
              ),
              new Flexible(
                child: Text(
                  'Age:   ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              new Flexible(
                child: TextField(
                  controller: ageController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: 'Age',
                    fillColor: Colors.black,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
              ),
            ],
          ),
          RaisedButton(
            onPressed: onPressedCalculate,
            color: Colors.black,
            padding: EdgeInsets.all(10.0),
            child: //calculate button

                Text(
              'Calculate',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          Text(
            bmi.text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          //calculated bmi
          Text(
            response.text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  double metricFormula() {
    double weight = double.parse(weightController.text);
    double height = double.parse(heightController.text);
    return (weight / height / height) * 10000;
  }

  double imperialFormula() {
    double weight = double.parse(weightController.text);
    double height = double.parse(heightController.text);
    return (weight / (height * height)) * 703;
  }

  bool isNumericUsing_tryParse(String string) {
    // Null or empty string is not a number
    if (string == null || string.isEmpty) {
      return false;
    }
    // Try to parse input string to number.
    // Both integer and double work.
    // Use int.tryParse if you want to check integer only.
    // Use double.tryParse if you want to check double only.
    final number = num.tryParse(string);
    if (number == null || number <= 0) {
      return false;
    }

    return true;
  }

  void onPressedCalculate() {
    String metricSystem = selectedMetricSystem;
    String sex = selectedSex;
    String weight = weightController.text;
    String height = heightController.text;
    String age = ageController.text;
    double bmiCalculated = 0;
    if (!isNumericUsing_tryParse(height) ||
        !isNumericUsing_tryParse(weight) ||
        !isNumericUsing_tryParse(age)) {
      //check for valid number
      showAlertDialog(context);
    }
    if (metricSystem == 'Metric') {
      //calculate the bmi and update the height and weight hints when changing metric system
      bmiCalculated = metricFormula();
    } else {
      bmiCalculated = imperialFormula();
    }
    setState(() {
      bmi.text = bmiCalculated.toStringAsFixed(1);
    });
    getResponse();
  }

  void getResponse() {
    double bmiTest = double.parse(bmi.text);
    String s = '';
    if (bmiTest < 18.5) {
      s = 'You are underweight!';
    } else if (bmiTest >= 18.5 && bmiTest < 25) {
      s = 'You have a normal weight!';
    } else if (bmiTest >= 25 && bmiTest < 30) {
      s = 'You are overweight!';
    } else if (bmiTest >= 30 && bmiTest < 35) {
      s = 'You are class I obese!';
    } else if (bmiTest >= 35 && bmiTest < 40) {
      s = 'You are class II obese!';
    } else if (bmiTest >= 40) {
      s = 'You are class III obese!';
    }
    setState(() {
      response.text = s;
    });
  }

  Future sleep1() {
    //for sleeping
    return new Future.delayed(const Duration(milliseconds: 1), () => "1");
  }

  Future<void> updateHints() async {
    //updating the hints
    await Future.delayed(Duration(milliseconds: 500));
    String metricSystem = selectedMetricSystem;
    if (metricSystem == 'Metric') {
      //calculate the bmi and update the height and weight hints when changing metric system
      setState(() {
        weightType.text = 'Kg';
        heightType.text = 'Cm';
        weightController.text = '';
        heightController.text = '';
      });
    } else if (metricSystem == 'Imperial') {
      setState(() {
        weightType.text = 'Lbs';
        heightType.text = 'Inches';
        weightController.text = '';
        heightController.text = '';
      });
    }
  }

  showAlertDialog(BuildContext context) {
    // Create button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Invalid Values"),
      content: Text("Each value must be grater than 0!"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void fillFieldsFromDB() {
    User user = new User();
    user.name = 'test';
    user.height = 'test';
    user.weight = 'test';
    user.gender = selectedSex;
    user.birthDate = DateTime(2000, 12, 10);

    setState(() {
      heightController.text = user.height;
      selectedSex = user.gender;
      ageController.text = calculateAge(user.birthDate).toString();
    });
  }

  calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }
}
