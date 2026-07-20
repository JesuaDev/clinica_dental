import 'package:clinica_prodental/domain/entities/error_entity.dart';
import 'package:clinica_prodental/domain/entities/px/additionals_px/allergy_entity.dart';

class AllergyState {
  final bool? isLoading;
  final String? message;
  final ErrorEntity? error;
  final List<AllergyEntity>? allergys;

  AllergyState({
    this.isLoading = false,
    this.message = "",
    this.error,
    this.allergys = const [],
  });

  AllergyState copyWith({
    bool? isLoading,
    String? message,
    ErrorEntity? error,
    List<AllergyEntity>? allergys,
  }) {
    return AllergyState(
      isLoading: isLoading ?? this.isLoading,
      message: message ?? this.message,
      error: error,
      allergys: allergys ?? this.allergys,
    );
  }
}
