import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:clinica_prodental/domain/entities/entities.dart';
import 'package:clinica_prodental/infraestructure/mappers/mappers.dart';
import 'package:clinica_prodental/infraestructure/models/models.dart';
import 'package:clinica_prodental/core/api/response_api.dart';
import 'package:clinica_prodental/domain/datasources/px/citas_datasource.dart';

class CitasDatasourceImpl extends CitasDatasource {
  final Dio dio;

  CitasDatasourceImpl({required this.dio});

  @override
  Future<ResponseApi<List<CitaEntity>>> getCitas({int page = 1}) async {
    try {
      final response = await dio.get('/citas', queryParameters: {"page": page});

      final String? message = response.data["message"];
      final int? statusCode = response.statusCode;
      final List citas = response.data["data"];
      final Map<String, dynamic> pagination = response.data["pagination"];

      final citasParse = citas
          .map(
            (cita) => CitaMapper.citaToEntity(CitaModelResponse.fromJson(cita)),
          )
          .toList();

      final paginationParse = PaginationMapper.paginationToEntity(
        PaginationModel.fromJson(pagination),
      );

      return ResponseApi(
        statusCode: statusCode,
        message: message ?? "No hay mensaje...",
        data: citasParse,
        paginations: paginationParse,
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

  @override
  Future<ResponseApi<CitaEntity>> getCitaUpcoming() async {
    try {
      final response = await dio.get('/cita/upcoming');

      final String? message = response.data["message"];
      final int? statusCode = response.statusCode;
      final Map<String, dynamic> cita = response.data["data"];

      final citasParse = CitaMapper.citaToEntity(
        CitaModelResponse.fromJson(cita),
      );

      return ResponseApi(
        statusCode: statusCode,
        message: message ?? "No hay mensaje...",
        data: citasParse,
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
