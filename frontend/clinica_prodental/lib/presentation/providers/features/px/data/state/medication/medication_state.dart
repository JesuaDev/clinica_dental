import 'package:clinica_prodental/domain/entities/entities.dart';

class MedicationState {
  final bool? isLoading;
  final String? message;
  final int? statusCode;
  final ErrorEntity? error;
  final List<MedicationPxEntiy>? medications;

  MedicationState({
    this.isLoading = false,
    this.message,
    this.statusCode,
    this.error,
    this.medications = const [],
  });

  MedicationState copyWith({
    bool? isLoading,
    String? message,
    int? statusCode,
    ErrorEntity? error,
    List<MedicationPxEntiy>? medications,
  }) {
    return MedicationState(
      isLoading: isLoading ?? this.isLoading,
      message: message,
      statusCode: statusCode,
      error: error,
      medications: medications ?? this.medications,
    );
  }
}
