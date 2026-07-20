import 'dart:convert';
import 'package:flutter_riverpod/legacy.dart';
import 'package:clinica_prodental/presentation/providers/features/auth/data/login_state.dart';
import 'package:clinica_prodental/presentation/providers/features/auth/infraestructure/repository/login_repository_impl_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:clinica_prodental/domain/entities/entities.dart';
import 'package:clinica_prodental/infraestructure/dtos/dtos_login.dart';
import 'package:clinica_prodental/infraestructure/mappers/mappers.dart';
import 'package:clinica_prodental/infraestructure/models/models.dart';

final authUserProviders = StateNotifierProvider<LoginNotifier, LoginState>((
  ref,
) {
  final fetchUser = ref.watch(loginRespositoryProvider);

  return LoginNotifier(authUser: fetchUser.login);
});

typedef AuthUser = Future<UserWithProfile> Function(DtosLogin dtoLogin);

class LoginNotifier extends StateNotifier<LoginState> {
  final AuthUser authUser;

  LoginNotifier({required this.authUser}) : super(LoginState()) {
    checkLogin();
  }

  Future<void> login(DtosLogin dtoLogin) async {
    final storage = FlutterSecureStorage();
    try {
      state = state.copyWith(isLoading: true, error: null);
      final user = await authUser(dtoLogin);
      await storage.write(
        key: 'user',
        value: jsonEncode({
          "id_user": user.idUser,
          "email_user": user.userEmail,
          "rol": user.rol,
          "profile": {
            "name_user": user.profile.nameUser,
            "last_name_user": user.profile.lastNameUser,
            "picture_profile": user.profile.pictureUser,
          },
        }),
      );

      state = state.copyWith(isLoading: false, user: user);
    } on ErrorEntity catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: ErrorEntity(
          status: 500,
          message: 'Error desconocido',
          details: '',
        ),
      );
    }
  }

  Future<void> checkLogin() async {
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    final user = await storage.read(key: 'user');

    if (token != null && user != null) {
      final userParse = UserWithProfileResponse.fromJson(jsonDecode(user));
      final userMapper = UserMapper.userProfileToEntity(userParse);

      state = state.copyWith(isLoading: false, user: userMapper);
    }
  }
}
