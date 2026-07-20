import 'package:clinica_prodental/domain/entities/entities.dart';
import 'package:clinica_prodental/infraestructure/models/models.dart';
import 'package:clinica_prodental/infraestructure/mappers/mappers.dart';

class UserMapper {
  static UserWithProfile userProfileToEntity(
    UserWithProfileResponse userProfileResponse,
  ) => UserWithProfile(
    idUser: userProfileResponse.idUser,
    userEmail: userProfileResponse.emailUser,
    rol: userProfileResponse.rol,
    profile: ProfileMapper.toEntityProfile(userProfileResponse.profile),
  );
}
