import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:clinica_prodental/infraestructure/datasources/px/citas_datasource_impl.dart';
import 'package:clinica_prodental/presentation/providers/custom/network/dio_client_provider.dart';

final citaDataSourceProvider = Provider<CitasDatasourceImpl>((ref) {
  final Dio dio = ref.watch(dioProvider);
  return CitasDatasourceImpl(dio: dio);
});
