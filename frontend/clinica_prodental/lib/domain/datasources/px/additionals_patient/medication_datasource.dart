import 'package:clinica_prodental/core/api/response_api.dart';
import 'package:clinica_prodental/domain/entities/entities.dart';
import 'package:clinica_prodental/infraestructure/dtos/px/medication/dtos_medication.dart';

abstract class MedicationDatasource {
  Future<ResponseApi<List<MedicationPxEntiy>>> getMedications();
  Future<ResponseApi<MedicationPxEntiy>> postMedication(DtosMedication dtos);
}
