import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:proiect_bmi/main.dart';
import 'database.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  DateTime selectedDate = DateTime.now();
  String selectedSex = 'Male';

  final nameController = TextEditingController();
  final heightControler = TextEditingController();

  bool canPressContinue = true;
  bool loadingDuringRegister = false;

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
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Text('Name:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ))),
              new Flexible(
                child: TextField(
                  controller: nameController,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: 'Name',
                    fillColor: Colors.red,
                    border: OutlineInputBorder(),
                  ),
                ),
              )
            ],
          ),
          Row(
            children: [
              Text(
                'Birth date:',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              new Flexible(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "${selectedDate.toLocal()}".split(' ')[0],
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  ElevatedButton(
                    onPressed: () => _selectDate(context), // Refer step 3
                    child: Icon(Icons.edit),
                  ),
                ],
              ))
            ],
          ),
          Row(
            children: [
              Text('Height:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )),
              new Flexible(
                child: TextFormField(
                  controller: heightControler,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) =>
                      checkNumericValue(value!) ? null : "Numar invalid",
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: 'Height in centimeters',
                    fillColor: Colors.red,
                    border: OutlineInputBorder(),
                  ),
                ),
              )
            ],
          ),
          Row(
            children: [
              Text('Select your sex:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )),
              new Flexible(
                  child: DropdownButton<String>(
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
              ))
            ],
          ),
          ElevatedButton(
            onPressed: canPressContinue
                ? () async {
                    setState(() {
                      canPressContinue = false;
                      loadingDuringRegister = true;
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
            visible: loadingDuringRegister,
            child: Center(
              child: new CircularProgressIndicator(
                color: Colors.orange,
              ),
            ),
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
      });
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

  Future<bool> registerUser() async {
    await Future.delayed(Duration(seconds: 5));
    DBClient db = DBClient();
    try {
      await db.createDatabase();
      // de schimbat valoarea hardcodata 'Metric'
      await db.insertUser(nameController.text, selectedSex, selectedDate,
          double.parse(heightControler.text), 'Metric');
      return true;
    } catch (e) {
      print("Error during user registration: " + e.toString());
      return false;
    }
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

  void onPressedContinue() async {
    //create user in db
    bool registration = await registerUser();
    if (registration) {
      showToast("Registration complete", Colors.green.shade300, Colors.white);
      //create user object

      //pass user obj to home
      Navigator.pushAndRemoveUntil<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => Home(nameController.text),
          ),
          (route) => false);
    } else {
      showToast("An error occured during user registration. Please try again.",
          Colors.red.shade300, Colors.white);
      setState(() {
        canPressContinue = true;
        loadingDuringRegister = false;
      });
    }
  }
}
