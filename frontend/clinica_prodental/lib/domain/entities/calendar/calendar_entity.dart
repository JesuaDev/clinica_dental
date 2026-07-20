import 'package:clinica_prodental/domain/entities/entities.dart';

class CalendarEntity {
  final int idCalendar;
  final String titleReminder;
  final String? descriptionReminder;
  final DateTime dateInit;
  final DateTime dateLimit;
  final ProfileEntity? profile;
  final DentistEntity? dentistEntity;
  final CitaEntity? citaEntity;
  final PxEntity? pxEntity;

  const CalendarEntity({
    required this.idCalendar,
    required this.titleReminder,
    this.descriptionReminder,
    required this.dateInit,
    required this.dateLimit,
    this.dentistEntity,
    this.citaEntity,
    this.pxEntity,
    this.profile,
  });
}
