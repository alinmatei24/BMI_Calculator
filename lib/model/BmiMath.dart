class BmiMath {
  static bool checkNumericValue(String string) {
    if (string.isEmpty) {
      return true;
    }
    final number = num.tryParse(string);
    if (number == null || number <= 0) {
      return false;
    }
    return true;
  }

  static double fromCmToInch(double cm) {
    return 2;
  }

  static double fromInchToCm(double inch) {
    return 2;
  }

  static double fromLbsToKg(double lbs) {
    return 2;
  }

  static double fromKgToLbs(double kg) {
    return 2;
  }

  static double convertWeightToSystem(double weight, String newSystem) {
    return newSystem == 'Metric' ? fromLbsToKg(weight) : fromKgToLbs(weight);
  }

  static double convertHeightToSystem(double height, String newSystem) {
    // (widget.user.height / 2.54).toStringAsFixed(0).toString();
    return newSystem == 'Metric' ? fromInchToCm(height) : fromCmToInch(height);
  }

  static double calculateBmi(
      double weight, double height, String selectedUnitSystem) {
    return (weight / height / height) *
        (selectedUnitSystem == 'Metric' ? 10000 : 703);
  }
}
