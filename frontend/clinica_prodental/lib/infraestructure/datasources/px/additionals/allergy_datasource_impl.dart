import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:clinica_prodental/core/api/response_api.dart';
import 'package:clinica_prodental/infraestructure/dtos/dtos.dart';
import 'package:clinica_prodental/infraestructure/mappers/px/details/allergy_mapper.dart';
import 'package:clinica_prodental/infraestructure/models/models.dart';
import 'package:clinica_prodental/domain/entities/entities.dart';
import 'package:clinica_prodental/domain/datasources/px/additionals_patient/allergy_datasource.dart';

class AllergyDatasourceImpl extends AllergyDatasource {
  final Dio dio;

  AllergyDatasourceImpl({required this.dio});

  @override
  Future<ResponseApi<List<AllergyEntity>>> getAllergys() async {
    try {
      final response = await dio.get('/allergys');

      final List listResponse = response.data["data"];
      final String? message = response.data["message"];
      final int? statusCode = response.statusCode;

      final List<AllergyEntity> listAllergyParse = listResponse
          .map(
            (allergy) => AllergyMapper.allergyToEntity(
              AllergyResponse.fromJson(allergy),
            ),
          )
          .toList();

      return ResponseApi(
        statusCode: statusCode,
        message: message!,
        data: listAllergyParse,
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
  Future<ResponseApi<AllergyEntity>> postAllergy(DtosAllergy dtos) async {
    try {
      debugPrint(dtos.nameAllergy);
      final response = await dio.post('/allergy', data: dtos.toJson());

      final Map<String, dynamic> allergyResponse = response.data["data"];

      final String? message = response.data["message"];
      final int? statusCode = response.statusCode;

      final AllergyEntity allergyParse = AllergyMapper.allergyToEntity(
        AllergyResponse.fromJson(allergyResponse),
      );

      return ResponseApi(
        statusCode: statusCode,
        message: message!,
        data: allergyParse,
      );
    } on DioException catch (e) {
      throw ErrorEntity(
        status: e.response?.statusCode,
        message: e.response?.data["message"],
        details: e.response?.data["details"] ?? 'No hay detalles del error',
      );
    } catch (err, stack) {
      debugPrint("$err y $stack");
      rethrow;
    }
  }
}
