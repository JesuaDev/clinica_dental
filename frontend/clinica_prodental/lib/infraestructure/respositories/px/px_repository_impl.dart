import 'package:clinica_prodental/core/api/response_api.dart';

import 'package:clinica_prodental/domain/entities/px/px_entity.dart';
import 'package:clinica_prodental/domain/repositories/px/px_repository.dart';
import 'package:clinica_prodental/infraestructure/datasources/px/px_datasource_impl.dart';
import 'package:clinica_prodental/infraestructure/dtos/px/patient/patient_dtos.dart';

class PxRepositoryImpl extends PxRepository {
  final PxDatasourceImpl datasource;

  PxRepositoryImpl({required this.datasource});

  @override
  Future<ResponseApi<List<PxEntity>>> getPatients({int page = 1}) {
    return datasource.getPatients(page: page);
  }

  @override
  Future<ResponseApi<PxEntity>> postPatients(PatientDtos dtos) {
    return datasource.postPatients(dtos);
  }
}
