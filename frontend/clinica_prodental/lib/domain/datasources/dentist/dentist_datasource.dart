import 'package:clinica_prodental/core/api/response_api.dart';
import 'package:clinica_prodental/domain/entities/entities.dart';

abstract class DentistDatasource {
  Future<ResponseApi<List<DentistEntity>>> searchDentist(String search);
}
