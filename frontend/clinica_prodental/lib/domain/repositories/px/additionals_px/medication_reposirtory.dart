import 'package:clinica_prodental/domain/entities/px/additionals_px/medication_px_entity.dart';
import 'package:clinica_prodental/core/api/response_api.dart';
import 'package:clinica_prodental/infraestructure/dtos/px/medication/dtos_medication.dart';

abstract class MedicationReposirtory {
  Future<ResponseApi<List<MedicationPxEntiy>>> getMedications();
  Future<ResponseApi<MedicationPxEntiy>> postMedication(DtosMedication dtos);
}
