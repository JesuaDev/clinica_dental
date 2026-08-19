import 'package:clinica_prodental/infraestructure/mappers/dentist_mapper.dart';
import 'package:clinica_prodental/infraestructure/models/models.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:clinica_prodental/core/api/response_api.dart';
import 'package:clinica_prodental/domain/entities/entities.dart';
import 'package:clinica_prodental/domain/datasources/dentist/dentist_datasource.dart';

class DentistDatasourceImpl extends DentistDatasource {
  final Dio dio;

  DentistDatasourceImpl({required this.dio});

  @override
  Future<ResponseApi<List<DentistEntity>>> searchDentist(String search) async {
    try {
      final response = await dio.get(
        '/dentist/search',
        queryParameters: {"search": search},
      );

      final String? message = response.data["message"];
      final int? statusCode = response.statusCode;
      final List resultSearch = response.data["data"];

      final resultSearchParse = resultSearch
          .map(
            (cita) => DentistMapper.dentistToEntity(
              DentistModelResponse.fromJson(cita),
            ),
          )
          .toList();

      return ResponseApi(
        statusCode: statusCode,
        message: message ?? "Sin comentarios.",
        data: resultSearchParse,
      );
    } on DioException catch (e) {
      throw ErrorEntity(
        status: e.response?.statusCode,
        message: e.response?.data['message'],
        details: e.response?.data['details'] ?? 'No hay detalles del error',
      );
    } catch (err, stack) {
      debugPrint("$err y $stack");
      rethrow;
    }
  }
}
