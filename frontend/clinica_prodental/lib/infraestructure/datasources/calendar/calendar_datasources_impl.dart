import 'package:clinica_prodental/core/api/response_api.dart';
import 'package:clinica_prodental/domain/datasources/calendar/calendar_datasource.dart';
import 'package:clinica_prodental/domain/entities/entities.dart';
import 'package:clinica_prodental/infraestructure/dtos/appoitment/dtos_reminder.dart';
import 'package:clinica_prodental/infraestructure/mappers/calendar_mapper.dart';
import 'package:clinica_prodental/infraestructure/models/calendar/calendar_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

class CalendarDatasourcesImpl extends CalendarDatasource {
  final Dio dio;

  CalendarDatasourcesImpl(this.dio);

  @override
  Future<ResponseApi<List<CalendarEntity>>> getReminder() async {
    try {
      final reminder = await dio.get('/reminders');
      final List listReminder = reminder.data["data"];

      final String message = reminder.data["message"];
      final int? statusCode = reminder.statusCode;

      final List<CalendarEntity> listRemindersParse = listReminder
          .map(
            (rem) => CalendarMapper.calendarToEntity(
              ReminderModelResponse.fromJson(rem),
            ),
          )
          .toList();

      return ResponseApi(
        statusCode: statusCode,
        message: message,
        data: listRemindersParse,
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
  Future<ResponseApi<CalendarEntity>> postReminder(
    DtosReminder dtosReminder,
  ) async {
    try {
      final reminder = await dio.post('/reminder', data: dtosReminder.toJson());

      final CalendarEntity reminderParse = CalendarMapper.calendarToEntity(
        ReminderModelResponse.fromJson(reminder.data),
      );

      final String message = reminder.data["message"];
      final int? statusCode = reminder.statusCode;

      return ResponseApi(
        statusCode: statusCode,
        message: message,
        data: reminderParse,
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
  Future<ResponseApi<List<CalendarEntity>>> getReminderUpComing() async {
    try {
      final reminder = await dio.get('/reminders/upcoming');
      final List listReminder = reminder.data["data"];

      final String message = reminder.data["message"];
      final int? statusCode = reminder.statusCode;

      final List<CalendarEntity> listRemindersParse = listReminder
          .map(
            (rem) => CalendarMapper.calendarToEntity(
              ReminderModelResponse.fromJson(rem),
            ),
          )
          .toList();

      return ResponseApi(
        statusCode: statusCode,
        message: message,
        data: listRemindersParse,
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
