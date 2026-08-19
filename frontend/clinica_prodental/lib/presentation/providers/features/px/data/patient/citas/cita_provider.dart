import 'package:clinica_prodental/domain/entities/error_entity.dart';
import 'package:clinica_prodental/infraestructure/dtos/appoitment/dtos_date_appoitment.dart';
import 'package:clinica_prodental/presentation/providers/features/px/data/state/patient/citas/cita_state.dart';
import 'package:clinica_prodental/presentation/providers/features/px/infraestructure/repository/cita_repository_impl_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final citasProvider = NotifierProvider<CitasNotifier, CitaState>(
  CitasNotifier.new,
);

class CitasNotifier extends Notifier<CitaState> {
  @override
  build() => CitaState();

  Future<void> loadCitas({int page = 1}) async {
    try {
      const Duration minLoadingTime = Duration(milliseconds: 800);
      state = state.copyWith(isLoading: true, error: null);

      final DateTime start = DateTime.now();

      final repository = ref.read(citaRepositoryImplProvider);
      final response = await repository.getCitas(page: page);

      final Duration elapsed = DateTime.now().difference(start);
      if (elapsed < minLoadingTime) {
        await Future.delayed(minLoadingTime - elapsed);
      }

      state = state.copyWith(
        isLoading: false,
        citas: response.data,
        message: response.message,
        pagination: response.paginations,
      );
    } on ErrorEntity catch (err) {
      state = state.copyWith(isLoading: false, error: err);
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

  Future<void> loadCitaUpcoming() async {
    try {
      const Duration minLoadingTime = Duration(milliseconds: 800);
      state = state.copyWith(isLoading: true, error: null);

      final DateTime start = DateTime.now();

      final repository = ref.read(citaRepositoryImplProvider);
      final response = await repository.getCitaUpcoming();

      final Duration elapsed = DateTime.now().difference(start);
      if (elapsed < minLoadingTime) {
        await Future.delayed(minLoadingTime - elapsed);
      }

      state = state.copyWith(
        isLoading: false,
        citaUpcoming: response.data,
        message: response.message,
        pagination: response.paginations,
      );
    } on ErrorEntity catch (err) {
      state = state.copyWith(isLoading: false, error: err);
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

  Future<void> postMedicalAppoitment(DtosDateAppoitment dtos) async {
    try {
      const Duration minLoadingTime = Duration(milliseconds: 800);
      state = state.copyWith(isLoading: true, error: null);
      final DateTime start = DateTime.now();

      final repository = ref.watch(citaRepositoryImplProvider);
      final response = await repository.postMedicalAppoitment(dtos);

      final Duration elapsed = DateTime.now().difference(start);
      if (elapsed < minLoadingTime) {
        await Future.delayed(minLoadingTime - elapsed);
      }

      state = state.copyWith(
        isLoading: false,
        message: response.message,
        citas: [response.data, ...state.citas!],
      );
    } on ErrorEntity catch (err) {
      state = state.copyWith(isLoading: false, error: err);
    } catch (err) {
      state = state.copyWith(
        isLoading: false,
        error: ErrorEntity(
          status: 500,
          message: 'Error desconocido $err',
          details: '',
        ),
      );
    }
  }
}
