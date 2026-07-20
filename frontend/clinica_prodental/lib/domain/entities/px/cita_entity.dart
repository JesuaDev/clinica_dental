import 'package:clinica_prodental/domain/entities/entities.dart';

class CitaEntity {
  final int idCita;
  final int? idPx;
  final String reasonDate;
  final String dateCita;
  final String hourCita;
  final String? status;
  final double? priceCita;
  final String? diagnosis;
  final String? observation;
  final int? idDentist;
  final PxEntity? px;

  const CitaEntity({
    required this.idCita,
    this.idPx,
    required this.reasonDate,
    required this.dateCita,
    required this.hourCita,
    this.priceCita,
    this.diagnosis,
    this.observation,
    this.idDentist,
    this.px,
    this.status,
  });
}
