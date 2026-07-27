import 'package:clinica_prodental/domain/entities/entities.dart';

class PxState {
  final bool? isLoading;
  final List<PxEntity>? data;
  final PxEntity? px;
  final List<PxEntity>? search;
  final String? message;
  final int? statusCode;
  final ErrorEntity? error;
  final PaginationEntity? pagination;

  PxState({
    this.data = const [],
    this.message,
    this.error,
    this.isLoading = false,
    this.pagination,
    this.search = const [],
    this.statusCode,
    this.px,
  });

  PxState copyWith({
    bool? isLoading = false,
    List<PxEntity>? data,
    List<PxEntity>? search,
    String? message,
    ErrorEntity? error,
    PaginationEntity? pagination,
    int? statusCode,
    PxEntity? px
  }) {
    return PxState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      message: message,
      error: error,
      pagination: pagination,
      search: search ?? this.search,
      statusCode: statusCode,
      px: px
    );
  }
}
