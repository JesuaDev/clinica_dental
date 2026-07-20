import 'package:clinica_prodental/domain/entities/entities.dart';

class ReminderState {
  final bool isLoading;
  final ErrorEntity? error;
  final String? message;
  final List<CalendarEntity>? reminders;
  final List<CalendarEntity>? upcoming;

  ReminderState({
    this.isLoading = false,
    this.reminders = const [],
    this.error,
    this.message,
    this.upcoming = const [],
  });

  ReminderState copyWith({
    bool? isLoading,
    ErrorEntity? error,
    List<CalendarEntity>? reminders,
    List<CalendarEntity>? upcoming,
    String? message,
  }) {
    return ReminderState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      reminders: reminders ?? this.reminders,
      message: message,
      upcoming: upcoming ?? this.upcoming,
    );
  }
}
