import 'package:clinica_prodental/infraestructure/respositories/dentist/dentist_repository_impl.dart';
import 'package:clinica_prodental/presentation/providers/features/dentist/infraestructure/datasources/dentist_datasource_impl_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dentistRepositoryImplProvider = Provider<DentistRepositoryImpl>((ref) {
  final datasourceImpl = ref.watch(dentistDatasourceImplProvider);
  return DentistRepositoryImpl(datasourceImpl: datasourceImpl);
});
