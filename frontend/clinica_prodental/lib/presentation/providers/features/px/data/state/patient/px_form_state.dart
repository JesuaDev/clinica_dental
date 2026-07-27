import 'package:clinica_prodental/domain/entities/entities.dart';
import 'package:clinica_prodental/presentation/providers/features/px/data/state/patient/px_dental_record_form.dart';

class PxFormState {
  final String? names;
  final String? lastNames;
  final String? sex;
  final String? birthday;
  final String? phone;
  final String? direction;
  final List<AllergyEntity>? allergySelected;
  final List<MedicationPxEntiy>? medicationSelected;
  final List<DiseasesEntity>? diseasesSelected;
  final List<PxDentalRecordForm>? medicalRecord;

  PxFormState({
    this.names,
    this.lastNames,
    this.sex,
    this.birthday,
    this.phone,
    this.direction,
    this.allergySelected = const [],
    this.medicationSelected = const [],
    this.diseasesSelected = const [],
    this.medicalRecord = const [],
  });

  PxFormState copyWith({
    String? names,
    String? lastNames,
    String? sex,
    String? birthday,
    String? phone,
    String? direction,
    List<AllergyEntity>? allergySelected,
    List<MedicationPxEntiy>? medicationSelected,
    List<DiseasesEntity>? diseasesSelected,
    List<PxDentalRecordForm>? medicalRecord,
  }) {
    return PxFormState(
      names: names ?? this.names,
      lastNames: lastNames ?? this.lastNames,
      sex: sex ?? this.sex,
      birthday: birthday ?? this.birthday,
      phone: phone ?? this.phone,
      direction: direction ?? this.direction,
      allergySelected: allergySelected ?? this.allergySelected,
      medicationSelected: medicationSelected ?? this.medicationSelected,
      diseasesSelected: diseasesSelected ?? this.diseasesSelected,
      medicalRecord: medicalRecord ?? this.medicalRecord,
    );
  }
}
