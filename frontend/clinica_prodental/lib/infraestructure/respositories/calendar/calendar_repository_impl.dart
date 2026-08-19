import 'package:clinica_prodental/core/api/response_api.dart';
import 'package:clinica_prodental/domain/entities/calendar/calendar_entity.dart';
import 'package:clinica_prodental/domain/repositories/repositories.dart';
import 'package:clinica_prodental/infraestructure/datasources/calendar/calendar_datasources_impl.dart';
import 'package:clinica_prodental/infraestructure/dtos/appoitment/dtos_reminder.dart';

class CalendarRepositoryImpl extends CalendarRepository {
  final CalendarDatasourcesImpl datasourceImpl;

  CalendarRepositoryImpl(this.datasourceImpl);

  @override
  Future<ResponseApi<List<CalendarEntity>>> getReminder() {
    return datasourceImpl.getReminder();
  }

  @override
  Future<ResponseApi<CalendarEntity>> postReminder(DtosReminder dtosReminder) {
    return datasourceImpl.postReminder(dtosReminder);
  }

  @override
  Future<ResponseApi<List<CalendarEntity>>> getReminderUpComing() {
    return datasourceImpl.getReminderUpComing();
  }
}
