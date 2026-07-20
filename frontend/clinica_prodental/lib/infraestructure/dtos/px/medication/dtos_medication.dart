class DtosMedication {
  final String nameMedication;
  final String? doseMedication;

  DtosMedication({required this.nameMedication, this.doseMedication});

  Map<String, dynamic> toJson() {
    return {
      "name_medication": nameMedication,
      "dose_medication": doseMedication,
    };
  }
}
