import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clinica_prodental/domain/entities/entities.dart';
import 'package:clinica_prodental/presentation/providers/features/px/data/state/patient/px_form_state.dart';
import 'package:clinica_prodental/presentation/providers/features/px/data/state/patient/px_dental_record_form.dart';

final addDataPxInput = NotifierProvider<AddDataNotifier, PxFormState>(
  AddDataNotifier.new,
);

class AddDataNotifier extends Notifier<PxFormState> {
  @override
  build() => PxFormState();

  void clearForm() => PxFormState();

  void updateNamesPx(String value) {
    debugPrint(value); 
    state = state.copyWith(names: value);
  }

  void updateLastNamesPx(String value) {
    state = state.copyWith(lastNames: value);
  }

  void updateSexPx(String value) {
    state = state.copyWith(sex: value);
  }

  void updateBirthday(String value) {
    state = state.copyWith(birthday: value);
  }

  void updatePhone(String value) {
    state = state.copyWith(phone: value);
  }

  void updateDirection(String value) {
    state = state.copyWith(direction: value);
  }

  void updateIdsAllergy(List<AllergyEntity> value) {
    final items = value.length < state.allergySelected!.length
        ? value
        : [...state.allergySelected!, ...value];

    state = state.copyWith(allergySelected: items.toSet().toList());
  }

  void updateIdsMedication(List<MedicationPxEntiy> value) {
    state = state.copyWith(medicationSelected: value);
  }

  void updateIdsDiseases(List<DiseasesEntity> value) {
    state = state.copyWith(diseasesSelected: value);
  }

  void updateMedicalRecord(List<PxDentalRecordForm> value) {
    /*     final records = value.length < state.medicalRecord!.length
        ? value
        : [...state.medicalRecord!, value];
 */

    state = state.copyWith(medicalRecord: value);
  }
}
