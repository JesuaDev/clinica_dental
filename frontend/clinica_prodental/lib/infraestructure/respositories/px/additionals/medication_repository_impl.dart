import 'package:clinica_prodental/core/api/response_api.dart';
import 'package:clinica_prodental/domain/entities/px/additionals_px/medication_px_entity.dart';
import 'package:clinica_prodental/domain/repositories/px/additionals_px/medication_reposirtory.dart';
import 'package:clinica_prodental/infraestructure/datasources/px/additionals/medication_datasource_impl.dart';
import 'package:clinica_prodental/infraestructure/dtos/px/medication/dtos_medication.dart';

class MedicationRepositoryImpl extends MedicationReposirtory {
  final MedicationDatasourceImpl datasourceImpl;

  MedicationRepositoryImpl({required this.datasourceImpl});

  @override
  Future<ResponseApi<List<MedicationPxEntiy>>> getMedications() {
    return datasourceImpl.getMedications();
  }

  @override
  Future<ResponseApi<MedicationPxEntiy>> postMedication(DtosMedication dtos) {
    return datasourceImpl.postMedication(dtos);
  }
}
