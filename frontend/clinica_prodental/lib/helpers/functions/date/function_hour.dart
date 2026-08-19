class FunctionHour {
  static List<String> addHours() {
    List<String> listHours = [];

    listHours.clear();

    for (int hour = 7; hour <= 21; hour++) {
      for (int min = 0; min < 60; min += 30) {
        String hourFormat = hour.toString().padLeft(2, '0');
        String minFormat = min.toString().padLeft(2, '0');

        listHours.add('$hourFormat:$minFormat');
      }
    }

    return listHours;
  }
}
