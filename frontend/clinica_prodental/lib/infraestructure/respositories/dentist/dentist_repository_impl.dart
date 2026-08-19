import 'package:clinica_prodental/core/api/response_api.dart';
import 'package:clinica_prodental/domain/entities/dentist_entity.dart';
import 'package:clinica_prodental/domain/repositories/dentist/dentist_repository.dart';
import 'package:clinica_prodental/infraestructure/datasources/dentist/dentist_datasource_impl.dart';

class DentistRepositoryImpl extends DentistRepository {
  final DentistDatasourceImpl datasourceImpl;

  DentistRepositoryImpl({required this.datasourceImpl});

  @override
  Future<ResponseApi<List<DentistEntity>>> searchDentist(String search) {
    return datasourceImpl.searchDentist(search);
  }
}
