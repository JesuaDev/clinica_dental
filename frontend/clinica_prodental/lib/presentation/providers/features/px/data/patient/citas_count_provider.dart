import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clinica_prodental/presentation/providers/features/px/data/patient/cita_provider.dart';
import 'package:clinica_prodental/presentation/providers/features/px/data/state/patient/citas/appoitments_state.dart';

final appointmentsCount = Provider<AppoitmentsState>((ref) {
  final citasProv = ref.watch(citasProvider);
  int scheduled = 0;
  int complete = 0;
  int wait = 0;
  int cancel = 0;
  int postponed = 0;

  if (citasProv.citas != null && citasProv.citas!.isNotEmpty) {
    for (int i = 0; i < citasProv.citas!.length; i++) {
      final cita = citasProv.citas![i].status;
      switch (cita) {
        case "agendada":
          scheduled++;
          break;
        case "completado":
          complete++;
          break;

        case "pendiente":
          wait++;
          break;

        case "cancelado":
          cancel++;
          break;

        case "aplazado":
          postponed++;
          break;
      }
    }
  }

  return AppoitmentsState(
    scheduled: scheduled,
    complete: complete,
    wait: wait,
    cancel: cancel,
    postponed: postponed,
  );
});
