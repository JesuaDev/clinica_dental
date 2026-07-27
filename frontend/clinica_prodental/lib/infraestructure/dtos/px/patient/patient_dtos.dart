import 'package:clinica_prodental/helpers/format/date/combinate_date.dart';
import 'package:clinica_prodental/presentation/providers/features/px/data/state/patient/px_dental_record_form.dart';

class PatientDtos {
  final String names;
  final String? lastNames;
  final String? sex;
  final String? birthdate;
  final String phone;
  final String? direction;
  final List<int>? allergys;
  final List<int>? diseases;
  final List<int>? medications;
  final List<PxDentalRecordForm>? medicalRecord;

  PatientDtos({
    required this.names,
    this.lastNames,
    this.sex,
    required this.birthdate,
    required this.phone,
    this.direction,
    this.allergys = const [],
    this.diseases = const [],
    this.medications = const [],
    this.medicalRecord = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      "name_px": names,
      "last_name_px": lastNames,
      "sex_px": sex,
      "birthdate_px": birthdate,
      "phone_px": phone,
      "direction_px": direction,
      "allergys_px": allergys,
      "medication_px": medications,
      "diseases_px": diseases,
      "medical_record_px": medicalRecord != null && medicalRecord!.isNotEmpty
          ? medicalRecord!.map((e) => e.toJson())
          : [],
    };
  }
}
