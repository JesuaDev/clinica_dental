import 'package:clinica_prodental/domain/entities/entities.dart';
import 'package:clinica_prodental/domain/entities/error_entity.dart';
import 'package:clinica_prodental/infraestructure/dtos/dtos.dart';
import 'package:clinica_prodental/presentation/providers/features/px/data/state/allergy/allergy_state.dart';
import 'package:clinica_prodental/presentation/providers/features/px/infraestructure/repository/additionals/allergy_repository_impl_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final allergysProvider = NotifierProvider<AllergysNotifier, AllergyState>(
  AllergysNotifier.new,
);

class AllergysNotifier extends Notifier<AllergyState> {
  @override
  build() => AllergyState();

  Future<void> getAllergys() async {
    try {
      //*? Definimos el tiempo minimo de tiempo que puede hacer el loading y definimos primero en el state el loading en true
      const Duration minLoadingTime = Duration(milliseconds: 800);
      state = state.copyWith(isLoading: true, error: null);
      //? Definimos en que momento empieza el tiempo de espera de la respuesta de la api
      final DateTime start = DateTime.now();

      final repository = ref.watch(allergyRepositoryImplProvider);
      final response = await repository.getAllergys();
      //? Despues definimos el tiempo transcurrido (difference, calcula el tiempo que a transcurrido de la fecha o tiempo actual a la de la variable start) por eso es de tipo Duration
      final Duration elapsed = DateTime.now().difference(start);

      //? Aqui verificamos que el tiempo transcurrido es menor al minimo de tiempo para poder restarlos, ya que si el tiempo transcurrido es mayor al minimo entonces para que hacer mas tiempo de carga
      if (elapsed < minLoadingTime) {
        await Future.delayed(minLoadingTime - elapsed);
      }
      state = state.copyWith(
        isLoading: false,
        message: response.message,
        allergys: response.data,
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

  Future<AllergyEntity> postAllergy(DtosAllergy dtosAllergy) async {
    try {
      const Duration minLoadingTime = Duration(milliseconds: 800);
      state = state.copyWith(isLoading: true, error: null);
      final DateTime start = DateTime.now();

      final repository = ref.watch(allergyRepositoryImplProvider);
      final response = await repository.postAllergy(dtosAllergy);

      final Duration elapsed = DateTime.now().difference(start);
      if (elapsed < minLoadingTime) {
        await Future.delayed(minLoadingTime - elapsed);
      }

      state = state.copyWith(
        isLoading: false,
        message: response.message,
        allergys: [...state.allergys!, response.data],
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
