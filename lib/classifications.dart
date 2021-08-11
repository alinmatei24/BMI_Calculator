import 'package:proiect_bmi/utils.dart';

String getBmiResult(double? bmi) {
  if (bmi! < 18.5) {
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

String getClassification(double? bmi, double userWeight, double userHeight,
    String selectedUnitSystem) {
  return 'Underweight: 18.5 and under --> ' +
      toUnderweight(bmi, userWeight, userHeight, selectedUnitSystem) +
      '\n'
          'Normal Weight:18.6 24.9 --> ' +
      toNormalWeight(bmi, userWeight, userHeight, selectedUnitSystem) +
      '\n'
          'Overweight: 25-29.9 -->  ' +
      toOverWeight(bmi, userWeight, userHeight, selectedUnitSystem) +
      '\n'
          'Class I Obese:30-34.9 -->  ' +
      toClassIObese(bmi, userWeight, userHeight, selectedUnitSystem) +
      '\n'
          'Class II Obese:35-39.9 -->  ' +
      toClassIIObese(bmi, userWeight, userHeight, selectedUnitSystem) +
      '\n'
          'Class III Obese:40 and above -->  ' +
      toClassIIIObese(bmi, userWeight, userHeight, selectedUnitSystem);
}

String toUnderweight(double? bmi, double userWeight, double userHeight,
    String selectedUnitSystem) {
  double a = bmi!;
  double height = userHeight;
  double weight = userWeight;
  if (a >= 18.5) {
    while (a >= 18.5) {
      weight -= 0.1;
      a = (weight / height / height) *
          (selectedUnitSystem == 'Metric' ? 10000 : 703);
    }
    return ((userWeight) - weight).toStringAsFixed(1) +
        ' ' +
        getWeightUnit(selectedUnitSystem) +
        ' to lose';
  } else {
    return 'You are here';
  }
}

String toNormalWeight(double? bmi, double userWeight, double userHeight,
    String selectedUnitSystem) {
  double a = bmi!;
  double height = userHeight;
  double weight = userWeight;
  if (a > 24.9) {
    while (a > 24.9) {
      weight -= 0.1;
      a = (weight / height / height) *
          (selectedUnitSystem == 'Metric' ? 10000 : 703);
    }
    return ((userWeight) - weight).toStringAsFixed(1) +
        ' ' +
        getWeightUnit(selectedUnitSystem) +
        ' to lose';
  } else if (a < 18.5) {
    while (a < 18.5) {
      weight += 0.1;
      a = (weight / height / height) *
          (selectedUnitSystem == 'Metric' ? 10000 : 703);
    }
    return (((userWeight) - weight) * -1).toStringAsFixed(1) +
        ' ' +
        getWeightUnit(selectedUnitSystem) +
        ' to gain';
  } else {
    return 'You are here';
  }
}

String toOverWeight(double? bmi, double userWeight, double userHeight,
    String selectedUnitSystem) {
  double a = bmi!;
  double height = userHeight;
  double weight = userWeight;
  if (a > 29.9) {
    while (a > 29.9) {
      weight -= 0.1;
      a = (weight / height / height) *
          (selectedUnitSystem == 'Metric' ? 10000 : 703);
    }
    return ((userWeight) - weight).toStringAsFixed(1) +
        ' ' +
        getWeightUnit(selectedUnitSystem) +
        ' to lose';
  } else if (a < 25) {
    while (a < 25) {
      weight += 0.1;
      a = (weight / height / height) *
          (selectedUnitSystem == 'Metric' ? 10000 : 703);
    }
    return (((userWeight) - weight) * -1).toStringAsFixed(1) +
        ' ' +
        getWeightUnit(selectedUnitSystem) +
        ' to gain';
  } else {
    return 'You are here';
  }
}

String toClassIObese(double? bmi, double userWeight, double userHeight,
    String selectedUnitSystem) {
  double a = bmi!;
  double height = userHeight;
  double weight = userWeight;
  if (a > 34.9) {
    while (a > 34.9) {
      weight -= 0.1;
      a = (weight / height / height) *
          (selectedUnitSystem == 'Metric' ? 10000 : 703);
    }
    return ((userWeight) - weight).toStringAsFixed(1) +
        ' ' +
        getWeightUnit(selectedUnitSystem) +
        ' to lose';
  } else if (a < 30) {
    while (a < 30) {
      weight += 0.1;
      a = (weight / height / height) *
          (selectedUnitSystem == 'Metric' ? 10000 : 703);
    }
    return (((userWeight) - weight) * -1).toStringAsFixed(1) +
        ' ' +
        getWeightUnit(selectedUnitSystem) +
        ' to gain';
  } else {
    return 'You are here';
  }
}

String toClassIIObese(double? bmi, double userWeight, double userHeight,
    String selectedUnitSystem) {
  double a = bmi!;
  double height = userHeight;
  double weight = userWeight;
  if (a > 39.9) {
    while (a > 39.9) {
      weight -= 0.1;
      a = (weight / height / height) *
          (selectedUnitSystem == 'Metric' ? 10000 : 703);
    }
    return ((userWeight) - weight).toStringAsFixed(1) +
        ' ' +
        getWeightUnit(selectedUnitSystem) +
        ' to lose';
  } else if (a < 35) {
    while (a < 35) {
      weight += 0.1;
      a = (weight / height / height) *
          (selectedUnitSystem == 'Metric' ? 10000 : 703);
    }
    return (((userWeight) - weight) * -1).toStringAsFixed(1) +
        ' ' +
        getWeightUnit(selectedUnitSystem) +
        ' to gain';
  } else {
    return 'You are here';
  }
}

String toClassIIIObese(double? bmi, double userWeight, double userHeight,
    String selectedUnitSystem) {
  double a = bmi!;
  double height = userHeight;
  double weight = userWeight;
  if (a >= 40) {
    return 'You are here';
  } else {
    while (a < 40) {
      weight += 0.1;
      a = (weight / height / height) *
          (selectedUnitSystem == 'Metric' ? 10000 : 703);
    }
    return (((userWeight) - weight) * -1).toStringAsFixed(1) +
        ' ' +
        getWeightUnit(selectedUnitSystem) +
        ' to gain';
  }
}
