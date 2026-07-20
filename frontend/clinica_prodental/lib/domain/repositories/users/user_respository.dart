import 'package:clinica_prodental/domain/entities/entities.dart';

abstract class UserRespository {
  Future<List<UserWithProfile>> getUsers();

  Future<UserWithProfile> postUser({
    String emailUser,
    String rol,

    String nameUser,
    String lastNameUser,
    String? pictureUser,
  });

  Future<UserWithProfile> updateUser({
    int idUser,
    String emailUser,
    String rol,

    String nameUser,
    String lastNameUser,
    String? pictureUser,
  });
}
