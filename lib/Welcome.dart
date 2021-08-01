import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}



class _WelcomeState extends State<Welcome> {
  DateTime selectedDate = DateTime.now();

  String selectedSex='Male';

  int _value = 1;

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
          Text('Welcome, let\'s set things up\n',style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,),),
          Row(
            children: [
              Text('    Name    ',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,)),
              new Flexible(child:

              TextField(
                decoration: InputDecoration(
                  hintText: 'maai',
                  fillColor: Colors.red,
                  border: OutlineInputBorder(),
                ),
              ),
              )
            ],
          ),
          Row(
            children: [
              Text('Birth date    \n',style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,),),
              new Flexible(child:
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "${selectedDate.toLocal()}".split(' ')[0],
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  RaisedButton(
                    onPressed: () => _selectDate(context), // Refer step 3
                    child: Text(
                      'Select date',
                      style:
                      TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    color: Colors.black,
                  ),
                ],
              )
              )
            ],
          ),
          Row(
            children: [
              Text('    Height    ',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,)),
              new Flexible(child:
              TextField(
                decoration: InputDecoration(
                  hintText: 'Height in meters',
                  fillColor: Colors.red,
                  border: OutlineInputBorder(),
                ),
              ),
              )
            ],
          ),
          Row(
            children: [
              Text('    Select your sex    ',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,)),
              new Flexible(child:
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
              )
              )
            ],
          ),
          RaisedButton(onPressed: onPressed,color: Colors.black,padding: EdgeInsets.all(10.0), child:

          Text(
            'Continue',
            style: TextStyle(color: Colors.white,  )
            ,),
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
      lastDate: DateTime(2000),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }
  void onPressed(){}
}