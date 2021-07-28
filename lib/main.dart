import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));

}


class Home extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'BMI Calculator',
          style: TextStyle(
            fontSize: 32,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        child: Row(
          children: <Widget>[
            Text('aaa  '),
          ],

        ),
        text: Text('bbb  '),
        color: Colors.white,
      ),
      backgroundColor: Colors.black,
    );

  }
}


