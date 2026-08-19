import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clinica_prodental/domain/entities/error_entity.dart';
import 'package:clinica_prodental/presentation/providers/features/dentist/data/state/dentist_state.dart';
import 'package:clinica_prodental/presentation/providers/features/dentist/infraestructure/repositories/dentist_repository_impl_provider.dart';

final dentistNotifierProvider = NotifierProvider(DentistNotifier.new);

class DentistNotifier extends Notifier<DentistState> {
  @override
  DentistState build() => DentistState();

  Future<void> dentistSearch(String search) async {
    try {
      const Duration minLoadingTime = Duration(milliseconds: 800);
      state = state.copyWith(isLoading: true, error: null);

      final DateTime start = DateTime.now();

      final repository = ref.read(dentistRepositoryImplProvider);
      final response = await repository.searchDentist(search);

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
}
