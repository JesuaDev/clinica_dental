import 'package:clinica_prodental/domain/entities/entities.dart';

class CitaState {
  final bool? isLoading;
  final ErrorEntity? error;
  final List<CitaEntity>? citas;
  final CitaEntity? citaUpcoming;
  final PaginationEntity? pagination;
  final String? message;
  final int? statusCode;

  CitaState({
    this.isLoading = false,
    this.error,
    this.citas = const [],
    this.pagination,
    this.message,
    this.statusCode,
    this.citaUpcoming,
  });

  CitaState copyWith({
    bool? isLoading,
    ErrorEntity? error,
    List<CitaEntity>? citas,
    PaginationEntity? pagination,
    String? message,
    int? statusCode,
    CitaEntity? citaUpcoming,
  }) {
    return CitaState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      citas: citas ?? this.citas,
      pagination: pagination,
      message: message,
      statusCode: statusCode,
      citaUpcoming: citaUpcoming,
    );
  }
}
