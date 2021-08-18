import 'package:flutter/material.dart';
import 'package:proiect_bmi/model/user.dart';
import 'package:proiect_bmi/model/Classification.dart';
import 'package:proiect_bmi/view/UserProfileScreen.dart';
import 'UserBmiScreen.dart';
import '../model/BmiHints.dart';
import '../model/BmiMath.dart';
import '../model/Classification.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen(this.user);
  final User user;
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool canPressCalculate = false;
  double bmi = 0.0;

  String heightUnit = 'Cm';
  String weightUnit = 'Kg';
  String selectedGender = 'Male';
  String selectedUnitSystem = 'Metric';
  Classification? currentClassification;
  List<Classification>? allClassifications;

  final weightController = TextEditingController();
  final heightController = TextEditingController();
  final ageController = TextEditingController();

  void changeUnitSystem(String newUnitSystem) {
    if (selectedUnitSystem != newUnitSystem) {
      weightUnit = BmiHints.getWeightUnit(newUnitSystem);
      heightUnit = BmiHints.getHeightUnit(newUnitSystem);
      weightController.text = BmiMath.convertWeightToSystem(
              double.parse(weightController.text), newUnitSystem)
          .toString();
      heightController.text = BmiMath.convertHeightToSystem(
              double.parse(heightController.text), newUnitSystem)
          .toString();
      selectedUnitSystem = newUnitSystem;
    }
  }

  void checkCanPressCalculate() {
    if (weightController.text.isEmpty ||
        heightController.text.isEmpty ||
        ageController.text.isEmpty) {
      canPressCalculate = false;
    } else {
      canPressCalculate = true;
    }
    setState(() {});
  }

  void onPressedCalculate() async {
    bmi = BmiMath.calculateBmi(double.parse(weightController.text),
        double.parse(heightController.text), selectedUnitSystem);
    currentClassification = await Classification.getBmiClassification(bmi);
    allClassifications = await Classification.getAllBmiClassifications();
    setState(() {});
  }

  Future<void> onPressSave() async {
    try {
      await widget.user.insertUserBmi(
          DateTime.now(), double.parse(weightController.text), bmi);
    } catch (e) {
      Fluttertoast.showToast(
          msg: "An error occurred during user registration. Please try again.");
    }
  }

  @override
  Widget build(BuildContext context) {
    selectedUnitSystem = widget.user.prefferedUnitSystem;
    if (selectedUnitSystem == 'Metric') {
      heightController.text = widget.user.height.toString();
    } else {
      heightController.text =
          BmiMath.convertHeightToSystem(widget.user.height, selectedUnitSystem)
              .toString();
    }
    selectedGender = widget.user.gender;
    ageController.text =
        (DateTime.now().difference(widget.user.birthday).inDays / 365)
            .toStringAsFixed(0);

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
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: [
                Text(
                  'Gender:  ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
                  value: selectedUnitSystem,
                  items: <String>['Metric', 'Imperial'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: new Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      changeUnitSystem(newValue!);
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
                    onChanged: (text) {
                      checkCanPressCalculate();
                    },
                    controller: weightController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) => BmiMath.checkNumericValue(value!)
                        ? null
                        : "Numar invalid",
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: weightUnit,
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
                    onChanged: (text) {
                      checkCanPressCalculate();
                    },
                    controller: heightController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) => BmiMath.checkNumericValue(value!)
                        ? null
                        : "Numar invalid",
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: heightUnit,
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
                    onChanged: (text) {
                      checkCanPressCalculate();
                    },
                    controller: ageController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) => BmiMath.checkNumericValue(value!)
                        ? null
                        : "Number invalid",
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
              onPressed: (canPressCalculate) ? onPressedCalculate : null,
              style: ElevatedButton.styleFrom(
                  primary: Colors.black, padding: EdgeInsets.all(10.0)),
              child: Text(
                'Calculate',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  (bmi != 0.0) ? bmi.toStringAsFixed(1) : '',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Visibility(
                  child: ElevatedButton(
                    onPressed: onPressSave,
                    style: ElevatedButton.styleFrom(
                        primary: Colors.black, padding: EdgeInsets.all(10.0)),
                    child: Text(
                      'Save',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  visible: (bmi != 0) ? true : false,
                ),
              ],
            ),
            Text(
              currentClassification!.classification,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push<dynamic>(
                        context,
                        MaterialPageRoute<dynamic>(
                            builder: (BuildContext context) =>
                                UserProfileScreen(widget.user)));
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Colors.black, padding: EdgeInsets.all(10.0)),
                  child: Text(
                    'Edit profile',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push<dynamic>(
                        context,
                        MaterialPageRoute<dynamic>(
                            builder: (BuildContext context) =>
                                UserBmiScreen(widget.user)));
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Colors.black, padding: EdgeInsets.all(10.0)),
                  child: Text(
                    'See History',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(
              color: Colors.black,
              height: 25,
              thickness: 2,
              indent: 5,
              endIndent: 5,
            ),
            Text(
              'bla bla bla',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
