import 'package:flutter/material.dart';
import 'package:proiect_bmi/home.dart';
import '/model/user.dart';
import 'database.dart';
import 'package:intl/intl.dart';
import 'utils.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  DateTime? selectedDate;
  String selectedGender = 'Male';
  String selectedUnitSystem = 'Metric';
  String heightUnitHint = 'cm';

  final nameController = TextEditingController();
  final heightController = TextEditingController();

  bool canPressContinue = false;
  bool isWaitingForRegister = false;
  bool validBirthday = false;

  selectBirthday(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null)
      setState(() {
        selectedDate = picked;
        validBirthday = true;
      });
  }

  Future<bool> registerUserInDb() async {
    DBClient db = DBClient();
    try {
      await db.createDatabase();
      await db.insertUser(nameController.text, selectedGender, selectedDate!,
          double.parse(heightController.text), selectedUnitSystem);
      return true;
    } catch (e) {
      print("Error during user registration: " + e.toString());
      return false;
    }
  }

  void onPressedContinue() async {
    bool registration = await registerUserInDb();
    if (registration) {
      showToast("Registration complete", Colors.green.shade300, Colors.white);
      User user = User(
          name: nameController.text,
          height: double.parse(heightController.text),
          birthDate: selectedDate!,
          gender: selectedGender,
          unitSystem: selectedUnitSystem);
      print(user.name + ' ' + user.height.toString() + ' ' +user.birthDate.toString() + ' ' + user.gender + ' ' + user.unitSystem);
      Navigator.pushAndRemoveUntil<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => Home(user),
          ),
          (route) => false);
    } else {
      showToast("An error occurred during user registration. Please try again.",
          Colors.red.shade300, Colors.white);
      setState(() {
        canPressContinue = true;
        isWaitingForRegister = false;
      });
    }
  }

  void updateHints() {
    if (selectedUnitSystem == 'Metric') {
      heightUnitHint = 'cm';
    } else if (selectedUnitSystem == 'Imperial') {
      heightUnitHint = 'inches';
    }
    heightController.text = '';
  }

  void checkValidFields() {
    if (nameController.text.isEmpty ||
        heightController.text.isEmpty ||
        !validBirthday) {
      canPressContinue = false;
    } else {
      canPressContinue = true;
    }
    setState(() {});
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Welcome, let\'s set things up\n',
            style: TextStyle(
              fontSize: 30,
            ),
          ),
          Row(
            children: [
              Flexible(
                  child: Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  onChanged: (text) {
                    checkValidFields();
                  },
                  controller: nameController,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    labelText: 'Name',
                  ),
                ),
              ))
            ],
          ),
          Row(
            children: [
              Padding(
                  padding: EdgeInsets.only(right: 5, left: 10),
                  child: Text(
                    'Birthday:',
                  )),
              Padding(
                  padding: EdgeInsets.only(right: 5),
                  child: Text(
                    (!validBirthday)
                        ? 'Pick a date'
                        : DateFormat("dd-MMM-yyyy").format(selectedDate!),
                    style: TextStyle(fontSize: 15),
                  )),
              ElevatedButton(
                onPressed: () => selectBirthday(context),
                child: Icon(Icons.edit),
              ),
            ],
          ),
          Row(
            children: [
              Flexible(
                  child: Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Units:',
                ),
              )),
              Flexible(
                  child: DropdownButton<String>(
                value: selectedUnitSystem,
                items: <String>['Metric', 'Imperial'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    canPressContinue = false;
                    selectedUnitSystem = value!;
                    updateHints();
                  });
                },
              )),
            ],
          ),
          Flexible(
              child: Padding(
            padding: EdgeInsets.all(10),
            child: TextFormField(
              onChanged: (text) {
                checkValidFields();
              },
              controller: heightController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) =>
                  checkNumericValue(value!) ? null : "Invalid number",
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                  labelText: 'Height', helperText: heightUnitHint),
            ),
          )),
          Row(
            children: [
              Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Gender:',
                  )),
              Flexible(
                  child: DropdownButton<String>(
                value: selectedGender,
                items: <String>['Male', 'Female'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedGender = value!;
                  });
                },
              ))
            ],
          ),
          ElevatedButton(
            onPressed: (canPressContinue)
                ? () async {
                    setState(() {
                      canPressContinue = false;
                      isWaitingForRegister = true;
                    });
                    onPressedContinue();
                  }
                : null,
            child: Text(
              'Continue',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          Visibility(
            visible: isWaitingForRegister,
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.orange,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
