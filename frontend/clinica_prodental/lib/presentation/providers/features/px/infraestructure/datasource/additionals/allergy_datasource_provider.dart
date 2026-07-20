import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:clinica_prodental/presentation/providers/custom/network/dio_client_provider.dart';
import 'package:clinica_prodental/infraestructure/datasources/px/additionals/allergy_datasource_impl.dart';

final allergyDataSourceProvider = Provider<AllergyDatasourceImpl>((ref) {
  final Dio dio = ref.watch(dioProvider);

  return AllergyDatasourceImpl(dio: dio);
});
