class AllergyEntity {
  final int idAllergy;
  final String nameAllergy;
  final String? descriptionAllergy;

  AllergyEntity({
    required this.idAllergy,
    required this.nameAllergy,
    this.descriptionAllergy,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AllergyEntity &&
          runtimeType == other.runtimeType &&
          idAllergy == other.idAllergy;

  @override
  int get hashCode => idAllergy.hashCode;
}
