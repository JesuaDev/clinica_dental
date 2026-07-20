import 'package:clinica_prodental/infraestructure/datasources/px/px_datasource_impl.dart';
import 'package:clinica_prodental/infraestructure/respositories/px/px_repository_impl.dart';
import 'package:clinica_prodental/presentation/providers/features/px/infraestructure/datasource/px_datasource_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final pxRepositoryImplProvider = Provider<PxRepositoryImpl>((ref) {
  final PxDatasourceImpl datasource = ref.watch(pxDatasourceProvider);

  return PxRepositoryImpl(datasource: datasource);
});
