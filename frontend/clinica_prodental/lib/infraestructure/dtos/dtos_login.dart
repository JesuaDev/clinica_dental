class DtosLogin {
  final String emailUser;
  final String passwordUser;

  DtosLogin({required this.emailUser, required this.passwordUser});

  Map<String, dynamic> toJson() {
    return {"email_user": emailUser, "password_user": passwordUser};
  }
}
