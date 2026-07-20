import 'package:clinica_prodental/core/api/response_api.dart';
import 'package:clinica_prodental/domain/entities/px/additionals_px/diseases_entity.dart';
import 'package:clinica_prodental/infraestructure/dtos/px/diseases/dtos_diseases.dart';

abstract class DiseaseRepository {
  Future<ResponseApi<List<DiseasesEntity>>> getDiseases();
  Future<ResponseApi<DiseasesEntity>> postDisease(DtosDiseases dtos);
}
