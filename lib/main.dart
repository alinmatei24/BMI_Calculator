import 'dart:async';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:proiect_bmi/Welcome.dart';
import 'package:proiect_bmi/update.dart';

import 'User.dart';

void main() {
  if (1 == 1) {
    //to check if is first time opening app(probably a check if is something in teh database or cache memory, idk :)))
    runApp(MaterialApp(
      home: Home(_HomeState().getCurrentUser()), //home page
    ));
  } else {
    runApp(MaterialApp(
      home: Update(_HomeState().getCurrentUser()), //welcome page
    ));
  }
}

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
  final weightController = TextEditingController();
  final heightController = TextEditingController();
  final ageController = TextEditingController();

  final classification=TextEditingController(text: '');

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
      body: Column(
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

  void onPressedCalculate() {// to do save in db
    if (!checkNumericValue(heightController.text) ||
        !checkNumericValue(weightController.text) ||
        !checkNumericValue(ageController.text)) {
        classification.text='';
      //check for valid number
      showAlertDialog(context);
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
    weightController.text='';
    heightController.text='';
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

  void fillFieldsFromDB() {//asta o apelez inainte la loading la pagina
    setState(() {
      selectedMetricSystem=widget.user.metric;
      if(selectedMetricSystem=='Metric'){
        heightController.text = widget.user.height;
      }else{
        heightController.text= (double.parse(widget.user.height)/2.54).toStringAsFixed(0).toString();
      }
      selectedSex = widget.user.gender;
      ageController.text =(DateTime.now().difference(widget.user.birthDate).inDays / 365).toStringAsFixed(0).toString();
    });
  }

  User getCurrentUser() {//aici in trebe sa luam user din db ca metoda asta se apeleaza cand se creaza pagina)
    User user=new User('Andrei','165',DateTime(1922, 11, 12),'Male', 'Metric');//asa trebe sa arate datele din db/user
    return user;
  }

  void onPressUpdate(){ //inca nu am folosit
    Navigator.pushAndRemoveUntil<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => Update(widget.user),
        ),
            (route) => false);
  }

  void classificationString(){
      classification.text='Underweight: 18.5 and under --> ' + toUnderweight() + '\n'
          'Normal Weight:18.6 24.9 --> '+toNormalWeight() + '\n'
          'Overweight: 25-29.9 -->  '+ toOverWeight() + '\n'
          'Class I Obese:30-34.9 -->  '+ toClassIObese() + '\n'
          'Class II Obese:35-39.9 -->  '+ toClassIIObese() + '\n'
          'Class III Obese:40 and above -->  '+ toClassIIIObese();
  }

  String toUnderweight(){
    double a=bmi;
    double height=double.parse(heightController.text);
    double weight=double.parse(weightController.text);
    if(a>=18.5){
      while(a>=18.5){
        weight-=0.1;
        a=(weight / height / height) *
            (selectedMetricSystem == 'Metric' ? 10000 : 703);
      }
      return ((double.parse(weightController.text))-weight).toStringAsFixed(1)+' '+hintWeightType+' to lose';
    }else{
      return 'You are here';
    }
  }

  String toNormalWeight(){
    double a=bmi;
    double height=double.parse(heightController.text);
    double weight=double.parse(weightController.text);
    if(a>24.9){
      while(a>24.9){
        weight-=0.1;
        a=(weight / height / height) *
            (selectedMetricSystem == 'Metric' ? 10000 : 703);
      }
      return ((double.parse(weightController.text))-weight).toStringAsFixed(1)+' '+hintWeightType+' to lose';
    }else if(a<18.5){
      while (a<18.5){
        weight+=0.1;
        a=(weight / height / height) *
            (selectedMetricSystem == 'Metric' ? 10000 : 703);
      }
      return (((double.parse(weightController.text))-weight)*-1).toStringAsFixed(1)+' '+hintWeightType+' to gain';
    }else{
      return 'You are here';
    }
  }
  String toOverWeight(){
    double a=bmi;
    double height=double.parse(heightController.text);
    double weight=double.parse(weightController.text);
    if(a>29.9){
      while(a>29.9){
        weight-=0.1;
        a=(weight / height / height) *
            (selectedMetricSystem == 'Metric' ? 10000 : 703);
      }
      return ((double.parse(weightController.text))-weight).toStringAsFixed(1)+' '+hintWeightType+' to lose';
    }else if(a<25){
      while (a<25){
        weight+=0.1;
        a=(weight / height / height) *
            (selectedMetricSystem == 'Metric' ? 10000 : 703);
      }
      return (((double.parse(weightController.text))-weight)*-1).toStringAsFixed(1)+' '+hintWeightType+' to gain';
    }else{
      return 'You are here';
    }
  }
  String toClassIObese(){
    double a=bmi;
    double height=double.parse(heightController.text);
    double weight=double.parse(weightController.text);
    if(a>34.9){
      while(a>34.9){
        weight-=0.1;
        a=(weight / height / height) *
            (selectedMetricSystem == 'Metric' ? 10000 : 703);
      }
      return ((double.parse(weightController.text))-weight).toStringAsFixed(1)+' '+hintWeightType+' to lose';
    }else if(a<30){
      while (a<30){
        weight+=0.1;
        a=(weight / height / height) *
            (selectedMetricSystem == 'Metric' ? 10000 : 703);
      }
      return (((double.parse(weightController.text))-weight)*-1).toStringAsFixed(1)+' '+hintWeightType+' to gain';
    }else{
      return 'You are here';
    }
  }
  String toClassIIObese(){
    double a=bmi;
    double height=double.parse(heightController.text);
    double weight=double.parse(weightController.text);
    if(a>39.9){
      while(a>39.9){
        weight-=0.1;
        a=(weight / height / height) *
            (selectedMetricSystem == 'Metric' ? 10000 : 703);
      }
      return ((double.parse(weightController.text))-weight).toStringAsFixed(1)+' '+hintWeightType+' to lose';
    }else if(a<35){
      while (a<35){
        weight+=0.1;
        a=(weight / height / height) *
            (selectedMetricSystem == 'Metric' ? 10000 : 703);
      }
      return (((double.parse(weightController.text))-weight)*-1).toStringAsFixed(1)+' '+hintWeightType+' to gain';
    }else{
      return 'You are here';
    }
  }
  String toClassIIIObese(){
    double a=bmi;
    double height=double.parse(heightController.text);
    double weight=double.parse(weightController.text);
    if(a>=40){
      return 'You are here';
    }else{
      while (a<40){
        weight+=0.1;
        a=(weight / height / height) *
            (selectedMetricSystem == 'Metric' ? 10000 : 703);
      }
      return (((double.parse(weightController.text))-weight)*-1).toStringAsFixed(1)+' '+hintWeightType+' to gain';
    }
  }
}
