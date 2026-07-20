import 'package:clinica_prodental/infraestructure/datasources/px/additionals/medication_datasource_impl.dart';
import 'package:clinica_prodental/presentation/providers/custom/network/dio_client_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final medicationDatasourceProvider = Provider<MedicationDatasourceImpl>((ref) {
  final Dio dio = ref.watch(dioProvider);

  return MedicationDatasourceImpl(dio: dio);
});
