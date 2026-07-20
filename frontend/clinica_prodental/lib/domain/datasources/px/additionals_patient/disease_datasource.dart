import 'package:clinica_prodental/core/api/response_api.dart';
import 'package:clinica_prodental/domain/entities/entities.dart';
import 'package:clinica_prodental/infraestructure/dtos/dtos.dart';

abstract class DiseaseDatasource {
  Future<ResponseApi<List<DiseasesEntity>>> getDiseases();
  Future<ResponseApi<DiseasesEntity>> postDisease(DtosDiseases dtos);
}
