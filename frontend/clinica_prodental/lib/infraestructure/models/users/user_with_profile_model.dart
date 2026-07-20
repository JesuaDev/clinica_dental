class UserWithProfileResponse {
  final int idUser;
  final String emailUser;
  final String rol;
  final ProfileResponse profile;

  UserWithProfileResponse({
    required this.idUser,
    required this.emailUser,
    required this.rol,
    required this.profile,
  });

  factory UserWithProfileResponse.fromJson(Map<String, dynamic> json) =>
      UserWithProfileResponse(
        idUser: json["id_user"],
        emailUser: json["email_user"],
        rol: json["rol"],
        profile: ProfileResponse.fromJson(json["profile"]),
      );

  Map<String, dynamic> toJson() => {
    "id_user": idUser,
    "email_user": emailUser,
    "rol": rol,
    "profile": profile.toJson(),
  };
}

class ProfileResponse {
  final String nameUser;
  final String lastNameUser;
  final String pictureProfile;

  ProfileResponse({
    required this.nameUser,
    required this.lastNameUser,
    required this.pictureProfile,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) =>
      ProfileResponse(
        nameUser: json["name_user"] ?? ' ',
        lastNameUser: json["last_name_user"] ?? ' ',
        pictureProfile: json["picture_profile"] ?? ' ',
      );

  Map<String, dynamic> toJson() => {
    "name_user": nameUser,
    "last_name_user": lastNameUser,
    "picture_profile": pictureProfile,
  };

  factory ProfileResponse.empty() {
    return ProfileResponse(nameUser: '', pictureProfile: '', lastNameUser: '');
  }
}
