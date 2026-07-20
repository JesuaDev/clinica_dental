import 'package:clinica_prodental/core/api/response_api.dart';
import 'package:clinica_prodental/domain/entities/px/px_entity.dart';
import 'package:clinica_prodental/infraestructure/dtos/px/patient/patient_dtos.dart';

abstract class PxDatasource {
  Future<ResponseApi<List<PxEntity>>> getPatients({int page = 1});

  Future<ResponseApi<PxEntity>> postPatients(PatientDtos dtos);
}
