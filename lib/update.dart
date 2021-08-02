import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Update extends StatefulWidget {
  @override
  _UpdateState createState() => _UpdateState();
}

class _UpdateState extends State<Update> {
  DateTime selectedDate = DateTime.now();
  String selectedSex='Male';
  final nameController=TextEditingController();
  final heightController=TextEditingController();

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
      body: Column(//everything
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Align(
            alignment: Alignment.center,
            child:Text('Edit Profile',style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,)),
            ),
            SizedBox(height: 50),//space between items in column
            Align(
              alignment: Alignment.topLeft,
              child:Text('Name',style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,)),
            ),
            TextField(//name
              textAlign: TextAlign.center,
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'Name',
                fillColor: Colors.red,
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 30),//space between items in column
            Row(//the row with height, date and gender
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Flexible(child:
                Column(//height
                  children: <Widget>[
                    Text('Height',style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,)),
                    TextField(//Height
                      controller: heightController,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Height',
                        fillColor: Colors.red,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
                ),
                new Flexible(child:
                Column(//select date
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      "${selectedDate.toLocal()}".split(' ')[0],
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    RaisedButton(
                      onPressed: () => _selectDate(context), // Refer step 3
                      child: Text(
                        'Select birth date',
                        style:
                        TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      color: Colors.black,
                    ),
                  ],
                )
                ),
                new Flexible(child://select gender
                Column(
                  children: [
                    Text('Gender',style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,)),
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
            SizedBox(height: 30),//space between items in column
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(onPressed: onPressedCancel,
                  color: Colors.black,
                  padding: EdgeInsets.all(10.0),
                  child: //calculate button

                  Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white,)
                    ,),
                ),
                RaisedButton(onPressed: onPressedUpdate,
                  color: Colors.black,
                  padding: EdgeInsets.all(10.0),
                  child: //calculate button

                  Text(
                    'Update',
                    style: TextStyle(color: Colors.white,)
                    ,),
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
  void onPressedUpdate(){}
  void onPressedCancel(){}
}