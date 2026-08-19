import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clinica_prodental/domain/entities/entities.dart';
import 'package:clinica_prodental/presentation/providers/features/px/data/state/patient/citas/cita_form_state.dart';

final citaFormProvider = NotifierProvider<CitaFormNotifier, CitaFormState>(
  CitaFormNotifier.new,
);

class CitaFormNotifier extends Notifier<CitaFormState> {
  @override
  CitaFormState build() => CitaFormState();

  void updatePatient(PxEntity px) {
    state = state.copyWith(px: px);
  }

  void updateDentist(DentistEntity dentist) {
    state = state.copyWith(dentist: dentist);
  }

  void updateReasonDate(String reason) {
    state = state.copyWith(reasonDate: reason);
    debugPrint(reason);
  }

  void updateDate(DateTime date) {
    state = state.copyWith(fechaAppointment: date);
  }

  void updateHour(String? hour) {
    state = state.copyWith(hourDate: hour);
  }

  void updatePrice(String price) {
    state = state.copyWith(price: price);
  }

  void updateObservation(String observation) {
    state = state.copyWith(observation: observation);
  }

  void updateDiagnosis(String diagnosis) {
    state = state.copyWith(diagnosis: diagnosis);
  }

  void updateIsReminder(bool isReminder) {
    state = state.copyWith(isReminder: isReminder);
  }

  //? CLEAR
  //? Clear selected result (Search)
  void clearPatient() {
    state = CitaFormState(px: null);
    state = state.copyWith(px: null);
  }

  void clearDentist() {
    state = CitaFormState(dentist: null);
    state = state.copyWith(dentist: null);
  }

  void clearForm() {
    state = CitaFormState(
      px: null,
      reasonDate: null,
      fechaAppointment: null,
      hourDate: null,
      price: null,
      diagnosis: null,
      observation: null,
      dentist: null,
      isReminder: null,
    );
  }
}
