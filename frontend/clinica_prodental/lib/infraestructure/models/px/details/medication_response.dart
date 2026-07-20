class MedicationModelResponse {
  final int idMedication;
  final String nameMedication;
  final String? doseMedication;

  MedicationModelResponse({
    required this.idMedication,
    required this.nameMedication,
    this.doseMedication,
  });

  factory MedicationModelResponse.fromJson(Map<String, dynamic> json) =>
      MedicationModelResponse(
        idMedication: json["id_medication"],
        nameMedication: json["name_medication"] ?? " ",
        doseMedication: json["dose_medication"] ?? " ",
      );

  Map<String, dynamic> toJson() => {
    "id_medication": idMedication,
    "name_medication": nameMedication,
    "dose_medication": doseMedication,
  };
}
