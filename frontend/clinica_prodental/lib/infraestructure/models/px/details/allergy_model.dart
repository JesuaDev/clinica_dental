class AllergyResponse {
  final int idAllergy;
  final String nameAllergy;
  final String? descriptionAllergy;

  AllergyResponse({
    required this.idAllergy,
    required this.nameAllergy,
    this.descriptionAllergy,
  });

  factory AllergyResponse.fromJson(Map<String, dynamic> json) =>
      AllergyResponse(
        idAllergy: json["id_allergy"],
        nameAllergy: json["name_allergy"] ?? " ",
        descriptionAllergy: json["description_allergy"] ?? " ",
      );

  Map<String, dynamic> toJson() => {
    "id_allergy": idAllergy,
    "name_allergy": nameAllergy,
    "description_allergy": descriptionAllergy,
  };
}
