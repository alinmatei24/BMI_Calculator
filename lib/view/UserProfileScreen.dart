import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:proiect_bmi/model/user.dart';
import 'HomeScreen.dart';
import '../model/BmiHints.dart';
import '../model/BmiMath.dart';

class UserProfileScreen extends StatefulWidget {
  UserProfileScreen(this.user);
  final User user;
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool canPressUpdateButton = false;

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
      });
  }

  Future<void> _onPressedUpdate() async {
    try {
      await _updateUser();
    } catch (e) {
      print("Error updating user: " + e.toString());
    }
  }

  Future<void> _updateUser() async {
    await widget.user.updateUser(
        nameController.text,
        double.parse(heightController.text),
        selectedDate!,
        selectedGender,
        selectedUnitSystem);
    Navigator.pushAndRemoveUntil<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => HomeScreen(widget.user),
        ),
        (route) => false);
  }

  void _checkValidUpdatePress() {
    if (nameController.text.isEmpty || heightController.text.isEmpty) {
      canPressUpdateButton = true;
    } else {
      canPressUpdateButton = false;
    }
    setState(() {});
  }

  void initFields() {
    nameController.text = widget.user.name;
    selectedGender = widget.user.gender;
    selectedUnitSystem = widget.user.prefferedUnitSystem;
    selectedDate = widget.user.birthday;
    if (selectedUnitSystem == 'Metric') {
      heightController.text = widget.user.height.toString();
    } else {
      heightController.text =
          BmiMath.convertHeightToSystem(widget.user.height, selectedUnitSystem)
              .toString();
    }
  }

  @override
  void initState() {
    initFields();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit profile',
          style: TextStyle(
            fontSize: 32,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Text('Edit Profile',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                )),
          ),
          SizedBox(height: 50),
          Row(
            children: [
              new Flexible(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text('Name',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    TextField(
                      onChanged: (text) {
                        _checkValidUpdatePress();
                      },
                      textAlign: TextAlign.center,
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: 'Name',
                        fillColor: Colors.red,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              new Flexible(
                child: Text(
                  'Select Metric System:',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              new Flexible(
                  child: DropdownButton<String>(
                value: selectedUnitSystem,
                items: <String>['Metric', 'Imperial'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: new Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedUnitSystem = newValue!;
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
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Flexible(
                child: Column(
                  children: <Widget>[
                    Text('Height',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        )),
                    TextFormField(
                      onChanged: (text) {
                        _checkValidUpdatePress();
                      },
                      controller: heightController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) => BmiMath.checkNumericValue(value!)
                          ? null
                          : "Number invalid",
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: heightUnit,
                        fillColor: Colors.red,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              new Flexible(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "${selectedDate!.toLocal()}".split(' ')[0],
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  ElevatedButton(
                    onPressed: () => _selectBirthday(context),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                    ),
                    child: Text(
                      'Select birth date',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              )),
              new Flexible(
                child: Column(
                  children: [
                    Text('Gender',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        )),
                    DropdownButton<String>(
                      value: selectedGender,
                      items: <String>['Male', 'Female'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedGender = newValue!;
                        });
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil<dynamic>(
                      context,
                      MaterialPageRoute<dynamic>(
                        builder: (BuildContext context) =>
                            HomeScreen(widget.user),
                      ),
                      (route) => false);
                },
                style: ElevatedButton.styleFrom(
                    primary: Colors.black, padding: EdgeInsets.all(10.0)),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: (canPressUpdateButton) ? null : _onPressedUpdate,
                style: ElevatedButton.styleFrom(
                    primary: Colors.black, padding: EdgeInsets.all(10.0)),
                child: Text(
                  'Update',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
