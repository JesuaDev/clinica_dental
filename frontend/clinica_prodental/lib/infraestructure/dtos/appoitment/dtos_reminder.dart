class DtosReminder {
  final String titleReminder;
  final String descriptionReminder;
  final DateTime dateInit;
  final DateTime dateLimit;
  final int idUser;
  final int? idCita;
  final int? idDentist;

  const DtosReminder({
    required this.titleReminder,
    required this.descriptionReminder,
    required this.dateInit,
    required this.dateLimit,
    required this.idUser,
    this.idCita,
    this.idDentist,
  });

  Map<String, dynamic> toJson() {
    return {
      "title_reminder": titleReminder,
      "description_reminder": descriptionReminder,
      "date_init": dateInit.toIso8601String(),
      "date_limit": dateLimit.toIso8601String(),
      "id_user": idUser,
      "id_cita": idCita,
      "id_dentist": idDentist,
    };
  }
}
