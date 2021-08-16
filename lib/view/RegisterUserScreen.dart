import 'package:flutter/material.dart';
import 'package:proiect_bmi/model/user.dart';
import 'package:proiect_bmi/view/HomeScreen.dart';
import 'package:intl/intl.dart';
import '../model/BmiMath.dart';
import '../model/BmiHints.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterUserScreen extends StatefulWidget {
  final bool defaultUser;
  RegisterUserScreen(this.defaultUser);
  @override
  _RegisterUserScreenState createState() => _RegisterUserScreenState();
}

class _RegisterUserScreenState extends State<RegisterUserScreen> {
  bool canPressContinue = false;
  bool isWaitingForRegister = false;
  bool validBirthday = false;

  String selectedGender = 'Male';
  String selectedUnitSystem = 'Metric';
  String heightUnit = 'Cm';

  DateTime? selectedDate;

  final nameController = TextEditingController();
  final heightController = TextEditingController();

  _selectBirthday(BuildContext context) async {
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

  void _registerNewUser() async {
    User user = await User.createUser(
        nameController.text,
        double.parse(heightController.text),
        selectedDate!,
        selectedGender,
        selectedUnitSystem,
        widget.defaultUser);
    Navigator.pushAndRemoveUntil<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => HomeScreen(user),
        ),
        (route) => false);
  }

  void showFailedUserRegistration() {
    Fluttertoast.showToast(
        msg: "An error occurred during user registration. Please try again.");
    showOrHideLoadingIcon();
  }

  void beginUserRegistration() async {
    try {
      _registerNewUser();
    } catch (e) {
      showFailedUserRegistration();
    }
  }

  void showOrHideLoadingIcon() {
    setState(() {
      canPressContinue = !canPressContinue;
      isWaitingForRegister = !isWaitingForRegister;
    });
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
          'Register',
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
            'Let\'s create a new user',
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
                onPressed: () => _selectBirthday(context),
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
                    selectedUnitSystem = value!;
                    heightUnit = BmiHints.getHeightUnit(selectedUnitSystem);
                    heightController.text = BmiMath.convertHeightToSystem(
                            double.parse(heightController.text),
                            selectedUnitSystem)
                        .toString();
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
                  BmiMath.checkNumericValue(value!) ? null : "Invalid number",
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration:
                  InputDecoration(labelText: 'Height', helperText: heightUnit),
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
                ? () {
                    showOrHideLoadingIcon();
                    beginUserRegistration();
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
