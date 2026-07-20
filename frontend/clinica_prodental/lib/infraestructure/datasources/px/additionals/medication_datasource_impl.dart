import 'package:clinica_prodental/domain/entities/error_entity.dart';
import 'package:clinica_prodental/infraestructure/dtos/px/medication/dtos_medication.dart';
import 'package:clinica_prodental/infraestructure/mappers/px/details/medication_mapper.dart';
import 'package:clinica_prodental/infraestructure/models/models.dart';
import 'package:dio/dio.dart';
import 'package:clinica_prodental/domain/datasources/px/additionals_patient/medication_datasource.dart';
import 'package:clinica_prodental/core/api/response_api.dart';
import 'package:clinica_prodental/domain/entities/px/additionals_px/medication_px_entity.dart';
import 'package:flutter/material.dart';

class MedicationDatasourceImpl extends MedicationDatasource {
  final Dio dio;

  MedicationDatasourceImpl({required this.dio});

  @override
  Future<ResponseApi<List<MedicationPxEntiy>>> getMedications() async {
    try {
      final response = await dio.get('/medications');

      final List dataMedications = response.data["data"];
      final String? message = response.data["message"];
      final int? statusCode = response.statusCode;

      final List<MedicationPxEntiy> medicationsParse = dataMedications
          .map(
            (medication) => MedicationMapper.medicationToEntity(
              MedicationModelResponse.fromJson(medication),
            ),
          )
          .toList();

      return ResponseApi(
        statusCode: statusCode,
        message: message!,
        data: medicationsParse,
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
  Future<ResponseApi<MedicationPxEntiy>> postMedication(
    DtosMedication dtos,
  ) async {
    try {
      final response = await dio.post('/medication', data: dtos.toJson());

      final String? message = response.data["message"];
      final int? statusCode = response.statusCode;
      final Map<String, dynamic> medication = response.data["data"];

      final MedicationPxEntiy medicationParse =
          MedicationMapper.medicationToEntity(
            MedicationModelResponse.fromJson(medication),
          );

      return ResponseApi(
        statusCode: statusCode,
        message: message!,
        data: medicationParse,
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
