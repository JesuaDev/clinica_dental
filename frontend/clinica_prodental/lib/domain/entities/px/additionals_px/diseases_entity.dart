class DiseasesEntity {
  final int idDiaseases;
  final String nameDiseases;
  final String? descriptionDiseases;
  final String? observationDiseases;

  DiseasesEntity({
    required this.idDiaseases,
    required this.nameDiseases,
    this.descriptionDiseases,
    this.observationDiseases,
  });
}
