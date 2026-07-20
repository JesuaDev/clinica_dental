import 'package:clinica_prodental/infraestructure/datasources/px/citas_datasource_impl.dart';
import 'package:clinica_prodental/infraestructure/respositories/px/citas_repository_impl.dart';
import 'package:clinica_prodental/presentation/providers/features/px/infraestructure/datasource/cita_datasource_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final citaRepositoryImplProvider = Provider<CitasRepositoryImpl>((ref) {
  final CitasDatasourceImpl datasource = ref.watch(citaDataSourceProvider);
  return CitasRepositoryImpl(datasource: datasource);
});
