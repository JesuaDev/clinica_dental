import 'package:clinica_prodental/core/api/response_api.dart';
import 'package:clinica_prodental/domain/datasources/px/additionals_patient/disease_datasource.dart';
import 'package:clinica_prodental/domain/entities/error_entity.dart';
import 'package:clinica_prodental/domain/entities/px/additionals_px/diseases_entity.dart';
import 'package:clinica_prodental/infraestructure/dtos/px/diseases/dtos_diseases.dart';
import 'package:clinica_prodental/infraestructure/mappers/px/details/diseases_mapper.dart';
import 'package:clinica_prodental/infraestructure/models/px/details/diseases_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DiseaseDatasourceImpl extends DiseaseDatasource {
  final Dio dio;

  DiseaseDatasourceImpl({required this.dio});

  @override
  Future<ResponseApi<List<DiseasesEntity>>> getDiseases() async {
    try {
      final response = await dio.get('/diseases');

      final List listResponse = response.data["data"];
      final String? message = response.data["message"];
      final int? statusCode = response.statusCode;

      final List<DiseasesEntity> diseasesParse = listResponse
          .map(
            (disease) => DiseasesMapper.diseasesToEntity(
              DiseaseModelResponse.fromJson(disease),
            ),
          )
          .toList();

      return ResponseApi(
        statusCode: statusCode,
        message: message!,
        data: diseasesParse,
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
  Future<ResponseApi<DiseasesEntity>> postDisease(DtosDiseases dtos) async {
    try {
      final response = await dio.post("/disease", data: dtos.toJson());

      final Map<String, dynamic> disease = response.data["data"];
      final String? message = response.data["message"];
      final int? statusCode = response.statusCode;

      final DiseasesEntity diseaseParse = DiseasesMapper.diseasesToEntity(
        DiseaseModelResponse.fromJson(disease),
      );

      return ResponseApi(
        statusCode: statusCode,
        message: message!,
        data: diseaseParse,
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
