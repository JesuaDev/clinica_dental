class DentalRecordEntity {
  final int idDentRecord;
  final String recordDental;
  final String? descriptionRecord;

  DentalRecordEntity({
    required this.idDentRecord,
    required this.recordDental,
    this.descriptionRecord,
  });
}
