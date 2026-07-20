import 'package:clinica_prodental/core/api/response_api.dart';
import 'package:clinica_prodental/domain/entities/px/additionals_px/diseases_entity.dart';
import 'package:clinica_prodental/domain/repositories/px/additionals_px/disease_repository.dart';
import 'package:clinica_prodental/infraestructure/datasources/px/additionals/disease_datasource_impl.dart';
import 'package:clinica_prodental/infraestructure/dtos/px/diseases/dtos_diseases.dart';

class DiseaseRepositoryImpl extends DiseaseRepository {
  final DiseaseDatasourceImpl datasourceImpl;

  DiseaseRepositoryImpl({required this.datasourceImpl});

  @override
  Future<ResponseApi<List<DiseasesEntity>>> getDiseases() {
    return datasourceImpl.getDiseases();
  }

  @override
  Future<ResponseApi<DiseasesEntity>> postDisease(DtosDiseases dtos) {
    return datasourceImpl.postDisease(dtos);
  }
}
