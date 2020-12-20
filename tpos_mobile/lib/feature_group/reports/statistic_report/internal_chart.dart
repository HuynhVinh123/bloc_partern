double getInterval(double maxValue) {
  double value = 1;
  if (maxValue != null) {
    if (maxValue >= 10 && maxValue < 20) {
      value = 2;
    } else if (maxValue >= 20 && maxValue <= 30) {
      value = 5;
    } else if (maxValue > 30 && maxValue <= 100) {
      value = 10;
    } else if (maxValue > 100 && maxValue <= 200) {
      value = 20;
    } else if (maxValue > 200 && maxValue <= 500) {
      value = 50;
    } else if (maxValue > 500) {
      value = 100;
    } else {
      value = 1;
    }
  }
  return value;
}
