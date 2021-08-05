import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'User.dart';
import 'main.dart';

class Update extends StatefulWidget {
  Update(this.user);
  final User user;
  @override
  _UpdateState createState() => _UpdateState();
}

class _UpdateState extends State<Update> {
  DateTime selectedDate = DateTime.now();
  String selectedSex = 'Male';
  String selectedMetricSystem = 'Metric';
  final nameController = TextEditingController();
  final heightController = TextEditingController();
  String hintHeightType = 'Cm';

  @override
  void initState() {
    fillFieldsFromDataBase();
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
        //everything
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
          SizedBox(height: 50), //space between items in column
          Row(
            children: [
              new Flexible(child:
              Column(
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
                    //name
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
              new Flexible(child:
              Text(
                'Select Metric System:',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
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
                      setState(() {
                        selectedMetricSystem = newValue!;
                        updateHints();
                      });
                    },
                  )),
            ],
          ),
          SizedBox(height: 30), //space between items in column
          Row(
            //the row with height, date and gender
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Flexible(
                child: Column(
                  //height
                  children: <Widget>[
                    Text('Height',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        )),
                    TextFormField(
                      controller: heightController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) =>
                      checkNumericValue(value!) ? null : "Number invalid",
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: hintHeightType,
                        fillColor: Colors.red,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              new Flexible(
                  child: Column(
                //select date
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "${selectedDate.toLocal()}".split(' ')[0],
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  ElevatedButton(
                    onPressed: () => _selectDate(context), // Refer step 3
                    style: ElevatedButton.styleFrom(
                    primary: Colors.black,),
                    child: Text(
                      'Select birth date',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              )),
              new Flexible(
                child: //select gender
                    Column(
                  children: [
                    Text('Gender',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        )),
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
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 30), //space between items in column
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(
                onPressed: onPressedCancel,
                style: ElevatedButton.styleFrom(
                    primary: Colors.black, padding: EdgeInsets.all(10.0)),
                child: //calculate button
                    Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: onPressedCancel,
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
            ],
          ),
        ],
      ),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(1900),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        print(picked);
      });
  }

  void onPressedUpdate() {
    User user=new User(name: nameController.text, height: double.parse(heightController.text), birthDate: selectedDate,gender: selectedSex,metric: selectedMetricSystem);
    //de trimis catre bd si mesaj cu updated successfully
  }

  void onPressedCancel() {
    Navigator.pushAndRemoveUntil<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => Home(widget.user),
        ),
            (route) => false);
  }

  void fillFieldsFromDataBase() {
    setState(() {
      nameController.text = widget.user.name;
      selectedSex = widget.user.gender;
      selectedMetricSystem=widget.user.metric;
      selectedDate = widget.user.birthDate;
      if(selectedMetricSystem=='Metric'){
        heightController.text = widget.user.height.toString();
      }else{
        heightController.text = (double.parse(widget.user.height.toString())/2.54).toStringAsFixed(0).toString();
      }
    });
  }

  void updateHints() {
    if (selectedMetricSystem == 'Metric') {
      hintHeightType = 'Cm';
    } else if (selectedMetricSystem == 'Imperial') {
      hintHeightType = 'Inches';
    }
    heightController.text = '';
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

}
