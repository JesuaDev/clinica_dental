import 'package:clinica_prodental/core/api/response_api.dart';
import 'package:clinica_prodental/domain/entities/entities.dart';
import 'package:clinica_prodental/infraestructure/dtos/dtos.dart';

abstract class CalendarRepository {
  Future<ResponseApi<CalendarEntity>> postReminder(DtosReminder dtosReminder);
  Future<ResponseApi<List<CalendarEntity>>> getReminder();
  Future<ResponseApi<List<CalendarEntity>>> getReminderUpComing();
}
