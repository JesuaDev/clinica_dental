import 'package:intl/intl.dart';

class DateFormater {
  static DateTime combineDateAndHour(DateTime date, String hour) {
    final parts = hour.split(':');

    final int h = int.parse(parts[0]);
    final int m = int.parse(parts[1]);

    return DateTime(date.year, date.month, date.day, h, m);
  }

  static String parseDate(DateTime date) {
    return "${date.year.toString().padLeft(4, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.day.toString().padLeft(2, '0')}";
  }

  static String formatDateHour(DateTime date) {
    return "${DateFormat.MMMd().format(date)} / ${DateFormat.Hm().format(date)}";
  }
}
