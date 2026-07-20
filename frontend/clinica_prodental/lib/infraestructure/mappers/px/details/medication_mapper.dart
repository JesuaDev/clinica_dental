import 'package:clinica_prodental/domain/entities/px/additionals_px/medication_px_entity.dart';
import 'package:clinica_prodental/infraestructure/models/models.dart';

class MedicationMapper {
  static MedicationPxEntiy medicationToEntity(
    MedicationModelResponse medicationResponse,
  ) => MedicationPxEntiy(
    idMedication: medicationResponse.idMedication,
    nameMedication:
        medicationResponse.nameMedication.isNotEmpty &&
            medicationResponse.nameMedication != " "
        ? medicationResponse.nameMedication
        : "Medicación desconocida",
    doseMedication:
        medicationResponse.doseMedication != null &&
            medicationResponse.doseMedication!.isNotEmpty &&
            medicationResponse.doseMedication != " "
        ? medicationResponse.doseMedication
        : "No hay dosis para está medicación",
  );
}
