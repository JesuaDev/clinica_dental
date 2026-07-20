import 'package:clinica_prodental/domain/repositories/users/login_repository.dart';
import 'package:clinica_prodental/infraestructure/respositories/users/login_repository_impl.dart';
import 'package:clinica_prodental/presentation/providers/features/auth/infraestructure/datasource/auth_datasource_provider.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final loginRespositoryProvider = Provider<LoginRepository>((ref) {
  final datasource = ref.watch(loginDatasourcesProvider);

  return LoginRepositoryImpl(datasource);
});
