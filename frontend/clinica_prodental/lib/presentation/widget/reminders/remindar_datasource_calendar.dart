import 'package:clinica_prodental/domain/entities/entities.dart';

import 'package:syncfusion_flutter_calendar/calendar.dart';

class ReminderDataSourceCalendar extends CalendarDataSource {
  ReminderDataSourceCalendar(List<CalendarEntity> reminders) {
    update(reminders);
  }

  void update(List<CalendarEntity> reminders) {
    appointments = reminders.expand(_buildAppointments).toList();

    notifyListeners(CalendarDataSourceAction.reset, appointments!);
  }

  List<Appointment> _buildAppointments(CalendarEntity reminder) {
    if (_isSameDay(reminder.dateInit, reminder.dateLimit)) {
      return [_appointment(reminder, reminder.dateInit, reminder.dateLimit)];
    }

    final List<Appointment> list = [];

    DateTime current = reminder.dateInit;

    while (!_isSameDay(current, reminder.dateLimit)) {
      list.add(
        _appointment(
          reminder,
          current,
          DateTime(current.year, current.month, current.day, 23, 59, 59),
        ),
      );

      current = DateTime(current.year, current.month, current.day + 1);
    }

    list.add(
      _appointment(
        reminder,
        DateTime(
          reminder.dateLimit.year,
          reminder.dateLimit.month,
          reminder.dateLimit.day,
        ),
        reminder.dateLimit,
      ),
    );

    return list;
  }

  Appointment _appointment(
    CalendarEntity reminder,
    DateTime start,
    DateTime end,
  ) {
    return Appointment(
      startTime: start,
      endTime: end,
      subject: reminder.titleReminder,
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
