import 'package:flutter/material.dart';
import 'package:proiect_bmi/view/RegisterUserScreen.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Welcome',
            style: TextStyle(
              fontSize: 32,
            ),
          ),
          centerTitle: true,
        ),
        body: Center(
            child: Column(
          children: [
            Text("Welcome, let\'s get started.."),
            Text(
                "Please choose the theme you'd like to use and fill out the form on the next page"),
            ElevatedButton(
                onPressed: () {
                  Navigator.push<dynamic>(
                      context,
                      MaterialPageRoute<dynamic>(
                          builder: (BuildContext context) =>
                              RegisterUserScreen(true)));
                },
                child: Icon(Icons.arrow_right))
          ],
        )));
  }
}
