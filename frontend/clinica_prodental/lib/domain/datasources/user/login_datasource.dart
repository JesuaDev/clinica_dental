import 'package:clinica_prodental/domain/entities/entities.dart';
import 'package:clinica_prodental/infraestructure/dtos/dtos.dart';

abstract class LoginDatasource {
  Future<UserWithProfile> login(DtosLogin dtoLogin);
}
