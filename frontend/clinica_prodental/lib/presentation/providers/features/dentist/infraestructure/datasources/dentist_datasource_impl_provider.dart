import 'package:clinica_prodental/infraestructure/datasources/dentist/dentist_datasource_impl.dart';
import 'package:clinica_prodental/presentation/providers/custom/network/dio_client_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dentistDatasourceImplProvider = Provider<DentistDatasourceImpl>((ref) {
  final Dio dio = ref.watch(dioProvider);
  return DentistDatasourceImpl(dio: dio);
});
