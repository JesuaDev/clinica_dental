import 'package:clinica_prodental/core/api/response_api.dart';
import 'package:clinica_prodental/domain/entities/px/cita_entity.dart';
import 'package:clinica_prodental/domain/repositories/px/citas_repository.dart';
import 'package:clinica_prodental/infraestructure/datasources/px/citas_datasource_impl.dart';
import 'package:clinica_prodental/infraestructure/dtos/appoitment/dtos_date_appoitment.dart';

class CitasRepositoryImpl extends CitasRepository {
  final CitasDatasourceImpl datasource;

  CitasRepositoryImpl({required this.datasource});

  @override
  Future<ResponseApi<List<CitaEntity>>> getCitas({int page = 1}) {
    return datasource.getCitas(page: page);
  }

  @override
  Future<ResponseApi<CitaEntity>> getCitaUpcoming() {
    return datasource.getCitaUpcoming();
  }

  @override
  Future<ResponseApi<CitaEntity>> postMedicalAppoitment(
    DtosDateAppoitment dtos,
  ) {
    return datasource.postMedicalAppoitment(dtos);
  }
}
