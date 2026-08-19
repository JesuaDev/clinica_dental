class DentistModelResponse {
  final int idDentist;
  final String nameDentist;
  final String? lastNameDentist;
  final bool available;
  final String? phone;
  final int? age;
  final String? specialty;
  final String? email;
  final DateTime? birthdate;

  DentistModelResponse({
    required this.idDentist,
    required this.nameDentist,
 
    required this.available,
    this.lastNameDentist,
    required this.phone,
    this.age,
    this.specialty,
    this.email,
    this.birthdate,
  });

  factory DentistModelResponse.fromJson(Map<String, dynamic> json) =>
      DentistModelResponse(
        idDentist: json["id_dentist"] ?? 0,
        nameDentist: json["name_dentist"] ?? ' ',
        lastNameDentist: json["last_name"] as String?,
        available: json["available"] ?? false, 
        phone: json["phone_dentist"] ?? '',
        age: json["age"] ?? 0,
        specialty: json["specialty"] ?? '',
        email: json["email"] ?? '',
        birthdate: json["birthdate"]
      );

  factory DentistModelResponse.empty() {
    return DentistModelResponse(
      idDentist: 0,
      nameDentist: '',
      available: false,
      phone: '',
    );
  }
  Map<String, dynamic> toJson() => {
    "id_dentist": idDentist,
    "name_dentist": nameDentist,
    "last_name": lastNameDentist,
    "available": available,
  };
}
