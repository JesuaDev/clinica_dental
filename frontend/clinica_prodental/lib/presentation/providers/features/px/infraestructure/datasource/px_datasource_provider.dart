import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clinica_prodental/presentation/providers/custom/network/dio_client_provider.dart';
import 'package:clinica_prodental/infraestructure/datasources/px/px_datasource_impl.dart';

final pxDatasourceProvider = Provider<PxDatasourceImpl>((ref) {
  final dio = ref.watch(dioProvider);

  return PxDatasourceImpl(dio: dio);
});
