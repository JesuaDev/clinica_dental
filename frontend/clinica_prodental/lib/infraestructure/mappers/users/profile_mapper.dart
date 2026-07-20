import 'package:clinica_prodental/domain/entities/entities.dart';
import 'package:clinica_prodental/infraestructure/models/models.dart';

class ProfileMapper {
  static ProfileEntity toEntityProfile(ProfileResponse profileResponse) =>
      ProfileEntity(
        nameUser: (profileResponse.nameUser) != ''
            ? profileResponse.nameUser
            : 'Uknow',
        lastNameUser: (profileResponse.lastNameUser) != ''
            ? profileResponse.nameUser
            : 'Uknow',
        pictureUser: (profileResponse.pictureProfile) != ''
            ? profileResponse.pictureProfile
            : 'assets/images/avatar_default.png',
      );
}
