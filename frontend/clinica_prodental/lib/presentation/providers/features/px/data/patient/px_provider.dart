import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clinica_prodental/infraestructure/dtos/px/patient/patient_dtos.dart';

import 'package:clinica_prodental/presentation/providers/features/px/infraestructure/repository/px_repository_impl_provider.dart';
import 'package:clinica_prodental/presentation/providers/features/px/data/state/patient/px_state.dart';

import 'package:clinica_prodental/core/api/response_api.dart';
import 'package:clinica_prodental/domain/entities/entities.dart';

final pxProvider = NotifierProvider<PxNotifier, PxState>(PxNotifier.new);

typedef GetListPatients = Future<ResponseApi<List<PxEntity>>> Function();

class PxNotifier extends Notifier<PxState> {
  /*  final GetListPatients getListPatients;
  PxStateProvider({required this.getListPatients}) : super(PxState()); */

  @override
  PxState build() => PxState();

  Future<void> getPatients({int page = 1}) async {
    try {
      const Duration minLoadingTime = Duration(milliseconds: 800);
      state = state.copyWith(isLoading: true, error: null);

      final DateTime start = DateTime.now();

      final repository = ref.read(pxRepositoryImplProvider);
      final response = await repository.getPatients(page: page);

      final Duration elapsed = DateTime.now().difference(start);
      if (elapsed < minLoadingTime) {
        await Future.delayed(minLoadingTime - elapsed);
      }

      state = state.copyWith(
        isLoading: false,
        data: response.data,
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

  Future<void> postPx(PatientDtos dtosPatient) async {
    try {
      const Duration minLoadingTime = Duration(milliseconds: 800);
      state = state.copyWith(isLoading: true, error: null);
      final DateTime start = DateTime.now();

      final repository = ref.watch(pxRepositoryImplProvider);
      final response = await repository.postPatients(dtosPatient);

      final Duration elapsed = DateTime.now().difference(start);
      if (elapsed < minLoadingTime) {
        await Future.delayed(minLoadingTime - elapsed);
      }

      state = state.copyWith(
        isLoading: false,
        message: response.message,
        data: [response.data, ...state.data!],
        px: response.data
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

  Future<void> searchPx(String value) async {
    try {
      const Duration minLoadingTime = Duration(milliseconds: 800);
      state = state.copyWith(isLoading: true, error: null);

      final DateTime start = DateTime.now();

      final repository = ref.read(pxRepositoryImplProvider);
      final response = await repository.searchPx(value);

      final Duration elapsed = DateTime.now().difference(start);
      if (elapsed < minLoadingTime) {
        await Future.delayed(minLoadingTime - elapsed);
      }
      state = state.copyWith(
        isLoading: false,
        search: response.data,
        message: response.message,
        statusCode: response.statusCode,
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
  void clearPatient() {
    state = PxState(search: []);
    state = state.copyWith(search: []);
  }

}
