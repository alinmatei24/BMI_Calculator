import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:proiect_bmi/user_profile.dart';
//import 'package:syncfusion_flutter_charts/charts.dart';
import 'history.dart';
import 'model/user.dart';
import 'database.dart';
import 'utils.dart';
import 'classifications.dart';

class Home extends StatefulWidget {
  Home(this.user);
  final User user;
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String heightUnit = 'Cm';
  String weightUnit = 'Kg';
  String selectedSex = 'Male';
  String selectedUnitSystem = 'Metric';

  String classification = '';
  String response = '';
  double bmi = 0.0;
  bool canPressCalculate = false;

  final weightController = TextEditingController();
  final heightController = TextEditingController();
  final ageController = TextEditingController();

  @override
  void initState() {
    initFields();
    super.initState();
  }

  void initFields() {
    selectedUnitSystem = widget.user.unitSystem;
    if (selectedUnitSystem == 'Metric') {
      heightController.text = widget.user.height.toString();
    } else {
      heightController.text =
          convertHeight(widget.user.height, selectedUnitSystem).toString();
    }
    selectedSex = widget.user.gender;
    ageController.text =
        (DateTime.now().difference(widget.user.birthDate).inDays / 365)
            .toStringAsFixed(0);
  }

  void unitSystemChanged(String newUnitSystem) {
    if (selectedUnitSystem != newUnitSystem) {
      weightUnit = getWeightUnit(newUnitSystem);
      heightUnit = getHeightUnit(newUnitSystem);
      weightController.text =
          convertWeight(double.parse(weightController.text), newUnitSystem)
              .toString();
      heightController.text =
          convertHeight(double.parse(heightController.text), newUnitSystem)
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

  void onPressedCalculate() {
    bmi = calculateBmi(double.parse(weightController.text),
        double.parse(heightController.text), selectedUnitSystem);
    response = getBmiResult(bmi);
    classification = getClassification(bmi, double.parse(weightController.text),
        double.parse(heightController.text), selectedUnitSystem);
    setState(() {});
  }

  Future<void> onPressSave() async {
    try {
      DBClient db = DBClient();
      await db.createDatabase();
      await db.registerBMI(
          widget.user.birthDate, double.parse(weightController.text), bmi);
    } catch (e) {
      showToast("An error occurred during data saving. Please try again.",
          Colors.red.shade300, Colors.white);
    }
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
                  value: selectedUnitSystem,
                  items: <String>['Metric', 'Imperial'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: new Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      unitSystemChanged(newValue!);
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
                    validator: (value) =>
                        checkNumericValue(value!) ? null : "Numar invalid",
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
                    validator: (value) =>
                        checkNumericValue(value!) ? null : "Numar invalid",
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
                    validator: (value) =>
                        checkNumericValue(value!) ? null : "Number invalid",
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
              response.toString(),
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
                                UserProfile(widget.user)));
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
                                History(widget.user)));
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
              classification.toString(),
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
