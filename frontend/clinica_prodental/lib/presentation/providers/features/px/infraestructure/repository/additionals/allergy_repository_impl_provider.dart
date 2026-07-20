import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clinica_prodental/infraestructure/respositories/px/additionals/allergy_repository_impl.dart';
import 'package:clinica_prodental/presentation/providers/features/px/infraestructure/datasource/additionals/allergy_datasource_provider.dart';

final allergyRepositoryImplProvider = Provider<AllergyRepositoryImpl>((ref) {
  final datasourceImpl = ref.watch(allergyDataSourceProvider);
  return AllergyRepositoryImpl(datasourceImpl: datasourceImpl);
});
