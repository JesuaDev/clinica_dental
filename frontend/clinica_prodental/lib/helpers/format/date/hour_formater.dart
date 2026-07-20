import 'package:intl/intl.dart';

class HourFormater {
  static String hourAmPm(String hour) {
    final time = DateFormat("HH:mm").parse(hour);

    final String formatted = DateFormat("hh:mm a").format(time);

    return formatted;
  }
}
