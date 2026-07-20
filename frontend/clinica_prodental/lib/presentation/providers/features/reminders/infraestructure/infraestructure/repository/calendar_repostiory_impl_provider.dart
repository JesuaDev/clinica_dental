import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clinica_prodental/domain/repositories/repositories.dart';
import 'package:clinica_prodental/infraestructure/respositories/calendar/calendar_repository_impl.dart';
import 'package:clinica_prodental/presentation/providers/features/reminders/infraestructure/infraestructure/datasource/calendar_datasource_provider.dart';

final calendarRepositoryImplProvider = Provider<CalendarRepository>((ref) {
  final datasource = ref.watch(calendarDatasourceProvider);
  return CalendarRepositoryImpl(datasource);
});
