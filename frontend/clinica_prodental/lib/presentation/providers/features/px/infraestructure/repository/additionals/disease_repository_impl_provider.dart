import 'package:clinica_prodental/infraestructure/respositories/px/additionals/disease_repository_impl.dart';
import 'package:clinica_prodental/presentation/providers/features/px/infraestructure/datasource/additionals/disease_datasource_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final diseaseRepositoryImplProvider = Provider<DiseaseRepositoryImpl>((ref) {
  final datasourceImpl = ref.watch(diseaseDatasourceProvider);

  return DiseaseRepositoryImpl(datasourceImpl: datasourceImpl);
});
