import 'package:clinica_prodental/infraestructure/mappers/mappers.dart';
import 'package:clinica_prodental/domain/entities/calendar/calendar_entity.dart';
import 'package:clinica_prodental/infraestructure/models/calendar/calendar_model.dart';

class CalendarMapper {
  static CalendarEntity calendarToEntity(
    ReminderModelResponse reminderResponse,
  ) => CalendarEntity(
    idCalendar: reminderResponse.idReminder,
    titleReminder: reminderResponse.titleReminder,
    descriptionReminder:
        reminderResponse.descriptionReminder != null &&
            reminderResponse.descriptionReminder.toString().isNotEmpty &&
            reminderResponse.descriptionReminder != ' '
        ? reminderResponse.descriptionReminder
        : 'No hay descripción de la nota',
    dateInit: reminderResponse.dateHourInit,
    dateLimit: reminderResponse.dateHourLimit,
    profile: ProfileMapper.toEntityProfile(reminderResponse.profile),
    dentistEntity: reminderResponse.dentist != null
        ? DentistMapper.dentistToEntity(reminderResponse.dentist!)
        : null,
    citaEntity: reminderResponse.cita != null
        ? CitaMapper.citaToEntity(reminderResponse.cita!)
        : null,
    pxEntity: reminderResponse.px != null
        ? PxMapper.pxToEntity(reminderResponse.px!)
        : null,
  );
}
