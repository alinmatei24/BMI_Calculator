import 'package:flutter/material.dart';
import 'package:proiect_bmi/model/User.dart';
import 'package:proiect_bmi/view/HomeScreen.dart';
import 'package:proiect_bmi/view/WelcomeScreen.dart';

void main() {
  runApp(MaterialApp(
    home: StartScreen(),
  ));
}

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  Future goToHomeOrWelcomeScreen() async {
    try {
      User connectedUser = await User.getDefaultUser();
      Navigator.pushAndRemoveUntil<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => HomeScreen(connectedUser),
          ),
          (route) => false);
    } catch (e) {
      Navigator.pushAndRemoveUntil<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => WelcomeScreen(),
          ),
          (route) => false);
    }
  }

  @override
  void initState() {
    goToHomeOrWelcomeScreen();
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
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.orange,
          ),
        ));
  }
}
