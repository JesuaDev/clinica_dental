import 'package:clinica_prodental/domain/entities/entities.dart';
import 'package:clinica_prodental/domain/entities/px/px_entity.dart';
import 'package:clinica_prodental/infraestructure/dtos/px/medication/dtos_medication.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clinica_prodental/domain/entities/error_entity.dart';
import 'package:clinica_prodental/presentation/providers/features/px/data/state/medication/medication_state.dart';
import 'package:clinica_prodental/presentation/providers/features/px/infraestructure/repository/additionals/medication_repository_provider.dart';

final medicationProvider =
    NotifierProvider<MedicationNotifier, MedicationState>(
      MedicationNotifier.new,
    );

class MedicationNotifier extends Notifier<MedicationState> {
  @override
  MedicationState build() => MedicationState();

  Future<void> getMedications() async {
    try {
      const Duration minLoadingTime = Duration(milliseconds: 800);
      state = state.copyWith(isLoading: true, error: null);

      final DateTime start = DateTime.now();

      final repository = ref.watch(medicationRepositoryProvider);
      final response = await repository.getMedications();

      final Duration elapsed = DateTime.now().difference(start);
      if (elapsed < minLoadingTime) {
        await Future.delayed(minLoadingTime - elapsed);
      }

      state = state.copyWith(
        isLoading: false,
        message: response.message,
        medications: response.data,
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

  Future<MedicationPxEntiy> postMedication(DtosMedication dtos) async {
    const Duration minLoadingTime = Duration(milliseconds: 800);
    state = state.copyWith(isLoading: true, error: null);

    final DateTime start = DateTime.now();

    final repository = ref.watch(medicationRepositoryProvider);
    final response = await repository.postMedication(dtos);

    final Duration elapsed = DateTime.now().difference(start);
    if (elapsed < minLoadingTime) {
      await Future.delayed(minLoadingTime - elapsed);
    }

    state = state.copyWith(
      isLoading: false,
      message: response.message,
      medications: [...state.medications!, response.data],
    );

    return response.data;
  }
}
