import 'package:clinica_prodental/domain/entities/entities.dart';

class CitaFormState {
  final PxEntity? px;
  final String? reasonDate;
  final DentistEntity? dentist;
  final DateTime? fechaAppointment;
  final String? hourDate;
  final String? price;
  final String? diagnosis;
  final String? observation;
 
  final bool? isReminder; 

  CitaFormState({
    this.px,
    this.reasonDate,
    this.fechaAppointment,
    this.hourDate,
    this.price,
    this.diagnosis,
    this.observation,
    this.dentist,

    this.isReminder = false,
  });

  CitaFormState copyWith({
    PxEntity? px,
    String? reasonDate,
    DentistEntity? dentist,
    DateTime? fechaAppointment,
    String? hourDate,
    String? price,
    String? diagnosis,
    String? observation,
   
    bool? isReminder
  }) {
    return CitaFormState(
      px: px ?? this.px,
      reasonDate: reasonDate ?? this.reasonDate,
      dentist: dentist ?? this.dentist,
      price: price ?? this.price,
      hourDate: hourDate ?? this.hourDate,
      diagnosis: diagnosis ?? this.diagnosis,
      observation: observation ?? this.observation,
      fechaAppointment: fechaAppointment ?? this.fechaAppointment,
      isReminder: isReminder ?? this.isReminder, 
    );
  }
}
