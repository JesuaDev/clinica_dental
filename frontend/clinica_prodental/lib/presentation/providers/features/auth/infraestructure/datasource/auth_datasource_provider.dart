import 'package:clinica_prodental/infraestructure/datasources/users/login_datasource_impl.dart';
import 'package:clinica_prodental/presentation/providers/custom/network/dio_client_provider.dart';
import 'package:clinica_prodental/presentation/providers/features/auth/config/secure_storage_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final loginDatasourcesProvider = Provider<LoginDatasourceImpl>((ref) {
  final Dio dio = ref.watch(dioProvider);
  final FlutterSecureStorage storage = ref.watch(secureStorageProvider);
  return LoginDatasourceImpl(dio, storage);
});
