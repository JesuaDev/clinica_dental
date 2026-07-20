import 'package:clinica_prodental/infraestructure/datasources/calendar/calendar_datasources_impl.dart';
import 'package:clinica_prodental/presentation/providers/custom/network/dio_client_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final calendarDatasourceProvider = Provider<CalendarDatasourcesImpl>((ref) {
  final Dio dio = ref.watch(dioProvider);
  return CalendarDatasourcesImpl(dio);
});
