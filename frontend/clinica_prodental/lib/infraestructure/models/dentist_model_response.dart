class DentistModelResponse {
  final int idDentist;
  final String nameDentist;
  final String? lastName;
  final bool available;

  DentistModelResponse({
    required this.idDentist,
    required this.nameDentist,
    this.lastName,
    required this.available,
  });

  factory DentistModelResponse.fromJson(Map<String, dynamic> json) =>
      DentistModelResponse(
        idDentist: json["id_dentist"] ?? 0,
        nameDentist: json["name_dentist"] ?? ' ',
        lastName: json["last_name"] as String?,
        available: json["available"] ?? false,
      );

  factory DentistModelResponse.empty() {
    return DentistModelResponse(
      idDentist: 0,
      nameDentist: '',
      available: false,
    );
  }
  Map<String, dynamic> toJson() => {
    "id_dentist": idDentist,
    "name_dentist": nameDentist,
    "last_name": lastName,
    "available": available,
  };
}
