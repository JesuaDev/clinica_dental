import 'package:clinica_prodental/domain/entities/pagination/pagination_entity.dart';
import 'package:clinica_prodental/infraestructure/dtos/px/patient/patient_dtos.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'package:clinica_prodental/domain/datasources/px/px_datasource.dart';
import 'package:clinica_prodental/core/api/response_api.dart';
import '../../../domain/entities/entities.dart';

import 'package:clinica_prodental/infraestructure/models/models.dart';
import 'package:clinica_prodental/infraestructure/mappers/mappers.dart';

class PxDatasourceImpl extends PxDatasource {
  final Dio dio;

  PxDatasourceImpl({required this.dio});

  @override
  Future<ResponseApi<List<PxEntity>>> getPatients({int page = 1}) async {
    try {
     
      final patients = await dio.get(
        '/patients',
        queryParameters: {"page": page},
      );

      final int? statusCode = patients.statusCode;
      final String message = patients.data["message"];
      final List listPatients = patients.data["data"];

      final List<PxEntity> listPatientsParse = listPatients
          .map(
            (patient) => PxMapper.pxToEntity(PxModelResponse.fromJson(patient)),
          )
          .toList();

      final Map<String, dynamic> pagination = patients.data["pagination"];

      final PaginationEntity paginationParse =
          PaginationMapper.paginationToEntity(
            PaginationModel.fromJson(pagination),
          );

      return ResponseApi(
        data: listPatientsParse,
        statusCode: statusCode,
        message: message,
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
  Future<ResponseApi<PxEntity>> postPatients(PatientDtos dtos) async {
    try {
      debugPrint("${dtos.names} && ${dtos.medicalRecord} && ${dtos.toJson()}");
      final patient = await dio.post('/patient', data: dtos.toJson());

      final String? message = patient.data["message"];
      final int? statusCode = patient.statusCode;
      final Map<String, dynamic> patientData = patient.data["data"];

      final PxEntity patientParse = PxMapper.pxToEntity(
        PxModelResponse.fromJson(patientData),
      );

      return ResponseApi(
        statusCode: statusCode,
        message: message ?? "Sin mensaje...",
        data: patientParse,
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
  Future<ResponseApi<List<PxEntity>>> searchPx(String value) async {
    try {
      final search = await dio.get(
        '/patient/search',
        queryParameters: {"search": value},
      );

      final int? statusCode = search.statusCode;
      final String message = search.data["message"];
      final List listSearch = search.data["data"];

      final List<PxEntity> listPatientsParse = listSearch
          .map(
            (patient) => PxMapper.pxToEntity(PxModelResponse.fromJson(patient)),
          )
          .toList();

      return ResponseApi(
        statusCode: statusCode,
        message: message,
        data: listPatientsParse,
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
