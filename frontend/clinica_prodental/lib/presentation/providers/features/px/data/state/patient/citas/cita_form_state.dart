import 'package:clinica_prodental/domain/entities/entities.dart';

class CitaFormState {
  final PxEntity? px;
  final String? reasonDate;
  final int? idDentist;
  final DateTime? fechaAppointment;
  final String? hourDate;
  final double? price;
  final String? diagnosis;
  final String? observation;

  CitaFormState({
    this.px,
    this.reasonDate,
    this.idDentist,
    this.fechaAppointment,
    this.hourDate,
    this.price,
    this.diagnosis,
    this.observation,
  });

  CitaFormState copyWith({
    PxEntity? px,
    String? reasonDate,
    int? idDentist,
    DateTime? fechaAppointment,
    String? hourDate,
    double? price,
    String? diagnosis,
    String? observation,
  }) {
    return CitaFormState(
      px: px ?? this.px,
      reasonDate: reasonDate ?? this.reasonDate,
      idDentist: idDentist ?? this.idDentist,
      hourDate: hourDate ?? this.hourDate,
      diagnosis: diagnosis ?? this.diagnosis,
      observation: observation ?? this.observation,
    );
  }
}
