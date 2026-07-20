import 'package:clinica_prodental/infraestructure/respositories/px/additionals/medication_repository_impl.dart';
import 'package:clinica_prodental/presentation/providers/features/px/infraestructure/datasource/additionals/medication_datasource_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final medicationRepositoryProvider = Provider<MedicationRepositoryImpl>((ref) {
  final datasourceImpl = ref.watch(medicationDatasourceProvider);

  return MedicationRepositoryImpl(datasourceImpl: datasourceImpl);
});
