class DentistEntity {
  final int idDentist;
  final String nameDentist;
  final String? lastNameDentist;
  final bool available;

  const DentistEntity({
    required this.idDentist,
    required this.nameDentist,
    this.lastNameDentist,
    required this.available,
  });
}
