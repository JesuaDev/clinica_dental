import 'package:clinica_prodental/domain/entities/entities.dart';

class UserWithProfile {
  final int idUser;
  final String userEmail;
  final String rol;
  final ProfileEntity profile;

  UserWithProfile({
    required this.idUser,
    required this.userEmail,
    required this.profile,
    required this.rol,
  });
}
