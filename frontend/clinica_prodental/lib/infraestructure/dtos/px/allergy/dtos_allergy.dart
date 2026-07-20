class DtosAllergy {
  final String nameAllergy;
  final String? descriptionAllergy;

  DtosAllergy({required this.nameAllergy, this.descriptionAllergy});

  Map<String, dynamic> toJson() {
    return {
      "name_allergy": nameAllergy,
      "description_allergy": descriptionAllergy,
    };
  }
}
