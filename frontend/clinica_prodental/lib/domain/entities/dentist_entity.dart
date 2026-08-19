class DentistEntity {
  final int idDentist;
  final String nameDentist;
  final String? lastNameDentist;
  final bool available;
  final String? phone;
  final int? age;
  final String? specialty;
  final String? email;
  final DateTime? birthdate;

  const DentistEntity({
    required this.idDentist,
    required this.nameDentist,
    this.lastNameDentist,
    required this.available,
    required this.phone,
    this.age,
    this.specialty,
    this.email,
    this.birthdate,
  });
}
