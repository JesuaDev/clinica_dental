class DtosReminder {
  final String titleReminder;
  final String descriptionReminder;
  final String dateInit;
  final String dateLimit;
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
      "date_init": dateInit,
      "date_limit": dateLimit,
      "id_user": idUser,
      "id_cita": idCita,
      "id_dentist": idDentist,
    };
  }
}
