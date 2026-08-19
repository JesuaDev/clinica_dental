import 'package:clinica_prodental/domain/entities/entities.dart';

class DentistState {
  final bool? isLoading;
  final ErrorEntity? error;
  final List<DentistEntity>? search;
  final String? message;
  final int? statusCode;

  DentistState({
    this.isLoading = false,
    this.error,
    this.search = const [],
    this.message,
    this.statusCode,
  });

  DentistState copyWith({
    bool? isLoading,
    ErrorEntity? error,
    List<DentistEntity>? search,
    String? message,
    int? statusCode,
  }) {
    return DentistState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      search: search ?? this.search,
      message: message,
      statusCode: statusCode,
    );
  }
}
