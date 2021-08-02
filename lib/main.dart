import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:proiect_bmi/Welcome.dart';
import 'package:proiect_bmi/update.dart';

import 'User.dart';

void main() {
  if (1 == 1) {
    //to check if is first time opening app(probably a check if is something in teh database or cache memory, idk :)))
    runApp(MaterialApp(
      home: Update(), //home page
    ));
  } else {
    runApp(MaterialApp(
      home: Welcome(), //welcome page
    ));
  }
}

class Home extends StatefulWidget {
  Home(this.user);
  final String user;
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String hintHeightType = 'Cm';
  String hintWeightType = 'Kg';
  String selectedSex = 'Male';
  String selectedMetricSystem = 'Metric';
  String response = '';
  double bmi = 0;

  final weightController = TextEditingController();
  final heightController = TextEditingController();
  final ageController = TextEditingController();

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
              Padding(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: Text(
                    'Metric System:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
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
                  setState(() {
                    selectedMetricSystem = newValue!;
                    updateHints();
                  });
                },
              ))
            ],
          ),
          Row(
            children: [
              Text(
                'Weight:   ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              new Flexible(
                child: TextFormField(
                  controller: weightController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) =>
                      checkNumericValue(value!) ? null : "Numar invalid",
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: hintWeightType,
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
                child: TextFormField(
                  controller: heightController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) =>
                      checkNumericValue(value!) ? null : "Numar invalid",
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: hintHeightType,
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
                child: TextFormField(
                  controller: ageController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) =>
                      checkNumericValue(value!) ? null : "Numar invalid",
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
          ElevatedButton(
            onPressed: onPressedCalculate,
            style: ElevatedButton.styleFrom(
                primary: Colors.black, padding: EdgeInsets.all(10.0)),
            child: //calculate button
                Text(
              'Calculate',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          Text(
            bmi != 0 ? bmi.toStringAsFixed(1) : '',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          //calculated bmi
          Text(
            response,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  double calculateBMI() {
    double weight = double.parse(weightController.text);
    double height = double.parse(heightController.text);
    return (weight / height / height) *
        (selectedMetricSystem == 'Metric' ? 10000 : 703);
  }

  bool checkNumericValue(String string) {
    if (string.isEmpty) {
      return true;
    }
    final number = num.tryParse(string);
    if (number == null || number <= 0) {
      return false;
    }
    return true;
  }

  void onPressedCalculate() {
    if (!checkNumericValue(heightController.text) ||
        !checkNumericValue(weightController.text) ||
        !checkNumericValue(ageController.text)) {
      //check for valid number
      showAlertDialog(context);
    } else {
      bmi = calculateBMI();
      response = getResponse();
      setState(() {});
    }
  }

  String getResponse() {
    if (bmi < 18.5) {
      return 'You are underweight!';
    } else if (bmi >= 18.5 && bmi < 25) {
      return 'You have a normal weight!';
    } else if (bmi >= 25 && bmi < 30) {
      return 'You are overweight!';
    } else if (bmi >= 30 && bmi < 35) {
      return 'You are class I obese!';
    } else if (bmi >= 35 && bmi < 40) {
      return 'You are class II obese!';
    } else {
      return 'You are class III obese!';
    }
  }

  void updateHints() {
    if (selectedMetricSystem == 'Metric') {
      hintWeightType = 'Kg';
      hintHeightType = 'Cm';
      weightController.text = '';
      heightController.text = '';
    } else if (selectedMetricSystem == 'Imperial') {
      hintWeightType = 'Lbs';
      hintHeightType = 'Inches';
      weightController.text = '';
      heightController.text = '';
    }
  }

  showAlertDialog(BuildContext context) {
    // Create button
    Widget okButton = TextButton(
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
      //ageController.text = calculateAge(user.birthDate).toString();
    });
  }
}
