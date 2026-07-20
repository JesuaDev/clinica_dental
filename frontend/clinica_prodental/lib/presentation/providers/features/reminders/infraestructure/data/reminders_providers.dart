import 'package:clinica_prodental/presentation/providers/features/reminders/infraestructure/infraestructure/repository/calendar_repostiory_impl_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clinica_prodental/core/api/response_api.dart';
import 'package:clinica_prodental/presentation/providers/features/reminders/infraestructure/data/reminder_state.dart';
import 'package:clinica_prodental/domain/entities/entities.dart';
import 'package:clinica_prodental/infraestructure/dtos/dtos.dart';

final createReminderProvider =
    NotifierProvider<RemindersNotifier, ReminderState>(RemindersNotifier.new);

typedef GetReminder = Future<ResponseApi<List<CalendarEntity>>> Function();

class RemindersNotifier extends Notifier<ReminderState> {
  @override
  ReminderState build() => ReminderState();
  Future<void> postReminder(DtosReminder dtosReminder) async {
    try {
      const Duration minLoadingTime = Duration(milliseconds: 800);
      state = state.copyWith(isLoading: true, error: null);
      final DateTime start = DateTime.now();

      //? Hacer el post
      final repository = ref.read(calendarRepositoryImplProvider);
      final reminder = await repository.postReminder(dtosReminder);

      final Duration elapsed = DateTime.now().difference(start);
      if (elapsed < minLoadingTime) {
        await Future.delayed(minLoadingTime - elapsed);
      }

      state = state.copyWith(
        reminders: [reminder.data, ...state.reminders!],
        message: reminder.message,
      );
    } on ErrorEntity catch (err) {
      state = state.copyWith(isLoading: false, error: err);
    } catch (err) {
      state = state.copyWith(
        isLoading: false,
        error: ErrorEntity(
          status: 500,
          message: 'Error desconocido',
          details: '',
        ),
      );
    }
  }

  Future<void> getRemindersCalendar() async {
    try {
      state.copyWith(isLoading: true, error: null);
      const Duration minLoadingTime = Duration(milliseconds: 800);
      state = state.copyWith(isLoading: true, error: null);
      final DateTime start = DateTime.now();

      final repository = ref.read(calendarRepositoryImplProvider);
      final reminder = await repository.getReminder();

      final Duration elapsed = DateTime.now().difference(start);
      if (elapsed < minLoadingTime) {
        await Future.delayed(minLoadingTime - elapsed);
      }

      state = state.copyWith(reminders: reminder.data);
    } on ErrorEntity catch (err) {
      state = state.copyWith(isLoading: false, error: err);
    } catch (err) {
      state = state.copyWith(
        isLoading: false,
        error: ErrorEntity(
          status: 500,
          message: 'Error desconocido',
          details: '',
        ),
      );
    }
  }

  Future<void> getRemindersUpgcoming() async {
    try {
      state.copyWith(isLoading: true, error: null);
      const Duration minLoadingTime = Duration(milliseconds: 800);
      state = state.copyWith(isLoading: true, error: null);
      final DateTime start = DateTime.now();

      final repository = ref.read(calendarRepositoryImplProvider);
      final reminderUpcoming = await repository.getReminderUpComing();

      final Duration elapsed = DateTime.now().difference(start);
      if (elapsed < minLoadingTime) {
        await Future.delayed(minLoadingTime - elapsed);
      }

      state = state.copyWith(upcoming: reminderUpcoming.data);
    } on ErrorEntity catch (err) {
      state = state.copyWith(isLoading: false, error: err);
    } catch (err) {
      state = state.copyWith(
        isLoading: false,
        error: ErrorEntity(
          status: 500,
          message: 'Error desconocido',
          details: '',
        ),
      );
    }
  }
}
