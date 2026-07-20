import 'package:clinica_prodental/infraestructure/models/models.dart';

class ReminderModelResponse {
  final int idReminder;
  final String titleReminder;
  final String? descriptionReminder;
  final DateTime dateHourInit;
  final DateTime dateHourLimit;
  final ProfileResponse profile;
  final CitaModelResponse? cita;
  final PxModelResponse? px;
  final DentistModelResponse? dentist;

  ReminderModelResponse({
    required this.titleReminder,
    this.descriptionReminder,
    required this.dateHourInit,
    required this.dateHourLimit,
    required this.profile,
    required this.cita,
    required this.px,
    required this.dentist,
    required this.idReminder,
  });

  factory ReminderModelResponse.fromJson(Map<String, dynamic> json) =>
      ReminderModelResponse(
        idReminder: json['id_calendar'] ?? 0,
        titleReminder: json["title_reminder"] ?? ' ',
        descriptionReminder: json["description_reminder"] ?? ' ',
        dateHourInit: json["date_hour_init"] != null
            ? DateTime.parse((json["date_hour_init"]).toString()).toLocal()
            : DateTime.now(),
        dateHourLimit: json["date_hour_limit"] != null
            ? DateTime.parse((json["date_hour_limit"]).toString()).toLocal()
            : DateTime.now(),
        profile: ProfileResponse.fromJson(json["profile"] ?? {}),
        cita: CitaModelResponse.fromJson(json["cita"] ?? {}),
        px: PxModelResponse.fromJson(json["px"] ?? {}),
        dentist: DentistModelResponse.fromJson(json["dentist"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
    "id_calendar": idReminder,
    "title_reminder": titleReminder,
    "description_reminder": descriptionReminder,
    "date_hour_init": dateHourInit,
    "date_hour_limit": dateHourLimit,
    "profile": profile.toJson(),
    "cita": cita != null ? cita!.toJson() : {},
    "px": px != null ? px!.toJson() : {},
    "dentist": dentist != null ? dentist!.toJson() : {},
  };
}
