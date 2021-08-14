class BmiHints {
  static String getHeightUnit(String unitSystem) {
    return unitSystem == 'Metric' ? 'cm' : 'inches';
  }

  static String getWeightUnit(String unitSystem) {
    return unitSystem == 'Metric' ? 'kg' : 'lbs';
  }
}
