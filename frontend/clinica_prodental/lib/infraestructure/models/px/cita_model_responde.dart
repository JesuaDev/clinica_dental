import 'package:clinica_prodental/infraestructure/models/models.dart';

class CitaModelResponse {
  final int idCita;
  final int? idPx;
  final int? idDentist;
  final String reasonDate;
  final String fechaCita;
  final String hourCita;
  final String? status;
  final double? priceCita;
  final String? diagnosis;
  final String? observation;
  final PxModelResponse? px;

  CitaModelResponse({
    required this.idCita,
    required this.reasonDate,
    required this.fechaCita,
    required this.hourCita,
    this.idPx,
    this.idDentist,
    this.priceCita,
    this.diagnosis,
    this.observation,
    this.px,
    this.status,
  });

  factory CitaModelResponse.fromJson(Map<String, dynamic> json) =>
      CitaModelResponse(
        idCita: json["id_cita"] ?? 0,
        idPx: json["id_px"] as int?,
        idDentist: json["id_dentist"] as int?,
        reasonDate: json["reason_date"] ?? ' ',
        fechaCita: json["fecha_cita"] ?? ' ',
        hourCita: json["hour_cita"] ?? ' ',
        priceCita: json['price_cita'] != null
            ? (json['price_cita'] as num).toDouble()
            : 0.0,
        diagnosis: json['diagnosis'] as String?,
        observation: json['observation'] as String?,
        px: PxModelResponse.fromJson(json['px'] ?? {}),
        status: json['status'] ?? ""
      );

  factory CitaModelResponse.empty() {
    return CitaModelResponse(
      idCita: 0,
      reasonDate: '',
      fechaCita: '',
      hourCita: '',
    );
  }
  Map<String, dynamic> toJson() => {
    "id_cita": idCita,
    "reason_date": reasonDate,
    "fecha_cita": fechaCita,
    "hour_cita": hourCita,
  };
}
