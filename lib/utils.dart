import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

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

double fromCmToInch(double cm) {
  return 2;
}

double fromInchToCm(double inch) {
  return 2;
}

double fromLbsToKg(double lbs) {
  return 2;
}

double fromKgToLbs(double kg) {
  return 2;
}

double convertWeight(double weight, String newSystem) {
  return newSystem == 'Metric' ? fromLbsToKg(weight) : fromKgToLbs(weight);
}

double convertHeight(double height, String newSystem) {
  // (widget.user.height / 2.54).toStringAsFixed(0).toString();
  return newSystem == 'Metric' ? fromInchToCm(height) : fromCmToInch(height);
}

String getHeightUnit(String unitSystem) {
  return unitSystem == 'Metric' ? 'cm' : 'inches';
}

String getWeightUnit(String unitSystem) {
  return unitSystem == 'Metric' ? 'kg' : 'lbs';
}

double calculateBmi(double weight, double height, String selectedUnitSystem) {
  return (weight / height / height) *
      (selectedUnitSystem == 'Metric' ? 10000 : 703);
}
