import 'package:clinica_prodental/domain/entities/entities.dart';

abstract class UserDatasource {
  Future<List<UserWithProfile>> getUsers();

  Future<UserWithProfile> postUser({
    String emailUser,
    String rol,
    String passwordUser,
    String nameUser,
    String lastNameUser,
    String? pictureUser,
  });
}
