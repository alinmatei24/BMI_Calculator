import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:proiect_bmi/update.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'BMI.dart';
import 'User.dart';
import 'database.dart';

class Home extends StatefulWidget {
  Home(this.user);
  final User user;
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
  bool updateButton = true;
  final weightController = TextEditingController();
  final heightController = TextEditingController();
  final ageController = TextEditingController();

  final classification = TextEditingController(text: '');

  @override
  void initState() {
    fillFieldsFromDB();
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
                    onChanged: (text) {
                      checkValidUpdatePress();
                    },
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
                    onChanged: (text) {
                      checkValidUpdatePress();
                    },
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
                    onChanged: (text) {
                      checkValidUpdatePress();
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
              onPressed: (updateButton) ? null : onPressedCalculate,
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
            Row(
                mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
                crossAxisAlignment: CrossAxisAlignment.center, //Center Row contents vertically,
              children: [
            Text(
              bmi != 0 ? bmi.toStringAsFixed(1) : '',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              ),
              Visibility(child:
              ElevatedButton(
                onPressed: onPressSave,
                style: ElevatedButton.styleFrom(
                    primary: Colors.black, padding: EdgeInsets.all(10.0)),
                child: //calculate button
                Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
                visible: (bmi!=0)? true:false,
              ),
              ],
            ),
            //calculated bmi
            Text(
              response,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton(
              onPressed: onPressUpdate,
              style: ElevatedButton.styleFrom(
                  primary: Colors.black, padding: EdgeInsets.all(10.0)),
              child: //calculate button
                  Text(
                'Update',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            const Divider(
              color: Colors.black,
              height: 25,
              thickness: 2,
              indent: 5,
              endIndent: 5,
            ),
            Text(
              classification.text,
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
    // to do save in db
    if (!checkNumericValue(heightController.text) ||
        !checkNumericValue(weightController.text) ||
        !checkNumericValue(ageController.text)) {
      classification.text = '';
      //check for valid number
      showToast("There are some invalid values", Colors.white, Colors.black);
    } else {
      bmi = calculateBMI();
      response = getResponse();
      classificationString();
    }
    setState(() {});
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
    } else if (selectedMetricSystem == 'Imperial') {
      hintWeightType = 'Lbs';
      hintHeightType = 'Inches';
    }
    weightController.text = '';
    heightController.text = '';
  }

  void showToast(String msg, Color backgroundColor, Color textColor) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: backgroundColor,
        textColor: textColor,
        fontSize: 16.0);
  }

  void fillFieldsFromDB() {
    //asta o apelez inainte la loading la pagina
    setState(() {
      selectedMetricSystem = widget.user.metric;
      if (selectedMetricSystem == 'Metric') {
        heightController.text = widget.user.height.toString();
      } else {
        heightController.text =
            (widget.user.height / 2.54).toStringAsFixed(0).toString();
      }
      selectedSex = widget.user.gender;
      ageController.text =
          (DateTime.now().difference(widget.user.birthDate).inDays / 365)
              .toStringAsFixed(0)
              .toString();
    });
  }

  void onPressUpdate() {
    Navigator.push<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => Update(widget.user)));
  }

  void classificationString() {
    classification.text = 'Underweight: 18.5 and under --> ' +
        toUnderweight() +
        '\n'
            'Normal Weight:18.6 24.9 --> ' +
        toNormalWeight() +
        '\n'
            'Overweight: 25-29.9 -->  ' +
        toOverWeight() +
        '\n'
            'Class I Obese:30-34.9 -->  ' +
        toClassIObese() +
        '\n'
            'Class II Obese:35-39.9 -->  ' +
        toClassIIObese() +
        '\n'
            'Class III Obese:40 and above -->  ' +
        toClassIIIObese();
  }

  String toUnderweight() {
    double a = bmi;
    double height = double.parse(heightController.text);
    double weight = double.parse(weightController.text);
    if (a >= 18.5) {
      while (a >= 18.5) {
        weight -= 0.1;
        a = (weight / height / height) *
            (selectedMetricSystem == 'Metric' ? 10000 : 703);
      }
      return ((double.parse(weightController.text)) - weight)
              .toStringAsFixed(1) +
          ' ' +
          hintWeightType +
          ' to lose';
    } else {
      return 'You are here';
    }
  }

  String toNormalWeight() {
    double a = bmi;
    double height = double.parse(heightController.text);
    double weight = double.parse(weightController.text);
    if (a > 24.9) {
      while (a > 24.9) {
        weight -= 0.1;
        a = (weight / height / height) *
            (selectedMetricSystem == 'Metric' ? 10000 : 703);
      }
      return ((double.parse(weightController.text)) - weight)
              .toStringAsFixed(1) +
          ' ' +
          hintWeightType +
          ' to lose';
    } else if (a < 18.5) {
      while (a < 18.5) {
        weight += 0.1;
        a = (weight / height / height) *
            (selectedMetricSystem == 'Metric' ? 10000 : 703);
      }
      return (((double.parse(weightController.text)) - weight) * -1)
              .toStringAsFixed(1) +
          ' ' +
          hintWeightType +
          ' to gain';
    } else {
      return 'You are here';
    }
  }

  String toOverWeight() {
    double a = bmi;
    double height = double.parse(heightController.text);
    double weight = double.parse(weightController.text);
    if (a > 29.9) {
      while (a > 29.9) {
        weight -= 0.1;
        a = (weight / height / height) *
            (selectedMetricSystem == 'Metric' ? 10000 : 703);
      }
      return ((double.parse(weightController.text)) - weight)
              .toStringAsFixed(1) +
          ' ' +
          hintWeightType +
          ' to lose';
    } else if (a < 25) {
      while (a < 25) {
        weight += 0.1;
        a = (weight / height / height) *
            (selectedMetricSystem == 'Metric' ? 10000 : 703);
      }
      return (((double.parse(weightController.text)) - weight) * -1)
              .toStringAsFixed(1) +
          ' ' +
          hintWeightType +
          ' to gain';
    } else {
      return 'You are here';
    }
  }

  String toClassIObese() {
    double a = bmi;
    double height = double.parse(heightController.text);
    double weight = double.parse(weightController.text);
    if (a > 34.9) {
      while (a > 34.9) {
        weight -= 0.1;
        a = (weight / height / height) *
            (selectedMetricSystem == 'Metric' ? 10000 : 703);
      }
      return ((double.parse(weightController.text)) - weight)
              .toStringAsFixed(1) +
          ' ' +
          hintWeightType +
          ' to lose';
    } else if (a < 30) {
      while (a < 30) {
        weight += 0.1;
        a = (weight / height / height) *
            (selectedMetricSystem == 'Metric' ? 10000 : 703);
      }
      return (((double.parse(weightController.text)) - weight) * -1)
              .toStringAsFixed(1) +
          ' ' +
          hintWeightType +
          ' to gain';
    } else {
      return 'You are here';
    }
  }

  String toClassIIObese() {
    double a = bmi;
    double height = double.parse(heightController.text);
    double weight = double.parse(weightController.text);
    if (a > 39.9) {
      while (a > 39.9) {
        weight -= 0.1;
        a = (weight / height / height) *
            (selectedMetricSystem == 'Metric' ? 10000 : 703);
      }
      return ((double.parse(weightController.text)) - weight)
              .toStringAsFixed(1) +
          ' ' +
          hintWeightType +
          ' to lose';
    } else if (a < 35) {
      while (a < 35) {
        weight += 0.1;
        a = (weight / height / height) *
            (selectedMetricSystem == 'Metric' ? 10000 : 703);
      }
      return (((double.parse(weightController.text)) - weight) * -1)
              .toStringAsFixed(1) +
          ' ' +
          hintWeightType +
          ' to gain';
    } else {
      return 'You are here';
    }
  }

  String toClassIIIObese() {
    double a = bmi;
    double height = double.parse(heightController.text);
    double weight = double.parse(weightController.text);
    if (a >= 40) {
      return 'You are here';
    } else {
      while (a < 40) {
        weight += 0.1;
        a = (weight / height / height) *
            (selectedMetricSystem == 'Metric' ? 10000 : 703);
      }
      return (((double.parse(weightController.text)) - weight) * -1)
              .toStringAsFixed(1) +
          ' ' +
          hintWeightType +
          ' to gain';
    }
  }

  void checkValidUpdatePress() {
    if (weightController.text.isEmpty ||
        heightController.text.isEmpty ||
        ageController.text.isEmpty) {
      updateButton = true;
    } else {
      updateButton = false;
    }
    setState(() {});
  }

  Future<void> onPressSave() async{
    try {
      DBClient db = DBClient();
      await db.createDatabase();
      await db.registerBMI(widget.user.birthDate, double.parse(weightController.text), bmi);

    } catch (e) {
      print("Error updating user: " + e.toString());
    }
  }

  Future<void> getHistoryList() async {
    List<BMI> history=[];
    try {
      DBClient db = DBClient();
      await db.createDatabase();
     history= await db.getHistory();
      displayHistory(history);

    } catch (e) {
      print("Error updating user: " + e.toString());
    }
  }
  void displayHistory(List<BMI> list){

    for(int i=0;i<list.length;i++){
      print("Date:"+list[i].calcDate.toString()+" ");
      print("Weight:"+list[i].weight.toString()+" ");
      print("Result:"+list[i].result.toString()+" ");

    }
  }
}
