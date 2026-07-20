import 'package:dio/dio.dart';
import 'package:clinica_prodental/domain/entities/entities.dart';
import 'package:clinica_prodental/infraestructure/dtos/dtos.dart';
import 'package:clinica_prodental/infraestructure/mappers/mappers.dart';
import 'package:clinica_prodental/infraestructure/models/models.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../domain/datasources/datasources.dart';

class LoginDatasourceImpl extends LoginDatasource {
  final Dio dio;
  final FlutterSecureStorage storage;

  LoginDatasourceImpl(this.dio, this.storage);

  @override
  Future<UserWithProfile> login(DtosLogin dtosLogin) async {
    try {
      final res = await dio.post('/login', data: dtosLogin.toJson());

      final token = res.data['token'];
      storage.write(key: 'token', value: token);

      final dataUser = res.data['data'];

      final UserWithProfileResponse resParse = UserWithProfileResponse.fromJson(
        dataUser,
      );

      final UserWithProfile userProfile = UserMapper.userProfileToEntity(
        resParse,
      );

      return userProfile;
    } on DioException catch (e) {
      throw ErrorEntity(
        status: e.response?.statusCode,
        message: e.response?.data['message'],
        details: e.response?.data['details'] ?? 'No hay detalles del error',
      );
    }
  }
}
