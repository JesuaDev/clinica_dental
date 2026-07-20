// To parse this JSON data, do

class DiseaseModelResponse {
  final int idDiseases;
  final String nameDiseases;
  final String? descriptionDiseases;
  final String? observationDiseases;

  DiseaseModelResponse({
    required this.idDiseases,
    required this.nameDiseases,
    this.descriptionDiseases,
    this.observationDiseases,
  });

  factory DiseaseModelResponse.fromJson(Map<String, dynamic> json) =>
      DiseaseModelResponse(
        idDiseases: json["id_diseases"],
        nameDiseases: json["name_diseases"] ?? " ",
        descriptionDiseases: json["description_diseases"] ?? " ",
        observationDiseases: json["observation_diseases"] ?? " ",
      );

  Map<String, dynamic> toJson() => {
    "id_diseases": idDiseases,
    "name_diseases": nameDiseases,
    "description_diseases": descriptionDiseases,
    "observation_diseases": observationDiseases,
  };
}
