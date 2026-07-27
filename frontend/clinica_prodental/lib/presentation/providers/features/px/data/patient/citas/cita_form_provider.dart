
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

  void clearPatient() {
    state = CitaFormState(px: null);
    state = state.copyWith(px: null);
  }
}
