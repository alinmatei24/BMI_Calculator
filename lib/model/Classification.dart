import 'package:flutter/material.dart';
import 'DatabaseClient.dart';
import 'BmiHints.dart';

class Classification {
  int id;
  double? fromBmi;
  double? toBmi;
  String classification;
  Color classificationColor;

  Classification._(
      {required this.id,
      required this.fromBmi,
      required this.toBmi,
      required this.classification,
      required this.classificationColor});

  static Future<List<Classification>> getAllBmiClassifications() async {
    DatabaseClient databaseClient = await DatabaseClient.getDatabaseClient();
    try {
      List<Map> databaseResults = await databaseClient.getDatabase().rawQuery(
          'select id, from_bmi, to_bmi, classification, color from bmi_classifications');
      List<Classification> classifications = [];
      databaseResults.forEach((result) {
        Classification classification = new Classification._(
            id: result["id"],
            fromBmi: result["from_bmi"],
            toBmi: result["to_bmi"],
            classification: result["classification"],
            classificationColor: Color(int.parse(result["color"])));
        classifications.add(classification);
      });
      return classifications;
    } catch (e) {
      throw Exception(
          "Exception thrown while getting classifications: " + e.toString());
    }
  }

  static Future<Classification> getBmiClassification(double bmi) async {
    DatabaseClient databaseClient = await DatabaseClient.getDatabaseClient();
    try {
      List<Map> databaseResults = await databaseClient.getDatabase().rawQuery(
          'select id, from_bmi, to_bmi, classification, color from bmi_classifications where (? > from_bmi or from_bmi is null) and (? < to_bmi or to_bmi is null)',
          [bmi, bmi]);
      return new Classification._(
          id: databaseResults.first["id"],
          fromBmi: databaseResults.first["from_bmi"],
          toBmi: databaseResults.first["to_bmi"],
          classification: databaseResults.first["classification"],
          classificationColor:
              Color(int.parse(databaseResults.first["color"])));
    } catch (e) {
      throw Exception(
          "Exception thrown getting the classification: " + e.toString());
    }
  }

  String getExtraWeightInfo(double bmi, double userWeight, double userHeight,
      String selectedUnitSystem) {
    if (this.toBmi != null && bmi > this.toBmi!) {
      return _getWeightToLoseInfo(
          bmi, userWeight, userHeight, selectedUnitSystem);
    } else if (this.fromBmi != null && bmi < this.fromBmi!) {
      return _getWeightToGainInfo(
          bmi, userWeight, userHeight, selectedUnitSystem);
    } else {
      return 'You are here';
    }
  }

  String _getWeightToLoseInfo(double bmi, double userWeight, double userHeight,
      String selectedUnitSystem) {
    double calculatedBmi = bmi;
    double calculatedWeight = userWeight;
    while (calculatedBmi > this.toBmi!) {
      calculatedWeight -= 0.1;
      calculatedBmi = (calculatedWeight / userHeight / userHeight) *
          (selectedUnitSystem == 'Metric' ? 10000 : 703);
    }
    return ((userWeight) - calculatedWeight).toStringAsFixed(1) +
        ' ' +
        BmiHints.getWeightUnit(selectedUnitSystem) +
        ' to lose';
  }

  String _getWeightToGainInfo(double bmi, double userWeight, double userHeight,
      String selectedUnitSystem) {
    double calculatedBmi = bmi;
    double calculatedWeight = userWeight;
    while (calculatedBmi < this.fromBmi!) {
      calculatedWeight += 0.1;
      calculatedBmi = (calculatedWeight / userWeight / userWeight) *
          (selectedUnitSystem == 'Metric' ? 10000 : 703);
    }
    return (((userWeight) - calculatedWeight) * -1).toStringAsFixed(1) +
        ' ' +
        BmiHints.getWeightUnit(selectedUnitSystem) +
        ' to gain';
  }
}
