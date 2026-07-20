import 'package:clinica_prodental/domain/entities/entities.dart';
import 'package:clinica_prodental/domain/repositories/users/login_repository.dart';
import 'package:clinica_prodental/infraestructure/dtos/dtos.dart';

import '../../datasources/users/login_datasource_impl.dart';

class LoginRepositoryImpl extends LoginRepository {
  late LoginDatasourceImpl datasourceImpl;

  LoginRepositoryImpl(this.datasourceImpl);

  @override
  Future<UserWithProfile> login(DtosLogin dtosLogin) {
    return datasourceImpl.login(dtosLogin);
  }
}
