import 'package:clinica_prodental/domain/entities/entities.dart';

class DiseaseState {
  final bool? isLoading;
  final String? message;
  final int? statusCode;
  final ErrorEntity? error;
  final List<DiseasesEntity>? diseases;

  DiseaseState({
    this.message,
    this.statusCode,
    this.error,
    this.diseases = const [],
    this.isLoading = false,
  });

  DiseaseState copyWith({
    bool? isLoading,
    String? message,
    int? statusCode,
    ErrorEntity? error,
    List<DiseasesEntity>? diseases,
  }) {
    return DiseaseState(
      isLoading: isLoading ?? this.isLoading,
      message: message,
      statusCode: statusCode,
      error: error,
      diseases: diseases ?? this.diseases,
    );
  }
}
