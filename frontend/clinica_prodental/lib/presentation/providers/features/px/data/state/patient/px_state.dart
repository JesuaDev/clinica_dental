import 'package:clinica_prodental/domain/entities/entities.dart';

class PxState {
  final bool? isLoading;
  final List<PxEntity>? data;
  final String? message;
  final ErrorEntity? error;
  final PaginationEntity? pagination;

  PxState({
    this.data = const [],
    this.message,
    this.error,
    this.isLoading = false,
    this.pagination,
  });

  PxState copyWith({
    bool? isLoading = false,
    List<PxEntity>? data,
    String? message,
    ErrorEntity? error,
    PaginationEntity? pagination,
  }) {
    return PxState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      message: message,
      error: error,
      pagination: pagination,
    );
  }
}
