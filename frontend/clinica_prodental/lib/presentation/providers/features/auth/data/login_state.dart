import 'package:clinica_prodental/domain/entities/entities.dart';

class LoginState {
  final bool isLoading;
  final UserWithProfile? user;
  final ErrorEntity? error;

  LoginState({this.isLoading = false, this.user, this.error});

  LoginState copyWith({
    bool? isLoading,
    UserWithProfile? user,
    ErrorEntity? error,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: error,
    );
  }
}
