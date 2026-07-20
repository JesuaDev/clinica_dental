class DtosDiseases {
  final String nameDisease;
  final String? descriptionDisease;
  final String? observationDisease;

  DtosDiseases({
    required this.nameDisease,
    this.descriptionDisease,
    this.observationDisease,
  });

  Map<String, dynamic> toJson() {
    return {
      "name_diseases": nameDisease,
      "description_diseases": descriptionDisease,
      "observation_diseases": observationDisease,
    };
  }
}
