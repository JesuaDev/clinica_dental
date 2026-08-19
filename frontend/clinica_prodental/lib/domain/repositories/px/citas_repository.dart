import 'package:clinica_prodental/core/api/response_api.dart';
import 'package:clinica_prodental/domain/entities/entities.dart';
import 'package:clinica_prodental/infraestructure/dtos/dtos.dart';

abstract class CitasRepository {
  Future<ResponseApi<List<CitaEntity>>> getCitas({int page = 1});
  Future<ResponseApi<CitaEntity>> getCitaUpcoming();
  Future<ResponseApi<CitaEntity>> postMedicalAppoitment(
    DtosDateAppoitment dtos,
  );
}
