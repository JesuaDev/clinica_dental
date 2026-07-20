import 'package:clinica_prodental/domain/entities/entities.dart';
import 'package:clinica_prodental/infraestructure/dtos/dtos.dart';
import 'package:clinica_prodental/presentation/providers/features/px/data/state/disease/disease_state.dart';
import 'package:clinica_prodental/presentation/providers/features/px/infraestructure/repository/additionals/disease_repository_impl_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final diseaseProvider = NotifierProvider<DiseaseNotifier, DiseaseState>(
  DiseaseNotifier.new,
);

class DiseaseNotifier extends Notifier<DiseaseState> {
  @override
  build() => DiseaseState();

  Future<void> getDiseases() async {
    try {
      const Duration minLoadingTime = Duration(milliseconds: 800);
      state = state.copyWith(isLoading: true, error: null);
      final DateTime start = DateTime.now();

      final repository = ref.watch(diseaseRepositoryImplProvider);
      final response = await repository.getDiseases();

      final Duration elapsed = DateTime.now().difference(start);
      if (elapsed < minLoadingTime) {
        await Future.delayed(minLoadingTime - elapsed);
      }

      state = state.copyWith(
        isLoading: false,
        message: response.message,
        diseases: response.data,
      );
    } on ErrorEntity catch (err) {
      state = state.copyWith(isLoading: false, error: err);
      rethrow;
      ();
    } catch (err) {
      state = state.copyWith(
        isLoading: false,
        error: ErrorEntity(
          status: 500,
          message: 'Error desconocido',
          details: '',
        ),
      );
    }
  }

  Future<DiseasesEntity> postDiseases(DtosDiseases dtos) async {
    try {
      const Duration minLoadingTime = Duration(milliseconds: 800);
      state = state.copyWith(isLoading: true, error: null);
      final DateTime start = DateTime.now();

      final repository = ref.watch(diseaseRepositoryImplProvider);
      final response = await repository.postDisease(dtos);

      final Duration elapsed = DateTime.now().difference(start);
      if (elapsed < minLoadingTime) {
        await Future.delayed(minLoadingTime - elapsed);
      }

      state = state.copyWith(
        isLoading: false,
        message: response.message,
        diseases: [...state.diseases!, response.data],
      );

      return response.data;
    } on ErrorEntity catch (err) {
      state = state.copyWith(isLoading: false, error: err);
      rethrow;
    } catch (err) {
      state = state.copyWith(
        isLoading: false,
        error: ErrorEntity(
          status: 500,
          message: 'Error desconocido',
          details: '',
        ),
      );

      rethrow;
    }
  }
}
